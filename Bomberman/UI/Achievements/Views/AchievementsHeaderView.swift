//
//  AchievementsHeaderView.swift
//  Bomberman
//

import SwiftUI

struct AchievementsHeaderView: View {
    let playerName: String

    var body: some View {
        VStack(spacing: 4) {
            Text("Достижения")
                .appFont(.sansBold, size: 22)
                .foregroundColor(.mainTextColor)

            Text("Игрок: \(playerName)")
                .appFont(.sansRegular, size: 14)
                .foregroundColor(.secondaryTextColor)
        }
        .frame(maxWidth: .infinity)
        .multilineTextAlignment(.center)
    }
}
