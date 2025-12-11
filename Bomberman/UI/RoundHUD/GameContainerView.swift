//
//  GameContainerView.swift
//  Bomberman
//

import SwiftUI

struct GameContainerView: View {
    @EnvironmentObject var gameClient: GameClient
    
    var body: some View {
        ZStack {
            GameSceneView()
            RoundHUDView()
        }
        .background(Color.blackApp.ignoresSafeArea())
    }
}
