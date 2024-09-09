//
//  DayCardsViewViewModel.swift
//  Flashy Flash Cards
//
//  Created by Simon Matome on 31/07/2024.
//

import Foundation
import SwiftUI

@MainActor
class DayCardsViewViewModel: ObservableObject {
    @Published var boxes: [FileRating: [Subject]] = [:]
    
    // Main buffer to create boxes to hold subjects
    private var buffer: [FileRating: [Subject]] = [:]
    
    // Buffers created to hold the cards right after rating.
    private var buffers: [BufferBoxes: [FlashCardModel]] = [:]
    
    private let notificationHandler = NotificationsHandler.instance
    
    init() {
        reloadUIFromBuffer()
    }
    
    /// Method to update the badge
    func updateBadge() -> Int {
        var count = 0
        for subjects in boxes.values {
            subjects.forEach { subject in
                count += subject.topics.count
            }
        }
        return count
    }
    
// MARK: Methods to serve the right data to the charts
    
    /// Method that returns a list of topic names that are contained in the boxes dictionary
    func topicNames() -> [String: [String]] {
        var topics = [String: [String]]()
        for subjects in boxes.values {
            subjects.forEach { subject in
                subject.topics.forEach { topic in
                    if topics.keys.contains(subject.title) {
                        if !topics[subject.title,default: []].contains(topic.name) {
                            topics[subject.title, default: []].append(topic.name)
                        }
                    } else {
                        topics[subject.title] = [topic.name]
                    }
                }
            }
            
        }
        return topics
    }
    
    /// Method takes in the name of topic and returns a list with the number of flashcards of that particular topic with a particular rating
    func serveTopic(topic: String) -> [TopicStat] {
        var topicStats = [TopicStat]()
        for (box, subjects) in boxes {
            subjects.forEach { subject in
                guard let currentTopic = subject.topics.first(where: { $0.name == topic }) else { return }
                topicStats.append(TopicStat(box: box, number: currentTopic.flashCards.count ))
            }
        }
        return topicStats
    }

// MARK: Methods to deal with property updates
    
    /// Method to update a card that has been edited which exists in the buffer or boxes
    func updateCard(card: FlashCardModel, topic: String, subject: String) {
        for (box, subjects) in boxes {
            if let subjectIndex = subjects.firstIndex(where: { $0.title == subject }) {
                if let topicIndex = subjects[subjectIndex].topics.firstIndex(where: { $0.name == topic }) {
                    if let cardIndex = subjects[subjectIndex].topics[topicIndex].flashCards.firstIndex(where: { $0.id == card.id }) {
                        boxes[box, default: []][subjectIndex].topics[topicIndex].flashCards[cardIndex] = card
                    }
                }
            }
        }
        for (box, subjects) in buffer {
            if let subjectIndex = subjects.firstIndex(where: { $0.title == subject }) {
                if let topicIndex = subjects[subjectIndex].topics.firstIndex(where: { $0.name == topic }) {
                    if let cardIndex = subjects[subjectIndex].topics[topicIndex].flashCards.firstIndex(where: { $0.id == card.id }) {
                        buffer[box, default: []][subjectIndex].topics[topicIndex].flashCards[cardIndex] = card
                    }
                }
            }
        }
        Task {
            do {
                try await save(path: .buffer_data)
                try await save(path: .cards_data, cards: boxes)
            } catch {
                print(error)
            }
        }
    }
    
    /// Method to update topic review Intervals for a particular topic
    func updateReviewIntervals(subject: String, topic: String, reviewIntervals: [ReviewInterval]) {
        for (box, subjects) in boxes {
            if let subjectIndex = subjects.firstIndex(where: { $0.title == subject }) {
                if let topicIndex = subjects[subjectIndex].topics.firstIndex(where: { $0.name == topic }) {
                    boxes[box, default: []][subjectIndex].topics[topicIndex].reviewIntervals = reviewIntervals
                }
            }
        }
        for (box, subjects) in buffer {
            if let subjectIndex = subjects.firstIndex(where: { $0.title == subject }) {
                if let topicIndex = subjects[subjectIndex].topics.firstIndex(where: { $0.name == topic }) {
                    buffer[box, default: []][subjectIndex].topics[topicIndex].reviewIntervals = reviewIntervals
                }
            }
        }
        Task {
            do {
                try await save(path: .buffer_data)
                try await save(path: .cards_data, cards: boxes)
            } catch {
                print(error)
            }
        }
    }
    
