//
//  LobbyView.swift
//  Bomberman
//

import SwiftUI

struct LobbyView: View {
    @EnvironmentObject var gameClient: GameClient
    @State private var showLeaderboard = false
    @State private var selectedPlayerForAchievements: PlayerSummary?
    
    var body: some View {
        VStack(spacing: 16) {
            
            HStack(spacing: 12) {
                Text("Комната")
                    .appFont(.sansBold, size: 24)
                    .foregroundColor(.mainTextColor)
                
                Spacer()
                
                Button {
                    showLeaderboard = true
                } label: {
                    Text("Статистика")
                        .appFont(.sansRegular, size: 14)
                        .foregroundColor(.secondaryTextColor)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.lightGrayApp)
                        .cornerRadius(10)
                }
                
                Button {
                    gameClient.leaveRoom()
                } label: {
                    Text("Выйти")
                        .appFont(.sansRegular, size: 14)
                        .foregroundColor(.secondaryTextColor)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.lightGrayApp)
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            
            if let me = gameClient.me {
                HStack {
                    Text("Вы: \(me.name) • \(me.role.title)")
                        .appFont(.sansRegular, size: 16)
                        .foregroundColor(.secondaryTextColor)
                    Spacer()
                }
                .padding(.horizontal, 24)
            }
            
            VStack(spacing: 12) {
                ForEach(gameClient.players) { player in
                    playerCard(player)
                }
            }
            .padding(.horizontal, 24)
            
            Spacer()
            
            VStack(spacing: 12) {
                Button {
                    gameClient.toggleReady()
                } label: {
                    Text(gameClient.isReady ? "Отменить готовность" : "Готов к игре")
                        .appFont(.sansSemiBold, size: 18)
                        .foregroundColor(.mainTextColor)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(gameClient.isReady ? Color.lightGrayApp : Color.grayApp)
                        .cornerRadius(16)
                }
                
                Button {
                    // Для демо запускаем локальный раунд, пока нет настоящего сервера
                    gameClient.startRoundLocallyForDemo()
                } label: {
                    Text("Запустить раунд (демо)")
                        .appFont(.sansRegular, size: 14)
                        .foregroundColor(.secondaryTextColor)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
        .background(Color.blackApp.ignoresSafeArea())
        .sheet(isPresented: $showLeaderboard) {
            LeaderboardView()
                .environmentObject(gameClient)
        }
        .sheet(item: $selectedPlayerForAchievements) { player in
            AchievementsView(player: player)
                .environmentObject(gameClient)
        }
    }
}

private extension LobbyView {
    func playerCard(_ player: PlayerSummary) -> some View {
        let statusColor: Color = player.readyStatus == .ready ? .green : .secondaryTextColor
        
        return HStack(spacing: 14) {
            VStack(alignment: .leading, spacing: 4) {
                Text(player.name)
                    .appFont(.sansSemiBold, size: 16)
                    .foregroundColor(.mainTextColor)
                
                Text(player.role.title)
                    .appFont(.sansRegular, size: 12)
                    .foregroundColor(.secondaryTextColor)
                
                HStack(spacing: 6) {
                    Text(player.readyStatus == .ready ? "Готов" : "Не готов")
                        .appFont(.sansRegular, size: 14)
                        .foregroundColor(statusColor)

                    if player.isMe {
                        Text("•")
                            .foregroundColor(.secondaryTextColor)
                        
                        Text("Вы")
                            .appFont(.sansRegular, size: 14)
                            .foregroundColor(.secondaryTextColor)
                    }
                }
            }
            
            Spacer()
            
            Button {
                selectedPlayerForAchievements = player
            } label: {
                Image(systemName: "trophy.fill")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.mainTextColor)
                    .padding(8)
                    .background(Color.lightGrayApp)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.grayApp)
        )
    }
}
