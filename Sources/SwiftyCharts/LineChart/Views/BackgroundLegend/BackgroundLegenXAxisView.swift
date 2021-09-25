//
//  BackgroundLegenXAxisView.swift
//  SwiftyCharts
//
//  Created by Alex Borchers on 25.09.21.
//

import SwiftUI

struct BackgroundLegenXAxisView: View {
    @ObservedObject var viewModel: LineChartModel
    
    var body: some View {
        Group {
            // x-Axis
            if viewModel.currentDataset.legendStyle.showXAxis,
               let xAxisDescriptionValues = viewModel.xAxisDescriptionValues,
               !xAxisDescriptionValues.isEmpty {
                HStack(alignment: .top, spacing: 0) {
                    if viewModel.currentDataset.legendStyle.showYAxis {
                        Spacer()
                            .frame(width: viewModel.currentDataset.legendStyle.yAxisDescriptionWidth + viewModel.currentDataset.legendStyle.pathFrameEdgeInsets.leading)
                    }
                    ForEach(xAxisDescriptionValues, id: \.self) { description in
                        Text(description)
                            .font(.caption)
                            .foregroundColor(viewModel.currentDataset.style.secondaryColor)
                        
                        // No spacer after last value
                        if description != xAxisDescriptionValues.last {
                            Spacer()
                        }
                    }
                }
                .frame(height: viewModel.currentDataset.legendStyle.xAxisDescriptionHeight + viewModel.currentDataset.legendStyle.pathFrameEdgeInsets.bottom)
                .frame(maxWidth: .infinity)
            } else if viewModel.currentDataset.legendStyle.showYAxis {
                HStack(spacing: 0) {
                    Spacer()
                        .frame(width: viewModel.currentDataset.legendStyle.yAxisDescriptionWidth + viewModel.currentDataset.legendStyle.pathFrameEdgeInsets.leading)
                    Spacer()
                }
            }
        }
    }
}

struct BackgroundLegenXAxisView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LineChartView(viewModel: LineChartModel(datasets: [.init(title: "Test",
                                                                     chartData: .sampleDataPoints(),
                                                                     legendStyle: .init(yAxisValueFormat: "%.6f"))]))
            
            LineChartView(viewModel: LineChartModel(datasets: [.init(title: "Test",
                                                                     chartData: .sampleDataPoints(),
                                                                     legendStyle: LineChartLegendStyle(showXAxis: false))]))
            
            LineChartView(viewModel: LineChartModel(datasets: [.init(title: "Test",
                                                                     chartData: .sampleDataPoints(),
                                                                     legendStyle: LineChartLegendStyle(showYAxis: false))]))
            
            LineChartView(viewModel: LineChartModel(datasets: [.init(title: "Test",
                                                                     chartData: .sampleDataPoints(),
                                                                     legendStyle: LineChartLegendStyle(showYAxis: false,
                                                                                                       showXAxis: false))]))
        }
        .frame(maxWidth: .infinity, maxHeight: 400)
        .padding(20)
    }
}
