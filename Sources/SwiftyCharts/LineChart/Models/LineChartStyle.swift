//
//  LineChartStyle.swift
//  StressEating
//
//  Created by Alex Borchers on 11.11.20.
//  Copyright © 2020 FBL. All rights reserved.
//

import Foundation
import SwiftUI


public struct LineChartStyle {
    let primaryColor: Color
    let secondaryColor: Color
    let gradientLineColor: LinearGradient
    let fillOpacity: Double
    let showAidLines: Bool
    
    public init(primaryColor: Color = .primary,
                secondaryColor: Color = .secondary,
                gradientLineColor: LinearGradient,
                fillOpacity: Double = 0.1,
                showAidLines: Bool = true) {
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
        self.gradientLineColor = gradientLineColor
        self.fillOpacity = fillOpacity
        self.showAidLines = showAidLines
    }
    
    static public let defaultStyle = LineChartStyle(primaryColor: .primary,
                                                    secondaryColor: .secondary,
                                                    gradientLineColor: LinearGradient(gradient: Gradient(colors: [Color.red, Color.blue]),
                                                                                      startPoint: .leading,
                                                                                      endPoint: .trailing),
                                                    fillOpacity: 0.1)
}

public struct LineChartLegendStyle {
    var minimumYValue: Double?
    var maximumYValue: Double?
    let minYValueOffset: Double
    let maxYValueOffset: Double
    let pathFrameEdgeInsets: EdgeInsets
    let yAxisDescriptionWidth: CGFloat
    let xAxisDescriptionHeight: CGFloat
    let showYAxis: Bool
    let showXAxis: Bool
    let yAxisValueFormat: String
    
    /// Defines the style for the two axes.
    ///
    /// - Parameters:
    ///     - minimumYValue: If no value is provided the minimum data point value for the dateset is chosen.
    ///     - maximumYValue: If no value is provided the minimum data point value for the dateset is chosen.
    ///     - minYValueOffset: This value will be converted to an absolute value.
    ///     - maxYValueOffset: This value will be converted to an absolute value.
    ///     - pathFrameEdgeInsets: Only the leading and bottom insets are used (see discussion).
    ///
    /// For the pathFrameEdgeInsets only the leading and bottom edge are used. The other edges can be controlled with the padding of the parent view (LineChartView).
    public init(minimumYValue: Double? = nil,
                maximumYValue: Double? = nil,
                minYValueOffset: Double = 0,
                maxYValueOffset: Double = 0,
                pathFrameEdgeInsets: EdgeInsets = EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 0),
                yAxisDescriptionWidth: CGFloat = 40,
                xAxisDescriptionHeight: CGFloat = 20,
                showYAxis: Bool = true,
                showXAxis: Bool = true,
                yAxisValueFormat: String = "%.2f") {
        self.minimumYValue = minimumYValue
        self.maximumYValue = maximumYValue
        self.minYValueOffset = abs(minYValueOffset)
        self.maxYValueOffset = abs(maxYValueOffset)
        self.pathFrameEdgeInsets = pathFrameEdgeInsets
        self.yAxisDescriptionWidth = yAxisDescriptionWidth
        self.xAxisDescriptionHeight = xAxisDescriptionHeight
        self.showYAxis = showYAxis
        self.showXAxis = showXAxis
        self.yAxisValueFormat = yAxisValueFormat
    }

    
    static public let defaultStyle = LineChartLegendStyle()
}

