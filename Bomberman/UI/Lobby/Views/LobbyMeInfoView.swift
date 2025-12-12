//
//  LobbyMeInfoView.swift
//  Bomberman
//

import SwiftUI

struct LobbyMeInfoView: View {
    let me: PlayerSummary

    var body: some View {
        HStack {
            Text("Вы: \(me.name) • \(me.role.title)")
                .appFont(.sansRegular, size: 16)
                .foregroundColor(.secondaryTextColor)
            Spacer()
        }
    }
}
