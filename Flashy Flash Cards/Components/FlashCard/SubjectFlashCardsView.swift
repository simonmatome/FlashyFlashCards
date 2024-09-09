//
//  SubjectFlashCardsView.swift
//  Flashy Flash Cards
//
//  Created by Simon Matome on 08/07/2024.
//

import SwiftUI

struct SubjectFlashCardsView: View {
    @EnvironmentObject var store: LibraryViewViewModel
    @EnvironmentObject var cardOfTheDay: DayCardsViewViewModel
    
    @Binding var subject: Subject
    @Binding var topic: Topic
    @Binding var presentCards: Bool
    let layout: LayoutProperties
    
    // Variables to track state
    @State private var isCreatingNewCard = false
            
    var body: some View {
        VStack {
            CardListHeaderView(topic: topic.name, layout: layout, category: .library) {
                cardOfTheDay.addToMainBox(subject: subject, topic: topic)
                Task {
                    do {
                        try await store.save(subjects: store.subjects)
                        try await cardOfTheDay.save(path: .cards_data, cards: cardOfTheDay.boxes)
                        try await store.load()
                    } catch {
                        print(error)
                    }
                }
                presentCards.toggle()
            } newCardLogic: {
                isCreatingNewCard.toggle()
            }
            
            if !topic.flashCards.isEmpty {
                ScrollView(.horizontal) {
                    LazyHStack {
                        ForEach($topic.flashCards) { $card in
                            FlashCardView(subject: $subject, topic: $topic, flashCard: $card, category: .library, layout: layout)
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
                EmptyFlashView(layout: layout, category: .library)
            }
        }
        .sheet(isPresented: $isCreatingNewCard) {
            NewFlashCardView(
                subject: $subject,
                topic: $topic,
                isCreatingNewCard: $isCreatingNewCard)
        }
    }
}

#Preview {
    SubjectFlashCardsView(
        subject: .constant(Subject.sample[0]),
        topic: .constant(Topic.sample[3]),
        presentCards: .constant(true),
        layout: currentLayout
    )
    .environmentObject(LibraryViewViewModel())
    .environmentObject(DayCardsViewViewModel())
}
