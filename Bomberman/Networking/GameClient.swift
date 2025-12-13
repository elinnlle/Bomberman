//
//  GameClient.swift
//  Bomberman
//

import Foundation

@MainActor
final class GameClient: ObservableObject {
    static let shared = GameClient()
    
    @Published var connectionState: ConnectionState = .disconnected
    @Published var players: [PlayerSummary] = []
    @Published var me: PlayerSummary?
    @Published var isReady: Bool = false
    
    @Published var roundPhase: RoundPhase = .notInRound
    @Published var roundTimeRemaining: TimeInterval = 0
    @Published var lastRoundResult: RoundResult?
    @Published var playerStats: [String: PlayerStats] = [:]
    @Published var roundHistory: [String: [RoundHistoryEntry]] = [:]
    
    // Игровое состояние
    @Published var gameState: GameState?
    @Published var myPlayerId: String?
    @Published var gameWinner: String? // Победитель игры (для наблюдателей)
    
    private var roundTimer: Timer?
    private var webSocketClient: WebSocketClient?
    private var pendingConnectionName: String?
    private var pendingConnectionRole: PlayerRole?
    private var hasSurrendered: Bool = false
    private var isReturningToLobby: Bool = false
    private var statsAppliedForCurrentRound: Bool = false
    
    // URL сервера - можно настроить через настройки приложения
    private let serverURL: URL = {
        // Для симулятора используем localhost, для устройства - IP компьютера
        #if targetEnvironment(simulator)
        return URL(string: "ws://localhost:8765")!
        #else
        // Для реального устройства замените на IP вашего компьютера
        // Например: return URL(string: "ws://192.168.1.100:8765")!
        return URL(string: "ws://localhost:8765")!
        #endif
    }()
    
    private init() {}
    
    func connect(name: String, role: PlayerRole) {
        connectionState = .connecting
        
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let finalName = trimmedName.isEmpty ? "Игрок" : trimmedName
        
        pendingConnectionName = finalName
        pendingConnectionRole = role
        
        // Создаем WebSocket клиент
        webSocketClient = WebSocketClient(serverURL: serverURL)
        
        // Настраиваем обработчики
        webSocketClient?.onConnected = { [weak self] in
            Task { @MainActor [weak self] in
                guard let self = self,
                      let name = self.pendingConnectionName,
                      let role = self.pendingConnectionRole else { return }
                
                self.connectionState = .connected
                
                // Для наблюдателя создаём me сразу, так как сервер не отправляет assign_id
                if role == .spectator {
                    let spectatorId = UUID().uuidString
                    self.myPlayerId = spectatorId
                    let mePlayer = PlayerSummary(
                        id: spectatorId,
                        name: name,
                        role: role,
                        readyStatus: .notReady,
                        isMe: true
                    )
                    self.me = mePlayer
                }
                
                // Отправляем сообщение о подключении
                let roleString = role == .player ? "player" : "spectator"
                let message: ClientMessage = .join(name: name, role: roleString)
                self.webSocketClient?.send(message)
            }
        }
        
        webSocketClient?.onDisconnected = { [weak self] in
            Task { @MainActor [weak self] in
                guard let self = self else { return }
                // Отключение только если мы были подключены и не в процессе игры
                // Если игра идёт — возможно это временная проблема
                if self.connectionState == .connected && self.roundPhase == .notInRound {
                    self.connectionState = .disconnected
                    self.cleanup()
                }
            }
        }
        
        webSocketClient?.onError = { [weak self] error in
            Task { @MainActor [weak self] in
                guard let self = self else { return }
                // Логируем ошибку, но не отключаемся сразу — возможно это временная проблема
                print("WebSocket error: \(error.localizedDescription)")
                // Отключаемся только если соединение потеряно полностью
                if self.connectionState == .connecting {
                    self.connectionState = .failed(error.localizedDescription)
                    self.cleanup()
                }
            }
        }
        
        webSocketClient?.onMessage = { [weak self] message in
            Task { @MainActor [weak self] in
                self?.handleServerMessage(message)
            }
        }
        
        // Подключаемся
        webSocketClient?.connect()
    }
    
    func toggleReady() {
        guard let me = me, me.role != .spectator else { return }
        
        // Отправляем команду на сервер
        webSocketClient?.send(.ready)
        
        // Локально обновляем состояние (сервер подтвердит через game_state)
        isReady.toggle()
    }
    
    func finishRound(with result: RoundResult?) {
        roundTimer?.invalidate()
        roundPhase = .finished
        lastRoundResult = result
        hasSurrendered = true  // Помечаем что игрок сдался локально

        guard
            let result,
            let mePlayer = me
        else { return }

        // Статистика применяется в determineRoundResult, не дублируем здесь
        // applyResultToStats(result)

        let ROUND_DURATION: TimeInterval = 120 // 2 минуты (соответствует серверу)
        let duration = max(0, ROUND_DURATION - roundTimeRemaining)
        
        let entry = RoundHistoryEntry(
            playerId: mePlayer.id,
            result: result,
            duration: duration
        )

        roundHistory[mePlayer.id, default: []].append(entry)
    }
    
