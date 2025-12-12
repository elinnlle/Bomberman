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
    
    private var roundTimer: Timer?
    
    private init() {}
    
    func connect(name: String, role: PlayerRole) {
        connectionState = .connecting
        
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let finalName = trimmedName.isEmpty ? "Игрок" : trimmedName
        
        let mePlayer = PlayerSummary(
            id: UUID().uuidString,
            name: finalName,
            role: role,
            readyStatus: .notReady,
            isMe: true
        )
        
        let otherPlayer = PlayerSummary(
            id: UUID().uuidString,
            name: "Другой",
            role: .player,
            readyStatus: .notReady,
            isMe: false
        )
        
        me = mePlayer
        players = [mePlayer, otherPlayer]
        isReady = false
        connectionState = .connected
        roundPhase = .notInRound
        roundTimeRemaining = 0
        lastRoundResult = nil
        
        ensureStats(for: mePlayer)
        ensureStats(for: otherPlayer)
        
        // Здесь потом человек, пишущий WebSocket, вместо этой заглушки
        // вставит реальный вызов join_message {"type": "join", ...}
    }
    
    func toggleReady() {
        guard var mePlayer = me else { return }
        
        isReady.toggle()
        mePlayer.readyStatus = isReady ? .ready : .notReady
        me = mePlayer
        
        players = players.map { player in
            if player.id == mePlayer.id {
                var updated = player
                updated.readyStatus = mePlayer.readyStatus
                return updated
            } else {
                return player
            }
        }
        
        // Здесь потом будет отправка {"type": "ready"}
    }
    
    func startRoundLocallyForDemo(duration: TimeInterval = 90) {
        roundTimer?.invalidate()
        roundTimeRemaining = duration
        roundPhase = .running
        lastRoundResult = nil
        
        roundTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            Task { @MainActor in
                guard let self else { return }
                if self.roundTimeRemaining > 0 {
                    self.roundTimeRemaining -= 1
                } else {
                    timer.invalidate()
                    self.roundPhase = .finished
                    self.finishRound(with: .draw)
                }
            }
        }
    }
    
    func finishRound(with result: RoundResult?) {
        roundTimer?.invalidate()
        roundPhase = .finished
        lastRoundResult = result

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
        roundTimer?.invalidate()
        connectionState = .disconnected
        players = []
        me = nil
        isReady = false
        roundPhase = .notInRound
        roundTimeRemaining = 0
        lastRoundResult = nil
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
