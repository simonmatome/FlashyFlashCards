//
//  SubjectModel.swift
//  Flashy Flash Cards
//
//  Created by Simon Matome on 11/07/2024.
//

import Foundation
import SwiftUI

struct Subject: Identifiable, Codable {
    let id: UUID
    var title: String
    var topics: [Topic]
    var marker: SubjectTheme
    var fileBackground: SubjectBackgroundTheme
    
    init(id: UUID = UUID(), title: String, topics: [Topic], marker: SubjectTheme, background: SubjectBackgroundTheme) {
        self.id = id
        self.title = title
        self.topics = topics
        self.marker = marker
        self.fileBackground = background
    }
}


extension Subject {
    static var emptySubject: Subject {
        Subject(title: "", topics: [], marker: .periwinkle, background: SubjectBackgroundTheme.paper_vintage_1)
    }
}

extension Subject {
    static var sample: [Subject] {
        [
            Subject(
                title: "Science",
                topics: Topic.sample,
                marker: .fireball_fuchsia,
                background: SubjectBackgroundTheme.paper_vintage_1
            )
        ]
    }
}
