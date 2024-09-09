//
//  FlashCard.swift
//  Flashy Flash Cards
//
//  Created by Simon Matome on 11/07/2024.
//

import SwiftUI

struct FlashCardStruct<Front:View, Back:View>: View {
    var stop: () -> Void
    var front: () -> Front
    var back: () -> Back
    
    @State private var flipped: Bool = false
    @State private var flashcardRotation = 0.0
    @State private var contentRotation = 0.0
    
    init(@ViewBuilder front: @escaping () -> Front, 
         @ViewBuilder back: @escaping () -> Back,
         stop: @escaping () -> Void) {
        self.front = front
        self.back = back
        self.stop = stop
    }
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                if flipped {
                    back()
                        .position(x: proxy.size.width/2, y: proxy.size.height/2)
                        .frame(width: proxy.size.width*0.9, height: proxy.size.height*0.7)
                        .shadow(color: Color.black.opacity(0.4),radius: 10)
                        .onTapGesture {
                            flipFlashcard()
                        }
                } else {
                    front()
                        .position(x: proxy.size.width/2, y: proxy.size.height/2)
                        .frame(width: proxy.size.width*0.9, height: proxy.size.height*0.7)
                        .shadow(color: Color.black.opacity(0.4),radius: 10)
                        .onTapGesture {
                            flipFlashcard()
                            stop()
                        }

                }
            }
            .rotation3DEffect(.degrees(contentRotation),axis: (x: 0.0, y: 1.0, z: 0.0))
            .rotation3DEffect(.degrees(flashcardRotation),axis: (x: 0.0, y: 1.0, z: 0.0))
        }
        .containerRelativeFrame(.vertical)
        .containerRelativeFrame(.horizontal)
        .fixedSize(horizontal: false, vertical: true)
        
    }
    
    func flipFlashcard() {
        let animaTime = 0.5
        withAnimation(.spring(response: animaTime, dampingFraction: 0.75)) {
            flashcardRotation += 180
        }
        
        withAnimation(.linear(duration: 0.0001).delay(animaTime / 4)) {
            contentRotation += 180
            flipped.toggle()
        }
    }
}

