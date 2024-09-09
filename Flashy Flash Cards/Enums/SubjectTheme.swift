//
//  Theme.swift
//  Flashy Flash Cards
//
//  Created by Simon Matome on 14/07/2024.
//

import SwiftUI

enum SubjectTheme: String, CaseIterable, Identifiable, Codable {
    case blue
    case buff
    case canary
    case cesmic_orange
    case cherry
    case fireball_fuchsia
    case gray
    case green
    case ivory
    case lift_off_lemon
    case lunar_blue
    case orchid
    case periwinkle
    case planetary_purple
    case re_entry_red
    case rocket_red
    case salmon
    case terrestrial_teal
    case venus_violet
    case vulcan_green
    
    var SubjectAccentColor: Color {
        switch self {
        case .blue, .buff, .canary, .cesmic_orange, .cherry, .gray, .green, .ivory, .lift_off_lemon, .lunar_blue, .orchid, .periwinkle, .salmon, .terrestrial_teal, .vulcan_green: return .black
        case .planetary_purple, .re_entry_red, .rocket_red, .venus_violet, .fireball_fuchsia: return .white
        }
    }
    
    var SubjectMainColor: Color {
        Color(rawValue)
    }
    
    var name: String {
        rawValue.replacing("_", with: " ").capitalized
    }
    
    var id: String {
        name
    }
}

