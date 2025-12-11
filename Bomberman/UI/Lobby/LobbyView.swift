//
//  LobbyView.swift
//  Bomberman
//

import SwiftUI

struct LobbyView: View {
    @EnvironmentObject var gameClient: GameClient
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Комната")
                    .appFont(.sansBold, size: 24)
                    .foregroundColor(.mainTextColor)
                
                Spacer()
                
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
            
            List {
                Section {
                    ForEach(gameClient.players) { player in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(player.name)
                                    .appFont(.sansSemiBold, size: 16)
                                    .foregroundColor(.mainTextColor)
                                
                                Text(player.role.title)
                                    .appFont(.sansRegular, size: 12)
                                    .foregroundColor(.secondaryTextColor)
                            }
                            
                            Spacer()
                            
                            Text(player.readyStatus == .ready ? "Готов" : "Не готов")
                                .appFont(.sansRegular, size: 14)
                                .foregroundColor(player.readyStatus == .ready ? .greenAccent : .secondaryTextColor)
                            
                            if player.isMe {
                                Text("Вы")
                                    .appFont(.sansRegular, size: 12)
                                    .foregroundColor(.secondaryTextColor)
                                    .padding(.leading, 4)
                            }
                        }
                        .listRowBackground(Color.grayApp)
                    }
                } header: {
                    Text("Игроки")
                        .appFont(.sansRegular, size: 14)
                        .foregroundColor(.secondaryTextColor)
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.blackApp)
            
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
    }
}
