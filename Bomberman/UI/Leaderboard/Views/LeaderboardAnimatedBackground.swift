//
//  LeaderboardAnimatedBackground.swift
//  Bomberman
//

import SwiftUI

struct LeaderboardAnimatedBackground: View {
    @Binding var animate: Bool

    var body: some View {
        ZStack {
            Color.blackApp

            LinearGradient(
                colors: [
                    Color.grayApp.opacity(0.50),
                    Color.blackApp.opacity(0.75)
                ],
                startPoint: animate ? .topLeading : .bottomTrailing,
                endPoint: animate ? .bottomTrailing : .topLeading
            )
            .animation(.easeInOut(duration: 6).repeatForever(), value: animate)

            Circle()
                .fill(Color.lightGrayApp.opacity(0.18))
                .blur(radius: 85)
                .frame(width: 260, height: 260)
                .offset(x: animate ? -90 : 110,
                        y: animate ? -40 : 80)
                .animation(.easeInOut(duration: 7).repeatForever(), value: animate)

            Circle()
                .fill(Color.grayApp.opacity(0.14))
                .blur(radius: 110)
                .frame(width: 300, height: 300)
                .offset(x: animate ? 120 : -120,
                        y: animate ? 100 : -90)
                .animation(.easeInOut(duration: 8).repeatForever(), value: animate)
        }
    }
}
