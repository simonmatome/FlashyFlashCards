//
//  TopicCardView.swift
//  Flashy Flash Cards
//
//  Created by Simon Matome on 06/09/2024.
//

import SwiftUI

struct TopicCardView: View {
    let layout: LayoutProperties
    let topicIndex: Int
    var topic: Topic
    
    @State private var systemFontSize: CGFloat = 19
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Image(systemName: "\(topicIndex + 1).circle.fill")
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
                    Text("\(topic.flashCards.count)")
                        .font(.system(size: systemFontSize))
                        .fontWeight(.medium)
                }
                GridRow {
                    Text("Flash Cards answered")
                        .font(.system(size: systemFontSize))
                        .fontWeight(.medium)
                    Text("0")
                        .font(.system(size: systemFontSize))
                        .fontWeight(.medium)
                }
                GridRow {
                    Text("Average time to answer (min)")
                        .font(.system(size: systemFontSize))
                        .fontWeight(.medium)
                    Text("30 sec")
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
