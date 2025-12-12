//
//  ConnectErrorView.swift
//  Bomberman
//

import SwiftUI

struct ConnectErrorView: View {
    let message: String

    var body: some View {
        Text(message)
            .appFont(.sansRegular, size: 14)
            .foregroundColor(.redAccent)
            .padding(.horizontal, 24)
    }
}

