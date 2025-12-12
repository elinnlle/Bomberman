//
//  LeaderboardEmptyStateView.swift
//  Bomberman
//

import SwiftUI

struct LeaderboardEmptyStateView: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("Нет данных для отображения")
                .appFont(.sansSemiBold, size: 18)
                .foregroundColor(.orangeAccent)

            Text("Сыграйте хотя бы один раунд.")
                .appFont(.sansRegular, size: 14)
                .foregroundColor(.secondaryTextColor)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 60)
    }
}
