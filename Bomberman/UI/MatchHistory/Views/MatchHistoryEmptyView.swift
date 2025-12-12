//
//  MatchHistoryEmptyView.swift
//  Bomberman
//

import SwiftUI

struct MatchHistoryEmptyView: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("История пока пуста")
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
