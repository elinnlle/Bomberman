//
//  TutorialPrimaryButton.swift
//  Bomberman
//

import SwiftUI

struct TutorialPrimaryButton: View {
    let title: String
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            Text(title)
                .appFont(.sansSemiBold, size: 18)
                .foregroundColor(.mainTextColor)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.grayApp)
                .cornerRadius(16)
        }
    }
}