    /// Method to delete a given subjects from Flashy Flash
    func deleteSubject(subject: String) {
        for (box, _) in boxes {
            boxes[box, default: []].removeAll(where: { $0.title == subject })
        }
        for (box, _) in buffer {
            buffer[box, default: []].removeAll(where: { $0.title == subject })
        }
        
        Task {
            do {
                try await save(path: .buffer_data)
                try await save(path: .cards_data, cards: boxes)
            } catch {
                print(error)
            }
        }
    }
    
    /// Method to update the theme of the subject file when updated from Library
    func updateSubjectTheme(subject: Subject) {
        for (box, subjects) in boxes {
            if let subjectIndex = subjects.firstIndex(where: { $0.title == subject.title }) {
                boxes[box, default: []][subjectIndex].marker = subject.marker
                boxes[box, default: []][subjectIndex].fileBackground = subject.fileBackground
            }
        }
        for (box, subjects) in buffer {
            if let subjectIndex = subjects.firstIndex(where: { $0.title == subject.title }) {
                buffer[box, default: []][subjectIndex].marker = subject.marker
                buffer[box, default: []][subjectIndex].fileBackground = subject.fileBackground
            }
        }
        Task {
            do {
                try await save(path: .buffer_data)
                try await save(path: .cards_data, cards: boxes)
            } catch {
                print(error)
            }
        }
    }
    
    /// Method to delete instance of a topic from the buffer and boxes.
    func deleteTopic(topic: String) {
        // First delete from the UI
        for (box, subjects) in boxes {
            for i in subjects.indices {
                boxes[box, default: []][i].topics.removeAll(where: { $0.name == topic })
                // Delete subject from the UI if it does not have topics
                if boxes[box, default: []][i].topics.isEmpty {
                    boxes[box, default: []].remove(at: i)
                    // Delete the key and value pair if the value is null
                    if boxes[box, default: []].isEmpty {
                        boxes.removeValue(forKey: box)
                    }
                }
            }
        }
        // Now delete the topic from the buffer
        for (box, subjects) in buffer {
            for i in subjects.indices {
                buffer[box, default: []][i].topics.removeAll(where: { $0.name == topic })
                // Delete subject from the UI if it does not have topics
                if buffer[box, default: []][i].topics.isEmpty {
                    buffer[box, default: []].remove(at: i)
                    // Delete the key and value pair if the value is null
                    if buffer[box, default: []].isEmpty {
                        buffer.removeValue(forKey: box)
                    }
                }
            }
        }
        
        // Save the deletion changes
        Task {
            do {
                try await save(path: .buffer_data)
                try await save(path: .cards_data, cards: boxes)
            } catch {
                print(error)
            }
        }

    }
    
// MARK: Methods to reset the boxes and buffer within the app
    
    /// Method to reset the main buffer and the boxes published variable
    func resetModel() {
        self.boxes = [:]
        self.buffer = [:]
        Task {
            do {
                // these four operations can run in parallel as they are not related
                try await save(path: .buffer_data)
                try await save(path: .cards_data, cards: boxes)
                try await load(path: .buffer_data)
                try await load(path: .cards_data)
            } catch {
                print(error)
            }
        }
    }
    
// MARK: Methods dealing with the cards published variable
    
