//
//  FontsExtension.swift
//

import SwiftUI

enum CustomFonts: String {
    case sansBold = "HSESans-Bold"
    case sansItalic = "HSESans-Italic"
    case sansRegular = "HSESans-Regular"
    case sansSemiBold = "HSESans-SemiBold"
    case sansThin = "HSESans-Thin"
}

extension Font {
    static func app(_ customFont: CustomFonts, size: CGFloat) -> Font {
        .custom(customFont.rawValue, size: size)
    }
}

extension View {
    func appFont(_ customFont: CustomFonts, size: CGFloat) -> some View {
        font(.app(customFont, size: size))
    }
}
