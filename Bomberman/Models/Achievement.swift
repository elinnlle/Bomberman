//
//  Achievement.swift
//  Bomberman
//

import Foundation

struct Achievement: Identifiable {
    let id: String
    let title: String
    let description: String
    let current: Int
    let target: Int

    var progress: Double {
        guard target > 0 else { return 0 }
        return min(1.0, Double(current) / Double(target))
    }

    var isUnlocked: Bool {
        current >= target
    }
}
