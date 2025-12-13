//
//  ConfirmDialogView.swift
//  Bomberman
//

import SwiftUI

struct ConfirmDialogView: View {
    let title: String
    let message: String
    let confirmTitle: String
    let cancelTitle: String
    let onConfirm: () -> Void
    let onCancel: () -> Void

    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                Text(title)
                    .appFont(.sansBold, size: 20)
                    .foregroundColor(.mainTextColor)
                    .multilineTextAlignment(.center)

                Text(message)
                    .appFont(.sansRegular, size: 14)
                    .foregroundColor(.secondaryTextColor)
                    .multilineTextAlignment(.center)

                HStack(spacing: 12) {
                    Button(action: onCancel) {
                        Text(cancelTitle)
                            .appFont(.sansRegular, size: 14)
                            .foregroundColor(.secondaryTextColor)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(Color.lightGrayApp)
                            .cornerRadius(12)
                    }

                    Button(action: onConfirm) {
                        Text(confirmTitle)
                            .appFont(.sansSemiBold, size: 14)
                            .foregroundColor(.mainTextColor)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(Color.grayApp)
                            .cornerRadius(12)
                    }
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.blackApp)
            )
            .padding(.horizontal, 32)
        }
    }
}
