//
//  LineChartView.swift
//  StressEating
//
//  Created by Alex Borchers on 11.11.20.
//  Copyright © 2020 FBL. All rights reserved.
//

import SwiftUI

public typealias IndicatorInformation = (isDragging: Bool,
                                         dataPoint: ChartData.DataPoint,
                                         position: CGPoint,
                                         pathFrame: CGRect)

public struct LineChartView<Indicator: View>: View {
    @ObservedObject private var viewModel: LineChartModel
    
    private let indicator: (IndicatorInformation) -> Indicator
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                BackgroundLegendView(viewModel: viewModel)
                LineView(viewModel: viewModel, indicator: indicator)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .onAppear {
                viewModel.setFrame(for: geometry.size)
            }
            .onChange(of: geometry.size, perform: { _ in
                viewModel.setFrame(for: geometry.size)
            })
        }
    }
    
    public init(viewModel: LineChartModel,
                @ViewBuilder indicator: @escaping (IndicatorInformation) -> Indicator) {
        self.viewModel = viewModel
        self.indicator = indicator
    }
    
    public init(viewModel: LineChartModel,
                showDataPointValueInIndicator: Bool = false) where Indicator == DefaultIndicator {
        self.init(viewModel: viewModel) { indicatorInformation in
            DefaultIndicator(indicatorInformation: indicatorInformation,
                             showValue: showDataPointValueInIndicator)
        }
    }
}

struct LineChartView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LineChartView(viewModel: .mock)
            LineChartView(viewModel: .mock)
        }
        .frame(maxWidth: .infinity, maxHeight: 400)
        .padding()
    }
}
