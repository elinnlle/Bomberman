//
//  GameContainerView.swift
//  Bomberman
//

import SwiftUI

struct GameContainerView: View {
    @EnvironmentObject var gameClient: GameClient
    
    var body: some View {
        ZStack {
            // Игровое поле
            GameSceneView()
            
            // Оверлей с HUD и управлением
            VStack {
                // Верхняя часть — HUD
                RoundHUDView()
                
                Spacer()
                
                // Нижняя часть — управление (только если игрок живой и игра идёт)
                if shouldShowControls {
                    ControlsView()
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
            }
        }
        .background(Color.blackApp.ignoresSafeArea())
    }
    
    private var shouldShowControls: Bool {
        guard gameClient.roundPhase == .running else { return false }
        
        // Проверяем, жив ли наш игрок
        if let myId = gameClient.myPlayerId,
           let state = gameClient.gameState,
           let myPlayer = state.players.first(where: { $0.id == myId }) {
            return myPlayer.alive
        }
        
        return false
    }
}
