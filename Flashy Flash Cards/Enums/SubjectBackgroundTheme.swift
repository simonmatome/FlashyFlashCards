//
//  SubjectBackgroundTheme.swift
//  Flashy Flash Cards
//
//  Created by Simon Matome on 29/07/2024.
//

import SwiftUI

enum SubjectBackgroundTheme: String, CaseIterable, Identifiable, Codable {
    case paper_vintage_1
    case paper_vintage_2
    case paper_vintage_3
    case paper_vintage_4
    case paper_vintage_5
    case raging_flame_1
    case raging_flame_2
    case raging_flame_3
    case raging_flame_4
    case raging_flame_5
    case transparent_paper_scale_1
    case transparent_paper_scale_2
    case transparent_paper_scale_3
    case transparent_paper_scale_4
    case transparent_paper_scale_5
    case wallpaper_panel_1
    case wallpaper_panel_2
    case wallpaper_panel_3
    case wallpaper_panel_4
    case wallpaper_panel_5
    case white_old_paper_1
    case white_old_paper_2
    case white_old_paper_3
    case white_old_paper_4
    case white_old_paper_5
    case writing_paper_1
    case writing_paper_2
    case writing_paper_3
    case writing_paper_4
    case writing_paper_5
    case wild_hunt_1
    case wild_hunt_2
    case wild_hunt_3
    case wild_hunt_4
    case wild_hunt_5
    
    var pallete: String {
        switch self {
        case .paper_vintage_1, .paper_vintage_2, .paper_vintage_3, .paper_vintage_4, .paper_vintage_5:
            return "Paper Vintage"
        case .raging_flame_1, .raging_flame_2, .raging_flame_3, .raging_flame_4, .raging_flame_5:
            return "Raging Flames"
        case .transparent_paper_scale_1, 
                .transparent_paper_scale_2,
                .transparent_paper_scale_3,
                .transparent_paper_scale_4, .transparent_paper_scale_5:
            return "Transparent Paper Scale"
        case .wallpaper_panel_1, .wallpaper_panel_2, 
                .wallpaper_panel_3, .wallpaper_panel_4, .wallpaper_panel_5:
            return "Wallpaper Panel"
        case .white_old_paper_1, .white_old_paper_2, .white_old_paper_3, 
                .white_old_paper_4, .white_old_paper_5:
            return "White Old Paper"
        case .writing_paper_1, .writing_paper_2, .writing_paper_3, .writing_paper_4, .writing_paper_5:
            return "Writing Paper"
        case .wild_hunt_1, .wild_hunt_2, .wild_hunt_3, .wild_hunt_4, .wild_hunt_5:
            return "Wild Hunt"
        }
    }
    
    var accent: Color {
        switch self {
        case .paper_vintage_5, .raging_flame_5, .wallpaper_panel_4, .wallpaper_panel_5, .wild_hunt_1, 
                .wild_hunt_3, .wild_hunt_4, .wild_hunt_5:
            return .white
        case .paper_vintage_1, .paper_vintage_2, .paper_vintage_3, .paper_vintage_4, 
                .raging_flame_1, .raging_flame_2, .raging_flame_3, .raging_flame_4,
                .transparent_paper_scale_1, .transparent_paper_scale_2, .transparent_paper_scale_3,
                .transparent_paper_scale_4, .transparent_paper_scale_5, 
                .wallpaper_panel_1, .wallpaper_panel_2, .wallpaper_panel_3,
                .white_old_paper_1, .white_old_paper_2, .white_old_paper_3, .white_old_paper_4, .white_old_paper_5,
                .writing_paper_1, .writing_paper_2, .writing_paper_3, .writing_paper_4, .writing_paper_5,
                .wild_hunt_2:
            return .black
        }
    }
    
    var main: Color {
        Color(rawValue)
    }
    
    var name: String {
        rawValue.replacing("_", with: " ").capitalized
    }
    
    var id: String {
        name
    }
}
