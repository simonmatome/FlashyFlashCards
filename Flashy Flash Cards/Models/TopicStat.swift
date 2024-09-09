//
//  TopicStats.swift
//  Flashy Flash Cards
//
//  Created by Simon Matome on 08/09/2024.
//

import Foundation

struct TopicStat: Identifiable {
    let id: FileRating
    var rating: String {
        ratingString(rating: id)
    }
    let number: Int
    
    init(box: FileRating, number: Int) {
        self.id = box
        self.number = number
    }
    
    private func ratingString(rating: FileRating) -> String {
        switch rating {
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
}
