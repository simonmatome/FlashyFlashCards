//
//  CardOfTheDayCardView.swift
//  Flashy Flash Cards
//
//  Created by Simon Matome on 03/08/2024.
//

import SwiftUI

struct CardOfTheDayCardView: View {
    @EnvironmentObject var store: LibraryViewViewModel
    @EnvironmentObject var vm: DayCardsViewViewModel
    
    @Binding var presentCards: Bool
    @Binding var subject: Subject
    @Binding var topic: Topic
    let layout: LayoutProperties
    
    var body: some View {
        VStack {
            CardListHeaderView(topic: topic.name, layout: layout, category: .dayCards) {
                presentCards.toggle()
                vm.addToMainBox(subject: subject, topic: topic)
                Task {
                    do {
                        // Dear reader, I am sorry
                        try await vm.save(path: .buffer_data)
                        try await vm.save(path: .cards_data, cards: vm.boxes)
                        try await vm.load(path: .cards_data)
                        try await vm.load(path: .buffer_data)
                    } catch {
                        print(error)
                    }
                }
            }
            
            if !topic.flashCards.isEmpty {
                ScrollView(.horizontal) {
                    LazyHStack {
                        ForEach($topic.flashCards) { $card in
                            FlashCardView(
                                subject: $subject,
                                topic: $topic,
                                flashCard: $card,
                                category: .dayCards,
                                layout: layout
                            )
                                .scrollTransition { content, phase in
                                    content
                                        .scaleEffect(
                                            x: phase.isIdentity ? 1.05 : 0.7,
                                            y: phase.isIdentity ? 1.05 : 0.7
                                        )
                                        .offset(
                                            y: phase.isIdentity ? 0 : 200
                                        )
                                }
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.viewAligned)
                .scrollIndicators(.hidden)
            } else {
                EmptyFlashView(layout: layout, category: .dayCards)
            }
        }
        .padding(.bottom)
    }
}

#Preview {
    CardOfTheDayCardView(
        presentCards: .constant(false), 
        subject: .constant(Subject.sample[0]),
        topic: .constant(Topic.sample[0]),
        layout: currentLayout
    )
    .environmentObject(LibraryViewViewModel())
}
