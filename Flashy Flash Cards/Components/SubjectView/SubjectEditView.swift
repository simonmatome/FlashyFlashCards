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
    @Binding var editedSubject: Subject
    @Binding var editSubject: Bool
    @Binding var oldSubjectName: String
    
    var body: some View {
        NavigationStack {
            SubjectSkeleton(layout: layout, subject: $editedSubject)
                .navigationTitle("Edit Subject")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            editedSubject = Subject.emptySubject
                            editSubject = false
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") {
                            subject = editedSubject
                            editedSubject = Subject.emptySubject
                            flashyFlashVM.updateSubjectTheme(subject: subject, oldSubjectName: oldSubjectName)
                            subject.topics.values.forEach { topic in
                                flashyFlashVM.updateReviewIntervals(subject: subject.title, topic: topic)
                            }
                            Task {
                                do {
                                    try await store.save(subjects: store.subjects)
                                } catch {
                                    print(error)
                                }
                            }
                            editSubject = false
                        }
                    }
                }
        }
    }
}
