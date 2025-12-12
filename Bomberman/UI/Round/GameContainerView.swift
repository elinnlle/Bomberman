//
//  GameContainerView.swift
//  Bomberman
//

import SwiftUI

struct GameContainerView: View {
    var body: some View {
        ZStack {
            GameSceneView()
            RoundHUDView()
        }
        .background(Color.blackApp.ignoresSafeArea())
    }
}
