//
//  ResponsiveView.swift
//  Flashy Flash Cards
//
//  Created by Simon Matome on 25/07/2024.
//

import SwiftUI

/// Based on code by K Apps
/// https://youtu.be/GprTnobaolc?si=lcwg06y4fBD4T0VA
struct ResponsiveView<Content:View>: View {
    var content: (LayoutProperties) -> Content
    
    var body: some View {
        GeometryReader { geo in
            let height = geo.size.height
            let width = geo.size.width
            let landScape = height < width
            let dimensValues = CustomDimensValues(height: height, width: width)
            let customFontSize = CustomFontSize(height: height, width: width)
            content(
                LayoutProperties(
                    landscape: landScape,
                    dimensValues: dimensValues,
                    customFontSize: customFontSize,
                    height: height,
                    width: width
                )
            )
        }
    }
}

func getPreviewLayoutProperties(landscape:Bool, height:CGFloat, width:CGFloat) -> LayoutProperties {
    return LayoutProperties(
        landscape: landscape,
        dimensValues: CustomDimensValues(height: height, width: width),
        customFontSize: CustomFontSize(height: height, width: width),
        height: height,
        width: width)
}

let currentLayout = getPreviewLayoutProperties(landscape: false, height: 844, width: 390)
