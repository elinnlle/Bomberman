//
//  LobbyPlayerCardView.swift
//  Bomberman
//

import SwiftUI

struct LobbyPlayerCardView: View {
    let player: PlayerSummary
    let onOpenAchievements: () -> Void

    var body: some View {
        let statusColor: Color = player.readyStatus == .ready ? .green : .secondaryTextColor

        HStack(spacing: 14) {
            VStack(alignment: .leading, spacing: 4) {
                Text(player.name)
                    .appFont(.sansSemiBold, size: 16)
                    .foregroundColor(.mainTextColor)

                Text(player.role.title)
                    .appFont(.sansRegular, size: 12)
                    .foregroundColor(.secondaryTextColor)

                HStack(spacing: 6) {
                    Text(player.readyStatus == .ready ? "Готов" : "Не готов")
                        .appFont(.sansRegular, size: 14)
                        .foregroundColor(statusColor)

                    if player.isMe {
                        Text("•")
                            .foregroundColor(.secondaryTextColor)

                        Text("Вы")
                            .appFont(.sansRegular, size: 14)
                            .foregroundColor(.secondaryTextColor)
                    }
                }
            }

            Spacer()

            if player.isMe {
                Button(action: onOpenAchievements) {
                    Image(systemName: "trophy.fill")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.mainTextColor)
                        .padding(8)
                        .background(Color.lightGrayApp)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.grayApp)
        )
    }
}
