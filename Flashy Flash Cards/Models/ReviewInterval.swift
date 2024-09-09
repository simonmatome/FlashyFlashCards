//
//  ReviewInterval.swift
//  Flashy Flash Cards
//
//  Created by Simon Matome on 06/09/2024.
//

import Foundation

struct ReviewInterval: Identifiable, Codable, Equatable {
    let id: UUID
    var amount: Double
    var unit: TimeUnit
    
    init(id: UUID = UUID(), amount: Double, unit: TimeUnit) {
        self.id = id
        self.amount = amount
        self.unit = unit
    }
    
    func timeInterval() -> Double {
        switch unit {
        case .hours:
            return Double(amount * 3600)
        case .days:
            return Double(amount * 3600 * 24)
        case .weeks:
            return Double(amount * 3600 * 24 * 7)
        case .months:
            return Double(amount * 3600 * 24 * 30)
        }
    }
}

extension ReviewInterval {
    static let sample: [ReviewInterval] = [
        ReviewInterval(amount: 0.0028, unit: .hours),
        ReviewInterval(amount: 0.0033, unit: .hours),
        ReviewInterval(amount: 0.0039, unit: .hours),
        ReviewInterval(amount: 0.0044, unit: .hours),
        ReviewInterval(amount: 0.005, unit: .hours)
    ]
}
