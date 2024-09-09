//
//  EditTopicView.swift
//  Flashy Flash Cards
//
//  Created by Simon Matome on 04/09/2024.
//

import SwiftUI

struct EditTopicView: View {
    let layout: LayoutProperties
    @Binding var topic: Topic
        
    var body: some View {
        List {
            Section("Topic Name") {
                TextField("", text: $topic.name)
            }
            Section("Review intervals") {
                ForEach(0..<5, id: \.self) { i in
                    CustomIntervalPicker(layout: layout, stage: i, reviewInterval: $topic.reviewIntervals[i])
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        EditTopicView(layout: currentLayout, topic: .constant(Topic.sample[0]))
            .toolbarTitleDisplayMode(.inline)
            .navigationTitle("\(Topic.sample[0].name)")
    }
}
