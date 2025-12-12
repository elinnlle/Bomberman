//
//  RoundHistoryEntry.swift
//  Bomberman
//

import Foundation

struct RoundHistoryEntry: Identifiable {
    let id: UUID
    let playerId: String
    let result: RoundResult
    let duration: TimeInterval
    let date: Date

    init(
        playerId: String,
        result: RoundResult,
        duration: TimeInterval,
        date: Date = Date()
    ) {
        self.id = UUID()
        self.playerId = playerId
        self.result = result
        self.duration = duration
        self.date = date
    }

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    var formattedDuration: String {
        let total = Int(duration)
        let minutes = total / 60
        let seconds = total % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
