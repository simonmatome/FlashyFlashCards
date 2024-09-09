//
//  CardListHeaderView.swift
//  Flashy Flash Cards
//
//  Created by Simon Matome on 20/08/2024.
//

import SwiftUI

struct CardListHeaderView: View {
    @EnvironmentObject var settingsVM: SettingsViewViewModel
    let topic: String
    let layout: LayoutProperties
    let category: Category
    var exitLogic: () -> Void
    var newCardLogic: () -> Void
    
    init(
        topic: String,
        layout: LayoutProperties,
        category: Category,
        exitLogic: @escaping () -> Void,
        newCardLogic: @escaping () -> Void = {}) {
        self.topic = topic
        self.layout = layout
        self.category = category
        self.exitLogic = exitLogic
        self.newCardLogic = newCardLogic
    }
        
    @State private var subjects = false
    @State private var pressed = false
    
    var body: some View {
        HStack {
            Image(systemName: "chevron.backward.circle.fill")
                .font(.largeTitle)
                .scaleEffect(subjects ? 0.9 : 1)
                .foregroundStyle(settingsVM.backgroundTheme.inverted())
                .onLongPressGesture(minimumDuration: 0.1, pressing: { pressing in
                    withAnimation(.easeInOut(duration: 0.1)) {
                        subjects = pressing
                    }
                }, perform: {
                    exitLogic()
                })
            Spacer()
            Text(topic)
                .font(.system(size: layout.customFontSize.extraLarge))
                .fontWeight(.bold)
                .foregroundStyle(settingsVM.backgroundTheme.inverted())
                .multilineTextAlignment(.center)
            Spacer()
            if category == .library {
                Image(systemName: "plus.rectangle.portrait.fill")
                    .font(.largeTitle)
                    .scaleEffect(pressed ? 0.9 : 1)
                    .foregroundStyle(settingsVM.backgroundTheme.inverted())
                    .onLongPressGesture(minimumDuration: 0.1, pressing: { pressing in
                        withAnimation(.easeInOut(duration: 0.1)) {
                            pressed = pressing
                        }
                    }, perform: {
                        newCardLogic()
                    })
            } else {
                EmptyView()
            }
        }
        .padding(.horizontal)
        .padding(.bottom)
        .background(Color.clear)
    }
}

#Preview {
    CardListHeaderView(
        topic: "Mathematics",
        layout: currentLayout,
        category: .library,
        exitLogic: {})
    .environmentObject(SettingsViewViewModel())
}
