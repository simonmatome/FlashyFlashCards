//
//  SubjectEditView.swift
//  Flashy Flash Cards
//
//  Created by Simon Matome on 25/07/2024.
//

import SwiftUI

struct SubjectSkeleton: View {
    @EnvironmentObject var flashFlashVM: DayCardsViewViewModel
    let layout: LayoutProperties
    @Binding var subject: Subject
    @Binding var selection: SubjectTheme
    var isNewSubject: Bool
    var canceLogic: () -> Void
    var confirmLogic: () -> Void
    
    
    @State private var topicHeading: String = ""
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("Enter subject title here", text: $subject.title)
                        .font(.system(size: layout.customFontSize.mediumLarge))
                        .autocorrectionDisabled()
                    
                        SubjectThemePicker(selection: $selection)
                    
                        BackgroundPicker(selection: $subject.fileBackground)
                } header: {
                    Text("Subject title")
                        .font(.system(size: layout.customFontSize.large))
                        .fontWeight(.medium)
                        .foregroundStyle(Color.black)
                        .multilineTextAlignment(.center)
                }
                Section {
                    ForEach(Array($subject.topics.values), id: \.id) { $topic in
                        NavigationLink {
                            EditTopicView(layout: layout, topic: $topic)
                        } label: {
                            Text("\(topic.name)")
                                .font(.system(size: layout.customFontSize.mediumLarge))
                        }
                    }
                    .onDelete { indices in
                        var topicID = UUID()
                        let keys  = Array(subject.topics.keys.sorted())
                        for index in indices {
                            let keyToDelete = keys[index]
                            topicID = keyToDelete
                            subject.topics.removeValue(forKey: keyToDelete)
                        }
                        flashFlashVM.deleteTopic(topicID: topicID)
                    }
                    HStack {
                        TextField("Enter topic heading", text: $topicHeading)
                            .autocorrectionDisabled()
                            Button {
                                withAnimation {
                                    let newTopic = Topic(name: topicHeading, flashCards: [])
                                    subject.topics[newTopic.id] = newTopic
                                    topicHeading = ""
                                }
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: layout.customFontSize.extraLarge))
                                    .foregroundStyle(topicHeading.trimmingCharacters(in: .whitespaces).isEmpty ? Color.gray : Color.green)
                            }
                            .disabled(topicHeading.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                } header: {
                    Text("Topics")
                        .font(.system(size: layout.customFontSize.large))
                        .fontWeight(.medium)
                        .foregroundStyle(Color.black)
                        .multilineTextAlignment(.center)
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        canceLogic()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        confirmLogic()
                    }
                    .disabled(isNewSubject ? subject.title.isEmpty : false)
                }
            }
            .navigationTitle(isNewSubject ? "Add Subject" : "Edit Subject")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

//#Preview {
//    SubjectSkeleton(layout: currentLayout, subject: .constant(Subject.sample[0]))
//        .environmentObject(DayCardsViewViewModel())
//}
