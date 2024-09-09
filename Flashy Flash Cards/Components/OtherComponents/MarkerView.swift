//
//  MarkerView.swift
//  Flashy Flash Cards
//
//  Created by Simon Matome on 29/07/2024.
//

import SwiftUI

struct MarkerView: View {
    let theme: SubjectTheme
    
    var body: some View {
        Text(theme.name)
            .fontWeight(.bold)
            .padding(4)
            .frame(maxWidth: .infinity)
            .background(theme.SubjectMainColor.roundedCorner(4, corners: .allCorners))
            .foregroundStyle(theme.SubjectAccentColor)
    }
}

#Preview {
    MarkerView(theme: .fireball_fuchsia)
}
