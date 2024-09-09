//
//  BackgroundPicker.swift
//  Flashy Flash Cards
//
//  Created by Simon Matome on 29/07/2024.
//

import SwiftUI

struct BackgroundPicker: View {
    @Binding var selection: SubjectBackgroundTheme
    @State private var isShowingDetailView = false
    var body: some View {
            HStack {
                Text("Background")
                HStack{
                    Text(selection.name)
                        .padding(4)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(selection.accent)
                        .background(selection.main.roundedCorner(4, corners: .allCorners))
                    Image(systemName: "chevron.forward")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                }
                .onTapGesture {
                    isShowingDetailView.toggle()
                }
            }
            .sheet(isPresented: $isShowingDetailView) {
                NavigationStack {
                    BackgroundChoiceView(layout: currentLayout, selection: $selection) {
                        isShowingDetailView.toggle()
                    }
                    .navigationTitle("Pick File Background")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                isShowingDetailView.toggle()
                            }
                        }
                }
                }
            }
    }
}

#Preview {
    NavigationStack {
        BackgroundPicker(selection: .constant(SubjectBackgroundTheme.raging_flame_1))
    }
}
