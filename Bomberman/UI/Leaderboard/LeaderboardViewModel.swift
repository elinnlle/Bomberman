//
//  LeaderboardViewModel.swift
//  Bomberman
//

import Foundation

@MainActor
final class LeaderboardViewModel: ObservableObject {
    @Published private(set) var sortedStats: [PlayerStats] = []

    private let gameClient: GameClient

    init(gameClient: GameClient) {
        self.gameClient = gameClient
        reload()
    }

    func reload() {
        sortedStats = gameClient.playerStats.values
            .sorted { $0.wins > $1.wins }
    }

    func resetStats() {
        gameClient.playerStats.removeAll()
        reload()
    }
}
