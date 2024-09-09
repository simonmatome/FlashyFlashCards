//
//  FlashCardAnswerView.swift
//  Flashy Flash Cards
//
//  Created by Simon Matome on 08/07/2024.
//

import SwiftUI
import LaTeXSwiftUI

struct FlashCardAnswerView: View {
    var namespace: Namespace.ID
    let answer: FlashCardModel
    @Binding var isQuestion: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            VStack {
                Text("A")
                    .font(.title)
                    .scaleEffect(2)
                    .minimumScaleFactor(0.5)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .padding()
                    .matchedGeometryEffect(id: "header", in: namespace)
                LaTeX(answer.answer)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.white)
                    .minimumScaleFactor(0.6)
                    .multilineTextAlignment(.leading)
                    .matchedGeometryEffect(id: "body", in: namespace)
            }
            CustomListView(points: answer.points)
            // Makes sure that this only shows if and only if there are keypoints
            if !answer.keyPoints.isEmpty {
            Text("Key Points:".uppercased())
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                ForEach(answer.keyPoints) { point in
                    HStack {
                     Image(systemName: "circle.fill")
                            .font(.custom("Copperplate", size: 6))
                            .foregroundStyle(.flame)
                        LaTeX(point.point)
                            .font(.system(size: 10))
                            .foregroundStyle(.white)
                        Spacer()
                    }
                }
            }
        }
        .padding()
        .background(Color.brown)
        .containerShape(RoundedRectangle(cornerRadius: 25.0))
        .shadow(radius: 10)
    }
}

struct FlashCardAnswerView_Previews: PreviewProvider {
    @Namespace static var namespace
    
    static var previews: some View {
        FlashCardAnswerView(
            namespace: namespace,
            answer: FlashCardModel.sample[0],
            isQuestion: .constant(false))
    }
}
