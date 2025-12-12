//
//  TutorialContentView.swift
//  Bomberman
//

import SwiftUI

struct TutorialContentView: View {
    let page: TutorialPage

    var body: some View {
        VStack(spacing: 16) {
            Text(page.title)
                .appFont(.sansBold, size: 24)
                .foregroundColor(.mainTextColor)
                .multilineTextAlignment(.center)

            Text(page.message)
                .appFont(.sansRegular, size: 16)
                .foregroundColor(.secondaryTextColor)
                .multilineTextAlignment(.center)
        }
    }
}
