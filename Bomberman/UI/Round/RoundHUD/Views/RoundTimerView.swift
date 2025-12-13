//
//  RoundTimerView.swift
//  Bomberman
//

import SwiftUI

struct RoundTimerView: View {
    let timeText: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Раунд")
                .appFont(.sansRegular, size: 14)
                .foregroundColor(.secondaryTextColor)

            Text(timeText)
                .appFont(.sansBold, size: 24)
                .foregroundColor(.mainTextColor)
        }
    }
}