    /// Method to schedule the rated cards to appear in the UI after rating
    private func scheduleCards(subject: Subject, topic: String, bufferCards: [FlashCardModel], box: BufferBoxes, reviewIntervals: [ReviewInterval]) {
        var newTopic = Topic(name: topic, flashCards: bufferCards, reviewIntervals: reviewIntervals)
        newTopic.topicDelay(box: box)
        let newSubject = Subject(title: subject.title, topics: [newTopic], marker: subject.marker, background: subject.fileBackground)
        
        // Remove all empty subjects from the boxes array
        boxes.forEach { (rating, subjects) in
            subjects.forEach { current in
                if current.topics.isEmpty {
                    boxes[rating, default: []].removeAll(where: { $0.title == current.title })
                }
            }
        }
        
        let rating = FileRating(rawValue: box.rawValue) ?? FileRating.moderate
        let currentBox = boxes[rating, default: []]
        // We accesss rating in boxes a lot in this code, this needs to be cleaned up
        
        if let subjectIndex = currentBox.firstIndex(where: { $0.title == subject.title }) {
            if let topicIndex = currentBox[subjectIndex].topics.firstIndex(where: { $0.name == topic }) {
                if currentBox[subjectIndex].topics[topicIndex].flashCards.isEmpty {
                    self.boxes[rating, default: []][subjectIndex].topics[topicIndex].topicDelay(box: box)
                    let topicNow = boxes[rating, default: []][subjectIndex].topics[topicIndex]
                    notificationHandler.scheudleNotification(time: topicNow.delay, topic: topicNow.name, rating: rating)
                    DispatchQueue.main.asyncAfter(deadline: .now() + topicNow.delay) { [weak self] in
                        self?.boxes[rating, default: []][subjectIndex].topics[topicIndex].flashCards = bufferCards
                    }
                } else {
                    // If the UI already has some cards inside the topic, we should append the current bufferCards to those
                    boxes[rating, default: []][subjectIndex].topics[topicIndex].flashCards += bufferCards
                }
            } else {
                notificationHandler.scheudleNotification(time: newTopic.delay, topic: newTopic.name, rating: rating)
                DispatchQueue.main.asyncAfter(deadline: .now() + newTopic.delay) { [weak self] in
                    self?.boxes[rating, default: []][subjectIndex].topics.insert(newTopic, at: 0)
                }
            }
        } else {
            notificationHandler.scheudleNotification(time: newTopic.delay, topic: newTopic.name, rating: rating)
            DispatchQueue.main.asyncAfter(deadline: .now() + newTopic.delay) { [weak self] in
                self?.boxes[rating, default: []].insert(newSubject, at: 0)
            }
        }
    }
        
    /// Method to remove card from the UI
    private func removeCardFromUI(card: FlashCardModel, subject: String, topic: String) {
        guard let rating = FileRating(rawValue: card.box),
              let subjectIndex = boxes[rating, default: []].firstIndex(where: { $0.title == subject }),
              let topicIndex = boxes[rating, default: []][subjectIndex].topics.firstIndex(where: { $0.name == topic })
        else {
            print("Couldnt find topic the card belongs")
            return
        }
        boxes[rating, default: []][subjectIndex].topics[topicIndex].flashCards.removeAll(where: { $0.id == card.id })
        
        // Tower of doom is not ideal
        if boxes[rating, default: []][subjectIndex].topics[topicIndex].flashCards.isEmpty {
            boxes[rating, default: []][subjectIndex].topics.remove(at: topicIndex)
            if boxes[rating, default: []][subjectIndex].topics.isEmpty {
                boxes[rating, default: []].remove(at: subjectIndex)
                if boxes[rating, default: []].isEmpty {
                    boxes.removeValue(forKey: rating)
                }
            }
        }
    }
    
    
// MARK: Methods dealing with the buffer
        
    /// Method to reload the UI using the buffer if the user gets a notification and the app was quit by the user
    func reloadUIFromBuffer() {
        Task {
            do {
                try await load(path: .buffer_data)
                try await load(path: .cards_data)
                print("\nThe files have loaded, they are:\n \(print(Array(buffer)))\n")
                for (box, subjects) in buffer {
                    print("\nThe current box is: \(box.rawValue)\n")
                    var boxContents = boxes[box, default: []]
                    
                    for subject in subjects {
                        guard let subjectIndex = boxContents.firstIndex(where: { $0.title == subject.title }) else {
                            scheduleOrInsert(box: box, subject: subject)
                            continue
                        }
                        
                        var subjectContent = boxContents[subjectIndex]
                        
                        for topic in subject.topics {
                            let timeElapsed = Date().timeIntervalSince(topic.dateAdded)
                            let overTime  = timeElapsed >= topic.delay
                            let difference = topic.delay - timeElapsed
                            
                            if let topicIndex = subjectContent.topics.firstIndex(where: { $0.name == topic.name }) {
                                updateOrScheduleFlashCards(
                                    for: &subjectContent.topics[topicIndex],
                                    with: topic.flashCards,
                                    at: (box, subjectIndex, topicIndex),
                                    overTime: overTime, delay: difference
                                )
                            } else {
                                insertOrScheduleTopic(
                                    for: &subjectContent,
                                    at: (box, subjectIndex),
                                    with: topic,
                                    overTime: overTime, delay: difference
                                )
                            }
                        }
                        boxContents[subjectIndex] = subjectContent
                    }
                }
                try await load(path: .cards_data)
            } catch {
                print("failed to run the load function")
            }
        }
    }
    
