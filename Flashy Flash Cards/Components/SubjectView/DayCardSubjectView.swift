//
//  DayCardSubjectView.swift
//  Flashy Flash Cards
//
//  Created by Simon Matome on 06/09/2024.
//

import SwiftUI

struct DayCardSubjectView: View {
    var subject: Subject
    var box: Int
    let layout: LayoutProperties
    @Binding var selectedTopic: Topic
    var performLogic: () -> Void
    
    @State private var contentPressed = false
    
    var body: some View {
        VStack {
            DaySubjectHeader(card: subject, layout: layout, rating: box)
            TabView {
                ForEach(subject.topics.indices, id: \.self) { index in
                    TopicCardView(layout: layout, topicIndex: index, topic: subject.topics[index])
                        .scaleEffect(contentPressed ? 0.95 : 1)
                        .tabItem {
                            Image(systemName: "\(index + 1).circle.fill")
                        }
                        .onLongPressGesture(minimumDuration: 0.2, pressing: { pressing in
                            withAnimation(.easeInOut(duration: 0.1)) {
                                contentPressed.toggle()
                            }
                        }, perform: {
                            performLogic()
                            selectedTopic = subject.topics[index]
                        })
                        .tag(index)
                    //                                    TopicCard(card: subject)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .automatic))
            .indexViewStyle(.page(backgroundDisplayMode: .always))
        }
        .frame(width: layout.width * 0.9, height: layout.height * 0.45)
        .background(subject.fileBackground.main.roundedCorner(20, corners: .allCorners))
        .padding()
        .shadow(radius: 10)
    }
}
