//
//  AchievementsViewModel.swift
//  Bomberman
//

import Foundation

@MainActor
final class AchievementsViewModel: ObservableObject {
    @Published private(set) var achievements: [Achievement] = []
    @Published private(set) var stats: PlayerStats?

    private let player: PlayerSummary
    private let gameClient: GameClient

    init(player: PlayerSummary, gameClient: GameClient) {
        self.player = player
        self.gameClient = gameClient
        load()
    }

    func load() {
        let stats = gameClient.playerStats[player.id]
        self.stats = stats

        guard let stats else {
            achievements = []
            return
        }

        achievements = Self.buildAchievements(from: stats)
    }

    private static func buildAchievements(from stats: PlayerStats) -> [Achievement] {
        let games = stats.gamesPlayed

        return [
            Achievement(id: "first_game",
                        title: "Первые шаги",
                        description: "Сыграть 1 матч",
                        current: games,
                        target: 1),

            Achievement(id: "five_games",
                        title: "В бой!",
                        description: "Сыграть 5 матчей",
                        current: games,
                        target: 5),

            Achievement(id: "ten_games",
                        title: "Ветеран",
                        description: "Сыграть 10 матчей",
                        current: games,
                        target: 10),

            Achievement(id: "first_win",
                        title: "Первая победа",
                        description: "Выиграть 1 матч",
                        current: stats.wins,
                        target: 1),

            Achievement(id: "three_wins",
                        title: "Стабильный победитель",
                        description: "Выиграть 3 матча",
                        current: stats.wins,
                        target: 3),

            Achievement(id: "five_wins",
                        title: "Бомбический игрок",
                        description: "Выиграть 5 матчей",
                        current: stats.wins,
                        target: 5),

            Achievement(id: "no_quit",
                        title: "Несдающийся",
                        description: "Проиграть 5 матчей и не сдаться",
                        current: stats.losses,
                        target: 5),

            Achievement(id: "peacemaker",
                        title: "Миротворец",
                        description: "Сыграть 3 ничьи",
                        current: stats.draws,
                        target: 3)
        ]
    }
}
