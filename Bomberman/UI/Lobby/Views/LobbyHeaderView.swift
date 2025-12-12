//
//  LobbyHeaderView.swift
//  Bomberman
//

import SwiftUI

struct LobbyHeaderView: View {
    let title: String
    let onShowLeaderboard: () -> Void
    let onLeave: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Text(title)
                .appFont(.sansBold, size: 24)
                .foregroundColor(.mainTextColor)

            Spacer()

            Button(action: onShowLeaderboard) {
                Text("Статистика")
                    .appFont(.sansRegular, size: 14)
                    .foregroundColor(.secondaryTextColor)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.lightGrayApp)
                    .cornerRadius(10)
            }

            Button(action: onLeave) {
                Text("Выйти")
                    .appFont(.sansRegular, size: 14)
                    .foregroundColor(.secondaryTextColor)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.lightGrayApp)
                    .cornerRadius(10)
            }
        }
    }
}

