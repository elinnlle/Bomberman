//
//  TutorialView.swift
//  Bomberman
//

import SwiftUI

struct TutorialView: View {
    let onFinish: () -> Void
    
    private let pages: [TutorialPage] = [
        TutorialPage(
            title: "Добро пожаловать в Bomberman",
            message: "Разрушайте стены, ставьте бомбы и выживайте в лабиринте. В конце раунда останется только один!"
        ),
        TutorialPage(
            title: "Управление",
            message: "На поле вы сможете двигаться по четырём направлениям и закладывать бомбы. Следите за временем и взрывами."
        ),
        TutorialPage(
            title: "Роли",
            message: "Можно играть в роли игрока или наблюдателя. Игроки участвуют в раунде, наблюдатели просто смотрят за происходящим."
        ),
        TutorialPage(
            title: "Готовность",
            message: "В лобби пометьте себя готовым. Раунд начнётся, когда все будут готовы или по решению сервера."
        )
    ]
    
    private let iconNames = [
        "flame.fill",
        "rectangle.grid.2x2.fill",
        "person.2.fill",
        "flag.checkered"
    ]
    
    private let accentColors: [Color] = [
        .orangeAccent,
        .greenAccent,
        .blueAccent,
        .yellowAccent
    ]
    
    @State private var currentIndex = 0
    @State private var animateBackground = false
    @State private var animateIcon = false
    
    var body: some View {
        ZStack {
            animatedBackground
            
            VStack(spacing: 24) {
                Spacer().frame(height: 40)
                
                stepBadge
                
                iconView
                
                contentText
                    .padding(.horizontal, 24)
                
                Spacer()
                
                pageDots
                
                primaryButton
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
            }
        }
        .background(Color.blackApp.ignoresSafeArea())
        .onAppear {
            animateBackground = true
            animateIcon = true
        }
    }
}

// MARK: - Computed helpers

private extension TutorialView {
    var currentPage: TutorialPage {
        pages[currentIndex]
    }
    
    var currentAccentColor: Color {
        let index = min(currentIndex, max(0, accentColors.count - 1))
        return accentColors[index]
    }
    
    var currentIconName: String {
        let index = min(currentIndex, max(0, iconNames.count - 1))
        return iconNames[index]
    }
    
    var stepText: String {
        "Шаг \(currentIndex + 1) из \(pages.count)"
    }
}

// MARK: - Subviews

private extension TutorialView {
    var animatedBackground: some View {
        ZStack {
            Color.blackApp
            
            LinearGradient(
                colors: [
                    Color.grayApp.opacity(0.5),
                    Color.blackApp.opacity(0.8)
                ],
                startPoint: animateBackground ? .topLeading : .bottomTrailing,
                endPoint: animateBackground ? .bottomTrailing : .topLeading
            )
            .animation(.easeInOut(duration: 6).repeatForever(), value: animateBackground)
            
            Circle()
                .fill(Color.lightGrayApp.opacity(0.18))
                .blur(radius: 85)
                .frame(width: 260, height: 260)
                .offset(x: animateBackground ? -90 : 110, y: animateBackground ? -40 : 80)
                .animation(.easeInOut(duration: 7).repeatForever(), value: animateBackground)
            
            Circle()
                .fill(Color.grayApp.opacity(0.14))
                .blur(radius: 110)
                .frame(width: 300, height: 300)
                .offset(x: animateBackground ? 120 : -120, y: animateBackground ? 100 : -90)
                .animation(.easeInOut(duration: 8).repeatForever(), value: animateBackground)
        }
    }
    
    var stepBadge: some View {
        Text(stepText)
            .appFont(.sansRegular, size: 13)
            .foregroundColor(.secondaryTextColor)
            .padding(.horizontal, 14)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(Color.grayApp.opacity(0.9))
            )
    }
    
    var iconView: some View {
        ZStack {
            Circle()
                .fill(currentAccentColor.opacity(0.16))
                .frame(width: 140, height: 140)
                .shadow(color: currentAccentColor.opacity(0.4), radius: 18, x: 0, y: 12)
            
            Image(systemName: currentIconName)
                .font(.system(size: 54, weight: .semibold))
                .foregroundColor(currentAccentColor)
                .scaleEffect(animateIcon ? 1.05 : 0.90)
                .offset(y: animateIcon ? -4 : 4)
                .shadow(color: currentAccentColor.opacity(0.7), radius: 14, x: 0, y: 10)
                .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: animateIcon)
        }
        .padding(.top, 10)
        .padding(.bottom, 8)
    }
    
    var contentText: some View {
        VStack(spacing: 16) {
            Text(currentPage.title)
                .appFont(.sansBold, size: 24)
                .foregroundColor(.mainTextColor)
                .multilineTextAlignment(.center)
            
            Text(currentPage.message)
                .appFont(.sansRegular, size: 16)
                .foregroundColor(.secondaryTextColor)
                .multilineTextAlignment(.center)
        }
        .animation(.easeInOut(duration: 0.25), value: currentIndex)
    }
    
    var pageDots: some View {
        HStack(spacing: 8) {
            ForEach(0..<pages.count, id: \.self) { index in
                let isActive = index == currentIndex
                Circle()
                    .fill(isActive ? currentAccentColor : Color.secondaryTextColor.opacity(0.4))
                    .frame(width: isActive ? 10 : 6, height: isActive ? 10 : 6)
                    .animation(.easeInOut(duration: 0.2), value: currentIndex)
            }
        }
    }
    
    var primaryButton: some View {
        Button {
            if currentIndex < pages.count - 1 {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                    currentIndex += 1
                }
            } else {
                onFinish()
            }
        } label: {
            Text(currentIndex == pages.count - 1 ? "Начать игру" : "Далее")
                .appFont(.sansSemiBold, size: 18)
                .foregroundColor(.mainTextColor)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.grayApp)
                .cornerRadius(16)
        }
    }
}
