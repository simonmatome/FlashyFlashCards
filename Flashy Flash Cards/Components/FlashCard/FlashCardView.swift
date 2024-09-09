//
//  FlashCardView.swift
//  Flashy Flash Cards
//
//  Created by Simon Matome on 08/07/2024.
//

import SwiftUI

struct FlashCardView: View {
    @EnvironmentObject var store: LibraryViewViewModel
    @EnvironmentObject var cardOfTheDay: DayCardsViewViewModel
    @Namespace var namespace
    @Binding var subject: Subject
    @Binding var topic: Topic
    @Binding var flashCard: FlashCardModel
    let category: Category
    let layout: LayoutProperties
    
    @StateObject var timer = CardTimer()

    @State private var isQuestion: Bool = false
    @State private var flashCardRotation = 0.0
    @State private var selected: Rating? = nil
    @State private var isEditingCurrentCard = false

    
    var body: some View {
        VStack(spacing: 0) {
            if category == .dayCards {
                TimerView(vm: timer)
                    .minimumScaleFactor(0.5)
            }
            FlashCardStruct {
                FlashCardQuestionView(namespace: namespace, question: flashCard.question, isQuestion: $isQuestion)
            } back: {
                FlashCardAnswerView(namespace: namespace, answer: flashCard, isQuestion: $isQuestion)
            } stop: {
                if flashCard.viewed == false && category == .dayCards {
                    flashCard.rate()
                }
            }
            .frame(height: layout.height*0.73)
            CardRatingView(subject: subject, topic: $topic, flashcard: $flashCard, category: category)
            if category == .library {
                HStack(alignment: .center) {
                    Button {
                        isEditingCurrentCard = true
                    } label: {
                        Text("Edit card")
                    }
                    Spacer()
                    Button {
                        store.deleteFlashCard(in: subject.id, topicID: topic.id, flashCard: flashCard)
                        topic.flashCards.removeAll(where: { $0.id == flashCard.id })
                        Task {
                            do {
                                try await cardOfTheDay.save(path: .cards_data, cards: cardOfTheDay.boxes)
                            } catch {
                                print(error)
                            }
                        }
                    } label: {
                        Text("Delete card")
                    }
                }
                .padding(.top)
                .padding(.horizontal, 50)
            }
        }
        .sheet(isPresented: (category == .library) ? $isEditingCurrentCard : .constant(false)) {
                FlashCardEditView(
                    subject: $subject,
                    topic: $topic,
                    editingCard: $flashCard,
                    isEditingCurrentCard: $isEditingCurrentCard
                )
            }
    }
}

#Preview {
    FlashCardView(subject: .constant(Subject.sample[0]), topic: .constant(Topic.sample[0]),flashCard: .constant(FlashCardModel.sample[0]), category: .dayCards, layout: currentLayout)
        .environmentObject(LibraryViewViewModel())
        .environmentObject(DayCardsViewViewModel())
}



