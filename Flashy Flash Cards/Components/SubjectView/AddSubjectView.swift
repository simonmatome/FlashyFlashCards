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
    @State private var selection: SubjectTheme = .cesmic_orange
    
    var body: some View {
            SubjectSkeleton(layout: layout, subject: $subject, selection: $selection, isNewSubject: true) {
                subject = Subject.emptySubject
                addSubject = false
            } confirmLogic: {
                subject.marker = selection
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
    }
    
}

struct AddSubjectView_Previews: PreviewProvider {
    
    static var previews: some View {
        AddSubjectView(addSubject: .constant(true), subjects: .constant(Subject.sample), layout: currentLayout)
    }
}
