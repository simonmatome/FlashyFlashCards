//
//  Rating.swift
//  Flashy Flash Cards
//
//  Created by Simon Matome on 19/07/2024.
//

import SwiftUI

enum Rating: String, CaseIterable, Identifiable {
    case very_easy
    case easy
    case moderate
    case hard
    case very_hard
    
    var RatingColor: Color {
        switch self {
        case .very_easy:
            return .green
        case .easy:
            return .vulcanGreen
        case .moderate:
            return .yellow
        case .hard:
            return .orange
        case .very_hard:
            return .red
        }
    }
    
    var DelayTiming: Double {
        switch self {
        case .very_easy:
            40
        case .easy:
            30
        case .moderate:
            20
        case .hard:
            10
        case .very_hard:
            5
        }
    }
    
    var RatingColorAccent: Color {
        switch self {
        case .very_easy, .easy, .moderate, .hard: 
                return .black
        case .very_hard:
            return .white
        }
    }
    
    var name: String {
        rawValue.replacing("_", with: " ").capitalized
    }
    
    var id: String {
        name
    }
}
