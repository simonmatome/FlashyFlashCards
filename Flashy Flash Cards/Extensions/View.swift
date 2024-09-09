//
//  View.swift
//  Flashy Flash Cards
//
//  Created by Simon Matome on 25/07/2024.
//

import Foundation
import SwiftUI

extension View {
    func cardRatingStyle(
        current: Rating = .easy,
        selected: Rating? = .easy,
        background: Color = .green,
        accent: Color = .black) -> some View {
            self
                .font(.caption)
                .fontWeight(.bold)
                .lineLimit(1)
                .padding(8)
                .background(
                    (selected == nil ?
                     Color(background).roundedCorner(7, corners: .allCorners) : Color(background).opacity( selected == current ? 1.0 : 0.2).roundedCorner(7, corners: .allCorners))
                )
                .foregroundStyle(Color(accent))
                .shadow(radius: 2)
        }
}

//extension View {
//    func timerButtonStyle(isValid: Bool = true) -> some View {
//        self
//            .font(.title2)
//            .padding()
//            .background(Color.teal.opacity(isValid ? 1.0 : 0.2))
//            .foregroundStyle(Color.black)
//            .roundedCorner(10, corners: .allCorners)
//            .shadow(radius: 5)
//    }
//}
