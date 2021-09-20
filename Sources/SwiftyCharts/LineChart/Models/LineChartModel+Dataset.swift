//
//  LineChartModel+Dataset.swift
//  SwiftyCharts
//
//  Created by Alex Borchers on 18.09.21.
//

import Foundation

extension LineChartModel {
    public struct Dataset: Identifiable, Hashable {
        public static func == (lhs: LineChartModel.Dataset, rhs: LineChartModel.Dataset) -> Bool {
            lhs.id == rhs.id
        }
        
        public var id: UUID
        public var title: String
        var chartData: ChartData
        var style: LineChartStyle
        var legendStyle: LineChartLegendStyle
        
        public init(id: UUID = UUID(),
                    title: String,
                    chartData: ChartData,
                    style: LineChartStyle = .defaultStyle,
                    legendStyle: LineChartLegendStyle = .defaultStyle) {
            self.id = id
            self.title = title
            self.chartData = chartData
            self.style = style
            self.legendStyle = legendStyle
            
            if let minDataPointValue = chartData.onlyYValues.min(),
               let maxDataPointValue = chartData.onlyYValues.max() {
                // Set the minimum yValue for the chart based on the dataset
                if let explicitMinYValue = legendStyle.minimumYValue,
                   explicitMinYValue < minDataPointValue {
                    self.legendStyle.minimumYValue = explicitMinYValue - legendStyle.minYValueOffset
                } else {
                    self.legendStyle.minimumYValue = minDataPointValue - legendStyle.minYValueOffset
                }
                
                // Set the maximum yValue for the chart based on the dataset
                if let explicitMaxYValue = legendStyle.maximumYValue,
                   explicitMaxYValue > maxDataPointValue {
                    self.legendStyle.maximumYValue = explicitMaxYValue + legendStyle.maxYValueOffset
                } else {
                    self.legendStyle.maximumYValue = maxDataPointValue + legendStyle.maxYValueOffset
                }
            }
        }
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }
}
