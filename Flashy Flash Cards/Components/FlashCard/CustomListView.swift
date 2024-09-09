//
//  CustomListView.swift
//  Flashy Flash Cards
//
//  Created by Simon Matome on 08/07/2024.
//

import SwiftUI
import LaTeXSwiftUI

struct CustomListView: View {
    let points: [FlashCardModel.PointDescription]
    
    var body: some View {
        Grid(alignment: .leading, verticalSpacing: 10) {
            ForEach(points) { point in
                    GridRow {
                        Image(systemName: "circle.fill")
                            .font(.system(size: 5))
                            .foregroundStyle(Color.white)
                        
                        LaTeX(point.point)
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(Color.white)
                        
                        LaTeX(point.description)
                            .font(.system(size: 10))
                            .foregroundStyle(Color.white)
                            .minimumScaleFactor(0.6)
                    }
            }
        }
    }
}

#Preview {
    CustomListView(points: FlashCardModel.sample[0].points)
        .background(.blue)
}
