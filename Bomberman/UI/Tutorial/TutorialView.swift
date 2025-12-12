//
//  TutorialView.swift
//  Bomberman
//

import SwiftUI

struct TutorialView: View {
    let onFinish: () -> Void

    @StateObject private var viewModel = TutorialViewModel()

    var body: some View {
        ZStack {
            TutorialBackgroundView(animate: viewModel.animateBackground)

            VStack(spacing: 24) {
                Spacer().frame(height: 40)

                TutorialStepBadgeView(text: viewModel.stepText)

                TutorialIconView(
                    iconName: viewModel.currentIconName,
                    accentColor: viewModel.currentAccentColor,
                    animate: viewModel.animateIcon
                )

                TutorialContentView(page: viewModel.currentPage)
                    .padding(.horizontal, 24)

                Spacer()

                TutorialPageDotsView(
                    count: viewModel.pages.count,
                    currentIndex: viewModel.currentIndex,
                    accentColor: viewModel.currentAccentColor
                )

                TutorialPrimaryButton(
                    title: viewModel.isLastPage ? "Начать игру" : "Далее",
                    onTap: { viewModel.next(onFinish: onFinish) }
                )
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .background(Color.blackApp.ignoresSafeArea())
        .onAppear { viewModel.onAppear() }
    }
}
