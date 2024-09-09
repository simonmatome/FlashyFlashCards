//
//  ExampleView.swift
//  Flashy Flash Cards
//
//  Created by Simon Matome on 08/07/2024.
//

import SwiftUI

//struct AnimalView: View {
//    let items = ["Lion", "Elephant", "Tiger", "Leopard"]
//
//    var body: some View {
//        
//        VStack {
//            
//            HStack {
//                Text("Big 4".uppercased())
//                    .font(.custom("Copperplate", size: 60))
//                    .fontWeight(.bold)
//                    .foregroundStyle(Color(red: 237/255, green: 209/255, blue: 173/255))
//                
//                
//            }
//            
//            ScrollView {
//                LazyVStack {
//                    ForEach(0..<items.count, id: \.self) { animal in
//                        CardView(animal: items[animal], index: animal)
//                            .scrollTransition { content, phase in
//                                content
//                                    .scaleEffect(
//                                        x: phase.isIdentity ? 1.0 : 0.7,
//                                        y: phase.isIdentity ? 1.0 : 0.7
//                                    )
//                                    .offset(x: phase.isIdentity ? 0 : 200)
//                                    .rotationEffect(.degrees(phase.isIdentity ? 0.0 : -10))
//                                    .opacity(phase.isIdentity ? 1 : 0.5)
//                            }
//                    }
//                }
//                .scrollTargetLayout()
//            }
//            .scrollTargetBehavior(.viewAligned)
//            .contentMargins(.horizontal, 20)
//            .contentMargins(.vertical, 70)
//            .scrollIndicators(.hidden)
//        }
//        .background(Color(red: 173/255, green: 201/255, blue: 237/255))
//    }
//}
//
//#Preview {
//    AnimalView()
//}
//
//struct CardView: View {
//    
//    let animal: String
//    let index: Int
//    private let descriptions = [
//        "The lion (Panthera leo) is a large feline native to Africa and India, known for its strength and majestic mane. Lions live in social groups called prides, consisting of several females, their cubs, and a few males. They are apex predators, primarily hunting large herbivores such as zebras and wildebeests. Lions are iconic symbols of courage and royalty, and their roars can be heard up to five miles away. They face threats from habitat loss and poaching.",
//        "Elephants are the largest land animals, with two species: the African elephant and the Asian elephant. Known for their intelligence, strong social bonds, and impressive memory, elephants use their trunks for a variety of tasks, including feeding, drinking, and communication. They play a vital role in their ecosystems by dispersing seeds and creating water holes used by other animals. Elephants face significant threats from habitat destruction and poaching for their ivory tusks.",
//        "The tiger (Panthera tigris) is the largest cat species, recognizable by its striking orange coat with black stripes. Native to Asia, tigers are solitary hunters, primarily preying on large ungulates like deer and wild boar. They are powerful swimmers and often live near water. Tigers are critically endangered due to habitat loss, poaching, and human-wildlife conflict, with fewer than 4,000 remaining in the wild.",
//        "The leopard (Panthera pardus) is a versatile and adaptable big cat found in sub-Saharan Africa, parts of Asia, and India. Known for its distinctive spotted coat and exceptional climbing ability, leopards are solitary and elusive predators. They have a varied diet, hunting anything from insects to large mammals. Leopards are adept at adapting to different environments, from forests to savannas, but face threats from habitat fragmentation and poaching."
//    ]
//    
//    init(animal: String = "Lion", index: Int = 0) {
//        self.animal = animal
//        self.index = index
//    }
//    
//    var body: some View {
//        VStack{
//            HStack {
//                Text(animal.uppercased())
//                    .font(.custom("Helvitica", size: 49))
//                    .fontWeight(.bold)
//                    .strokeText(lineWidth: 0.4, strokeColor: .black)
//                    .foregroundStyle(Color(red: 38, green: 38, blue: 38))
//                
//                Spacer()
//            }
//            
//            Text(descriptions[index])
//                .font(.callout)
//                .fontWeight(.bold)
//                .strokeText(lineWidth: 0.1, strokeColor: .black)
//                .foregroundStyle(Color.white)
//            
//        }
//        .padding()
//        .frame(width: 300)
//        .background(
//            Image(animal)
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .blur(radius: 3)
//        )
//        .clipShape(CustomCardShape())
//        .overlay {
//            CustomCardShape()
//                .stroke(Color.brown, lineWidth: 4)
//        }
//        .shadow(radius: 10)
//        .padding()
//        
//    }
//}
//
//
//
//struct StrokeText: ViewModifier {
//    var lineWidth: CGFloat
//    var strokeColor: Color
//    
//    func body(content: Content) -> some View {
//        ZStack {
//            content
//                .offset(x: lineWidth, y: lineWidth)
//                .foregroundStyle(strokeColor)
//            
//            content
//                .offset(x: -lineWidth, y: -lineWidth)
//                .foregroundStyle(strokeColor)
//            
//            content
//                .offset(x: lineWidth, y: -lineWidth)
//                .foregroundStyle(strokeColor)
//            
//            content
//                .offset(x: -lineWidth, y: lineWidth)
//                .foregroundStyle(strokeColor)
//            
//            content
//            
//        }
//    }
//}
//
//extension View {
//    func strokeText(lineWidth: CGFloat, strokeColor: Color) -> some View {
//        self.modifier(StrokeText(lineWidth: lineWidth, strokeColor: strokeColor))
//    }
//}
//
//struct CustomCardShape: Shape {
//    func path(in rect: CGRect) -> Path {
//        return RoundedRectangle(cornerRadius: 10).path(in: rect)
//    }
//}
