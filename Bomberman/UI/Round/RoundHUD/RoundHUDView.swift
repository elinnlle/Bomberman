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

                RoundSurrenderButton {
                    viewModel.surrender()
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)

            Spacer()

            if viewModel.shouldShowResult,
               let result = viewModel.roundResult {
                RoundResultOverlayView(
                    result: result,
                    onBackToLobby: viewModel.backToLobby
                )
                .padding(.bottom, 40)
            }
        }
        .padding(.top, 8)
        .onChange(of: gameClient.roundTimeRemaining) { _ in
            viewModel.updateTime()
        }
    }
}
