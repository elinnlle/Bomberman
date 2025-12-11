//
//  RootView.swift
//  Bomberman
//

import SwiftUI

struct RootView: View {
    @AppStorage("hasSeenTutorial") private var hasSeenTutorial = false
    @EnvironmentObject var gameClient: GameClient
    
    var body: some View {
        ZStack {
            Color.blackApp.ignoresSafeArea()
            
            Group {
                if !hasSeenTutorial {
                    TutorialView {
                        hasSeenTutorial = true
                    }
                } else if gameClient.connectionState != .connected {
                    ConnectView()
                } else if gameClient.roundPhase == .running || gameClient.roundPhase == .countdown || gameClient.roundPhase == .finished {
                    GameContainerView()
                } else {
                    LobbyView()
                }
            }
        }
    }
}
