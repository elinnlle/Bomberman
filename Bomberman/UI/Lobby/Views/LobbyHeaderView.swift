//
//  LobbyHeaderView.swift
//  Bomberman
//

import SwiftUI

struct LobbyHeaderView: View {
    let title: String
    let onShowLeaderboard: () -> Void
    let onShowMatchHistory: () -> Void
    let onLeave: () -> Void

    @State private var showConfirmDialog = false

    var body: some View {
        HStack(spacing: 12) {
            Text(title)
                .appFont(.sansBold, size: 24)
                .foregroundColor(.mainTextColor)

            Spacer()

            Button(action: onShowLeaderboard) {
                Image(systemName: "chart.bar.fill")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.secondaryTextColor)
                    .frame(width: 32, height: 32)
                    .background(Color.lightGrayApp)
                    .clipShape(Circle())
            }

            Button(action: onShowMatchHistory) {
                Image(systemName: "clock.arrow.circlepath")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.secondaryTextColor)
                    .frame(width: 32, height: 32)
                    .background(Color.lightGrayApp)
                    .clipShape(Circle())
            }
            Button {
                showConfirmDialog = true
            } label: {
                Text("Выйти")
                    .appFont(.sansRegular, size: 14)
                    .foregroundColor(.secondaryTextColor)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.lightGrayApp)
                    .cornerRadius(10)
            }
        }
        .confirmDialog(
            isPresented: $showConfirmDialog,
            title: "Выйти из комнаты?",
            message: "Вы действительно хотите покинуть комнату?",
            confirmTitle: "Выйти",
            cancelTitle: "Отмена",
            onConfirm: onLeave
        )
    }
}
