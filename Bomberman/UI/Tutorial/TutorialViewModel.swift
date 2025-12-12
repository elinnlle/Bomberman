//
//  TutorialViewModel.swift
//  Bomberman
//

import SwiftUI

@MainActor
final class TutorialViewModel: ObservableObject {
    @Published var currentIndex: Int = 0
    @Published var animateBackground = false
    @Published var animateIcon = false

    let pages: [TutorialPage]

    init(pages: [TutorialPage] = TutorialConfig.pages) {
        self.pages = pages
    }

    var currentPage: TutorialPage {
        pages[currentIndex]
    }

    var stepText: String {
        "Шаг \(currentIndex + 1) из \(pages.count)"
    }

    var isLastPage: Bool {
        currentIndex == pages.count - 1
    }

    var currentAccentColor: Color {
        let index = min(currentIndex, TutorialConfig.accentColors.count - 1)
        return TutorialConfig.accentColors[index]
    }

    var currentIconName: String {
        let index = min(currentIndex, TutorialConfig.iconNames.count - 1)
        return TutorialConfig.iconNames[index]
    }

    func onAppear() {
        animateBackground = true
        animateIcon = true
    }

    func next(onFinish: () -> Void) {
        if isLastPage {
            onFinish()
        } else {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                currentIndex += 1
            }
        }
    }
}


