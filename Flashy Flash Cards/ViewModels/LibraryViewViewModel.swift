//
//  FlashyFlashStore.swift
//  Flashy Flash Cards
//
//  Created by Simon Matome on 27/07/2024.
//

import Foundation

/// Based on code from apple
///  https://developer.apple.com/tutorials/app-dev-training/persisting-data

@MainActor
class LibraryViewViewModel: ObservableObject {
    @Published var subjects: [Subject] = []
    
    init() {
        Task {
            do {
                try await load()
            } catch {
                print(error)
            }
        }
    }
    
    /// Method to delete all subjects in the library
    func emptyLibrary() {
        self.subjects = []
        Task {
            do {
                try await save(subjects: subjects)
                try await load()
            } catch {
                print(error)
            }
        }
    }
    
    /// Method to reset the transferedToDayCards property in the FlashCardModel
    func resetTransfer() {
        for subInd in subjects.indices {
            for topInd in subjects[subInd].topics.indices {
                for cardInd in subjects[subInd].topics[topInd].flashCards.indices {
                    subjects[subInd].topics[topInd].flashCards[cardInd].transferedToCardOfTheDay = false
                }
            }
        }
        Task {
            do {
                try await save(subjects: subjects)
                try await load()
            } catch {
                print(error)
            }
        }
    }
    
    /// Method to update specific flashcard in a specific topic of a specif subject after editing the card.
    func updateFlashCard(in subjectID: UUID, topicID: UUID,with flashCard: FlashCardModel) {
        guard let subjectIndex = subjects.firstIndex(where: { $0.id == subjectID }),
              let topicIndex = subjects[subjectIndex].topics.firstIndex(where: { $0.id == topicID }),
              let flashCardIndex = subjects[subjectIndex].topics[topicIndex].flashCards.firstIndex(where: { $0.id == flashCard.id })
        else {
            return
        }
        subjects[subjectIndex].topics[topicIndex].flashCards[flashCardIndex] = flashCard
        Task {
            do {
                try await save(subjects: subjects)
            } catch {
                print(error)
            }
            do {
                try await load()
            } catch {
                print(error)
            }
        }
    }
    
    /// Method to update the transferedToCardOfTheDay property of a flash card in the library store after rating it for the first time.
    func cardRated(in subjectID: UUID, topicID: UUID, with card: FlashCardModel) {
        guard let subjectIndex = subjects.firstIndex(where: { $0.id == subjectID }) else {
            return
        }
        guard let topicIndex = subjects[subjectIndex].topics.firstIndex(where: { $0.id == topicID }) else {
            return
        }
        guard let cardIndex = subjects[subjectIndex].topics[topicIndex].flashCards.firstIndex(where: { $0.id == card.id }) else { return }
        subjects[subjectIndex].topics[topicIndex].flashCards[cardIndex].transferedToCardOfTheDay = true
    }
    
    
    /// Method to add flashcard to the topic in the library
    func addFlash(topic: Topic) {
        guard let subjectIndex = subjects.firstIndex(where: { $0.topics.contains(where: { $0.name == topic.name })}) else { return }
        subjects[subjectIndex].topics.removeAll(where: { $0.name == topic.name })
        subjects[subjectIndex].topics.append(topic)
    }
    
    /// Method to add a new flashcard to a specific topic to a specific subject
    func addFlashCard(to subjectID: UUID, topicID: UUID, flashCard: FlashCardModel) {
        guard let subjectIndex = subjects.firstIndex(where: { $0.id == subjectID }),
              let topicIndex = subjects[subjectIndex].topics.firstIndex(where: { $0.id == topicID })
        else {
            print("failed to save card")
            return
        }
        subjects[subjectIndex].topics[topicIndex].flashCards.append(flashCard)
        Task {
            do {
                try await save(subjects: subjects)
                try await load()
            } catch {
                print(error)
            }
        }
    }
    
    /// Method to delete selected flashCard
    func deleteFlashCard(in subjectID: UUID, topicID: UUID, flashCard: FlashCardModel) {
        guard let subjectIndex = subjects.firstIndex(where: { $0.id == subjectID }),
              let topicIndex = subjects[subjectIndex].topics.firstIndex(where: { $0.id == topicID })
        else {
            return
        }
        subjects[subjectIndex].topics[topicIndex].flashCards.removeAll(where: { $0.id == flashCard.id})
        Task {
            do {
                try await save(subjects: subjects)
                try await load()
            } catch {
                print(error)
            }
        }
    }
    
    
    // MARK: Methods to load and save the current library of cards
    
    /// method to create file URL
    static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appending(path: "library.data")
    }
    
    /// Method to decode data from the URL file path
    func load() async throws {
        let task = Task<[Subject], Error> {
            let fileURL = try Self.fileURL()
            print(fileURL)
            guard let data = try? Data(contentsOf: fileURL) else { return [] }
            let subjects = try JSONDecoder().decode([Subject].self, from: data)
            return subjects
        }
        let subjects = try await task.value
        self.subjects = subjects
    }
    
    /// Method to save data to user file
    func save(subjects: [Subject]) async throws {
        let task = Task {
            let data = try JSONEncoder().encode(subjects)
            let outfile = try Self.fileURL()
            try data.write(to: outfile)
        }
        _ = try await task.value
    }
}
