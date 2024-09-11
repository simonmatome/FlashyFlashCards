//
//  ContentView.swift
//  Flashy Flash Cards
//
//  Created by Simon Matome on 08/07/2024.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var settingsVM: SettingsViewViewModel
    @EnvironmentObject var flahsyVM: DayCardsViewViewModel
    let layoutProps: LayoutProperties
    @AppStorage("SelectedTab") private var selectedTab = "library"
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                DayCardsView(layout: layoutProps)
                    .tabItem {
                        Label("Flashy Flash", systemImage: "book.pages.fill")
                    }
                    .badge(flahsyVM.badgeNumber)
                    .tag("flashy-flash")
                
                LibraryView(layout: layoutProps)
                    .tabItem {
                        Label("Library", systemImage: "books.vertical.fill")
                    }
                    .tag("library")
                
                StatisticsView(layout: layoutProps)
                    .tabItem {
                        Label("Statistics", systemImage: "chart.xyaxis.line")
                    }
                    .tag("statistics")
                
                SettingsView(layout: layoutProps)
                    .tabItem {
                        Label("Settings", systemImage: "gearshape.fill")
                    }
                    .navigationTitle("Settings")
                    .tag("settings")
            }
            .tint(settingsVM.backgroundTheme.inverted())
        }
    }
}

#Preview {
    RootView(layoutProps: currentLayout)
        .environmentObject(SettingsViewViewModel())
}
