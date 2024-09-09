//
//  BackgroundPicker.swift
//  Flashy Flash Cards
//
//  Created by Simon Matome on 29/07/2024.
//

import SwiftUI

struct BackgroundChoiceView: View {
    let layout: LayoutProperties
    @Binding var selection: SubjectBackgroundTheme
    let selected: () -> Void
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
            ForEach(SubjectBackgroundTheme.allCases) { color in
                    Text(color.name)
                        .multilineTextAlignment(.center)
                        .padding()
                        .foregroundStyle(color.accent)
                        .frame(width: layout.width * 0.4, height: layout.height * 0.13)
                        .background(color.main.roundedCorner(10, corners: .allCorners))
                        .onTapGesture {
                            withAnimation {
                                selection = color
                                selected()
                            }
                        }
                        .overlay(alignment: .center) {
                            if color == selection {
                                HStack {
                                    Image(systemName: "checkmark")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: layout.width * 0.12)
                                        .foregroundStyle(.white)
                                }
                            }
                        }
                }
            }
        }
        .padding()
    }
}

#Preview {
    NavigationStack {
        BackgroundChoiceView(
            layout: currentLayout,
            selection: .constant(SubjectBackgroundTheme.raging_flame_1), 
            selected: {})
    }
}
