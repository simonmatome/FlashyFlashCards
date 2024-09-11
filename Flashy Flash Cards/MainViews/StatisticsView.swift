//
//  StatisticsView.swift
//  Flashy Flash Cards
//
//  Created by Simon Matome on 06/09/2024.
//

import SwiftUI

struct StatisticsView: View {
    @EnvironmentObject var bgColor: SettingsViewViewModel
    @EnvironmentObject var flashFlashVM: DayCardsViewViewModel
    let layout: LayoutProperties
    
    var body: some View {
        if !flashFlashVM.topicNamesData.isEmpty {
            VStack {
                Text("Statistics")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(bgColor.backgroundTheme.getContrastText())
                ScrollView {
                    ForEach(flashFlashVM.topicNamesData.sorted(by: {$0.key < $1.key}), id: \.key) { subject, topics in
                        Section {
                            ForEach(topics, id: \.self) { topic in
                                let topicStats = flashFlashVM.serveTopic(topic: topic)
                                let totalCards = topicStats.map({ $0.number }).reduce(0, +)
                                VStack {
                                    Text(topic)
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .padding(.bottom, 10)
                                    ChartView(topicStats: topicStats)
                                        .frame(width: layout.width * 0.9)
                                        .padding(.top, 10)
                                    HStack {
                                        Text("Total number of cards under review is \(totalCards)")
                                            .font(.footnote)
                                    }
                                }
                                .padding()
                                .background(Color.white.roundedCorner(10, corners: .allCorners))
                                .shadow(radius: 5)
                                .padding()
                            }
                        } header: {
                            Text(subject)
                                .font(.system(size: layout.customFontSize.extraLarge))
                                .fontWeight(.bold)
                                .padding(.top)
                                .foregroundStyle(bgColor.backgroundTheme.getContrastText())
                        }
                    }
                }
            }
            .frame(width: layout.width)
            .background(bgColor.backgroundTheme)
        } else {
            ContentUnavailableView("No statistics currently", systemImage: "chart.xyaxis.line", description: Text("If you have cards under review come back later when they show up in Flashy-Flash"))
                .background(bgColor.backgroundTheme)
        }
    }
}

#Preview {
    StatisticsView(layout: currentLayout)
        .environmentObject(SettingsViewViewModel())
        .environmentObject(DayCardsViewViewModel())
}
