//
//  HeaderView.swift
//  Flashy Flash Cards
//
//  Created by Simon Matome on 08/07/2024.
//

import SwiftUI

struct HeaderView: View {
    @EnvironmentObject var settingsVM: SettingsViewViewModel
    let namespace: Namespace.ID
    @Binding var addSubject: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            Text("Library")
                .font(.largeTitle)
                .fontWeight(.bold)
                .getContrastText(backgroundColor: settingsVM.backgroundTheme)
            Spacer()
            Text("add subject")
                .font(.headline)
                .getContrastText(backgroundColor: settingsVM.backgroundTheme.inverted())
                .fontWeight(.bold)
                .padding(8)
                .background(settingsVM.backgroundTheme.inverted().roundedCorner(10, corners: .allCorners))
                .scaleEffect(addSubject ? 0.9 : 1)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.1)) {
                        addSubject.toggle()
                    }
                }
        }
        .background(Color.clear)
    }
}

struct HeaderView_Previews: PreviewProvider {
    @Namespace static var namespace
    
    static var previews: some View {
        HeaderView(namespace: namespace, addSubject: .constant(false))
            .environmentObject(SettingsViewViewModel())
    }
}
