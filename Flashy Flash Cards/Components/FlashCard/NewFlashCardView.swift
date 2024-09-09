//
//  NewFlashCardView.swift
//  Flashy Flash Cards
//
//  Created by Simon Matome on 21/07/2024.
//

import SwiftUI

struct NewFlashCardView: View {
    @EnvironmentObject var store: LibraryViewViewModel
    @EnvironmentObject var cardOfTheDay: DayCardsViewViewModel
    
    @Binding var subject: Subject
    @Binding var topic: Topic
    @Binding var isCreatingNewCard: Bool
    
    @State private var newCard = FlashCardModel.emptyCard
    
    var body: some View {
        NavigationStack {
            FlashCardSkeleton(card: $newCard)
                .navigationTitle("Create New Flash Card")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            newCard = FlashCardModel.emptyCard
                            isCreatingNewCard = false
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            topic.flashCards.append(newCard)
                            store.addFlash(topic: topic)
                            Task {
                                do {
                                    try await store.save(subjects: store.subjects)
                                    try await store.load()
                                } catch {
                                    print(error)
                                }
                            }
                            isCreatingNewCard.toggle()
                        }
                        .disabled(newCard.question.trimmingCharacters(in: .whitespaces).isEmpty || newCard.answer.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                }
        }
    }
}

#Preview {
    NewFlashCardView(
        subject: .constant(Subject.sample[0]),
        topic: .constant(Topic.sample[0]),
        isCreatingNewCard: .constant(true))
    .environmentObject(DayCardsViewViewModel())
}
