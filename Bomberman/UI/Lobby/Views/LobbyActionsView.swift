//
//  LobbyActionsView.swift
//  Bomberman
//

import SwiftUI

struct LobbyActionsView: View {
    let isReady: Bool
    let onToggleReady: () -> Void

    var body: some View {
        Button(action: onToggleReady) {
            Text(isReady ? "Отменить готовность" : "Готов к игре")
                .appFont(.sansSemiBold, size: 18)
                .foregroundColor(.mainTextColor)
                .frame(maxWidth: .infinity)
                .padding()
                .background(isReady ? Color.lightGrayApp : Color.grayApp)
                .cornerRadius(16)
        }
    }
}
