//
//  LeaderboardResetButtonView.swift
//  Bomberman
//

import SwiftUI

struct LeaderboardResetButtonView: View {
    let onReset: () -> Void

    var body: some View {
        Button(action: onReset) {
            Text("Сбросить статистику")
                .appFont(.sansSemiBold, size: 16)
                .foregroundColor(.mainTextColor)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.grayApp)
                .cornerRadius(14)
        }
    }
}
