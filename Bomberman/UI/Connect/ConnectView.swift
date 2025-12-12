//
//  ConnectView.swift
//  Bomberman
//

import SwiftUI

struct ConnectView: View {
    @EnvironmentObject var gameClient: GameClient
    @StateObject private var viewModel: ConnectViewModel

    init() {
        _viewModel = StateObject(
            wrappedValue: ConnectViewModel(gameClient: GameClient.shared)
        )
    }

    var body: some View {
        VStack(spacing: 24) {
            ConnectTitleView()

            ConnectNameInputView(name: $viewModel.name)

            ConnectRolePickerView(selectedRole: $viewModel.selectedRole)

            ConnectButtonView(
                title: viewModel.buttonTitle,
                isEnabled: viewModel.canConnect,
                onTap: viewModel.connect
            )

            if let error = viewModel.errorMessage {
                ConnectErrorView(message: error)
            }

            Spacer()
        }
        .padding(.top, 60)
    }
}
