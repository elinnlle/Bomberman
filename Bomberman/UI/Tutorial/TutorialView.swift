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
    
    @State private var currentIndex = 0
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Text(pages[currentIndex].title)
                .appFont(.sansBold, size: 24)
                .foregroundColor(.mainTextColor)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            
            Text(pages[currentIndex].message)
                .appFont(.sansRegular, size: 16)
                .foregroundColor(.secondaryTextColor)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            
            Spacer()
            
            HStack(spacing: 8) {
                ForEach(0..<pages.count, id: \.self) { index in
                    Circle()
                        .fill(index == currentIndex ? Color.mainTextColor : Color.secondaryTextColor.opacity(0.4))
                        .frame(width: 8, height: 8)
                }
            }
            
            Button {
                if currentIndex < pages.count - 1 {
                    currentIndex += 1
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
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
        .background(Color.blackApp.ignoresSafeArea())
    }
}
