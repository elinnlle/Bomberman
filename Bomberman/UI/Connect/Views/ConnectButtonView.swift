//
//  ConnectButtonView.swift
//  Bomberman
//

import SwiftUI

struct ConnectButtonView: View {
    let title: String
    let isEnabled: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            Text(title)
                .appFont(.sansSemiBold, size: 18)
                .foregroundColor(.mainTextColor)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    isEnabled
                        ? Color.grayApp
                        : Color.grayApp.opacity(0.5)
                )
                .cornerRadius(16)
        }
        .disabled(!isEnabled)
        .padding(.horizontal, 24)
    }
}

