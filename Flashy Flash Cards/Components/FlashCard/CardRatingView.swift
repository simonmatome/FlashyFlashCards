//
//  CardRatingView.swift
//  Flashy Flash Cards
//
//  Created by Simon Matome on 19/07/2024.
//

import SwiftUI

struct CardRatingView: View {
    var subject: Subject
    @Binding var topic: Topic
    @Binding var flashcard: FlashCardModel
    var category: Category
    
    @EnvironmentObject var cardsOfTheDay: DayCardsViewViewModel
    @EnvironmentObject var store: LibraryViewViewModel
    
    @State private var selected: Rating? = nil
    
    var body: some View {
        switch category {
        case .library:
            if !flashcard.transferedToCardOfTheDay {
                HStack(spacing: 5) {
                    ForEach(Rating.allCases) { rating in
                        Button {
                            selected = rating
                            flashcard.transferedToCardOfTheDay = true
                            cardsOfTheDay.rateCard(
                                card: flashcard,
                                subject: subject.title,
                                topicID: topic.id,
                                rating: rating,
                                category: category
                            )
                            store.cardRated(in: subject.id, topicID: topic.id, with: flashcard) // update the transferedToCardOfTheDay property
                            guard let cardIndex = topic.flashCards.firstIndex(where: { $0.id == flashcard.id }) 
                            else { return }
                            topic.flashCards[cardIndex] = flashcard
                            Task {
                                do {
                                    try await store.save(subjects: store.subjects)
                                    try await cardsOfTheDay.save(path: .buffer_data)
                                } catch {
                                    print(error)
                                }
                            }
                        } label: {
                            Text(rating.name)
                                .cardRatingStyle(
                                    current: rating, selected: selected,
                                    background: rating.RatingColor,
                                    accent: rating.RatingColorAccent
                                )
                        }
                    }
                }
            }

        case .dayCards:
            if flashcard.viewed {
                HStack(spacing: 5) {
                    ForEach(Rating.allCases) { rating in
                        Button {
                            selected = rating
                            cardsOfTheDay.rateCard(
                                card: flashcard, 
                                subject: subject.title,
                                topicID: topic.id,
                                rating: rating,
                                category: category
                            )
                            topic.flashCards.removeAll(where: { $0.id == flashcard.id })
                            Task {
                                do {
                                    try await cardsOfTheDay.save(path: .cards_data, cards: cardsOfTheDay.boxes)
                                    try await cardsOfTheDay.save(path: .buffer_data)
                                    try await cardsOfTheDay.load(path: .buffer_data)
                                    try await cardsOfTheDay.load(path: .cards_data)
                                } catch {
                                    print(error)
                                }
                            }
                        } label: {
                            Text(rating.name)
                                .cardRatingStyle(
                                    current: rating, selected: selected,
                                    background: rating.RatingColor,
                                    accent: rating.RatingColorAccent
                                )
                        }
                    }
                }
            }

        }
    }
    
    // Helper function to delete the
}

#Preview {
    CardRatingView(
        subject: Subject.sample[0],
        topic: .constant(Topic.sample[0]),
        flashcard: .constant(FlashCardModel.sample[0]), category: .library)
    .environmentObject(DayCardsViewViewModel())
}
