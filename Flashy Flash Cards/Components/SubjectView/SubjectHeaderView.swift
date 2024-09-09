//
//  SubjectHeaderView.swift
//  Flashy Flash Cards
//
//  Created by Simon Matome on 23/07/2024.
//

import SwiftUI

struct SubjectHeaderView: View {
    @Binding var subject: Subject
    @Binding var addTopic: Bool
    @Binding var isEditSubject: Bool
    @Binding var editedSubject: Subject
    let layout: LayoutProperties
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            SubjectMarkerView(subject: subject, layout: layout)
                .frame(maxWidth: layout.width * 0.7)
                .onTapGesture {
                    editedSubject = subject
                    isEditSubject = true
                }
            
            DeleteSubjectButton(title: "Delete Subject", color: .red, fontWeight: .bold,
                               foregroundColor: .white, corners: .allCorners, addTopic: $addTopic)
            .frame(maxWidth: layout.width / 3)
        }
        .background(Color.white.roundedCorner(20, corners: [.topLeft, .topRight]))
        .frame(maxWidth: layout.width)
        .padding(.bottom, 0)
    }
}

#Preview {
    GeometryReader { proxy in
        ZStack {
            SubjectHeaderView(
                subject: .constant(Subject.sample[0]),
                addTopic: .constant(false),
                isEditSubject: .constant(false), editedSubject: .constant(Subject.emptySubject),
                layout: currentLayout
            )
                .zIndex(1.0)
            Color.blue.opacity(0.8)
                .zIndex(0)
        }
    }
}
