//
//  MatchHistoryResetButtonView.swift
//  Bomberman
//

import SwiftUI

struct MatchHistoryResetButtonView: View {
    let onReset: () -> Void

    @State private var showConfirmDialog = false

    var body: some View {
        Button {
            showConfirmDialog = true
        } label: {
            Text("Сбросить историю")
                .appFont(.sansSemiBold, size: 16)
                .foregroundColor(.mainTextColor)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.grayApp)
                .cornerRadius(14)
        }
        .confirmDialog(
            isPresented: $showConfirmDialog,
            title: "Сбросить историю?",
            message: "История матчей будет удалена без возможности восстановления.",
            confirmTitle: "Сбросить",
            cancelTitle: "Отмена",
            onConfirm: onReset
        )
    }
}
