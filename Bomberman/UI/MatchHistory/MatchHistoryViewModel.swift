//
//  MatchHistoryViewModel.swift
//  Bomberman
//

import Foundation

@MainActor
final class MatchHistoryViewModel: ObservableObject {
    @Published private(set) var entries: [RoundHistoryEntry] = []

    private let gameClient: GameClient
    private let playerId: String

    init(gameClient: GameClient, playerId: String) {
        self.gameClient = gameClient
        self.playerId = playerId
        load()
    }

    func load() {
        entries = gameClient.roundHistory[playerId] ?? []
            .sorted { $0.date > $1.date }
    }

    func reset() {
        gameClient.roundHistory[playerId] = []
        load()
    }
}
