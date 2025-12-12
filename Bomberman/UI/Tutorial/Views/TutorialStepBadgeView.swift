//
//  TutorialStepBadgeView.swift
//  Bomberman
//

import SwiftUI

struct TutorialStepBadgeView: View {
    let text: String

    var body: some View {
        Text(text)
            .appFont(.sansRegular, size: 13)
            .foregroundColor(.secondaryTextColor)
            .padding(.horizontal, 14)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(Color.grayApp.opacity(0.9))
            )
    }
}
