//
//  BufferBoxes.swift
//  Flashy Flash Cards
//
//  Created by Simon Matome on 17/08/2024.
//

import Foundation

enum BufferBoxes: Int, Codable {
    case box1 = 1, box2, box3, box4, box5
    
    // I want to be able to select my own review intervals as a user for each topic and box
    var WaitingTime: Double {
        switch self {
        case .box1: return 10
        case .box2: return 12
        case .box3: return 14
        case .box4: return 16
        case .box5: return 18
        }
    }
    
    var fileRating: FileRating {
        switch self {
        case .box1: return  .very_hard
        case .box2: return  .hard
        case .box3: return  .moderate
        case .box4: return  .easy
        case .box5: return  .very_easy
        }
    }
}
