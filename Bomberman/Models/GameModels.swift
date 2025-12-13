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

struct PlayerStats: Identifiable, Equatable {
    let id: String
    var name: String
    var wins: Int
    var losses: Int
    var draws: Int
    
    var gamesPlayed: Int {
        wins + losses + draws
    }
}

// MARK: - Game State Models

enum TileType: String, Equatable {
    case empty = " "
    case wall = "#"
    case brick = "."
    case startPosition = "p"
}

struct GameMap: Equatable {
    let width: Int
    let height: Int
    let tiles: [[TileType]]
    
    init(from serverMap: [[String]]) {
        self.height = serverMap.count
        self.width = serverMap.first?.count ?? 0
        self.tiles = serverMap.map { row in
            row.map { char in
                TileType(rawValue: char) ?? .empty
            }
        }
    }
    
    func tile(at x: Int, y: Int) -> TileType? {
        guard y >= 0, y < height, x >= 0, x < width else { return nil }
        return tiles[y][x]
    }
}

struct BombPosition: Equatable {
    let x: Int
    let y: Int
}

struct ExplosionPosition: Equatable {
    let x: Int
    let y: Int
}

struct PlayerPosition: Identifiable, Equatable {
    let id: String
    let name: String
    let x: Int
    let y: Int
    let alive: Bool
    let ready: Bool
}

enum GameStateType: String, Equatable {
    case waiting = "WAITING"
    case inProgress = "IN_PROGRESS"
    case gameOver = "GAME_OVER"
}

struct GameState: Equatable {
    let state: GameStateType
    let winner: String?
    let timeRemaining: TimeInterval?
    let map: GameMap
    let players: [PlayerPosition]
    let bombs: [BombPosition]
    let explosions: [ExplosionPosition]
    
    init?(from json: [String: Any]) {
        guard let stateString = json["state"] as? String,
              let stateType = GameStateType(rawValue: stateString),
              let mapArray = json["map"] as? [[String]],
              let playersArray = json["players"] as? [[String: Any]],
              let bombsArray = json["bombs"] as? [[String: Any]],
              let explosionsArray = json["explosions"] as? [[String: Any]] else {
            return nil
        }
        
        self.state = stateType
        self.winner = json["winner"] as? String
        self.timeRemaining = json["time_remaining"] as? TimeInterval
        self.map = GameMap(from: mapArray)
        
        self.players = playersArray.compactMap { playerDict in
            guard let id = playerDict["id"] as? String,
                  let name = playerDict["name"] as? String,
                  let x = playerDict["x"] as? Int,
                  let y = playerDict["y"] as? Int,
                  let alive = playerDict["alive"] as? Bool,
                  let ready = playerDict["ready"] as? Bool else {
                return nil
            }
            return PlayerPosition(id: id, name: name, x: x, y: y, alive: alive, ready: ready)
        }
        
        self.bombs = bombsArray.compactMap { bombDict in
            guard let x = bombDict["x"] as? Int,
                  let y = bombDict["y"] as? Int else {
                return nil
            }
            return BombPosition(x: x, y: y)
        }
        
        self.explosions = explosionsArray.compactMap { expDict in
            guard let x = expDict["x"] as? Int,
                  let y = expDict["y"] as? Int else {
                return nil
            }
            return ExplosionPosition(x: x, y: y)
        }
    }
}
