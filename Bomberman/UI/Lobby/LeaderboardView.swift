//
//  LeaderboardView.swift
//  Bomberman
//

import SwiftUI

struct LeaderboardView: View {
    @EnvironmentObject var gameClient: GameClient
    @State private var animateBg = false
    
    private var sortedStats: [PlayerStats] {
        gameClient.playerStats.values.sorted { $0.wins > $1.wins }
    }
    
    var body: some View {
        ZStack {
            animatedBackground
            
            VStack(spacing: 20) {
                header
                
                if sortedStats.isEmpty {
                    emptyState
                } else {
                    statsList
                        .animation(.easeInOut(duration: 0.35), value: sortedStats)
                }
                
                Spacer(minLength: 100)
            }
            .padding(.top, 24)
            
            VStack {
                Spacer()
                resetButton
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
            }
        }
        .ignoresSafeArea()
    }
}

// MARK: - Animated Background

private extension LeaderboardView {
    var animatedBackground: some View {
        ZStack {
            Color.blackApp
            
            LinearGradient(
                colors: [
                    Color.grayApp.opacity(0.50),
                    Color.blackApp.opacity(0.75)
                ],
                startPoint: animateBg ? .topLeading : .bottomTrailing,
                endPoint: animateBg ? .bottomTrailing : .topLeading
            )
            .animation(.easeInOut(duration: 6).repeatForever(), value: animateBg)
            .onAppear { animateBg = true }
            
            Circle()
                .fill(Color.lightGrayApp.opacity(0.18))
                .blur(radius: 85)
                .frame(width: 260, height: 260)
                .offset(x: animateBg ? -90 : 110, y: animateBg ? -40 : 80)
                .animation(.easeInOut(duration: 7).repeatForever(), value: animateBg)
            
            Circle()
                .fill(Color.grayApp.opacity(0.14))
                .blur(radius: 110)
                .frame(width: 300, height: 300)
                .offset(x: animateBg ? 120 : -120, y: animateBg ? 100 : -90)
                .animation(.easeInOut(duration: 8).repeatForever(), value: animateBg)
        }
    }
}

// MARK: - Header

private extension LeaderboardView {
    var header: some View {
        VStack(spacing: 6) {
            Text("Статистика раундов")
                .appFont(.sansBold, size: 24)
                .foregroundColor(.mainTextColor)
            
            Text("Результаты ваших игр")
                .appFont(.sansRegular, size: 14)
                .foregroundColor(.secondaryTextColor)
        }
    }
}

// MARK: - Stats List

private extension LeaderboardView {
    var statsList: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(Array(sortedStats.enumerated()), id: \.element.id) { index, stats in
                    leaderboardCard(for: stats, rank: index + 1)
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    func leaderboardCard(for stats: PlayerStats, rank: Int) -> some View {
        HStack(spacing: 14) {
            Text("#\(rank)")
                .appFont(.sansSemiBold, size: 16)
                .foregroundColor(.mainTextColor.opacity(0.8))
                .frame(width: 38, alignment: .leading)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(stats.name)
                    .appFont(.sansSemiBold, size: 16)
                    .foregroundColor(.mainTextColor)
                
                Text("Побед: \(stats.wins)   Поражений: \(stats.losses)   Ничьих: \(stats.draws)")
                    .appFont(.sansRegular, size: 12)
                    .foregroundColor(.secondaryTextColor)
            }
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.grayApp)
        )
    }
}

// MARK: - Reset Button

private extension LeaderboardView {
    var resetButton: some View {
        Button {
            gameClient.playerStats.removeAll()
        } label: {
            Text("Сбросить статистику")
                .appFont(.sansSemiBold, size: 16)
                .foregroundColor(.mainTextColor)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.grayApp)
                .cornerRadius(14)
        }
    }
}

// MARK: - Empty State

private extension LeaderboardView {
    var emptyState: some View {
        VStack(spacing: 12) {
            Text("Нет данных для отображения")
                .appFont(.sansSemiBold, size: 18)
                .foregroundColor(.orangeAccent)
            
            Text("Сыграйте хотя бы один раунд.")
                .appFont(.sansRegular, size: 14)
                .foregroundColor(.secondaryTextColor)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 60)
    }
}
