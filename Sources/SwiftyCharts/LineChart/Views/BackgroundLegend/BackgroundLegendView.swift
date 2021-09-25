//
//  BackgroundLegendView.swift
//  StressEating
//
//  Created by Alex Borchers on 11.11.20.
//  Copyright © 2020 FBL. All rights reserved.
//

import SwiftUI

struct BackgroundLegendView: View {
    @ObservedObject var viewModel: LineChartModel
    
    var body: some View {
        if !viewModel.currentDataset.chartData.dataPoints.isEmpty {
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    BackgroundLegendYAxisView(viewModel: viewModel)
                    
                    BackgroundLegenXAxisView(viewModel: viewModel)
                }
            }
        } else {
            Text("The dataset ")
                + Text("\"\(viewModel.currentDataset.title)\"").italic()
                + Text(" is empty!")
        }
    }
}

struct BackgroundLegendView_Previews: PreviewProvider {
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
            
            LineChartView(viewModel: LineChartModel(datasets: [.init(title: "Empty Set",
                                                                     chartData: ChartData(dataPoints: [Int]()))]))
        }
        .frame(maxWidth: .infinity, maxHeight: 400)
        .padding(20)
    }
}
