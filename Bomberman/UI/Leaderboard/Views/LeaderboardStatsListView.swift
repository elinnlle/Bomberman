//
//  LeaderboardStatsListView.swift
//  Bomberman
//

import SwiftUI

struct LeaderboardStatsListView: View {
    let stats: [PlayerStats]

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(Array(stats.enumerated()), id: \.element.id) {
                    LeaderboardCardView(
                        stats: $0.element,
                        rank: $0.offset + 1
                    )
                }
            }
            .padding(.horizontal, 20)
        }
    }
}
