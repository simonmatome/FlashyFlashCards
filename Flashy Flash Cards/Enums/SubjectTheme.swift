//
//  Theme.swift
//  Flashy Flash Cards
//
//  Created by Simon Matome on 14/07/2024.
//

import SwiftUI

enum SubjectTheme: String, CaseIterable, Identifiable, Codable {
    case blu
    case buff
    case canary
    case cesmic_orange
    case cherry
    case fireball_fuchsia
    case grey
    case gren
    case ivory
    case lift_off_lemon
    case lunar_blu
    case orchid
    case periwinkle
    case planetary_purple
    case re_entry_rd
    case rocket_rd
    case salmon
    case terrestrial_teal
    case venus_violet
    case vulcan_green
    
    var SubjectAccentColor: Color {
        switch self {
        case .blu, .buff, .canary, .cesmic_orange, .cherry, .grey, .gren, .ivory, .lift_off_lemon, .lunar_blu, .orchid, .periwinkle, .salmon, .terrestrial_teal, .vulcan_green: return .black
        case .planetary_purple, .re_entry_rd, .rocket_rd, .venus_violet, .fireball_fuchsia: return .white
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

