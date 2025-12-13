//
//  RoundResult+Presentation.swift
//  Bomberman
//

import SwiftUI

extension RoundResult {
    var title: String {
        switch self {
        case .victory: return "Победа"
        case .defeat: return "Поражение"
        case .draw: return "Ничья"
        }
    }

    var accentColor: Color {
        switch self {
        case .victory: return .greenAccent
        case .defeat: return .redAccent
        case .draw: return .yellowAccent
        }
    }

    var iconName: String {
        switch self {
        case .victory: return "star.fill"
        case .defeat: return "xmark"
        case .draw: return "equal"
        }
    }
}
