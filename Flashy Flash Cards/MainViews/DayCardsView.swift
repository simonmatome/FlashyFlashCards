//
//  CardsOfTheDay.swift
//  Flashy Flash Cards
//
//  Created by Simon Matome on 31/07/2024.
//

import SwiftUI

struct DayCardsView: View {
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject var settingsVM: SettingsViewViewModel
    @EnvironmentObject var vm: DayCardsViewViewModel
    @EnvironmentObject var store: LibraryViewViewModel
    let layout: LayoutProperties
    
    @State private var contentPressed = false
    @State private var presentCards = false
    @State private var selectedTopic: Topic = Topic.emptyTopic
    @State private var selectedSubject: Subject = Subject.emptySubject
    
    var body: some View {
        VStack {
            Text("Flashy Flash Cards")
                .font(.largeTitle)
                .fontWeight(.bold)
                .getContrastText(backgroundColor: settingsVM.backgroundTheme)
            
            if !vm.boxes.isEmpty {
                ScrollView {
                    ForEach(Array(vm.boxes), id: \.key) { box, subjects in
                        ForEach(subjects) { subject in
                            DayCardSubjectView(
                                subject: subject,
                                box: box.rawValue,
                                layout: layout,
                                selectedTopic: $selectedTopic
                            ) {
                                presentCards.toggle()
                                selectedSubject = subject
                            }
                        }
                    }
                }
                .scrollIndicators(.hidden)
                
            } else {
                ContentUnavailableView(
                    "No Cards for now",
                    systemImage: "books.vertical.fill",
                    description: Text("Come back later for more cards or browse the library")
                )
            }
        }
        .fullScreenCover(isPresented: $presentCards) {
            CardOfTheDayCardView(
                presentCards: $presentCards,
                subject: $selectedSubject,
                topic: $selectedTopic,
                layout: layout
            )
        }
        .frame(width: layout.width)
        .background(settingsVM.backgroundTheme)
        .onDisappear {
            Task {
                do {
                    try await vm.save(path: .cards_data, cards: vm.boxes)
                    try await vm.save(path: .buffer_data)
                    try await store.save(subjects: store.subjects)
                } catch {
                    print(error)
                }
            }
        }
        .onChange(of: scenePhase) {
            if scenePhase == .background || scenePhase == .inactive {
                Task {
                    do {
                        try await vm.save(path: .cards_data, cards: vm.boxes)
                        try await vm.save(path: .buffer_data)
                        try await store.save(subjects: store.subjects)
                    } catch {
                        print(error)
                    }
                }
            }
        }
        .task {
            do {
                try await vm.load(path: .cards_data)
                try await vm.load(path: .buffer_data)
            } catch {
                print(error)
            }
        }

    }
}

#Preview {
    DayCardsView(layout: currentLayout)
        .environmentObject(DayCardsViewViewModel())
        .environmentObject(LibraryViewViewModel())
}
