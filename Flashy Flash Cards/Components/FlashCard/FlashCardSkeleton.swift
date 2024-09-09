//
//  FlashCardFormView.swift
//  Flashy Flash Cards
//
//  Created by Simon Matome on 12/07/2024.
//

import SwiftUI

struct FlashCardSkeleton: View {
    
    /// Binding to a flashcard object
    @Binding var card: FlashCardModel
    
    /// Variables for State control
    @State private var show = false
    @State private var extraPoint = false
    
    /// Variables for the form
    @State private var question = ""
    @State private var answer = ""
    @State private var userPoint = "point..."
    @State private var description = "description..."
    @State private var keyPoint = "Key point..."
    
    var body: some View {
        VStack {
            List {
                /// Section to edit question
                Section {
                    TextEditor(text: $card.question)
                        .frame(height: 85)
                        .border(.secondary)
                        .autocorrectionDisabled()
                } header: {
                    Text("question".uppercased())
                        .font(.body)
                        .foregroundStyle(Color.black)
                        .fontWeight(.medium)
                }
                
                /// Section to edit enter answer
                Section {
                    TextEditor(text: $card.answer)
                        .frame(height: 85)
                        .border(.secondary)
                        .autocorrectionDisabled()
                    
                } header: {
                    Text("Answer".uppercased())
                        .font(.body)
                        .foregroundStyle(Color.black)
                        .fontWeight(.medium)
                }
                
                /// Section for points and their respective description
                Section {
                    ForEach($card.points) { $point in
                        HStack {
                            Grid(alignment: .topLeading, verticalSpacing: 10) {
                                GridRow {
                                    TextEditor(text: $point.point)
                                        .padding(.trailing)
                                        .autocorrectionDisabled()
                                    
                                    TextEditor(text: $point.description)
                                        .minimumScaleFactor(0.6)
                                        .autocorrectionDisabled()
                                }
                                .frame(height: 75)
                                .gridCellAnchor(.topLeading)
                            }
                        }
                    }
                    .onDelete { indices in
                        card.points.remove(atOffsets: indices)
                    }
                    
                    if card.points.count + 1 <= 4 {
                        Grid {
                            GridRow {
                                TextEditor(text: $userPoint)
                                    .background(Color.gray.opacity(0.2).roundedCorner(10, corners: .allCorners))
                                    .autocorrectionDisabled()
                                TextEditor(text: $description)
                                    .background(Color.gray.opacity(0.2).roundedCorner(10, corners: .allCorners))
                                    .minimumScaleFactor(0.6)
                                    .autocorrectionDisabled()
                                Button {
                                    withAnimation {
                                        let newPoint = FlashCardModel.PointDescription(point: userPoint, description: description)
                                        card.points.append(newPoint)
                                        userPoint = "point..."
                                        description = "description..."
                                    }
                                } label: {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundStyle(
                                            (userPoint == "point..." || description == "description..." || userPoint == "" || description == "") ?
                                            Color.gray : Color.green)
                                }
                                .disabled( (userPoint == "point...") || ( description == "description..."))
                            }
                            .frame(height: 75)
                        }
                    }
                    
                } header: {
                    Text("Add/Edit points? (max 4)")
                        .font(.body)
                        .foregroundStyle(Color.black)
                        .fontWeight(.medium)
                }
                
                /// Section for Key points
                Section {
                    ForEach($card.keyPoints) { $keyPoint in
                        HStack {
                            Image(systemName: "circle.fill")
                                .font(.caption2)
                            TextEditor(text: $keyPoint.point)
                            Spacer()
                        }
                    }
                    .onDelete { indices in
                        card.keyPoints.remove(atOffsets: indices)
                    }
                    
                    if card.keyPoints.count + 1 <= 3 {
                        HStack {
                            Image(systemName: "circle.fill")
                                .font(.caption2)
                            TextEditor(text: $keyPoint)
                            Button(action: {
                                withAnimation {
                                    let keypoint = FlashCardModel.KeyPoint(point: keyPoint)
                                    card.keyPoints.append(keypoint)
                                    keyPoint = "Key point..."
                                }
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundStyle((keyPoint == "Key point..." || keyPoint == "") ? Color.gray : Color.green)
                            }
                            .disabled((keyPoint == "Key point..." || keyPoint == ""))
                        }
                    }
                } header: {
                    Text("Add key points? (max 3)")
                        .font(.body)
                        .foregroundStyle(Color.black)
                        .fontWeight(.medium)
                }
                
            }
            .scrollContentBackground(.hidden)
            
        }
    }
}

#Preview {
    FlashCardSkeleton(card: .constant(FlashCardModel.sample[1]))
}
