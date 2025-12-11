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
                    self.lastRoundResult = .draw
                }
            }
        }
    }
    
    func finishRound(with result: RoundResult?) {
        roundTimer?.invalidate()
        roundPhase = .finished
        lastRoundResult = result
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
}
