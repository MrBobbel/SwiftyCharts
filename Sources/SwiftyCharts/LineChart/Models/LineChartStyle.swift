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
