//
//  DaySubjectHeader.swift
//  Flashy Flash Cards
//
//  Created by Simon Matome on 18/08/2024.
//

import SwiftUI

struct DaySubjectHeader: View {
    let card: Subject
    let layout: LayoutProperties
    let rating: Int
    
    var fileRating: FileRating {
        FileRating(rawValue: rating) ?? .easy
    }
    
    var fileColor: Color {
        RatingView(rating: fileRating)
    }
    
    var body: some View {
        HStack {
            Text(card.title)
                .font(.system(size: layout.customFontSize.large))
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.9)
                .foregroundStyle(card.marker.SubjectAccentColor)
                .fontWeight(.medium)
                .padding(layout.dimensValues.large)
                .frame(maxWidth: layout.width * 0.7)
                .background(card.marker.SubjectMainColor.roundedCorner(20, corners: [.topLeft, .topRight]))
            Spacer()
        }
        .background(fileColor.roundedCorner(20, corners: [.topLeft, .topRight]))
            .frame(maxWidth: layout.width)
            .padding(.bottom, 0)
    }
    
    // Subject Rating View
    fileprivate func RatingView(rating: FileRating ) -> Color {
        switch rating {
        case .very_easy:
            return Color.green
        case .easy:
            return Color.vulcanGreen
        case .moderate:
            return Color.yellow
        case .hard:
            return Color.orange
        case .very_hard:
            return Color.red
        }
    }

}

#Preview {
    DaySubjectHeader(card: Subject.sample[0], layout: currentLayout, rating: 2)
}
