//
//  LeaderboardView.swift
//  Bomberman
//

import SwiftUI

struct LeaderboardView: View {
    @EnvironmentObject var gameClient: GameClient
    @StateObject private var viewModel: LeaderboardViewModel
    @State private var animateBg = false

    init() {
        _viewModel = StateObject(
            wrappedValue: LeaderboardViewModel(
                gameClient: GameClient.shared
            )
        )
    }

    var body: some View {
        ZStack {
            LeaderboardAnimatedBackground(animate: $animateBg)

            VStack(spacing: 20) {
                LeaderboardHeaderView()

                if viewModel.sortedStats.isEmpty {
                    LeaderboardEmptyStateView()
                } else {
                    LeaderboardStatsListView(stats: viewModel.sortedStats)
                        .animation(.easeInOut(duration: 0.35),
                                   value: viewModel.sortedStats)
                }

                Spacer(minLength: 100)
            }
            .padding(.top, 24)

            VStack {
                Spacer()
                LeaderboardResetButtonView(
                    onReset: viewModel.resetStats
                )
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .ignoresSafeArea()
        .onAppear {
            animateBg = true
        }
    }
}
