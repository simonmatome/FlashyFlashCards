//
//  TopicView.swift
//  Flashy Flash Cards
//
//  Created by Simon Matome on 11/07/2024.
//

import SwiftUI

struct TopicView: View {
    @Binding var topic: Topic
    var index: Int
    
    // This property will be used once we use incoporate the timer.
    @State private var averageAnswerTime = 1.2
    @State private var systemFontSize: CGFloat = 19
    
    private var numberOfFlashCardsAnswered: Int {
        topic.flashCards.filter({ $0.transferedToCardOfTheDay == true }).count
    }
    private var numberOfFlashCards: Int {
        topic.flashCards.count
    }
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Image(systemName: "\(index + 1).circle.fill")
                    .font(.system(size: 40))
                    .fontWeight(.medium)
                Spacer()
                Text(topic.name)
                    .font(.system(size: 25))
                    .fontWeight(.bold)
                
                Spacer()
            }
            /// Card details
            Grid(alignment: .leading, horizontalSpacing: 10, verticalSpacing: 30) {
                GridRow {
                    Text("Number of FlashCards")
                        .font(.system(size: systemFontSize))
                        .fontWeight(.medium)
                    Text("\(numberOfFlashCards)")
                        .font(.system(size: systemFontSize))
                        .fontWeight(.medium)
                }
                GridRow {
                    Text("Flashcards being reviewed")
                        .font(.system(size: systemFontSize))
                        .fontWeight(.medium)
                    Text("\(numberOfFlashCardsAnswered)")
                        .font(.system(size: systemFontSize))
                        .fontWeight(.medium)
                }
                GridRow {
                    Text("Average time to answer (min)")
                        .font(.system(size: systemFontSize))
                        .fontWeight(.medium)
                    Text(averageAnswerTime.asNumberWith2Sf())
                        .font(.system(size: systemFontSize))
                        .fontWeight(.medium)
                }
            }
        }
        .padding()
        .background(Color.white.roundedCorner(20, corners: .allCorners))
        .shadow(radius: 10)
        .padding(.horizontal)
    }
}

#Preview {
    TopicView(topic: .constant(Topic.sample[0]), index: 2)
}
