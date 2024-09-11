//
//  SubjectsView.swift
//  Flashy Flash Cards
//
//  Created by Simon Matome on 08/07/2024.
//

import SwiftUI

struct LibraryView: View {
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject var settingsVM: SettingsViewViewModel
    @EnvironmentObject var flashyFlashVM: DayCardsViewViewModel
    @EnvironmentObject var store: LibraryViewViewModel
    
    @Namespace var namespace
    let layout: LayoutProperties
    
    @State private var selectedItem: String? = nil
    @State private var addSubject: Bool = false

    
    var body: some View {
            VStack {
                HeaderView(namespace: namespace, addSubject: $addSubject)
                    .padding(.horizontal)
                if !store.subjects.isEmpty {
                    ScrollView {
                        LazyVStack(spacing: 40) {
                            ForEach($store.subjects) { $subject in
                                SubjectView(subjects: $store.subjects, subject: $subject, layout: layout)
                                    .scrollTransition { content, phase in
                                        content
                                            .scaleEffect(
                                                x: phase.isIdentity ? 1.0 : 0.7,
                                                y: phase.isIdentity ? 1.0 : 0.7
                                            )
                                            .opacity(phase.isIdentity ? 1 : 0.5)
                                    }
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .scrollTargetBehavior(.viewAligned(limitBehavior: .always))
                    .contentMargins(.vertical, 20)
                .scrollIndicators(.hidden)
                } else {
                    ContentUnavailableView(
                        "No added Subject",
                        systemImage: "books.vertical.fill",
                        description: Text("You do not have any added subjects yet")
                    )
                }
            }
            .background(settingsVM.backgroundTheme)
            .blur(radius: addSubject ? 3 : 0) // blur the library when add subject is visible
            .sheet(isPresented: $addSubject) {
                AddSubjectView(addSubject: $addSubject, subjects: $store.subjects, layout: layout)
            }
            .onChange(of: scenePhase) {
                if scenePhase == .inactive || scenePhase == .inactive {
                    Task {
                        do {
                            try await store.save(subjects: store.subjects)
                            try await flashyFlashVM.save(path: .cards_data, cards: flashyFlashVM.boxes)
                            try await flashyFlashVM.save(path: .buffer_data)
                        } catch {
                            print(error)
                        }
                    }
                }
            }
            .task {
                do {
                    try await store.load()
                } catch {
                    print(error)
                }
            }
    }
}


struct SubjectsView_Previews: PreviewProvider {
    @Namespace static var namespace
    private var question = "This is a question"
    
    static var previews: some View {
        NavigationStack {
            TabView {
                LibraryView(
                    layout: currentLayout
                )
                .environmentObject(LibraryViewViewModel())
                .environmentObject(SettingsViewViewModel())
                .environmentObject(DayCardsViewViewModel())
                    .tabItem {
                        Label("Library", systemImage: "books.vertical.fill")
                    }
                SettingsView(layout: currentLayout)
                    .tabItem {
                        Label("Settings", systemImage: "gearshape.fill")
                    }
            }
            .tint(.pink)
        }
    }
}
