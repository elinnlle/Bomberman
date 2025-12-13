//
//  RoundHUDView.swift
//  Bomberman
//

import SwiftUI

struct RoundHUDView: View {
    @EnvironmentObject var gameClient: GameClient
    @StateObject private var viewModel: RoundHUDViewModel

    init() {
        _viewModel = StateObject(
            wrappedValue: RoundHUDViewModel(gameClient: GameClient.shared)
        )
    }

    var body: some View {
        VStack {
            HStack {
                RoundTimerView(timeText: viewModel.timeText)

                Spacer()

                // Показываем кнопку "Сдаться" только для игроков, не для наблюдателей
                if gameClient.me?.role != .spectator {
                    RoundSurrenderButton {
                        viewModel.surrender()
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)

            Spacer()

            if viewModel.shouldShowResult,
               let result = viewModel.roundResult {
                let isSpectator = gameClient.me?.role == .spectator || gameClient.myPlayerId == nil
                RoundResultOverlayView(
                    result: result,
                    gameWinner: gameClient.gameWinner,
                    isSpectator: isSpectator,
                    onBackToLobby: viewModel.backToLobby
                )
                .padding(.bottom, 40)
            }
        }
        .padding(.top, 8)
        .onChange(of: gameClient.roundTimeRemaining) { _, _ in
            viewModel.updateTime()
        }
    }
}
