//
//  MatchHistoryRowView.swift
//  Bomberman
//

import SwiftUI

struct MatchHistoryRowView: View {
    let entry: RoundHistoryEntry

    var body: some View {
        HStack(spacing: 12) {
            icon

            VStack(alignment: .leading, spacing: 4) {
                Text(entry.result.title)
                    .appFont(.sansSemiBold, size: 16)
                    .foregroundColor(.mainTextColor)

                Text(entry.formattedDate)
                    .appFont(.sansRegular, size: 12)
                    .foregroundColor(.secondaryTextColor)

                ProgressView(value: 1)
                    .opacity(0)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                resultBadge

                Text(entry.formattedDuration)
                    .appFont(.sansRegular, size: 12)
                    .foregroundColor(.secondaryTextColor)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.grayApp)
        )
    }

    private var icon: some View {
        ZStack {
            Circle()
                .fill(color.opacity(0.25))
                .frame(width: 40, height: 40)

            Image(systemName: iconName)
                .foregroundColor(.mainTextColor)
        }
    }

    private var iconName: String {
        switch entry.result {
        case .victory: return "star.fill"
        case .defeat: return "xmark"
        case .draw: return "equal"
        }
    }

    private var color: Color {
        switch entry.result {
        case .victory: return .greenAccent
        case .defeat: return .redAccent
        case .draw: return .yellowAccent
        }
    }

    private var resultBadge: some View {
        Text(entry.result.title)
            .appFont(.sansRegular, size: 12)
            .foregroundColor(.mainTextColor)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(
                Capsule().fill(color.opacity(0.25))
            )
    }
}
