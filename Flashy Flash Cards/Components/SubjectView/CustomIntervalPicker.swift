//
//  CustomIntervalPicker.swift
//  Flashy Flash Cards
//
//  Created by Simon Matome on 06/09/2024.
//

import SwiftUI

struct CustomIntervalPicker: View {
    let layout: LayoutProperties
    let stage: Int
    @Binding var reviewInterval: ReviewInterval
    
    var body: some View {
        HStack {
            Text("Stage \(stage + 1)")
                .font(.headline)
                .frame(minWidth: layout.width * 0.3)
            Spacer()
            HStack(spacing: 0) {
                TextField(reviewInterval.amount.formatted(), value: $reviewInterval.amount, format: .number)
                    .frame(width: layout.width*0.25, alignment: .center)
                    .textFieldStyle(.roundedBorder)
                    .border(Color.secondary)
                    .multilineTextAlignment(.center)
                    .keyboardType(.decimalPad)
                Picker(selection: $reviewInterval.unit) {
                    ForEach(TimeUnit.allCases, id: \.self) { unit in
                        Text("\(unit.rawValue)").tag(unit)
                    }
                } label: {
                    //
                }
                .multilineTextAlignment(.center)
                .pickerStyle(.menu)
                .frame(width: layout.width*0.32)
            }
            .padding(.trailing)
        }
        .padding(.horizontal)
    }
}

#Preview {
    CustomIntervalPicker(layout: currentLayout, stage: 1, reviewInterval: .constant(ReviewInterval.sample[0]))
}
