//
//  SettingsView.swift
//  Flashy Flash Cards
//
//  Created by Simon Matome on 08/07/2024.
//

import SwiftUI

struct SettingsView: View {
    let layout: LayoutProperties
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
                        Text("Clear all subjects from Flashy Flash")
                            .foregroundStyle(Color.blue)
                            .onTapGesture {
                                vm.popOverOne.toggle()
                            }
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
                    .popover(isPresented: $vm.popOverOne) {
                        VStack {
                            Text("Are you sure you want to clear all subjects?")
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                            Spacer()
                            Divider()
                                .fontWeight(.bold)
                            HStack(spacing: 20) {
                                Button {
                                    vm.popOverOne.toggle()
                                } label: {
                                    Text("Cancel")
                                        .foregroundStyle(Color.blue)
                                        .font(.headline)
                                        .padding()
                                }
                                Button {
                                    store.resetTransfer()
                                    dayCards.resetModel()
                                    vm.popOverOne.toggle()
                                } label: {
                                    Label("Clear", systemImage: "eraser.fill")
                                        .foregroundStyle(Color.red)
                                        .font(.headline)
                                        .padding()
                                        .background(Color.gray.opacity(0.1).roundedCorner(4,corners: .allCorners))
                                }

                            }
                        }
                        .padding()
                        .frame(width: layout.width * 0.8, height: layout.height * 0.20)
                        .frame(maxHeight: layout.height * 0.5)
                        .presentationCompactAdaptation(.popover)
                    }
                    Divider()
                    HStack {
                        Text("Delete all subjects from the library")
                            .foregroundStyle(Color.blue)
                            .onTapGesture {
                                vm.popOverTwo.toggle()
                            }
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
                    .popover(isPresented: $vm.popOverTwo) {
                        VStack {
                            Text("Are you sure you want to delete all subjects?")
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                            Spacer()
                            Divider()
                            HStack(spacing: 20) {
                                Button {
                                    vm.popOverTwo.toggle()
                                } label: {
                                    Text("Cancel")
                                        .foregroundStyle(Color.blue)
                                        .font(.headline)
                                        .padding()
                                }
                                Button {
                                    store.emptyLibrary()
                                    dayCards.resetModel()
                                    vm.popOverTwo.toggle()
                                } label: {
                                    Label("Delete", systemImage: "trash.fill")
                                        .foregroundStyle(Color.red)
                                        .font(.headline)
                                        .padding()
                                        .background(Color.gray.opacity(0.2).roundedCorner(4,corners: .allCorners))
                                }

                            }
                        }
                        .padding()
                        .frame(width: layout.width * 0.8, height: layout.height * 0.20)
                        .frame(maxHeight: layout.height * 0.5)
                        .presentationCompactAdaptation(.popover)
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
        SettingsView(layout: currentLayout)
            .environmentObject(SettingsViewViewModel())
            .environmentObject(LibraryViewViewModel())
            .environmentObject(DayCardsViewViewModel())
    }
    .navigationTitle("Setting")
}
