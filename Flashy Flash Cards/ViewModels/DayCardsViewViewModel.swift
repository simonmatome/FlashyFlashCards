//
//  DayCardsViewViewModel.swift
//  Flashy Flash Cards
//
//  Created by Simon Matome on 31/07/2024.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class DayCardsViewViewModel: ObservableObject {
    
    @Published var table: [FileRating: [UUID: Subject]] = [:]
    @Published var boxes: [FileRating: [Subject]] = [:]
    @Published var topicNamesData: [String: [String]] = [:]
    @Published var badgeNumber: Int = 0
    
    var cancellables = Set<AnyCancellable>()
    
    // Main buffer to create boxes to hold subjects
    private var buffer: [FileRating: [Subject]] = [:]
    
    // Buffers created to hold the cards right after rating.
    private var buffers: [BufferBoxes: [FlashCardModel]] = [:]
    
    private let notificationHandler = NotificationsHandler.instance
    
    init() {
        reloadUIFromBuffer()
        updateTopicNames()
        updateBadge()
        autoSave()
    }
    
    /// Private method to do auto-save
    private func autoSave() {
        $boxes
            .sink { box in
                Task {
                    do {
                        try await self.save(path: .cards_data, cards: box)
                    } catch {
                        // need to start displaying these saving errors
                        print(error)
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    /// Method to update the badge
    private func updateBadge() {
        $boxes
            .map { (boxes) -> Int in
                var count = 0
                for subjects in boxes.values {
                    subjects.forEach { subject in
                        count += subject.topics.count
                    }
                }
                return count
            }
            .sink { [weak self] number in
                guard let self else { return }
                self.badgeNumber = number
            }
            .store(in: &cancellables)
    }
    
// MARK: Methods to serve the right data to the charts
    
    /// Method to update the statistics in Statistics page
    private func updateTopicNames() {
        $boxes
            .map { (boxes) -> [String: [String]] in
                self.topicNames(boxes: boxes)
            }
            .sink { [weak self] names in
                guard let self else { return }
                self.topicNamesData = names
            }
            .store(in: &cancellables)
    }
    
    /// Method that returns a list of topic names that are contained in the boxes dictionary
    func topicNames(boxes: [FileRating: [Subject]]) -> [String: [String]] {
        var topics = [String: [String]]()
        for subjects in boxes.values {
            subjects.forEach { subject in
                subject.topics.values.forEach { topic in
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
                guard let currenTopic = subject.topics.first(where: { $0.value.name == topic }) else { return }
                topicStats.append(TopicStat(box: box, number: currenTopic.value.flashCards.count ))
            }
        }
        return topicStats
    }
    
    /// Method to serve topics to the 
// MARK: Methods to deal with property updates
    
    /// Method to update a card that has been edited which exists in the buffer or boxes
    func updateCard(card: FlashCardModel, topicID: UUID, subject: String) {
        for (box, subjects) in boxes {
            if let subjectIndex = subjects.firstIndex(where: { $0.title == subject }),
               boxes[box]![subjectIndex].topics[topicID] != nil,
               let cardIndex = boxes[box]![subjectIndex].topics[topicID, default: Topic.emptyTopic].flashCards.firstIndex(where: { $0.id == card.id }){
                boxes[box]![subjectIndex].topics[topicID, default: Topic.emptyTopic].flashCards[cardIndex] = card
            }
        }
        for (box, subjects) in buffer {
            if let subjectIndex = subjects.firstIndex(where: { $0.title == subject }) {
                if buffer[box]![subjectIndex].topics[topicID] != nil {
                    if let cardIndex = buffer[box]![subjectIndex].topics[topicID, default: Topic.emptyTopic].flashCards.firstIndex(where: { $0.id == card.id }) {
                        buffer[box]![subjectIndex].topics[topicID, default: Topic.emptyTopic].flashCards[cardIndex] = card
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
    func updateReviewIntervals(subject: String, topic: Topic) {
        for (box, subjects) in boxes {
            if let subjectIndex = subjects.firstIndex(where: { $0.title == subject }) {
                if boxes[box]![subjectIndex].topics[topic.id] != nil {
                    boxes[box]![subjectIndex].topics[topic.id]!.reviewIntervals = topic.reviewIntervals
                }
            }
        }
        for (box, subjects) in buffer {
            if let subjectIndex = subjects.firstIndex(where: { $0.title == subject }) {
                if buffer[box]![subjectIndex].topics[topic.id] != nil {
                    buffer[box]![subjectIndex].topics[topic.id]!.reviewIntervals = topic.reviewIntervals
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
            if boxes[box, default: []].isEmpty {
                boxes.removeValue(forKey: box)
            }
        }
        for (box, _) in buffer {
            buffer[box, default: []].removeAll(where: { $0.title == subject })
            if buffer[box, default: []].isEmpty {
                buffer.removeValue(forKey: box)
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
    
    /// Method to update the theme of the subject file as well as its title when updated from Library
    func updateSubjectTheme(subject: Subject, oldSubjectName: String) {
        for (box, subjects) in boxes {
            if let subjectIndex = subjects.firstIndex(where: { $0.title == oldSubjectName }) {
                boxes[box,default: []][subjectIndex].title = subject.title
                boxes[box, default: []][subjectIndex].marker = subject.marker
                boxes[box, default: []][subjectIndex].fileBackground = subject.fileBackground
            }
        }
        for (box, subjects) in buffer {
            if let subjectIndex = subjects.firstIndex(where: { $0.title == oldSubjectName }) {
                buffer[box,default: []][subjectIndex].title = subject.title
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
    func deleteTopic(topicID: UUID) {
        // First delete from the UI
        for (box, subjects) in boxes {
            for i in subjects.indices {
                boxes[box, default: []][i].topics.removeValue(forKey: topicID)
                
                // Delete subject from the UI if it does not have topics
                if boxes[box, default: []][i].topics.isEmpty {
                    boxes[box, default: []].remove(at: i)
                }
                
                // Delete the key and value pair if the value is null
                if boxes[box, default: []].isEmpty {
                    boxes.removeValue(forKey: box)
                }
            }
        }
        // Now delete the topic from the buffer
        for (box, subjects) in buffer {
            for i in subjects.indices {
                buffer[box, default: []][i].topics.removeValue(forKey: topicID)
                
                // Delete subject from the UI if it does not have topics
                if buffer[box, default: []][i].topics.isEmpty {
                    buffer[box, default: []].remove(at: i)
                }
                
                // Delete the key and value pair if the value is null
                if buffer[box, default: []].isEmpty {
                    buffer.removeValue(forKey: box)
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
    private func scheduleCards(subject: Subject, topic: Topic, bufferCards: [FlashCardModel], box: BufferBoxes) {
        var newTopic = Topic(id: topic.id, name: topic.name, flashCards: bufferCards, reviewIntervals: topic.reviewIntervals)
        newTopic.topicDelay(box: box)
        let newSubject = Subject(title: subject.title, topics: [newTopic.id: newTopic], marker: subject.marker, background: subject.fileBackground)
        
        // Remove all empty subjects from the boxes array
        boxes.forEach { (rating, subjects) in
            subjects.forEach { current in
                if current.topics.isEmpty {
                    boxes[rating, default: []].removeAll(where: { $0.title == current.title })
                }
            }
            if subjects.isEmpty {
                boxes.removeValue(forKey: rating)
            }
        }
        
        let rating = box.fileRating
        let currentBox = boxes[rating, default: []]
        // We accesss rating in boxes a lot in this code, this needs to be cleaned up
        
        if let subjectIndex = currentBox.firstIndex(where: { $0.title == subject.title }) {
            if currentBox[subjectIndex].topics[topic.id] != nil {
                boxes[rating]![subjectIndex].topics[topic.id]!.flashCards += bufferCards
            } else {
                notificationHandler.scheudleNotification(time: newTopic.delay, topic: newTopic.name, rating: rating)
                DispatchQueue.main.asyncAfter(deadline: .now() + newTopic.delay) { [weak self] in
                    guard let self = self else { return }
                    if self.boxes[rating, default: []][subjectIndex].topics.contains(where: { $0.key == newTopic.id }) {
                        self.boxes[rating]![subjectIndex].topics[topic.id]!.flashCards += bufferCards
                    } else {
                        self.boxes[rating, default: []][subjectIndex].topics[newTopic.id] = newTopic
                    }
                }
            }
        } else {
            notificationHandler.scheudleNotification(time: newTopic.delay, topic: newTopic.name, rating: rating)
            DispatchQueue.main.asyncAfter(deadline: .now() + newTopic.delay) { [weak self] in
                guard let self = self else { return }
                if let subjectIndex = self.boxes[rating, default: []].firstIndex(where: { $0.title == subject.title }) {
                    if self.boxes[rating, default: []][subjectIndex].topics.contains(where: { $0.key == newTopic.id }) {
                        self.boxes[rating, default: []][subjectIndex].topics[newTopic.id]!.flashCards += bufferCards
                    } else {
                        self.boxes[rating, default: []][subjectIndex].topics[newTopic.id] = newTopic
                    }
                } else {
                    self.boxes[rating, default: []].insert(newSubject, at: 0)
                }
            }
        }
    }
        
    /// Method to remove card from the UI
    private func removeCardFromUI(card: FlashCardModel, subject: String, topicID: UUID) {
        guard let rating = FileRating(rawValue: card.box),
              let subjectIndex = boxes[rating, default: []].firstIndex(where: { $0.title == subject })
        else {
            print("Couldnt find topic the card belongs")
            return
        }
        boxes[rating]![subjectIndex].topics[topicID]!.flashCards.removeAll(where: { $0.id == card.id })
        
        if boxes[rating]![subjectIndex].topics[topicID]!.flashCards.isEmpty {
            boxes[rating, default: []][subjectIndex].topics.removeValue(forKey: topicID)
        }
        if boxes[rating, default: []][subjectIndex].topics.isEmpty {
            boxes[rating, default: []].remove(at: subjectIndex)
        }
        if boxes[rating, default: []].isEmpty {
            boxes.removeValue(forKey: rating)
        }
    }
    
    
// MARK: Methods dealing with the buffer
        
    /// Method to reload the UI using the buffer if the user gets a notification and the app was quit by the user
    func reloadUIFromBuffer() {
        Task {
            do {
                try await load(path: .buffer_data)
                try await load(path: .cards_data)
                for (box, subjects) in buffer {
                    var boxContents = self.boxes[box, default: []]
                    
                    for subject in subjects {
                        guard let subjectIndex = boxContents.firstIndex(where: { $0.title == subject.title }) else {
                            scheduleOrInsert(box: box, subject: subject)
                            Task {
                                do {
                                    try await save(path: .cards_data, cards: self.boxes)
                                } catch {
                                    print(error)
                                }
                            }
                            continue
                        }
                        
                        var subjectContent = boxContents[subjectIndex]
                        
                        for topic in subject.topics.values {
                            let timeElapsed = Date().timeIntervalSince(topic.dateAdded)
                            let overTime  = timeElapsed >= topic.delay
                            let difference = topic.delay - timeElapsed
                            
                            if subjectContent.topics.contains(where: { $0.key == topic.id }) {
                                updateOrScheduleFlashCards(
                                    for: &subjectContent.topics[topic.id]!,
                                    with: topic.flashCards,
                                    at: (box, subjectIndex),
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
                try await save(path: .cards_data, cards: boxes)
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
        at location: (rating: FileRating, subjectIndex: Int),
        overTime: Bool, delay: TimeInterval) {
            let inTopic = topic
            let subject = buffer[location.rating]![location.subjectIndex]
            if overTime {
                topic.flashCards += flashCards
            } else {
                notificationHandler.scheudleNotification(time: delay, topic: topic.name, rating: location.rating)
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
                    guard let self = self else { return }
                    
                    if self.boxes[location.rating, default: []].indices.contains(location.subjectIndex) {
                        if self.boxes[location.rating]![location.subjectIndex].topics.contains(where: { $0.key == inTopic.id }) {
                            self.boxes[location.rating]![location.subjectIndex].topics[inTopic.id]!.flashCards += flashCards
                        } else {
                            self.boxes[location.rating]![location.subjectIndex].topics[inTopic.id] = inTopic
                        }
                    } else {
                        self.boxes[location.rating, default: []] += [Subject(title: subject.title, topics: [inTopic.id: inTopic], marker: subject.marker, background: subject.fileBackground)]
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
                subject.topics[topic.id] = topic
            } else {
                notificationHandler.scheudleNotification(time: delay, topic: topic.name, rating: location.rating)
                let sub = subject
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
                    guard let self = self else { return }
                    if self.boxes[location.rating, default: []].indices.contains(location.subjectIndex) {
                        if self.boxes[location.rating]![location.subjectIndex].topics.contains(where: { $0.key == topic.id }) {
                            self.boxes[location.rating]![location.subjectIndex].topics[topic.id]!.flashCards += topic.flashCards
                        } else {
                            self.boxes[location.rating]![location.subjectIndex].topics[topic.id] = topic
                        }
                    } else {
                        self.boxes[location.rating, default: []] += [Subject(title: sub.title, topics: [topic.id: topic], marker: sub.marker, background: sub.fileBackground)]
                    }
                }
            }
    }
    
    // Helper to schedule or insert subject from buffer
    private func scheduleOrInsert(box: FileRating, subject: Subject) {
        var newSubject = Subject(title: subject.title, topics: [:], marker: subject.marker, background: subject.fileBackground)

        for topic in subject.topics.values {
            let timeElapsed = Date().timeIntervalSince(topic.dateAdded)
            let overTime = timeElapsed >= topic.delay
            let difference = topic.delay - timeElapsed
            
            if overTime {
                newSubject.topics[topic.id] = topic
            } else {
                notificationHandler.scheudleNotification(time: difference, topic: topic.name, rating: box)
                DispatchQueue.main.asyncAfter(deadline: .now() + difference) { [weak self] in
                    guard let self = self else { return }
                    if let subjectIndex = self.boxes[box, default: []].firstIndex(where: { $0.title == subject.title }) {
                        if self.boxes[box]![subjectIndex].topics.contains(where: { $0.key == topic.id }) {
                            self.boxes[box]![subjectIndex].topics[topic.id]!.flashCards += topic.flashCards
                        } else {
                            self.boxes[box]![subjectIndex].topics[topic.id] = topic
                        }
                    } else {
                        newSubject.topics[topic.id] = topic
                        self.boxes[box,default: []].insert(newSubject, at: 0)
                    }
                    Task {
                        do {
                            try await self.save(path: .cards_data, cards: self.boxes)
                        }
                    }
                }
            }
            if !newSubject.topics.isEmpty {
                self.boxes[box, default: []].append(newSubject)
            }
        }
    }
        
    /// Method to add cards to temporary buffer boxes and remove just rated cards from the boxes published variable
    func rateCard(card: FlashCardModel, subject: String, topicID: UUID, rating: Rating, category: Category) {
        // Rate the card and append to the buffers
        var bufferCard = card
        bufferCard.rateCard(rating)
        bufferCard.resetRate()
        let box = BufferBoxes(rawValue: bufferCard.box) ?? BufferBoxes.box1
        buffers[box, default: []].append(bufferCard)
        
        // Remove the old card from the main buffer and published array
        if category == .dayCards {
            removeCardFromUI(card: card, subject: subject, topicID: topicID)
            removeCardFromBuffer(card: card, subject: subject, topicID: topicID)
        }
    }
    
            
    /// Method to add the just rated cards to main buffer box and and schedule to publisher
    func addToMainBox(subject: Subject, topic: Topic) {
        for (box, cardBox) in buffers where !cardBox.isEmpty {
            addToMainBuffer(subject: subject, topic: topic, cards: cardBox, box: box)
            scheduleCards(subject: subject, topic: topic, bufferCards: cardBox, box: box)
        }
        // Reset the buffers immediately after ranking the cards
        buffers = [:]
    }
    
    // MARK: Private methods to work with the buffer
        
    /// Add cards to appropriate box in the main buffer
    private func addToMainBuffer(subject: Subject, topic: Topic, cards: [FlashCardModel], box: BufferBoxes) {
        // Inherit review intervals
        var newTopic = Topic(id: topic.id, name: topic.name, flashCards: cards, reviewIntervals: topic.reviewIntervals)
        newTopic.topicDelay(box: box)
        let newSubject = Subject(title: subject.title, topics: [newTopic.id: newTopic], marker: subject.marker, background: subject.fileBackground)

        let rating = box.fileRating // should remain in the current box if we dont get a rating back
        let currentBox = buffer[rating, default: []]
        
        if let subjectIndex = currentBox.firstIndex(where: { $0.title == subject.title }) {
            if currentBox[subjectIndex].topics.contains(where: { $0.key == topic.id }) {
                buffer[rating]![subjectIndex].topics[topic.id]!.flashCards += cards
            } else {
                buffer[rating]![subjectIndex].topics[topic.id] = newTopic
            }
        } else {
            buffer[rating, default: []].insert(newSubject, at: 0)
        }
    }
    
    /// Method to remove rated card from buffer
    private func removeCardFromBuffer(card: FlashCardModel, subject: String, topicID: UUID) {
        guard let rating = FileRating(rawValue: card.box),
              let subjectIndex = buffer[rating, default: []].firstIndex(where: { $0.title == subject })
        else { return }
        
        buffer[rating]![subjectIndex].topics[topicID]!.flashCards.removeAll(where: { $0.id == card.id })
        
        if buffer[rating]![subjectIndex].topics[topicID]!.flashCards.isEmpty {
            buffer[rating]![subjectIndex].topics.removeValue(forKey: topicID)
        }
        if buffer[rating]![subjectIndex].topics.isEmpty {
            buffer[rating, default: []].remove(at: subjectIndex)
        }
        if buffer[rating, default: []].isEmpty {
            buffer.removeValue(forKey: rating)
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

