//
//  LeaderboardHeaderView.swift
//  Bomberman
//

import SwiftUI

struct LeaderboardHeaderView: View {
    var body: some View {
        VStack(spacing: 6) {
            Text("Статистика раундов")
                .appFont(.sansBold, size: 24)
                .foregroundColor(.mainTextColor)

            Text("Результаты ваших игр")
                .appFont(.sansRegular, size: 14)
                .foregroundColor(.secondaryTextColor)
        }
    }
}
