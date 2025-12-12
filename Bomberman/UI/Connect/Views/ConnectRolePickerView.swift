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

            Picker("", selection: $selectedRole) {
                ForEach(PlayerRole.allCases) { role in
                    Text(role.title)
                        .tag(role)
                }
            }
            .pickerStyle(.segmented)
        }
        .padding(.horizontal, 24)
    }
}
