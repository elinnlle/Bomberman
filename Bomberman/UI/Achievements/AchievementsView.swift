//
//  AchievementsView.swift
//  Bomberman
//

import SwiftUI

struct AchievementsView: View {
    @EnvironmentObject var gameClient: GameClient
    @StateObject private var viewModel: AchievementsViewModel

    init(player: PlayerSummary) {
        _viewModel = StateObject(
            wrappedValue: AchievementsViewModel(
                player: player,
                gameClient: GameClient.shared
            )
        )
    }

    var body: some View {
        ZStack {
            Color.blackApp.ignoresSafeArea()

            VStack(spacing: 16) {
                AchievementsHeaderView(playerName: viewModel.stats?.name ?? "")

                if let stats = viewModel.stats, stats.gamesPlayed > 0 {
                    AchievementsStatsView(stats: stats)

                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(viewModel.achievements) {
                                AchievementRowView(achievement: $0)
                            }
                        }
                        .padding(.top, 12)
                    }
                } else {
                    AchievementsEmptyView()
                }

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
        }
    }
}
