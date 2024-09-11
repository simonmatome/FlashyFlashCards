//
//  SubjectEditView.swift
//  Flashy Flash Cards
//
//  Created by Simon Matome on 26/07/2024.
//

import SwiftUI

struct SubjectEditView: View {
    @EnvironmentObject var store: LibraryViewViewModel
    @EnvironmentObject var flashyFlashVM: DayCardsViewViewModel
    let layout: LayoutProperties
    @Binding var subject: Subject
    @Binding var editSubject: Bool
    @Binding var oldSubjectName: String
    
    @State var selection: SubjectTheme = .cesmic_orange
    
    var body: some View {
            SubjectSkeleton(layout: layout, subject: $subject, selection: $selection, isNewSubject: false) {
                editSubject.toggle()
            } confirmLogic: {
                subject.marker = selection
                flashyFlashVM.updateSubjectTheme(subject: subject, oldSubjectName: oldSubjectName)
                subject.topics.values.forEach { topic in
                    flashyFlashVM.updateReviewIntervals(subject: subject.title, topic: topic)
                }
                Task {
                    do {
                        try await store.save(subjects: store.subjects)
                        try await store.load()
                    } catch {
                        print(error)
                    }
                }
                editSubject.toggle()
            }
            .task {
                selection = subject.marker
            }
    }
}
