//
//  EmptyFlashView.swift
//  Flashy Flash Cards
//
//  Created by Simon Matome on 25/07/2024.
//

import SwiftUI

struct CutRect: Shape {
    var cornerRadius: CGFloat
    var comp: CGFloat
    func path(in rect: CGRect) -> Path {
        Path { p in
            p.move(to: CGPoint(x: rect.minX, y: rect.minY))
            p.addLine(to: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY))
            p.addArc(
                tangent1End: CGPoint(x: rect.maxX, y: rect.minY),
                tangent2End: CGPoint(x: rect.maxX, y: rect.minY + cornerRadius),
                radius: cornerRadius
            )
            p.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
            p.addLine(to: CGPoint(x: rect.minX, y: ((rect.midY / 2 - comp) <= (rect.minY + cornerRadius)) ? rect.minY + cornerRadius : rect.midY / 2 - comp))
            p.addLine(to: CGPoint(x: rect.minX, y: rect.minY + cornerRadius))
            p.addArc(
                tangent1End: CGPoint(x: rect.minX, y: rect.minY),
                tangent2End: CGPoint(x: rect.minX + cornerRadius, y: rect.minY),
                radius: cornerRadius
            )
            p.closeSubpath()
        }
    }
}

struct EmptyFlashView: View {
    let layout: LayoutProperties
    let category: Category
    
    @State private var fillAngle: Angle = .degrees(57)
    @State private var comp: CGFloat = 33
    var body: some View {
        VStack(spacing: layout.dimensValues.extraLarge) {
            HStack(spacing: 0) {
                CutRect(cornerRadius: 10, comp: comp)
                    .fill(Color.gray)
                    .frame(width: layout.width * 0.14, height: layout.height * 0.12)
                    .rotation3DEffect( .degrees(180), axis: (x: 0.0, y: 1.0, z: 0.0) )
                    .rotationEffect(-fillAngle)
                    .offset(x: 38.75)
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray)
                    .frame(width: layout.width * 0.14, height: layout.height * 0.12)
                CutRect(cornerRadius: 10, comp: comp)
                    .fill(Color.gray)
                    .frame(width: layout.width * 0.14, height: layout.height * 0.12)
                    .rotationEffect(fillAngle)
                    .offset(x: -38.75)
            }
            switch category {
            case .library:
                VStack(spacing: layout.dimensValues.smallMedium) {
                    Text("No added Flash cards")
                        .font(.system(size: layout.customFontSize.extraLarge))
                        .fontWeight(.bold)
                    Text("You do not have flash cards added yet")
                        .font(.system(size: layout.customFontSize.mediumLarge))
                        .foregroundStyle(Color.gray)
                }

            case .dayCards:
                VStack(spacing: layout.dimensValues.smallMedium) {
                    Text("No flashcards for now")
                        .font(.system(size: layout.customFontSize.extraLarge))
                        .fontWeight(.bold)
                    Text("You have finished all cards for now, come back later for more")
                        .font(.system(size: layout.customFontSize.mediumLarge))
                        .foregroundStyle(Color.gray)
                }

            }
        }
        .frame(maxHeight: .infinity)
    }
}

#Preview {
    EmptyFlashView(layout: currentLayout, category: .library)
}
