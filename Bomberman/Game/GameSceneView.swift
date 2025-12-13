//
//  GameSceneView.swift
//  Bomberman
//

import SwiftUI
import SpriteKit

struct GameSceneView: View {
    @EnvironmentObject var gameClient: GameClient
    
    @StateObject private var sceneHolder = GameSceneHolder()
    
    var body: some View {
        GeometryReader { geometry in
            // Показываем сцену только если есть gameState и мы в раунде
            if gameClient.gameState != nil && 
               (gameClient.roundPhase == .running || gameClient.roundPhase == .finished) {
                SpriteView(scene: sceneHolder.scene, options: [.ignoresSiblingOrder])
                    .ignoresSafeArea()
                    .onAppear {
                        sceneHolder.scene.size = geometry.size
                        updateScene()
                    }
                    .onChange(of: geometry.size) { _, newSize in
                        sceneHolder.scene.size = newSize
                    }
                    .onChange(of: gameClient.gameState) { _, _ in
                        updateScene()
                    }
                    .onChange(of: gameClient.roundPhase) { _, _ in
                        if gameClient.roundPhase == .notInRound {
                            sceneHolder.scene.reset()
                        }
                    }
            } else {
                // Пустой view когда нет игры
                Color.clear
                    .onAppear {
                        sceneHolder.scene.reset()
                    }
            }
        }
    }
    
    private func updateScene() {
        if let state = gameClient.gameState {
            sceneHolder.scene.update(with: state, myPlayerId: gameClient.myPlayerId)
        } else {
            sceneHolder.scene.reset()
        }
    }
}

final class GameSceneHolder: ObservableObject {
    let scene: GameScene
    
    init() {
        let scene = GameScene()
        scene.scaleMode = .resizeFill
        scene.backgroundColor = SKColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        self.scene = scene
    }
}
