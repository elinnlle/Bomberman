//
//  ColorExtension.swift
//  Bomberman
//

import SwiftUI
import UIKit

extension Color {
    
    init(hex: String, alpha: Double = 1.0) {
        let cleaned = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: cleaned).scanHexInt64(&int)

        let r, g, b: UInt64
        switch cleaned.count {
        case 3: // RGB 12-bit
            r = (int >> 8) * 17
            g = ((int >> 4) & 0xF) * 17
            b = (int & 0xF) * 17

        case 6: // RGB 24-bit
            r = int >> 16
            g = (int >> 8) & 0xFF
            b = int & 0xFF

        default:
            r = 0; g = 0; b = 0
        }

        self.init(.sRGB,
                  red: Double(r) / 255.0,
                  green: Double(g) / 255.0,
                  blue: Double(b) / 255.0,
                  opacity: alpha)
    }
    
    // MARK: Adaptable light/dark color
    static func adaptiveColor(lightHex: String, darkHex: String) -> Color {
        Color(UIColor { trait in
            let hex = (trait.userInterfaceStyle == .dark) ? darkHex : lightHex
            return UIColor(hex: hex)
        })
    }
    
    static let blackApp        = adaptiveColor(lightHex: "#090A0C", darkHex: "#090A0C")
    static let grayApp         = adaptiveColor(lightHex: "#1E1E1E", darkHex: "#1E1E1E")
    static let lightGrayApp    = adaptiveColor(lightHex: "#2C2C2E", darkHex: "#2C2C2E")
    
    static let mainTextColor      = Color.white
    static let secondaryTextColor = Color.white.opacity(0.8)
    static let placeholderApp = Color.white.opacity(0.5)
    
    static let blueAccent      = adaptiveColor(lightHex: "#007AFF", darkHex: "#007AFF")
    static let greenAccent     = adaptiveColor(lightHex: "#34C759", darkHex: "#34C759")
    static let redAccent       = adaptiveColor(lightHex: "#FF3B30", darkHex: "#FF3B30")
    static let orangeAccent    = adaptiveColor(lightHex: "#FF9500", darkHex: "#FF9500")
    static let yellowAccent    = adaptiveColor(lightHex: "#FFCC00", darkHex: "#FFCC00")
    
    static let cardBackgroundApp = adaptiveColor(lightHex: "#1C1C1E", darkHex: "#1C1C1E")
    static let borderApp         = adaptiveColor(lightHex: "#2C2C2E", darkHex: "#2C2C2E")
}

extension UIColor {
    
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        let cleaned = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: cleaned).scanHexInt64(&int)

        let r, g, b: UInt64
        switch cleaned.count {
        case 3:
            r = (int >> 8) * 17
            g = ((int >> 4) & 0xF) * 17
            b = (int & 0xF) * 17

        case 6:
            r = int >> 16
            g = (int >> 8) & 0xFF
            b = int & 0xFF

        default:
            r = 0; g = 0; b = 0
        }

        self.init(red: CGFloat(r) / 255.0,
                  green: CGFloat(g) / 255.0,
                  blue: CGFloat(b) / 255.0,
                  alpha: alpha)
    }
}
