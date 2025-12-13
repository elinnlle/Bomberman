//
//  MatchHistoryView.swift
//  Bomberman
//

import SwiftUI

struct MatchHistoryView: View {
    @EnvironmentObject var gameClient: GameClient
    @Environment(\.dismiss) private var dismiss

    @StateObject private var viewModel: MatchHistoryViewModel

    init(player: PlayerSummary) {
        _viewModel = StateObject(
            wrappedValue: MatchHistoryViewModel(
                gameClient: GameClient.shared,
                playerId: player.id
            )
        )
    }

    var body: some View {
        ZStack {
            Color.blackApp.ignoresSafeArea()

            VStack(spacing: 16) {
                MatchHistoryHeaderView()

                if viewModel.entries.isEmpty {
                    MatchHistoryEmptyView()
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(viewModel.entries) {
                                MatchHistoryRowView(entry: $0)
                            }
                        }
                        .padding(.top, 8)
                    }
                }

                Spacer()

                MatchHistoryResetButtonView {
                    viewModel.reset()
                }
                .padding(.bottom, 24)
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
        }
    }
}
