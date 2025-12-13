//
//  RoundSurrenderButton.swift
//  Bomberman
//

import SwiftUI

struct RoundSurrenderButton: View {
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            Text("Сдаться")
                .appFont(.sansRegular, size: 14)
                .foregroundColor(.secondaryTextColor)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.blackApp.opacity(0.6))
                .cornerRadius(10)
        }
    }
}
