//
//  FileRating.swift
//  Flashy Flash Cards
//
//  Created by Simon Matome on 15/08/2024.
//

import Foundation

enum FileRating: Int, Codable, CaseIterable, Identifiable {
    case very_easy = 5
    case easy = 4
    case moderate = 3
    case hard = 2
    case very_hard = 1
    
    var name: String {
        switch self {
        case .very_easy:
            return "Very Easy"
        case .easy:
            return "Easy"
        case .moderate:
            return "Moderate"
        case .hard:
            return "Hard"
        case .very_hard:
            return "Very Hard"
        }
    }
    
    var id: Int {
        rawValue
    }
}
