//
//  SubjectThemePicker.swift
//  Flashy Flash Cards
//
//  Created by Simon Matome on 29/07/2024.
//

import SwiftUI

struct SubjectThemePicker: View {
    @Binding var selection: SubjectTheme
    var body: some View {
        Picker("Marker", selection: $selection) {
            ForEach(SubjectTheme.allCases) { theme in
                MarkerView(theme: theme)
                    .tag(theme)
            }
        }
        .pickerStyle(.navigationLink)
    }
}

#Preview {
    SubjectThemePicker(selection: .constant(.lunar_blue))
}
