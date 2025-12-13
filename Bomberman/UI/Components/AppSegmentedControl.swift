//
//  AppSegmentedControl.swift
//  Bomberman
//

import SwiftUI

struct AppSegmentedControl<T: Hashable & Identifiable>: View {
    let items: [T]
    @Binding var selection: T
    let title: (T) -> String

    var body: some View {
        HStack(spacing: 2) {
            ForEach(items) { item in
                segment(for: item)
            }
        }
        .padding(2)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.lightGrayApp)
        )
    }

    private func segment(for item: T) -> some View {
        let isSelected = item.id == selection.id

        return Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                selection = item
            }
        } label: {
            Text(title(item))
                .appFont(.sansRegular, size: 14)
                .foregroundColor(
                    isSelected
                        ? .mainTextColor
                        : .secondaryTextColor
                )
                .frame(maxWidth: .infinity)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            isSelected
                                ? Color.grayApp
                                : Color.clear
                        )
                )
        }
        .buttonStyle(.plain)
    }
}

