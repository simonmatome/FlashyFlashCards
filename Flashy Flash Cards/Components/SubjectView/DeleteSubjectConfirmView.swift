//
//  AddTopicView.swift
//  Flashy Flash Cards
//
//  Created by Simon Matome on 11/07/2024.
//

import SwiftUI

struct DeleteSubjectConfirmView: View {
    @EnvironmentObject var cardOfTheDay: DayCardsViewViewModel
    @EnvironmentObject var store: LibraryViewViewModel
    @Binding var subjects: [Subject]
    @Binding var subject: Subject
    @Binding var deleteSubject: Bool
    let layout: LayoutProperties
    
    var body: some View {
        
        VStack {
            Text("are you sure you want to delete subject?".uppercased())
                .multilineTextAlignment(.center)
                .font(.system(size: layout.customFontSize.large))
                .fontWeight(.bold)
            
            HStack (alignment: .center, spacing: 20) {
                
                Button {
                    deleteSubject = false
                } label: {
                    Label(
                        title: {
                            Text("Cancel")
                                .font(.system(size: layout.customFontSize.large))
                        },
                        icon: {
                            Image(systemName: "x.circle.fill")
                                .font(.system(size: layout.customFontSize.large))
                        }
                    )
                }
                .padding()
                .background(Color.gray.opacity(0.2).roundedCorner(10, corners: .allCorners))
                
                Button {
                    cardOfTheDay.deleteSubject(subject: subject.title)
                    subjects.removeAll { $0.title == subject.title }
                    Task {
                        do {
                            try await store.save(subjects: store.subjects)
                        } catch {
                            print(error)
                        }
                    }
                    deleteSubject = false
                } label: {
                    Label(
                        title: {
                            Text("Delete")
                                .font(.system(size: layout.customFontSize.large))
                                .foregroundStyle(Color.red)
                        },
                        icon: {
                            Image(systemName: "trash.fill")
                                .font(.system(size: layout.customFontSize.large))
                                .foregroundStyle(Color.red)
                        }
                    )
                }
                .padding()
                .background(Color.gray.opacity(0.2).roundedCorner(10, corners: .allCorners))
                .labelStyle(.trailingIcon)
            }
            .padding(.top, 20)
        }
        .padding()
        .background(Color.white.roundedCorner(20, corners: .allCorners))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(radius: 7)
        .padding()
    }
}

#Preview {
    DeleteSubjectConfirmView(
        subjects: .constant(Subject.sample),
        subject: .constant(Subject.sample[0]),
        deleteSubject: .constant(true),
        layout: currentLayout
    )
    .environmentObject(DayCardsViewViewModel())
    .environmentObject(LibraryViewViewModel())
}
