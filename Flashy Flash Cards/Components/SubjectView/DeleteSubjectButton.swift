//
//  AddTopicButtonView.swift
//  Flashy Flash Cards
//
//  Created by Simon Matome on 08/07/2024.
//

import SwiftUI

struct DeleteSubjectButton: View {
    
    let title: String
    let color: Color
    let fontWeight: Font.Weight
    let foregroundColor: Color
    let corners: UIRectCorner
    @Binding var addTopic: Bool
    @State private var pressed = false
    
    var body: some View {
        
        Button {
                
                addTopic.toggle()
                
            } label: {
                
                Text(title)
                    .fontWeight(fontWeight)
                    .font(.footnote)
                    .foregroundStyle(Color(foregroundColor))
                    .padding(5)
                    .background(Color(color).roundedCorner(5, corners: corners))
                    .scaleEffect(pressed ? 0.9 : 1)
            }
            .onLongPressGesture(minimumDuration: 0.1, pressing: { pressing in
                withAnimation(.easeInOut(duration: 0.1)) {
                    pressed = pressing
                }
        }, perform: {})
            .minimumScaleFactor(0.1)
    }
}

#Preview {
    DeleteSubjectButton(title: "add topic", color: .green, fontWeight: .bold, foregroundColor: .black, corners: .allCorners, addTopic: .constant(true))
}
