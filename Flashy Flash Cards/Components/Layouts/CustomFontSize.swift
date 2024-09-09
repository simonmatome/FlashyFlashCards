//
//  SwiftUIView.swift
//  Flashy Flash Cards
//
//  Created by Simon Matome on 25/07/2024.
//

import SwiftUI

struct CustomFontSize {
    let small: CGFloat
    let smallMedium: CGFloat
    let medium: CGFloat
    let mediumLarge: CGFloat
    let large: CGFloat
    let extraLarge: CGFloat
    init(height: CGFloat, width: CGFloat) {
        let widthToCalculate = height<width ? height : width
        switch widthToCalculate {
        case _ where widthToCalculate < 700:
            small = 7
            smallMedium = 10
            medium = 12
            mediumLarge = 15
            large = 17
            extraLarge = 22
            
        case _ where widthToCalculate >= 700 && widthToCalculate < 1000:
            small = 14
            smallMedium = 16
            medium = 19
            mediumLarge = 22
            large = 24
            extraLarge = 29
            
        case _ where widthToCalculate >= 1000:
            small = 17
            smallMedium = 20
            medium = 23
            mediumLarge = 25
            large = 28
            extraLarge = 32
            
        default:
            small = 5
            smallMedium = 8
            medium = 10
            mediumLarge = 13
            large = 15
            extraLarge = 20
        }
    }
}
