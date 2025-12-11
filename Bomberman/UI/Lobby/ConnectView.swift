//
//  ConnectView.swift
//  Bomberman
//

import SwiftUI

struct ConnectView: View {
    @EnvironmentObject var gameClient: GameClient
    
    @State private var name: String = ""
    @State private var selectedRole: PlayerRole = .player
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Bomberman")
                .appFont(.sansBold, size: 32)
                .foregroundColor(.mainTextColor)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Имя")
                    .appFont(.sansRegular, size: 16)
                    .foregroundColor(.secondaryTextColor)
                
                ZStack(alignment: .leading) {
                    if name.isEmpty {
                        Text("Введите имя")
                            .appFont(.sansRegular, size: 16)
                            .foregroundColor(.placeholderApp)
                    }
                    
                    TextField("", text: $name)
                        .appFont(.sansRegular, size: 16)
                        .foregroundColor(.mainTextColor)
                }
                .padding()
                .background(Color.cardBackgroundApp)
                .cornerRadius(12)

            }
            .padding(.horizontal, 24)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Роль")
                    .appFont(.sansRegular, size: 16)
                    .foregroundColor(.secondaryTextColor)
                
                Picker("", selection: $selectedRole) {
                    ForEach(PlayerRole.allCases) { role in
                        Text(role.title)
                            .tag(role)
                    }
                }
                .pickerStyle(.segmented)
            }
            .padding(.horizontal, 24)
            
            Button {
                gameClient.connect(name: name, role: selectedRole)
            } label: {
                Text(buttonTitle)
                    .appFont(.sansSemiBold, size: 18)
                    .foregroundColor(.mainTextColor)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(canConnect ? Color.grayApp : Color.grayApp.opacity(0.5))
                    .cornerRadius(16)
            }
            .disabled(!canConnect)
            .padding(.horizontal, 24)
            
            if case let .failed(message) = gameClient.connectionState {
                Text(message)
                    .appFont(.sansRegular, size: 14)
                    .foregroundColor(.redAccent)
                    .padding(.horizontal, 24)
            }
            
            Spacer()
        }
        .padding(.top, 60)
    }
    
    private var canConnect: Bool {
        if selectedRole == .spectator {
            return true
        }
        return !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private var buttonTitle: String {
        switch gameClient.connectionState {
        case .connecting:
            return "Подключение..."
        default:
            return "Подключиться"
        }
    }
}
