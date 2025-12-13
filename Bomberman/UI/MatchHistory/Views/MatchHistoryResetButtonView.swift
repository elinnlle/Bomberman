//
//  MatchHistoryResetButtonView.swift
//  Bomberman
//

import SwiftUI

struct MatchHistoryResetButtonView: View {
    let onReset: () -> Void

    var body: some View {
        Button(action: onReset) {
            Text("Сбросить историю")
                .appFont(.sansSemiBold, size: 16)
                .foregroundColor(.mainTextColor)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.grayApp)
                .cornerRadius(14)
        }
    }
}
