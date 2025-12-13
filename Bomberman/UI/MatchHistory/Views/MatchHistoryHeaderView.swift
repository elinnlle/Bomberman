//
//  MatchHistoryHeaderView.swift
//  Bomberman
//

import SwiftUI

struct MatchHistoryHeaderView: View {
    var body: some View {
        VStack(spacing: 6) {
            Text("История матчей")
                .appFont(.sansBold, size: 24)
                .foregroundColor(.mainTextColor)

            Text("Результаты ваших раундов")
                .appFont(.sansRegular, size: 14)
                .foregroundColor(.secondaryTextColor)
        }
    }
}
