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
    var topics: [UUID:Topic]
    var marker: SubjectTheme
    var fileBackground: SubjectBackgroundTheme
    
    init(id: UUID = UUID(), title: String, topics: [UUID:Topic], marker: SubjectTheme, background: SubjectBackgroundTheme) {
        self.id = id
        self.title = title
        self.topics = topics
        self.marker = marker
        self.fileBackground = background
    }
}


extension Subject {
    static var emptySubject: Subject {
        Subject(title: "", topics: [:], marker: .periwinkle, background: SubjectBackgroundTheme.paper_vintage_1)
    }
}

extension Subject {
    static var sample: [Subject] {
        [
            Subject(
                title: "Science",
                topics: [
                    Topic.sample[0].id : Topic.sample[0],
                    Topic.sample[1].id : Topic.sample[1],
                    Topic.sample[2].id : Topic.sample[2],
                    Topic.sample[3].id : Topic.sample[3]
                ],
                marker: .fireball_fuchsia,
                background: SubjectBackgroundTheme.paper_vintage_1
            )
        ]
    }
}
