//
//  LeaderboardCardView.swift
//  Bomberman
//

import SwiftUI

struct LeaderboardCardView: View {
    let stats: PlayerStats
    let rank: Int

    var body: some View {
        HStack(spacing: 14) {
            Text("#\(rank)")
                .appFont(.sansSemiBold, size: 16)
                .foregroundColor(.mainTextColor.opacity(0.8))
                .frame(width: 38, alignment: .leading)

            VStack(alignment: .leading, spacing: 4) {
                Text(stats.name)
                    .appFont(.sansSemiBold, size: 16)
                    .foregroundColor(.mainTextColor)

                Text("Побед: \(stats.wins)   Поражений: \(stats.losses)   Ничьих: \(stats.draws)")
                    .appFont(.sansRegular, size: 12)
                    .foregroundColor(.secondaryTextColor)
            }

            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.grayApp)
        )
    }
}

