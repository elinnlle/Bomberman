//
//  LeaderboardResetButtonView.swift
//  Bomberman
//

import SwiftUI

struct LeaderboardResetButtonView: View {
    let onReset: () -> Void

    @State private var showConfirmDialog = false

    var body: some View {
        Button {
            showConfirmDialog = true
        } label: {
            Text("Сбросить статистику")
                .appFont(.sansSemiBold, size: 16)
                .foregroundColor(.mainTextColor)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.grayApp)
                .cornerRadius(14)
        }
        .confirmDialog(
            isPresented: $showConfirmDialog,
            title: "Сбросить статистику?",
            message: "Все результаты будут удалены без возможности восстановления.",
            confirmTitle: "Сбросить",
            cancelTitle: "Отмена",
            onConfirm: onReset
        )
    }
}
