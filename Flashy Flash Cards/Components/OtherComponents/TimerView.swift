//
//  TimerView.swift
//  Flashy Flash Cards
//
//  Created by Simon Matome on 19/07/2024.
//

import SwiftUI

struct TimerView: View {
    @ObservedObject var vm = CardTimer()
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 300, height: 50)
                Progress(cornerRadius: 10, progress: vm.progress)
                    .fill(Color.blue)
                    .frame(width: 300, height: 50)
                Label(( vm.duration * vm.progress).format(using: [.minute, .second]), systemImage: "hourglass")
                    .foregroundStyle(.white)
                    .fontWeight(.medium)
                    .font(.system(size: 25))
            }
        }
    }
}

#Preview {
    TimerView()
}
