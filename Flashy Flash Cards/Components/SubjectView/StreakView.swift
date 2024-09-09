//
//  StreakView.swift
//  Flashy Flash Cards
//
//  Created by Simon Matome on 08/07/2024.
//

import SwiftUI

struct StreakView: View {
    
    @State private var isAnimating = false
    
    
    let streak: Int
    
    init(streak: Int = 15) {
        self.streak = streak
    }
    
    var body: some View {
        if streak > 5 {
            HStack {
                Image(systemName: "flame.fill")
                    .foregroundStyle(Color.theme.FlameColor)
                    .scaleEffect(isAnimating ? 1.3 : 1.1)
                    .animation(
                        isAnimating ?
                            .spring(response: 0.2, dampingFraction: 0.9, blendDuration: 1).repeatForever(autoreverses: true) : .default
                        , value: isAnimating
                    )
                    .onAppear {
                        isAnimating.toggle()
                    }
                
                Text("\(streak) days")
                    .font(.headline)
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .foregroundStyle(Color.theme.FlameColor)
                    .minimumScaleFactor(0.5)
            }
            .background(Color.clear)
        } else {
            EmptyView()
        }
    }
}

#Preview {
    StreakView()
}
