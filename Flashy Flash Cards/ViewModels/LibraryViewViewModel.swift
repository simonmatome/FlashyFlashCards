//
//  FlashyFlashStore.swift
//  Flashy Flash Cards
//
//  Created by Simon Matome on 27/07/2024.
//

import Foundation
import Combine

/// Based on code from apple
///  https://developer.apple.com/tutorials/app-dev-training/persisting-data

@MainActor
class LibraryViewViewModel: ObservableObject {
    @Published var subjects: [Subject] = []
    
    var cancellables = Set<AnyCancellable>()
    
    init() {
        Task {
            do {
                try await load()
            } catch {
                print(error)
            }
        }
    }
    
    /// Method to serve topics to the subject view
    func serveTopics(subject: Subject) -> [(index: Int, topic: Topic)] {
        var topics = [(index: Int, topic: Topic)]()
        var count = 0
        for key in subject.topics.keys {
            topics.append((index: count, topic: subject.topics[key]!))
            count += 1
        }
        return topics
    }
    
    /// Method to update subject
//    func updateSubject(subject: Subject) {
//        guard let index = subjects.firstIndex(where: { $0.id == subject.id }) else { return }
//        subjects.remove(at: index)
//        subjects.insert(subject, at: 0)
//    }
    
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
            for topId in subjects[subInd].topics.keys {
                for cardInd in subjects[subInd].topics[topId]!.flashCards.indices {
                    subjects[subInd].topics[topId]!.flashCards[cardInd].transferedToCardOfTheDay = false
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
              let flashCardIndex = subjects[subjectIndex].topics[topicID]!.flashCards.firstIndex(where: { $0.id == flashCard.id })
        else {
            return
        }
        subjects[subjectIndex].topics[topicID]!.flashCards[flashCardIndex] = flashCard
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
        guard let subjectIndex = subjects.firstIndex(where: { $0.id == subjectID }),
              let cardIndex = subjects[subjectIndex].topics[topicID]!.flashCards.firstIndex(where: { $0.id == card.id })
        else {
            return
        }
        subjects[subjectIndex].topics[topicID]!.flashCards[cardIndex].transferedToCardOfTheDay = true
    }
    
    
    /// Method to add flashcard to the topic in the library
    func addFlash(topic: Topic) {
        guard let subjectIndex = subjects.firstIndex(where: { $0.topics.contains(where: { $0.key == topic.id })})
        else { return }
        subjects[subjectIndex].topics[topic.id] = topic
    }
    
    /// Method to add a new flashcard to a specific topic to a specific subject
    func addFlashCard(to subjectID: UUID, topicID: UUID, flashCard: FlashCardModel) {
        guard let subjectIndex = subjects.firstIndex(where: { $0.id == subjectID })
        else {
            print("failed to save card")
            return
        }
        subjects[subjectIndex].topics[topicID]!.flashCards.append(flashCard)
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
        guard let subjectIndex = subjects.firstIndex(where: { $0.id == subjectID }) else { return }
        subjects[subjectIndex].topics[topicID]!.flashCards.removeAll(where: { $0.id == flashCard.id})
        if subjects[subjectIndex].topics[topicID]!.flashCards.isEmpty {
            subjects[subjectIndex].topics.removeValue(forKey: topicID)
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
