//
//  FlashCardEditView.swift
//  Flashy Flash Cards
//
//  Created by Simon Matome on 21/07/2024.
//

import SwiftUI

struct FlashCardEditView: View {
    @EnvironmentObject var store: LibraryViewViewModel
    @EnvironmentObject var flashVM: DayCardsViewViewModel
    @Binding var subject: Subject
    @Binding var topic: Topic
    @Binding var editingCard: FlashCardModel
    @Binding var isEditingCurrentCard: Bool
    
    var body: some View {
        NavigationStack {
            FlashCardSkeleton(card: $editingCard)
                .navigationTitle("Edit Card")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            isEditingCurrentCard = false
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") {
                            guard let cardIndex = topic.flashCards.firstIndex(where: { $0.id == editingCard.id }) else { return }
                            topic.flashCards[cardIndex] = editingCard
                            store.updateFlashCard(in: subject.id, topicID: topic.id, with: editingCard)
                            flashVM.updateCard(card: editingCard, topic: topic.name, subject: subject.title)
                            isEditingCurrentCard = false
                        }
                    }
                }
        }
    }
}

#Preview {
    FlashCardEditView(
        subject: .constant(Subject.sample[0]),
        topic: .constant(Topic.sample[0]),
        editingCard: .constant(FlashCardModel.sample[0]),
        isEditingCurrentCard: .constant(true)
    )
}
