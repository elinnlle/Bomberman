//
//  AchievementRowView.swift
//  Bomberman
//

import SwiftUI

struct AchievementRowView: View {
    let achievement: Achievement

    var body: some View {
        HStack(spacing: 12) {
            icon

            VStack(alignment: .leading, spacing: 4) {
                Text(achievement.title)
                    .appFont(.sansSemiBold, size: 16)
                    .foregroundColor(.mainTextColor)

                Text(achievement.description)
                    .appFont(.sansRegular, size: 12)
                    .foregroundColor(.secondaryTextColor)

                ProgressView(value: achievement.progress)
                    .tint(Color.blueAccent)
            }

            Spacer()

            Text("\(min(achievement.current, achievement.target))/\(achievement.target)")
                .appFont(.sansRegular, size: 12)
                .foregroundColor(.secondaryTextColor)
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
                .fill(achievement.isUnlocked ? Color.blueAccent : Color.lightGrayApp)
                .frame(width: 40, height: 40)

            Image(systemName: achievement.isUnlocked ? "star.fill" : "star")
                .foregroundColor(.mainTextColor)
        }
    }
}
