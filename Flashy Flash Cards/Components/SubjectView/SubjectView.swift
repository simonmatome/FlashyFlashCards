//
//  SubjectView.swift
//  Flashy Flash Cards
//
//  Created by Simon Matome on 08/07/2024.
//

import SwiftUI

struct SubjectView: View {
    @EnvironmentObject var store: LibraryViewViewModel
    @Binding var subjects: [Subject]
    @Binding var subject: Subject
    @Binding var editedSubject: Subject
    @Binding var isEditedSubject: Bool
    let layout: LayoutProperties
    
    @State private var pressed = false
    @State private var deleteSubject: Bool = false
    @State private var presentCards: Bool = false
    @State private var selectedTopic: Topic = Topic.emptyTopic
    @State private var oldSubjectName = ""
    
    var body: some View {
        ZStack {
            VStack {
                SubjectHeaderView(
                    subject: $subject,
                    addTopic: $deleteSubject,
                    isEditSubject: $isEditedSubject,
                    editedSubject: $editedSubject,
                    layout: layout
                )
                TabView {
                    let array = Array(subject.topics.keys)
                    ForEach(array, id: \.self) { key in
                        let index = array.firstIndex(where: { $0.uuidString == key.uuidString }) ?? 0
                        TopicView(topic: Binding(get: {
                            subject.topics[key]!
                        }, set: {
                            subject.topics[key]! = $0
                        }), index: index)
                            .scaleEffect(pressed ? 0.95 : 1)
                            .tabItem {
                                Image(systemName: "\(index + 1).circle.fill")
                            }
                            .onLongPressGesture(minimumDuration: 0.2, pressing: { pressing in
                                withAnimation(.easeInOut(duration: 0.1)) {
                                    pressed = pressing
                                }
                            }, perform: {
                                presentCards.toggle()
                                selectedTopic = subject.topics[key]!
                            })
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .automatic))
                .indexViewStyle(.page(backgroundDisplayMode: .always))
            }
            .frame(width: layout.width * 0.9, height: layout.height * 0.45)
            .background(subject.fileBackground.main.roundedCorner(20, corners: .allCorners))
            .blur(radius: deleteSubject ? 3 : 0)
            .shadow(radius: 10)
            
            
            if deleteSubject {
                Color.black.opacity(0.01)
                DeleteSubjectConfirmView(subjects: $subjects, subject: $subject, deleteSubject: $deleteSubject, layout: layout)
                    .transition(.scale)
                    .zIndex(1)
            }
        }
        .sheet(isPresented: $isEditedSubject) {
            SubjectEditView(layout: layout, subject: $subject, editedSubject: $editedSubject, editSubject: $isEditedSubject, oldSubjectName: $oldSubjectName)
                .onAppear {
                    oldSubjectName = subject.title
                }
        }
        .fullScreenCover(isPresented: $presentCards) {
//            Task {
//                do {
//                    try await store.save(subjects: subjects)
//                } catch {
//                    print(error)
//                }
//            }
        } content: {
            SubjectFlashCardsView(subject: $subject, topic: $selectedTopic, presentCards: $presentCards, layout: layout)
        }
        .animation(.spring(response: 0.6, dampingFraction: 0.75), value: deleteSubject)
    }
}

#Preview {
    SubjectView(
        subjects: .constant(Subject.sample),
        subject: .constant(Subject.sample[0]),
        editedSubject: .constant(Subject.emptySubject),
        isEditedSubject: .constant(false),
        layout: currentLayout)
    .environmentObject(LibraryViewViewModel())
}
