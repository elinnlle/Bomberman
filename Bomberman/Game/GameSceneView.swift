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
        }
    }
    
    private func updateScene() {
        if let state = gameClient.gameState {
            sceneHolder.scene.update(with: state, myPlayerId: gameClient.myPlayerId)
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
