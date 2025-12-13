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
    
    private var roundTimer: Timer?
    private var webSocketClient: WebSocketClient?
    private var pendingConnectionName: String?
    private var pendingConnectionRole: PlayerRole?
    private var hasSurrendered: Bool = false
    
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
                
                // Отправляем сообщение о подключении
                let roleString = role == .player ? "player" : "spectator"
                let message: ClientMessage = .join(name: name, role: roleString)
                self.webSocketClient?.send(message)
            }
        }
        
        webSocketClient?.onDisconnected = { [weak self] in
            Task { @MainActor [weak self] in
                guard let self = self else { return }
                if self.connectionState == .connected {
                    self.connectionState = .disconnected
                    self.cleanup()
                }
            }
        }
        
        webSocketClient?.onError = { [weak self] error in
            Task { @MainActor [weak self] in
                guard let self = self else { return }
                self.connectionState = .failed(error.localizedDescription)
                self.cleanup()
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
        guard me != nil else { return }
        
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

        applyResultToStats(result)

        let entry = RoundHistoryEntry(
            playerId: mePlayer.id,
            result: result,
            duration: 90 - roundTimeRemaining
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
        roundPhase = .notInRound
        lastRoundResult = nil
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
        webSocketClient = nil
        pendingConnectionName = nil
        pendingConnectionRole = nil
        hasSurrendered = false
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
        gameState = state
        
        // Обновляем список игроков
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
        
        // Обновляем информацию о себе
        if let myId = myPlayerId,
           let myPlayerPos = state.players.first(where: { $0.id == myId }) {
            var updatedMe = me
            updatedMe?.readyStatus = myPlayerPos.ready ? .ready : .notReady
            me = updatedMe
            isReady = myPlayerPos.ready
        }
        
        // Если игрок сдался — не обновляем фазу раунда от сервера
        if hasSurrendered {
            // Только обновляем таймер для отображения
            if let timeRemaining = state.timeRemaining {
                roundTimeRemaining = max(0, timeRemaining)
            }
            return
        }
        
        // Обновляем фазу раунда
        switch state.state {
        case .waiting:
            roundPhase = .notInRound
            roundTimeRemaining = 0
            lastRoundResult = nil
            hasSurrendered = false  // Сбрасываем флаг при возврате в лобби
            
        case .inProgress:
            if roundPhase != .running {
                roundPhase = .running
                lastRoundResult = nil
            }
            
            // Обновляем таймер
            if let timeRemaining = state.timeRemaining {
                roundTimeRemaining = max(0, timeRemaining)
            }
            
        case .gameOver:
            if roundPhase != .finished {
                roundPhase = .finished
                determineRoundResult(from: state)
            }
        }
    }
    
    private func determineRoundResult(from state: GameState) {
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
        
        // Применяем результат к статистике
        if let result = lastRoundResult {
            applyResultToStats(result)
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
        guard let mePlayer = me else { return }
        
        ensureStats(for: mePlayer)
        
        guard var stats = playerStats[mePlayer.id] else { return }
        
        switch result {
        case .victory:
            stats.wins += 1
        case .defeat:
            stats.losses += 1
        case .draw:
            stats.draws += 1
        }
        
        playerStats[mePlayer.id] = stats
    }
}

