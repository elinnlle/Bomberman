//
//  LobbyView.swift
//  Bomberman
//

import SwiftUI

struct LobbyView: View {
    @EnvironmentObject var gameClient: GameClient
    @State private var showLeaderboard = false
    @State private var showMatchHistory = false
    @State private var selectedPlayerForAchievements: PlayerSummary?

    var body: some View {
        VStack(spacing: 16) {
            LobbyHeaderView(
                title: "Комната",
                onShowLeaderboard: { showLeaderboard = true },
                onShowMatchHistory: { showMatchHistory = true },
                onLeave: { gameClient.leaveRoom() }
            )
            .padding(.horizontal, 24)
            .padding(.top, 16)

            if let me = gameClient.me {
                LobbyMeInfoView(me: me)
                    .padding(.horizontal, 24)
            }

            LobbyPlayersListView(
                players: gameClient.players,
                onOpenAchievements: { selectedPlayerForAchievements = $0 }
            )
            .padding(.horizontal, 24)

            Spacer()

            // Показываем метрики для наблюдателей, кнопку готовности для игроков
            if gameClient.me?.role == .spectator {
                SpectatorMetricsView()
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
            } else {
                LobbyActionsView(
                    isReady: gameClient.isReady,
                    onToggleReady: { gameClient.toggleReady() }
                )
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
        }
        .background(Color.blackApp.ignoresSafeArea())
        .sheet(isPresented: $showLeaderboard) {
            LeaderboardView()
                .environmentObject(gameClient)
        }
        .sheet(isPresented: $showMatchHistory) {
            if let me = gameClient.me {
                MatchHistoryView(player: me)
                    .environmentObject(gameClient)
            }
        }
        .sheet(item: $selectedPlayerForAchievements) { player in
            AchievementsView(player: player)
                .environmentObject(gameClient)
        }
    }
}
