//
//  ConnectNameInputView.swift
//  Bomberman
//

import SwiftUI

struct ConnectNameInputView: View {
    @Binding var name: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Имя")
                .appFont(.sansRegular, size: 16)
                .foregroundColor(.secondaryTextColor)

            ZStack(alignment: .leading) {
                if name.isEmpty {
                    Text("Введите имя")
                        .appFont(.sansRegular, size: 16)
                        .foregroundColor(.placeholderApp)
                }

                TextField("", text: $name)
                    .appFont(.sansRegular, size: 16)
                    .foregroundColor(.mainTextColor)
            }
            .padding()
            .background(Color.cardBackgroundApp)
            .cornerRadius(12)
        }
        .padding(.horizontal, 24)
    }
}
