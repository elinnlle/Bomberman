//
//  ConnectRolePickerView.swift
//  Bomberman
//

import SwiftUI

struct ConnectRolePickerView: View {
    @Binding var selectedRole: PlayerRole

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Роль")
                .appFont(.sansRegular, size: 16)
                .foregroundColor(.secondaryTextColor)

            AppSegmentedControl(
                items: PlayerRole.allCases,
                selection: $selectedRole,
                title: { $0.title }
            )
        }
        .padding(.horizontal, 24)
    }
}
