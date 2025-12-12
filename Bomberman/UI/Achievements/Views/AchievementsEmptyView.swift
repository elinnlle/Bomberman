//
//  AchievementsEmptyView.swift
//  Bomberman
//

import SwiftUI

struct AchievementsEmptyView: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("Пока нет достижений")
                .appFont(.sansSemiBold, size: 18)
                .foregroundColor(.orangeAccent)

            Text("Сыграйте хотя бы один раунд, чтобы начать получать достижения.")
                .appFont(.sansRegular, size: 14)
                .foregroundColor(.secondaryTextColor)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 40)
    }
}