    func leaveRoom() {
        webSocketClient?.disconnect()
        cleanup()
    }
    
    func movePlayer(dx: Int, dy: Int) {
        guard connectionState == .connected else { return }
        webSocketClient?.send(.move(dx: dx, dy: dy))
    }
    
    func placeBomb() {
        guard connectionState == .connected else { return }
        webSocketClient?.send(.placeBomb)
    }
    
    func returnToLobby() {
        hasSurrendered = false
        isReturningToLobby = true  // Помечаем что возвращаемся в лобби
        roundPhase = .notInRound
        lastRoundResult = nil
        gameState = nil  // Сбрасываем игровое состояние сразу
        roundTimeRemaining = 0  // Сбрасываем таймер
    }
    
    func surrenderAndReturnToLobby() {
        // Отправляем surrender на сервер - сервер пометит нас как мёртвых
        webSocketClient?.send(.surrender)
        
        // Помечаем локально что сдались
        hasSurrendered = true
        
        // Записываем поражение в статистику
        finishRound(with: .defeat)
        
        // Сбрасываем ready статус
        isReady = false
        if var updatedMe = me {
            updatedMe.readyStatus = .notReady
            me = updatedMe
        }
        
        // Обновляем статус в списке игроков
        players = players.map { player in
            if player.id == myPlayerId {
                var updated = player
                updated.readyStatus = .notReady
                return updated
            }
            return player
        }
    }
    
    private func cleanup() {
        roundTimer?.invalidate()
        roundTimer = nil
        connectionState = .disconnected
        players = []
        me = nil
        isReady = false
        roundPhase = .notInRound
        roundTimeRemaining = 0
        lastRoundResult = nil
        gameState = nil
        myPlayerId = nil
        gameWinner = nil
        webSocketClient = nil
        pendingConnectionName = nil
        pendingConnectionRole = nil
        hasSurrendered = false
        isReturningToLobby = false
        statsAppliedForCurrentRound = false
    }
    
    private func handleServerMessage(_ message: ServerMessage) {
        switch message {
        case .assignId(let id):
            myPlayerId = id
            // Создаем временного игрока с полученным ID
            if let name = pendingConnectionName, let role = pendingConnectionRole {
                let mePlayer = PlayerSummary(
                    id: id,
                    name: name,
                    role: role,
                    readyStatus: .notReady,
                    isMe: true
                )
                me = mePlayer
                ensureStats(for: mePlayer)
            }
            
        case .gameState(let state):
            updateGameState(state)
        }
    }
    
    private func updateGameState(_ state: GameState) {
        // Если мы возвращаемся в лобби, игнорируем все обновления кроме WAITING
        if isReturningToLobby && state.state != .waiting {
            return
        }
        
        gameState = state
        
        // Обновляем список игроков из состояния сервера
        let newPlayers = state.players.map { playerPos in
            PlayerSummary(
                id: playerPos.id,
                name: playerPos.name,
                role: .player, // Сервер не отправляет роль, предполагаем игрок
                readyStatus: playerPos.ready ? .ready : .notReady,
                isMe: playerPos.id == myPlayerId
            )
        }
        
        players = newPlayers
        
        for player in newPlayers {
            ensureStats(for: player)
        }
        
        // Обновляем информацию о себе
        if let myId = myPlayerId,
           let myPlayerPos = state.players.first(where: { $0.id == myId }) {
            var updatedMe = me
            updatedMe?.readyStatus = myPlayerPos.ready ? .ready : .notReady
            me = updatedMe
            isReady = myPlayerPos.ready
        }
        
        // Обновляем фазу раунда
        switch state.state {
        case .waiting:
            // Всегда переходим в лобби когда сервер говорит WAITING
            roundPhase = .notInRound
            roundTimeRemaining = 0
            lastRoundResult = nil
            gameWinner = nil
            hasSurrendered = false
            isReturningToLobby = false  // Сбрасываем флаг возврата
            statsAppliedForCurrentRound = false  // Сбрасываем флаг статистики
            // Сбрасываем gameState чтобы карта не обновлялась
            gameState = nil
            // Статусы готовности уже обновлены из сервера выше (сервер сбрасывает их при reset())
            
        case .inProgress:
            // Если игрок сдался — не возвращаем его в игру
            if hasSurrendered {
                if let timeRemaining = state.timeRemaining {
                    roundTimeRemaining = max(0, timeRemaining)
                }
                return
            }
            
            // Устанавливаем running для всех (включая наблюдателей)
            if roundPhase != .running {
                roundPhase = .running
                lastRoundResult = nil
                statsAppliedForCurrentRound = false  // Сбрасываем флаг для нового раунда
            }
            
            // Обновляем таймер
            if let timeRemaining = state.timeRemaining {
                roundTimeRemaining = max(0, timeRemaining)
            }
            
        case .gameOver:
            // Всегда устанавливаем finished и определяем результат при GAME_OVER
            // Это важно для наблюдателей, которые могут не иметь roundPhase == .running
            if roundPhase != .finished {
                roundPhase = .finished
            }
            // Определяем результат (важно вызывать даже если уже finished, чтобы обновить результат)
            determineRoundResult(from: state)
            
            // Сбрасываем ready статус у всех игроков сразу при завершении игры
            isReady = false
            if var updatedMe = me {
                updatedMe.readyStatus = .notReady
                me = updatedMe
            }
            // Обновляем статусы всех игроков на notReady
            players = players.map { player in
                var updated = player
                updated.readyStatus = .notReady
                return updated
            }
        }
    }
    
