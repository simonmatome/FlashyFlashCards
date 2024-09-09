//
//  Flashy_Flash_CardsApp.swift
//  Flashy Flash Cards
//
//  Created by Simon Matome on 08/07/2024.
//

import SwiftUI

@main
struct Flashy_Flash_CardsApp: App {
    @StateObject private var settingsViewModel = SettingsViewViewModel()
    @StateObject private var store = LibraryViewViewModel()
    @StateObject private var cardsOftheDay = DayCardsViewViewModel()
    
    var body: some Scene {
        WindowGroup {
            ResponsiveView { properties in
                RootView(layoutProps: properties)
                    .environmentObject(cardsOftheDay)
                    .environmentObject(settingsViewModel)
                    .environmentObject(store)
            }
            .task {
                cardsOftheDay.reloadUIFromBuffer()
            }
        }
    }
}
