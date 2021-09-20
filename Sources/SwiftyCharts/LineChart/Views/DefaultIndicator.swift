//
//  Indicator.swift
//  StressEating
//
//  Created by Alex Borchers on 11.11.20.
//  Copyright © 2020 FBL. All rights reserved.
//

import SwiftUI

public struct DefaultIndicator: View {
    @Environment(\.isEnabled) private var isEnabled
    
    private var indicatorInformation: IndicatorInformation
    private var showValue: Bool = false
    
    @State private var redIndicatorPointDiameterRange = Range<CGFloat>(uncheckedBounds: (7.0, 10.0))
    
    public var body: some View {
        ZStack {
            if indicatorInformation.isDragging {
                RoundedRectangle(cornerRadius: 15.0)
                    .strokeBorder(Color.secondary,
                                  style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                    .shadow(color: Color.secondary, radius: 8)
                    .frame(width: 50, height: indicatorInformation.pathFrame.height + 50)
                    .position(x: indicatorInformation.position.x, y: indicatorInformation.pathFrame.midY)
            }
            Circle()
                .frame(width: 15, height: 15, alignment: .center)
                .position(indicatorInformation.position)
                .foregroundColor(.white)
            Circle()
                .frame(width: indicatorInformation.isDragging
                        ? redIndicatorPointDiameterRange.lowerBound
                        : redIndicatorPointDiameterRange.upperBound,
                       height: indicatorInformation.isDragging
                        ? redIndicatorPointDiameterRange.lowerBound
                        : redIndicatorPointDiameterRange.upperBound)
                .position(indicatorInformation.position)
                .foregroundColor(isEnabled ? .red : .secondary)
            if showValue, indicatorInformation.isDragging {
                Text(String(format: "%.1f", indicatorInformation.dataPoint.value))
                    .bold()
                    .padding(5)
                    .background(Color.white.opacity(0.7).cornerRadius(10))
                    .position(x: indicatorInformation.position.x, y: indicatorInformation.pathFrame.minY)
            }
        }
        .animation(.default)
    }
    
    public init(indicatorInformation: IndicatorInformation, showValue: Bool = false) {
        self.indicatorInformation = indicatorInformation
        self.showValue = showValue
    }
}

struct DefaultIndicator_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            LineChartView(viewModel: .mock, showDataPointValueInIndicator: true)
                .padding()
        }
    }
}