    private func determineRoundResult(from state: GameState) {
        // Проверяем, наблюдатель ли мы - проверяем и me?.role и myPlayerId
        let isSpectator = (me?.role == .spectator) || (myPlayerId == nil && me == nil)
        
        if isSpectator {
            // Для наблюдателя определяем реальный результат игры
            // Сначала проверяем winner из состояния
            if let winner = state.winner, !winner.isEmpty, winner != "НИЧЬЯ" {
                // Есть победитель - сохраняем его имя
                gameWinner = winner
                lastRoundResult = .draw
            } else {
                // Если winner не установлен или это "НИЧЬЯ", определяем по количеству выживших
                let alivePlayers = state.players.filter { $0.alive }
                
                if alivePlayers.count == 1 {
                    // Есть один победитель
                    gameWinner = alivePlayers[0].name
                    lastRoundResult = .draw
                } else {
                    // Нет выживших или несколько выживших - ничья
                    gameWinner = nil
                    lastRoundResult = .draw
                }
            }
            // Не применяем результат к статистике для наблюдателя
            return
        }
        
        // Для игроков сбрасываем gameWinner (он нужен только для наблюдателей)
        // Но только если мы действительно игрок, а не наблюдатель
        if me?.role != .spectator {
            gameWinner = nil
        }
        
        // Для игрока определяем личный результат
        guard let myId = myPlayerId else {
            lastRoundResult = nil
            return
        }
        
        let myPlayer = state.players.first(where: { $0.id == myId })
        let alivePlayers = state.players.filter { $0.alive }
        
        if let winner = state.winner {
            if winner == "НИЧЬЯ" {
                lastRoundResult = .draw
            } else if let myPlayer = myPlayer, myPlayer.name == winner {
                lastRoundResult = .victory
            } else {
                lastRoundResult = .defeat
            }
        } else {
            // Определяем результат по количеству выживших
            if alivePlayers.count == 0 {
                lastRoundResult = .draw
            } else if alivePlayers.count == 1 {
                if alivePlayers[0].id == myId {
                    lastRoundResult = .victory
                } else {
                    lastRoundResult = .defeat
                }
            } else {
                // Несколько выживших - ничья
                if let myPlayer = myPlayer, myPlayer.alive {
                    lastRoundResult = .draw
                } else {
                    lastRoundResult = .defeat
                }
            }
        }
        
        // Применяем результат к статистике только один раз за раунд
        if let result = lastRoundResult, !statsAppliedForCurrentRound {
            applyResultToStats(result)
            statsAppliedForCurrentRound = true
            
            // Записываем историю раунда
            if let mePlayer = me {
                let ROUND_DURATION: TimeInterval = 120 // 2 минуты (соответствует серверу)
                let duration = max(0, ROUND_DURATION - roundTimeRemaining)
                
                let entry = RoundHistoryEntry(
                    playerId: mePlayer.id,
                    result: result,
                    duration: duration
                )
                
                roundHistory[mePlayer.id, default: []].append(entry)
            }
        }
    }
    
    private func ensureStats(for player: PlayerSummary) {
        if playerStats[player.id] == nil {
            playerStats[player.id] = PlayerStats(
                id: player.id,
                name: player.name,
                wins: 0,
                losses: 0,
                draws: 0
            )
        } else {
            var existing = playerStats[player.id]
            existing?.name = player.name
            if let updated = existing {
                playerStats[player.id] = updated
            }
        }
    }
    
    private func applyResultToStats(_ result: RoundResult) {
        for player in players {
            ensureStats(for: player)

            guard var stats = playerStats[player.id] else { continue }

            switch result {
            case .victory:
                if player.isMe {
                    stats.wins += 1
                } else {
                    stats.losses += 1
                }

            case .defeat:
                if player.isMe {
                    stats.losses += 1
                } else {
                    stats.wins += 1
                }

            case .draw:
                stats.draws += 1
            }

            playerStats[player.id] = stats
        }
    }
}

