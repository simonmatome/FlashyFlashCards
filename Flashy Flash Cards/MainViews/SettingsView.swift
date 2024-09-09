//
//  SettingsView.swift
//  Flashy Flash Cards
//
//  Created by Simon Matome on 08/07/2024.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var vm: SettingsViewViewModel
    @EnvironmentObject var store: LibraryViewViewModel
    @EnvironmentObject var dayCards: DayCardsViewViewModel
        
    var body: some View {
        ZStack {
            Color(vm.backgroundTheme)
                .ignoresSafeArea()
            VStack{
                Text("Settings")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .getContrastText(backgroundColor: vm.backgroundTheme)
                VStack {
                    ColorPicker("Choose background color", selection: Binding(get: {
                        vm.backgroundTheme
                    }, set: { newValue in
                        vm.bgColor = self.vm.updateCardColorInAppStorage(color: newValue)
                        vm.backgroundTheme = newValue
                    }))
                    Divider()
                    HStack {
                        Button("Clear all subjects from Flashy Flash") {
                            store.resetTransfer()
                            dayCards.resetModel()
                        }
                        .tint(.blue)
                        Spacer()
                        Image(systemName: "questionmark.circle")
                            .onTapGesture {
                                vm.overlayMessage.toggle()
                            }
                    }
                    .frame(height: vm.overlayMessage ? 50 : nil)
                    .opacity(vm.overlayMessage ? 0.0 : 1.0)
                    .overlay {
                        vm.overlayMessage ?
                        Text("This button clears all the subjects currently in the Flashy Flash algorithm. Deleting the content means you loose your current progress on the subject.")
                            .font(.caption)
                            .foregroundStyle(Color.secondary)
                            .lineLimit(4)
                            .multilineTextAlignment(.leading)
                            .onTapGesture {
                                vm.overlayMessage.toggle()
                            }
                        : nil
                    }
                    Divider()
                    HStack {
                        Button("Delete all subjects from the library") {
                            store.emptyLibrary()
                        }
                        .tint(.blue)
                        Spacer()
                        Image(systemName: "questionmark.circle")
                            .onTapGesture {
                                vm.libraryOverlay.toggle()
                            }
                    }
                    .frame(height: vm.libraryOverlay ? 50 : nil)
                    .opacity(vm.libraryOverlay ? 0.0 : 1.0)
                    .overlay {
                        vm.libraryOverlay ?
                        Text("This button clears all your subjects from the library. Deleting all content means you will no longer have access to it.")
                            .font(.caption)
                            .foregroundStyle(Color.secondary)
                            .lineLimit(4)
                            .multilineTextAlignment(.leading)
                            .onTapGesture {
                                vm.libraryOverlay.toggle()
                            }
                        : nil
                    }
                }
                .padding(.horizontal)
                .padding(.top, 4)
                .padding(.bottom)
                .background(Color.white.roundedCorner(10, corners: .allCorners))
                .padding(.horizontal)
                Spacer()
            }
        }
    }    
}

#Preview {
    NavigationStack {
        SettingsView()
            .environmentObject(SettingsViewViewModel())
            .environmentObject(LibraryViewViewModel())
            .environmentObject(DayCardsViewViewModel())
    }
    .navigationTitle("Setting")
}
