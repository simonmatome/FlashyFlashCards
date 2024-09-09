//
//  SubjectMarkerView.swift
//  Flashy Flash Cards
//
//  Created by Simon Matome on 08/07/2024.
//

import SwiftUI

struct SubjectMarkerView: View {
    let subject: Subject
    let layout: LayoutProperties
    
    var body: some View {
        Text(subject.title)
            .font(.system(size: layout.customFontSize.large))
            .multilineTextAlignment(.center)
            .lineLimit(2)
            .minimumScaleFactor(0.9)
            .foregroundStyle(subject.marker.SubjectAccentColor)
            .fontWeight(.medium)
            .padding(layout.dimensValues.large)
            .frame(maxWidth: layout.width * 0.7 )
            .background(subject.marker.SubjectMainColor.roundedCorner(20, corners: [.topLeft, .topRight]))
    }
}

#Preview {
    SubjectMarkerView(subject: Subject.sample[0], layout: currentLayout)
}