    // Helper to schedule cards from the buffer
    private func updateOrScheduleFlashCards(
        for topic: inout Topic,
        with flashCards: [FlashCardModel],
        at location: (rating: FileRating, subjectIndex: Int, topicIndex: Int),
        overTime: Bool, delay: TimeInterval) {
        if overTime {
            topic.flashCards += flashCards
        } else {
            notificationHandler.scheudleNotification(time: delay, topic: topic.name, rating: location.rating)
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
                guard let self = self else { return }
                
                if self.boxes[location.rating, default: []].indices.contains(location.subjectIndex),
                   self.boxes[location.rating, default: []][location.subjectIndex].topics.indices.contains(location.topicIndex) {
                    self.boxes[location.rating, default: []][location.subjectIndex].topics[location.topicIndex].flashCards += flashCards
                }
            }
        }
    }
    
    // Helper to schedule topics from the buffer
    private func insertOrScheduleTopic(
        for subject: inout Subject,
        at location: (rating: FileRating, subjectIndex: Int),
        with topic: Topic,
        overTime: Bool, delay: TimeInterval) {
            if overTime {
                subject.topics.insert(topic, at: 0)
            } else {
                notificationHandler.scheudleNotification(time: delay, topic: topic.name, rating: location.rating)
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
                    guard let self = self else { return }
                    if self.boxes[location.rating, default: []].indices.contains(location.subjectIndex) {
                        self.boxes[location.rating, default: []][location.subjectIndex].topics.insert(topic, at: 0)
                    }
                }
            }
    }
    
    // Helper to schedule or insert subject from buffer
    private func scheduleOrInsert(box: FileRating, subject: Subject) {
        var newSubject = Subject(title: subject.title, topics: [], marker: subject.marker, background: subject.fileBackground)

        for topic in subject.topics {
            let timeElapsed = Date().timeIntervalSince(topic.dateAdded)
            let overTime = timeElapsed >= topic.delay
            let difference = topic.delay - timeElapsed
            
            if overTime {
                newSubject.topics.append(topic)
            } else {
                notificationHandler.scheudleNotification(time: difference, topic: topic.name, rating: box)
                DispatchQueue.main.asyncAfter(deadline: .now() + difference) { [weak self] in
                    guard let self = self else { return }
                    if let subjectIndex = self.boxes[box]?.firstIndex(where: { $0.title == subject.title }) {
                        self.boxes[box, default: []][subjectIndex].topics.insert(topic, at: 0)
                    } else {
                        newSubject.topics.insert(topic, at: 0)
                        self.boxes[box,default: []].insert(newSubject, at: 0)
                    }
                }
            }
            if !newSubject.topics.isEmpty {
                self.boxes[box, default: []].append(newSubject)
                print("Successfuly added the overdue topics:\n\(boxes[box, default: []])")
                Task {
                    try await save(path:.cards_data, cards: boxes)
                }

            }
        }
    }
        
    /// Method to add cards to temporary buffer boxes and remove just rated cards from the boxes published variable
    func rateCard(card: FlashCardModel, subject: String, topic: String, rating: Rating, category: Category) {
        // Rate the card and append to the buffers
        var bufferCard = card
        bufferCard.rateCard(rating)
        bufferCard.resetRate()
        let box = BufferBoxes(rawValue: bufferCard.box) ?? BufferBoxes.box1
        buffers[box, default: []].append(bufferCard)
        
        // Remove the old card from the main buffer and published array
        if category == .dayCards {
            removeCardFromUI(card: card, subject: subject, topic: topic)
            removeCardFromBuffer(card: card, subject: subject, topic: topic)
        }
    }
    
            
    /// Method to add the just rated cards to main buffer box and and schedule to publisher
    func addToMainBox(subject: Subject, topic: Topic) {
        for (box, cardBox) in buffers where !cardBox.isEmpty {
            addToMainBuffer(subject: subject, topic: topic.name, cards: cardBox, box: box, reviewIntervals: topic.reviewIntervals)
            scheduleCards(subject: subject, topic: topic.name, bufferCards: cardBox, box: box, reviewIntervals: topic.reviewIntervals)
        }
        // Reset the buffers immediately after ranking the cards
        buffers = [:]
    }
    
    // MARK: Private methods to work with the buffer
        
    /// Add cards to appropriate box in the main buffer
    private func addToMainBuffer(subject: Subject, topic: String, cards: [FlashCardModel], box: BufferBoxes, reviewIntervals: [ReviewInterval]) {
        var newTopic = Topic(name: topic, flashCards: cards, reviewIntervals: reviewIntervals) // Inherit review intervals
        newTopic.topicDelay(box: box)
        let newSubject = Subject(title: subject.title, topics: [newTopic], marker: subject.marker, background: subject.fileBackground)

        let rating = FileRating(rawValue: box.rawValue) ?? FileRating.moderate // should remain in the current box if we dont get a rating back
        let currentBox = buffer[rating, default: []]
        
        if let subjectIndex = currentBox.firstIndex(where: { $0.title == subject.title }) {
            if let topicIndex = currentBox[subjectIndex].topics.firstIndex(where: { $0.name == topic }) {
                if currentBox[subjectIndex].topics[topicIndex].flashCards.isEmpty {
                    buffer[rating, default: []][subjectIndex].topics[topicIndex].flashCards = cards
                    buffer[rating, default: []][subjectIndex].topics[topicIndex].dateAdded = Date()
                    buffer[rating, default: []][subjectIndex].topics[topicIndex].topicDelay(box: box)
                } else {
                    buffer[rating, default: []][subjectIndex].topics[topicIndex].flashCards += cards
                }
            } else {
                buffer[rating, default: []][subjectIndex].topics.insert(newTopic, at: 0)
            }
        } else {
            buffer[rating, default: []].insert(newSubject, at: 0)
        }
    }
    
    /// Method to remove rated card from buffer
    private func removeCardFromBuffer(card: FlashCardModel, subject: String, topic: String) {
        guard let rating = FileRating(rawValue: card.box),
              let subjectIndex = buffer[rating, default: []].firstIndex(where: { $0.title == subject }),
              let topicIndex = buffer[rating, default: []][subjectIndex].topics.firstIndex(where: { $0.name == topic })
        else { return }
        
        print("\nThe card rating is: \(rating)\n")
        buffer[rating, default: []][subjectIndex].topics[topicIndex].flashCards.removeAll(where: { $0.id == card.id })
        
        // Tower of doom is not ideal
        if buffer[rating, default: []][subjectIndex].topics[topicIndex].flashCards.isEmpty {
            buffer[rating, default: []][subjectIndex].topics.remove(at: topicIndex)
            print("Topic \(topic) is deleted\n")
            if buffer[rating, default: []][subjectIndex].topics.isEmpty {
                buffer[rating, default: []].remove(at: subjectIndex)
                print("Subject \(subject) is deleted\n")
                if buffer[rating, default: []].isEmpty {
                    buffer.removeValue(forKey: rating)
                    print("box with number \(rating.rawValue) is deleted\n")
                }
            }
        }

    }
    
