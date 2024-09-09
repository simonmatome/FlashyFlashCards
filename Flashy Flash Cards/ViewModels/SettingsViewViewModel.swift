//
//  SettingsViewViewModel.swift
//  Flashy Flash Cards
//
//  Created by Simon Matome on 01/09/2024.
//

import Foundation
import SwiftUI

final class SettingsViewViewModel: ObservableObject {
    @AppStorage("BackgroundTheme") var bgColor = ""
    @Published var backgroundTheme: Color = Color(red: 173/255, green: 201/255, blue: 237/255)
    @Published var overlayMessage: Bool = false
    @Published var libraryOverlay: Bool = false
    
    init() {
        if (bgColor != "") {
            let rgbArray = bgColor.components(separatedBy: ",")
            if
                let red = Double(rgbArray[0]),
                let green = Double(rgbArray[1]),
                let blue = Double(rgbArray[2]),
                let alpha = Double(rgbArray[3]) {
                backgroundTheme = Color(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
            }
        }
    }
    
   func updateCardColorInAppStorage(color: Color) -> String {
        let uiColor = UIColor(color)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return "\(red),\(green),\(blue),\(alpha)"
    }

}
