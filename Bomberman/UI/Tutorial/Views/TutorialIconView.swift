//
//  TutorialIconView.swift
//  Bomberman
//

import SwiftUI

struct TutorialIconView: View {
    let iconName: String
    let accentColor: Color
    let animate: Bool

    var body: some View {
        ZStack {
            Circle()
                .fill(accentColor.opacity(0.16))
                .frame(width: 140, height: 140)
                .shadow(color: accentColor.opacity(0.4), radius: 18, x: 0, y: 12)

            Image(systemName: iconName)
                .font(.system(size: 54, weight: .semibold))
                .foregroundColor(accentColor)
                .scaleEffect(animate ? 1.05 : 0.9)
                .offset(y: animate ? -4 : 4)
                .shadow(color: accentColor.opacity(0.7), radius: 14, x: 0, y: 10)
                .animation(
                    .easeInOut(duration: 1.2)
                        .repeatForever(autoreverses: true),
                    value: animate
                )
        }
        .padding(.top, 10)
        .padding(.bottom, 8)
    }
}

