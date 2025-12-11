//
//  GameSceneView.swift
//  Bomberman
//

import SwiftUI

struct GameSceneView: View {
    var body: some View {
        ZStack {
            Color.grayApp
            Text("Здесь будет игровое поле (SpriteKit)")
                .appFont(.sansRegular, size: 16)
                .foregroundColor(.secondaryTextColor)
        }
    }
}
