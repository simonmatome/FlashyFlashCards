//
//  Double.swift
//  Flashy Flash Cards
//
//  Created by Simon Matome on 11/07/2024.
//

import Foundation

extension Double {
    
    private var numberformatter2: NumberFormatter {
        let formatter = NumberFormatter()
        
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        
        return formatter
    }
    
    func asNumberWith2Sf() -> String {
        let number = NSNumber(value: self)
        return numberformatter2.string(from: number) ?? "0.00"
    }
}
