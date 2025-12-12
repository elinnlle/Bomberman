//
//  TutorialPageDotsView.swift
//  Bomberman
//

import SwiftUI

struct TutorialPageDotsView: View {
    let count: Int
    let currentIndex: Int
    let accentColor: Color

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<count, id: \.self) { index in
                let isActive = index == currentIndex
                Circle()
                    .fill(isActive ? accentColor : Color.secondaryTextColor.opacity(0.4))
                    .frame(width: isActive ? 10 : 6, height: isActive ? 10 : 6)
                    .animation(.easeInOut(duration: 0.2), value: currentIndex)
            }
        }
    }
}
