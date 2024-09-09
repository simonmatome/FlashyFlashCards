//
//  ChartView.swift
//  Flashy Flash Cards
//
//  Created by Simon Matome on 08/09/2024.
//

import SwiftUI
import Charts

struct ChartView: View {
    let topicStats: [TopicStat]
    var maxNumber: Int {
        topicStats.map({ $0.number }).max() ?? 5
    }
    var body: some View {
        Chart(topicStats) {
            let number = $0.number
            BarMark(
                x: .value("Rating", $0.rating),
                y: .value("Number", $0.number)
            )
            .annotation(position: .top, alignment: .center) {
                Text("\(number)")
                    .font(.caption)
            }
        }
        .chartYScale(domain: 0...(maxNumber + 1), range: .plotDimension(padding: 5))
        .chartYAxis {
            AxisMarks(position: .leading, values: .automatic(desiredCount: 4))
        }
        .chartXAxisLabel(position: .automatic, alignment: .center) {
            Text("Flashcard rating")
                .padding(.top)
        }
        .chartYAxis(.hidden)
    }
}

