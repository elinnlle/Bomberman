//
//  GameModels.swift
//  Bomberman
//

import Foundation

enum PlayerRole: String, CaseIterable, Identifiable {
    case player
    case spectator
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .player: return "Игрок"
        case .spectator: return "Наблюдатель"
        }
    }
}

enum PlayerReadyStatus: String {
    case notReady
    case ready
}

struct PlayerSummary: Identifiable, Equatable {
    let id: String
    let name: String
    let role: PlayerRole
    var readyStatus: PlayerReadyStatus
    var isMe: Bool
}

enum ConnectionState: Equatable {
    case disconnected
    case connecting
    case connected
    case failed(String)
}

enum RoundPhase: Equatable {
    case notInRound
    case countdown
    case running
    case finished
}

enum RoundResult: Equatable {
    case victory
    case defeat
    case draw
}

struct TutorialPage: Identifiable {
    let id = UUID()
    let title: String
    let message: String
}
