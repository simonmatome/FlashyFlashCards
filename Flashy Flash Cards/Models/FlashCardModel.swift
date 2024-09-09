//
//  FlashCardModel.swift
//  Flashy Flash Cards
//
//  Created by Simon Matome on 11/07/2024.
//

import Foundation

struct FlashCardModel: Identifiable, Codable {
    let id: UUID
    var question: String
    var answer: String
    var points: [PointDescription]
    var keyPoints: [KeyPoint]
    var viewed: Bool = false
    var timeToAnswer: Int
    var box: Int
    var transferedToCardOfTheDay: Bool
    
    init(
        id: UUID = UUID(),
        question: String, answer: String,
        points: [(point: String, description: String)],
        keyPoints: [String],
        time: Int, box: Int = 1,
        transferred: Bool = false) {
        self.id = id
        self.question = question
        self.answer = answer
        self.points = points.map { PointDescription(point: $0, description: $1)}
        self.keyPoints = keyPoints.map { KeyPoint(point: $0) }
        self.timeToAnswer = time
        self.box = box
        self.transferedToCardOfTheDay = transferred
    }
    
    mutating func rateCard(_ rating: Rating) {
        switch rating {
        case .very_easy:
            box += 2
            if box > 5 {
                box = 5
            }
        case .easy:
            box += 1
            if box > 5 {
                box = 5
            }
        case .moderate:
            break
        case .hard:
            box -= 1
            if box < 1 {
                box = 1
            }
        case .very_hard:
            box -= 2
            if box < 1 {
                box = 1
            }
        }
    }
    mutating func rate() {
        viewed = true
    }
    mutating func resetRate() {
        viewed = false
    }
}

extension FlashCardModel {
    struct PointDescription: Identifiable, Hashable, Codable {
        let id: UUID
        var point: String
        var description: String
        
        init(id: UUID = UUID(), point: String, description: String) {
            self.id = id
            self.point = point
            self.description = description
        }
    }
    
    struct KeyPoint: Identifiable, Hashable, Codable {
        let id: UUID
        var point: String
        
        init(id: UUID = UUID(), point: String) {
            self.id = id
            self.point = point
        }
    }
}

extension FlashCardModel {
    static var emptyCard: FlashCardModel {
        FlashCardModel(question: "", answer: "", points: [], keyPoints: [], time: 10)
    }
    
    static var sample: [FlashCardModel] {
        [
            FlashCardModel(
                question: "What is the capital of France?",
                answer: "The capital of France is Paris.",
                points: [
                    ("Capital", "The capital city of France is Paris."),
                    ("Population", "Paris has a population of over 2 million people."),
                    ("Landmark", "The Eiffel Tower is located in Paris.")
                ],
                keyPoints: ["Capital", "Paris", "Eiffel Tower"], 
                time: 20,
                box: 0
            ),
            FlashCardModel(
                question: "What is the largest planet in our solar system?",
                answer: "The largest planet in our solar system is Jupiter.",
                points: [
                    ("Planet", "Jupiter is the largest planet in our solar system."),
                    ("Gas Giant", "Jupiter is classified as a gas giant."),
                    ("Moons", "Jupiter has 79 known moons.")
                ],
                keyPoints: ["Jupiter", "Largest planet", "Gas giant", "79 moons"], time: 40, box: 0
            ),
            FlashCardModel(
                question: "What is the chemical symbol for water?",
                answer: "The chemical symbol for water is $\\text{H}_2\\text{O}$.",
                points: [
                    ("Chemical Formula", "H2O is the chemical formula for water."),
                    ("Composition", "Water is composed of two hydrogen atoms and one oxygen atom."),
                    ("State", "Water can exist in three states: solid, liquid, and gas.")
                ],
                keyPoints: ["H2O", "Water", "Chemical formula", "Three states"], time: 18, box: 0
            ),
            FlashCardModel(
                question: "What is the speed of light?",
                answer: "The speed of light in a vacuum is approximately 299,792 kilometers per second.",
                points: [
                    ("Speed", "299,792 km/s is the speed of light."),
                    ("Measurement", "Speed of light is usually measured in a vacuum."),
                    ("Symbol", "The symbol for the speed of light is 'c'.")
                ],
                keyPoints: ["299,792 km/s", "Speed of light", "c"], time: 12, box: 0
            ),
            FlashCardModel(
                question: "Who developed the theory of relativity?",
                answer: "Albert Einstein developed the theory of relativity.",
                points: [
                    ("Scientist", "Albert Einstein."),
                    ("Theory", "Theory of relativity."),
                    ("Year", "Published in 1905.")
                ],
                keyPoints: ["Albert Einstein", "Theory of relativity", "1905"], time: 9, box: 0
            )
        ]
    }
}
