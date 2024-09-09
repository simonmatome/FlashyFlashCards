//
//  RectangleTimer.swift
//  Flashy Flash Cards
//
//  Created by Simon Matome on 23/07/2024.
//

import SwiftUI

struct Progress: Shape {
    var cornerRadius: CGFloat
    var progress: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let adjustedWidth = rect.width * progress
        let adjustedRect = CGRect(x: rect.minX, y: rect.minY, width: adjustedWidth, height: rect.height)
        path.addRoundedRect(in: adjustedRect, cornerSize: CGSize(width: cornerRadius, height: cornerRadius))
        return path
    }
}
