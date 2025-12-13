//
//  SpectatorMetricsView.swift
//  Bomberman
//

import SwiftUI

struct SpectatorMetricsView: View {
    @EnvironmentObject var gameClient: GameClient
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Статистика матча")
                .appFont(.sansBold, size: 20)
                .foregroundColor(.mainTextColor)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if let gameState = gameClient.gameState {
                // Метрики в сетке
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 12) {
                    MetricCard(
                        title: "Живых игроков",
                        value: "\(alivePlayersCount(from: gameState))",
                        icon: "person.2.fill",
                        color: .green
                    )
                    
                    MetricCard(
                        title: "Бомб на карте",
                        value: "\(gameState.bombs.count)",
                        icon: "flame.fill",
                        color: .red
                    )
                    
                    MetricCard(
                        title: "Активных взрывов",
                        value: "\(gameState.explosions.count)",
                        icon: "burst.fill",
                        color: .orange
                    )
                    
                    MetricCard(
                        title: "Осталось стен",
                        value: "\(destroyedWallsCount(from: gameState))",
                        icon: "square.grid.2x2.fill",
                        color: .blue
                    )
                }
                
                // Время раунда
                if gameState.state == .inProgress, let timeRemaining = gameState.timeRemaining {
                    HStack {
                        Image(systemName: "clock.fill")
                            .foregroundColor(.secondaryTextColor)
                        Text("Осталось времени: \(formatTime(timeRemaining))")
                            .appFont(.sansSemiBold, size: 16)
                            .foregroundColor(.mainTextColor)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.grayApp)
                    .cornerRadius(12)
                }
                
                // Статус игры
                StatusBadge(state: gameState.state)
                
                // Список игроков с их статусами
                if !gameState.players.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Игроки")
                            .appFont(.sansSemiBold, size: 16)
                            .foregroundColor(.mainTextColor)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        ForEach(gameState.players) { player in
                            PlayerStatusRow(player: player)
                        }
                    }
                    .padding()
                    .background(Color.grayApp)
                    .cornerRadius(12)
                }
            } else {
                // Показываем метрики лобби
                LobbyMetricsView()
            }
        }
        .padding()
        .background(Color.grayApp.opacity(0.3))
        .cornerRadius(16)
    }
    
    private func alivePlayersCount(from state: GameState) -> Int {
        state.players.filter { $0.alive }.count
    }
    
    private func destroyedWallsCount(from state: GameState) -> Int {
        // Подсчитываем оставшиеся разрушаемые стены
        let remainingBricks = state.map.tiles.flatMap { $0 }.filter { $0 == .brick }.count
        return remainingBricks
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let total = Int(max(0, time))
        let minutes = total / 60
        let seconds = total % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct MetricCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
            
            Text(value)
                .appFont(.sansBold, size: 24)
                .foregroundColor(.mainTextColor)
            
            Text(title)
                .appFont(.sansRegular, size: 12)
                .foregroundColor(.secondaryTextColor)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.grayApp)
        .cornerRadius(12)
    }
}

struct StatusBadge: View {
    let state: GameStateType
    
    var body: some View {
        HStack {
            Circle()
                .fill(statusColor)
                .frame(width: 8, height: 8)
            
            Text(statusText)
                .appFont(.sansSemiBold, size: 14)
                .foregroundColor(.mainTextColor)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(statusColor.opacity(0.2))
        .cornerRadius(8)
    }
    
    private var statusText: String {
        switch state {
        case .waiting:
            return "Ожидание игроков"
        case .inProgress:
            return "Игра идет"
        case .gameOver:
            return "Игра завершена"
        }
    }
    
    private var statusColor: Color {
        switch state {
        case .waiting:
            return .yellow
        case .inProgress:
            return .green
        case .gameOver:
            return .red
        }
    }
}

struct PlayerStatusRow: View {
    let player: PlayerPosition
    
    var body: some View {
        HStack {
            Circle()
                .fill(player.alive ? Color.green : Color.red)
                .frame(width: 8, height: 8)
            
            Text(player.name)
                .appFont(.sansRegular, size: 14)
                .foregroundColor(.mainTextColor)
            
            Spacer()
            
            Text(player.alive ? "Жив" : "Мертв")
                .appFont(.sansRegular, size: 12)
                .foregroundColor(player.alive ? .green : .red)
        }
        .padding(.vertical, 4)
    }
}

struct LobbyMetricsView: View {
    @EnvironmentObject var gameClient: GameClient
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Игроков в комнате")
                        .appFont(.sansRegular, size: 12)
                        .foregroundColor(.secondaryTextColor)
                    Text("\(gameClient.players.count)")
                        .appFont(.sansBold, size: 20)
                        .foregroundColor(.mainTextColor)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Готовы к игре")
                        .appFont(.sansRegular, size: 12)
                        .foregroundColor(.secondaryTextColor)
                    Text("\(readyPlayersCount)")
                        .appFont(.sansBold, size: 20)
                        .foregroundColor(.green)
                }
            }
            .padding()
            .background(Color.grayApp)
            .cornerRadius(12)
            
            // Список игроков в лобби
            if !gameClient.players.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Игроки")
                        .appFont(.sansSemiBold, size: 16)
                        .foregroundColor(.mainTextColor)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    ForEach(gameClient.players) { player in
                        HStack {
                            Circle()
                                .fill(player.readyStatus == .ready ? Color.green : Color.yellow)
                                .frame(width: 8, height: 8)
                            
                            Text(player.name)
                                .appFont(.sansRegular, size: 14)
                                .foregroundColor(.mainTextColor)
                            
                            Spacer()
                            
                            Text(player.readyStatus == .ready ? "Готов" : "Не готов")
                                .appFont(.sansRegular, size: 12)
                                .foregroundColor(player.readyStatus == .ready ? .green : .secondaryTextColor)
                        }
                        .padding(.vertical, 4)
                    }
                }
                .padding()
                .background(Color.grayApp)
                .cornerRadius(12)
            }
        }
    }
    
    private var readyPlayersCount: Int {
        gameClient.players.filter { $0.readyStatus == .ready }.count
    }
}

