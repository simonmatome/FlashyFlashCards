//
//  TimeInterval.swift
//  Flashy Flash Cards
//
//  Created by Simon Matome on 25/07/2024.
//

import Foundation

extension TimeInterval {
    func format(using units: NSCalendar.Unit) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = units
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: self) ?? ""
    }
}
