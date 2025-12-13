//
//  RoundResultOverlayView.swift
//  Bomberman
//

import SwiftUI

struct RoundResultOverlayView: View {
    let result: RoundResult
    let gameWinner: String?
    let isSpectator: Bool
    let onBackToLobby: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            Text(title)
                .appFont(.sansBold, size: 28)
                .foregroundColor(.mainTextColor)
            
            // Для наблюдателей показываем имя победителя, если есть
            if isSpectator, let winner = gameWinner {
                Text("Победитель: \(winner)")
                    .appFont(.sansSemiBold, size: 18)
                    .foregroundColor(.secondaryTextColor)
            }

            Button(action: onBackToLobby) {
                Text("Назад в лобби")
                    .appFont(.sansSemiBold, size: 16)
                    .foregroundColor(.mainTextColor)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                    .background(Color.grayApp)
                    .cornerRadius(16)
            }
        }
        .padding()
        .background(Color.blackApp.opacity(0.8))
        .cornerRadius(20)
        .padding(.horizontal, 24)
    }

    private var title: String {
        // Для наблюдателей показываем правильный результат
        if isSpectator {
            if let winner = gameWinner, !winner.isEmpty {
                return "Игра завершена"
            } else {
                return "Ничья"
            }
        }
        
        // Для игроков показываем личный результат
        switch result {
        case .victory: return "Победа!"
        case .defeat: return "Поражение"
        case .draw: return "Ничья"
        }
    }
}