// MARK: Methods dealing with on-device data storage
    
    /// Method to create file URL
    static func fileURl(pathKey: PathKeys) throws -> URL {
        try FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false)
        .appending(path: pathKey.name)
    }
    
    /// Method to load saved data
    func load(path: PathKeys) async throws {
        let task = Task<[FileRating: [Subject]], Error> {
            let fileURL = try Self.fileURl(pathKey: path)
            print(fileURL)
            guard let data = try? Data(contentsOf: fileURL) else { return [:] }
            let savedCards = try JSONDecoder().decode([FileRating: [Subject]].self, from: data)
            return savedCards
        }
        let savedCards = try await task.value
        path.toBuffer ? (self.buffer = savedCards) : (self.boxes = savedCards)
    }
    
    /// Method to save data
    func save(path: PathKeys, cards: [FileRating: [Subject]] = [:]) async throws {
        let task = Task {
            let data = try? JSONEncoder().encode(path.toBuffer ? buffer : cards)
            let outfile = try Self.fileURl(pathKey: path)
            try data?.write(to: outfile)
        }
        _ = try await task.value
    }
    
    enum PathKeys: String {
        case cards_data // Need to change this pathkey to boxes.data to reflect the publshed variable name
        case buffer_data
        var name: String{
            rawValue.replacing("_", with: ".")
        }
        var toBuffer: Bool {
            switch self {
            case .cards_data:
                return false
            case .buffer_data:
                return true
            }
        }
    }
}

