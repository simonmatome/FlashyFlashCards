//
//  Topic.swift
//  Flashy Flash Cards
//
//  Created by Simon Matome on 11/07/2024.
//

import Foundation

struct Topic: Identifiable, Codable {
    let id: UUID
    var name: String
    var flashCards: [FlashCardModel]
    var dateAdded: Date
    var delay: Double
    /// The review time increments for the topic
    var reviewIntervals: [ReviewInterval]
    
    init(
        id: UUID = UUID(),
        name: String,
        flashCards: [FlashCardModel],
        date: Date = Date(),
        delay: Double = 0,
        reviewIntervals: [ReviewInterval] = ReviewInterval.sample // Initialise the review intervals as an array of ones
    ) {
            self.id = id
            self.name = name
            self.flashCards = flashCards
            self.dateAdded = date
            self.delay = delay
            self.reviewIntervals = reviewIntervals
        }
    
    mutating func topicDelay(box: BufferBoxes) {
        switch box {
        case .box1:
            delay = reviewIntervals[0].timeInterval()
        case .box2:
            delay = reviewIntervals[1].timeInterval()
        case .box3:
            delay = reviewIntervals[2].timeInterval()
        case .box4:
            delay = reviewIntervals[3].timeInterval()
        case .box5:
            delay = reviewIntervals[4].timeInterval()
        }
    }
}

extension Topic {
    static var emptyTopic: Topic {
        Topic(name: "", flashCards: [])
    }
}

extension Topic {
    static var sample: [Topic] {
        [
            Topic(
                name: "Geography",
                flashCards: [FlashCardModel.sample[0]]
            ),
            Topic(
                name: "Astronomy",
                flashCards: [FlashCardModel.sample[1]]
            ),
            Topic(
                name: "Chemistry",
                flashCards: [FlashCardModel.sample[2]]
            ),
            Topic(
                name: "Physics",
                flashCards: [FlashCardModel.sample[3], FlashCardModel.sample[4]]
            )
        ]
    }
}


