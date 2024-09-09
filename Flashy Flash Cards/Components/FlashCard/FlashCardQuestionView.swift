//
//  FlashCardQuestionView.swift
//  Flashy Flash Cards
//
//  Created by Simon Matome on 08/07/2024.
//

import SwiftUI
import LaTeXSwiftUI

struct FlashCardQuestionView: View {
    var namespace: Namespace.ID
    let question: String
    @Binding var isQuestion: Bool
    
    var body: some View {
        VStack {
            VStack {
                Text("Q")
                    .font(.largeTitle)
                    .scaleEffect(2)
                    .minimumScaleFactor(0.5)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .padding()
                    .matchedGeometryEffect(id: "header", in: namespace)
                LaTeX(question)
                    .font(.title)
                    .foregroundStyle(Color.white)
                    .minimumScaleFactor(0.6)
                    .matchedGeometryEffect(id: "body", in: namespace)
            }
            .padding()
            .background(Color.blue)
            .containerShape(RoundedRectangle(cornerRadius: 25.0))
            .shadow(radius: 10)
        }
    }
}

struct FlashCardQuestionView_Previews: PreviewProvider {
    @Namespace static var namespace
    
    static var previews: some View {
            FlashCardQuestionView(
                namespace: namespace,
                question: FlashCardModel.sample[4].question,
                isQuestion: .constant(true))
    }
}
