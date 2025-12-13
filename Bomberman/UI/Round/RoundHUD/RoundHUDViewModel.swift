//
//  RoundHUDViewModel.swift
//  Bomberman
//

import Foundation

@MainActor
final class RoundHUDViewModel: ObservableObject {
    @Published private(set) var timeText: String = ""

    private let gameClient: GameClient

    init(gameClient: GameClient) {
        self.gameClient = gameClient
        updateTime()
    }

    func updateTime() {
        let total = Int(max(0, gameClient.roundTimeRemaining))
        let minutes = total / 60
        let seconds = total % 60
        timeText = String(format: "%02d:%02d", minutes, seconds)
    }

    var shouldShowResult: Bool {
        gameClient.roundPhase == .finished &&
        gameClient.lastRoundResult != nil
    }

    var roundResult: RoundResult? {
        gameClient.lastRoundResult
    }

    func surrender() {
        gameClient.finishRound(with: .defeat)
    }

    func backToLobby() {
        gameClient.roundPhase = .notInRound
    }
}

