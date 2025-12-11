//
//  RoundHUDView.swift
//  Bomberman
//

import SwiftUI

struct RoundHUDView: View {
    @EnvironmentObject var gameClient: GameClient
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Раунд")
                        .appFont(.sansRegular, size: 14)
                        .foregroundColor(.secondaryTextColor)
                    
                    Text(timeText)
                        .appFont(.sansBold, size: 24)
                        .foregroundColor(.mainTextColor)
                }
                
                Spacer()
                
                Button {
                    gameClient.finishRound(with: .defeat)
                } label: {
                    Text("Сдаться")
                        .appFont(.sansRegular, size: 14)
                        .foregroundColor(.secondaryTextColor)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.blackApp.opacity(0.6))
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            
            Spacer()
            
            if let result = gameClient.lastRoundResult,
               gameClient.roundPhase == .finished {
                resultView(result: result)
                    .padding(.bottom, 40)
            }
        }
        .padding(.top, 8)
    }
    
    private var timeText: String {
        let total = Int(max(0, gameClient.roundTimeRemaining))
        let minutes = total / 60
        let seconds = total % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func title(for result: RoundResult) -> String {
        switch result {
        case .victory: return "Победа!"
        case .defeat: return "Поражение"
        case .draw: return "Ничья"
        }
    }
    
    @ViewBuilder
    private func resultView(result: RoundResult) -> some View {
        VStack(spacing: 12) {
            Text(title(for: result))
                .appFont(.sansBold, size: 28)
                .foregroundColor(.mainTextColor)
            
            Button {
                gameClient.roundPhase = .notInRound
            } label: {
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
}
