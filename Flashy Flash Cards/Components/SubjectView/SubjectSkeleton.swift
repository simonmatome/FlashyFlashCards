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
    
    @State private var topicHeading: String = ""
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("Enter subject title here", text: $subject.title)
                        .font(.system(size: layout.customFontSize.mediumLarge))
                        .autocorrectionDisabled()
                    
                        SubjectThemePicker(selection: $subject.marker)
                    
                        BackgroundPicker(selection: $subject.fileBackground)
                } header: {
                    Text("Subject title")
                        .font(.system(size: layout.customFontSize.large))
                        .fontWeight(.medium)
                        .foregroundStyle(Color.black)
                        .multilineTextAlignment(.center)
                }
                Section {
                    ForEach($subject.topics) { $topic in
                        NavigationLink {
                            EditTopicView(layout: layout, topic: $topic)
                        } label: {
                            Text("\(topic.name)")
                                .font(.system(size: layout.customFontSize.mediumLarge))
                        }
                    }
                    .onDelete { indices in
                        // add logic to delete all instances of the topic from Flash Flash
                        let name = subject.topics[Int(indices.first ?? 0)].name
                        flashFlashVM.deleteTopic(topic: name)
                        subject.topics.remove(atOffsets: indices)
                    }
                    HStack {
                        TextField("Enter topic heading", text: $topicHeading)
                            .autocorrectionDisabled()
                            Button {
                                withAnimation {
                                    let newTopic = Topic(name: topicHeading, flashCards: [])
                                    subject.topics.append(newTopic)
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
        }
    }
}

#Preview {
    SubjectSkeleton(layout: currentLayout, subject: .constant(Subject.sample[0]))
        .environmentObject(DayCardsViewViewModel())
}
