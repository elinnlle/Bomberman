//
//  View+ConfirmAlert.swift
//  Bomberman
//

import SwiftUI

extension View {
    func confirmDialog(
        isPresented: Binding<Bool>,
        title: String,
        message: String,
        confirmTitle: String = "Подтвердить",
        cancelTitle: String = "Отмена",
        onConfirm: @escaping () -> Void
    ) -> some View {
        self
            .fullScreenCover(isPresented: isPresented) {
                ConfirmDialogView(
                    title: title,
                    message: message,
                    confirmTitle: confirmTitle,
                    cancelTitle: cancelTitle,
                    onConfirm: {
                        isPresented.wrappedValue = false
                        onConfirm()
                    },
                    onCancel: {
                        isPresented.wrappedValue = false
                    }
                )
                .presentationBackground(.clear)
            }
    }
}
