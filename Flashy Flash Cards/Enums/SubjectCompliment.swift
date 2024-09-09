//
//  SubjectCompliment.swift
//  Flashy Flash Cards
//
//  Created by Simon Matome on 15/07/2024.
//

import SwiftUI

extension SubjectTheme {
    enum SubjectCompliment: String, CaseIterable, Identifiable {
        case blue_comp
        case buff_comp
        case canary_comp
        case cesmic_comp
        case cherry_comp
        case fireball_comp
        case ivory_comp
        case lemon_comp
        case lunar_comp
        case orchid_comp
        case periwinkle_comp
        case planetary_comp
        case re_entry_comp
        case rocket_comp
        case salmon_comp
        case terrestrial_comp
        case venus_comp
        case vulcan_comp
        
        var ComplimentColor: Color {
            Color(rawValue)
        }
        
        var comp: String {
            rawValue.replacing("_comp", with: " compliment").capitalized
        }
        
        var id: String {
            comp
        }
    }
    
    var fileBackground: Color {
        switch self {
        case .blue:
            return SubjectCompliment.blue_comp.ComplimentColor
        case .buff:
            return SubjectCompliment.buff_comp.ComplimentColor
        case .canary:
            return SubjectCompliment.canary_comp.ComplimentColor
        case .cesmic_orange:
            return SubjectCompliment.cesmic_comp.ComplimentColor
        case .cherry:
            return SubjectCompliment.cherry_comp.ComplimentColor
        case .fireball_fuchsia:
            return SubjectCompliment.fireball_comp.ComplimentColor
        case .gray:
            return .black
        case .green:
            return .brown
        case .ivory:
            return SubjectCompliment.ivory_comp.ComplimentColor
        case .lift_off_lemon:
            return SubjectCompliment.lemon_comp.ComplimentColor
        case .lunar_blue:
            return SubjectCompliment.lunar_comp.ComplimentColor
        case .orchid:
            return SubjectCompliment.orchid_comp.ComplimentColor
        case .periwinkle:
            return SubjectCompliment.periwinkle_comp.ComplimentColor
        case .planetary_purple:
            return SubjectCompliment.planetary_comp.ComplimentColor
        case .re_entry_red:
            return SubjectCompliment.re_entry_comp.ComplimentColor
        case .rocket_red:
            return SubjectCompliment.rocket_comp.ComplimentColor
        case .salmon:
            return SubjectCompliment.salmon_comp.ComplimentColor
        case .terrestrial_teal:
            return SubjectCompliment.terrestrial_comp.ComplimentColor
        case .venus_violet:
            return SubjectCompliment.venus_comp.ComplimentColor
        case .vulcan_green:
            return SubjectCompliment.vulcan_comp.ComplimentColor
        }
    }
}

