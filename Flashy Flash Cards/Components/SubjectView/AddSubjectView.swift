//
//  AddSubject.swift
//  Flashy Flash Cards
//
//  Created by Simon Matome on 08/07/2024.
//

import SwiftUI

struct AddSubjectView: View {
    @EnvironmentObject var store: LibraryViewViewModel
    @Binding var addSubject: Bool
    @Binding var subjects: [Subject]
    let layout: LayoutProperties
    
    /// Empty subject to add a new one
    @State private var subject: Subject = Subject.emptySubject
    
    var body: some View {
        NavigationStack {
            SubjectSkeleton(layout: layout, subject: $subject)
                .navigationTitle("Add Subject")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            subject = Subject.emptySubject
                            addSubject = false
                        }
                    }
                    
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            subjects.append(subject)
                            Task {
                                do {
                                    try await store.save(subjects: store.subjects)
                                } catch {
                                    print(error)
                                }
                            }
                            addSubject = false
                        }
                        .disabled(subject.title.isEmpty)
                    }
                }
        }
    }
    
}

struct AddSubjectView_Previews: PreviewProvider {
    
    static var previews: some View {
        AddSubjectView(addSubject: .constant(true), subjects: .constant(Subject.sample), layout: currentLayout)
    }
}
