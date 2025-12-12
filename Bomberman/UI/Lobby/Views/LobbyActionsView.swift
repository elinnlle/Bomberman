//
//  LobbyActionsView.swift
//  Bomberman
//

import SwiftUI

struct LobbyActionsView: View {
    let isReady: Bool
    let onToggleReady: () -> Void
    let onStartDemoRound: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            Button(action: onToggleReady) {
                Text(isReady ? "Отменить готовность" : "Готов к игре")
                    .appFont(.sansSemiBold, size: 18)
                    .foregroundColor(.mainTextColor)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isReady ? Color.lightGrayApp : Color.grayApp)
                    .cornerRadius(16)
            }

            Button(action: onStartDemoRound) {
                Text("Запустить раунд (демо)")
                    .appFont(.sansRegular, size: 14)
                    .foregroundColor(.secondaryTextColor)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
            }
        }
    }
}
