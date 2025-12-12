//
//  TutorialConfig.swift
//  Bomberman
//

import SwiftUI

enum TutorialConfig {
    static let pages: [TutorialPage] = [
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

    static let iconNames = [
        "flame.fill",
        "rectangle.grid.2x2.fill",
        "person.2.fill",
        "flag.checkered"
    ]

    static let accentColors: [Color] = [
        .orangeAccent,
        .greenAccent,
        .blueAccent,
        .yellowAccent
    ]
}

