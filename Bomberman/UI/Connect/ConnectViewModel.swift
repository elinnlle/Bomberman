//
//  ConnectViewModel.swift
//  Bomberman
//

import Foundation

@MainActor
final class ConnectViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var selectedRole: PlayerRole = .player

    private let gameClient: GameClient

    init(gameClient: GameClient) {
        self.gameClient = gameClient
    }

    var canConnect: Bool {
        if selectedRole == .spectator {
            return true
        }
        return !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var buttonTitle: String {
        switch gameClient.connectionState {
        case .connecting:
            return "Подключение..."
        default:
            return "Подключиться"
        }
    }

    var errorMessage: String? {
        if case let .failed(message) = gameClient.connectionState {
            return message
        }
        return nil
    }

    func connect() {
        gameClient.connect(name: name, role: selectedRole)
    }
}
