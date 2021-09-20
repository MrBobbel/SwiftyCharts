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
    
    var yAxisDescriptionValues: [Double]? {
        //Case for 0 data points
        guard let min = viewModel.currentDataset.legendStyle.minimumYValue,
              let max = viewModel.currentDataset.legendStyle.maximumYValue else {
            return nil
        }
        //Case for 1 data point
        if viewModel.currentDataset.chartData.dataPoints.count < 2 {
            return [min, min == max ? max + 1 : max]
        }
        
        let valueRange = max - min
        
        //Check if the array only consits of elements with the same value
        if valueRange == 0 {
            return [min, min == max ? max + 1 : max]
        }
        
        let stepSize = valueRange / Double(viewModel.yValueDescriptorsAmount)
        
        var yDescriptionValues = [Double]()
        yDescriptionValues.append(min)
        for _ in 0..<viewModel.yValueDescriptorsAmount {
            
            yDescriptionValues.append((yDescriptionValues.last ?? min) + stepSize)
        }
        
        return yDescriptionValues
    }
    
    var xAxisDescriptionValues: [String]? {
        if viewModel.currentDataset.chartData.dataPoints.isEmpty {
            return nil
        }
        let datePoints = viewModel.currentDataset.chartData.onlyXValues
        return datePoints.map { $0.description }
    }
    
    var body: some View {
        if !viewModel.currentDataset.chartData.dataPoints.isEmpty {
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    // y-Axis
                    if viewModel.currentDataset.legendStyle.showYAxis,
                       let yAxisDescriptionValues = yAxisDescriptionValues {
                        ForEach(yAxisDescriptionValues.reversed(), id: \.self) { value in
                            // No Spacer before maximumYValue
                            if value != yAxisDescriptionValues.last {
                                Spacer()
                            }
                            Text(String(format: viewModel.currentDataset.legendStyle.yAxisValueFormat,
                                        value))
                                .font(.caption)
                                .fontWeight(value == yAxisDescriptionValues.first
                                                ? .bold
                                                : .regular)
                                .lineLimit(1)
                                .foregroundColor(value == yAxisDescriptionValues.first
                                                    ? viewModel.currentDataset.style.primaryColor
                                                    : viewModel.currentDataset.style.secondaryColor)
                                .frame(maxWidth: viewModel.currentDataset.legendStyle.yAxisDescriptionWidth,
                                       alignment: .trailing)
                        }
                    } else {
                        Spacer()
                    }
                    
                    // x-Axis
                    if viewModel.currentDataset.legendStyle.showXAxis,
                       let xAxisDescriptionValues = xAxisDescriptionValues,
                       !xAxisDescriptionValues.isEmpty {
                        HStack(spacing: 0) {
                            // TODO: Fix only x-Axis layout issue of first point
                            // Current fix is not to show the first x Axis data point description
                            if viewModel.currentDataset.legendStyle.showYAxis {
                                HStack(alignment: .lastTextBaseline, spacing: 2) {
                                    Text(xAxisDescriptionValues.first ?? "N/A")
                                        .font(.caption)
                                        .foregroundColor(viewModel.currentDataset.style.secondaryColor)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                    Divider()
                                }
                                .frame(width: viewModel.currentDataset.legendStyle.showYAxis ?
                                        viewModel.currentDataset.legendStyle.yAxisDescriptionWidth + viewModel.currentDataset.legendStyle.pathFrameEdgeInsets.leading
                                        : viewModel.currentDataset.legendStyle.yAxisDescriptionWidth)
                            }
                            
                            ForEach(xAxisDescriptionValues.dropFirst(), id: \.self) { description in
                                HStack(alignment: .lastTextBaseline, spacing: 2) {
                                    Text(description)
                                        .font(.caption)
                                        .foregroundColor(viewModel.currentDataset.style.secondaryColor)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                    Divider()
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
            .frame(width: viewModel.totalSize.width, height: viewModel.totalSize.height)
        } else {
            Text("This Dataset is empty!")
        }
    }
}

struct BackgroundLegendView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
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
