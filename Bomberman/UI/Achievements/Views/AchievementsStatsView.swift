//
//  AchievementsStatsView.swift
//  Bomberman
//

import SwiftUI

struct AchievementsStatsView: View {
    let stats: PlayerStats

    var body: some View {
        HStack(spacing: 12) {
            tile("Матчей", stats.gamesPlayed)
            tile("Победы", stats.wins)
            tile("Поражения", stats.losses)
            tile("Ничьи", stats.draws)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.grayApp)
        )
    }

    private func tile(_ title: String, _ value: Int) -> some View {
        VStack(spacing: 4) {
            Text("\(value)")
                .appFont(.sansBold, size: 18)
                .foregroundColor(.mainTextColor)

            Text(title)
                .appFont(.sansRegular, size: 11)
                .foregroundColor(.secondaryTextColor)
        }
        .frame(maxWidth: .infinity)
    }
}
