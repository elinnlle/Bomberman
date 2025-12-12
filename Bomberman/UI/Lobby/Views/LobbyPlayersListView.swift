//
//  LobbyPlayersListView.swift
//  Bomberman
//

import SwiftUI

struct LobbyPlayersListView: View {
    let players: [PlayerSummary]
    let onOpenAchievements: (PlayerSummary) -> Void

    var body: some View {
        VStack(spacing: 12) {
            ForEach(players) { player in
                LobbyPlayerCardView(
                    player: player,
                    onOpenAchievements: { onOpenAchievements(player) }
                )
            }
        }
    }
}
