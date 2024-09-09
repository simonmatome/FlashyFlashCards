//
//  Color.swift
//  Flashy Flash Cards
//
//  Created by Simon Matome on 08/07/2024.
//

import Foundation
import SwiftUI

extension Color {
    static let theme = ColorTheme()
    
    func inverted() -> Color {
        // Convert Color to UIColor
        let uiColor = UIColor(self)
        
        // Extract RGB components
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        // Invert the RGB components
        let invertedRed = 1.0 - red
        let invertedGreen = 1.0 - green
        let invertedBlue = 1.0 - blue
        
        // Create and return a new Color with the inverted values
        return Color(red: invertedRed, green: invertedGreen, blue: invertedBlue, opacity: alpha)
    }
    
    func getContrastText() -> Color {
        var r, g, b, a: CGFloat
        (r, g, b, a) = (0, 0, 0, 0)
        UIColor(self).getRed(&r, green: &g, blue: &b, alpha: &a)
        let luminance = 0.2126 * r + 0.7152 * g + 0.0722 * b
        return  luminance < 0.6 ? Color.white : Color.black
    }
}

struct ColorTheme {
    let FlameColor = Color("FlameColor")
    let BlueThemeComplement = Color("BlueThemeCompliment")
}
