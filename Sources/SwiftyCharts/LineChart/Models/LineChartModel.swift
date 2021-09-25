//
//  LineChartModel.swift
//  SwiftyCharts
//
//  Created by Alex Borchers on 16.09.21.
//

import Foundation
import SwiftUI

public class LineChartModel: ObservableObject, Identifiable {
    @Published public var datasets: [Dataset]
    @Published public var currentDataset: Dataset {
        didSet {
            updateModelForCurrentDataset()
        }
    }
    @Published public var currentSelectedDataPoint: ChartData.DataPoint? = nil
    @Published var totalSize: CGSize = .zero
    @Published var pathFrame: CGRect = .zero
    
    var yValueDescriptorsAmount: Int {
        let maximumAmountOfYDescriptors: CGFloat = 5
        let height = totalSize.height - (totalSize.height - pathFrame.height)
        let minimumHeightOfYAxisDescriptorText: CGFloat = 25
        
        return Int(min(height / minimumHeightOfYAxisDescriptorText, maximumAmountOfYDescriptors).rounded())
    }
    
    var xAxisDescriptionValues: [String]? {
        if currentDataset.chartData.dataPoints.isEmpty {
            return nil
        }
        let datePoints = currentDataset.chartData.onlyXValues
        return datePoints.map { $0.description }
    }
    
    var yAxisDescriptionValues: [Double]? {
        //Case for 0 data points
        guard let min = currentDataset.legendStyle.minimumYValue,
              let max = currentDataset.legendStyle.maximumYValue else {
            return nil
        }
        //Case for 1 data point
        if currentDataset.chartData.dataPoints.count < 2 {
            return [min, min == max ? max + 1 : max]
        }
        
        let valueRange = max - min
        
        //Check if the array only consits of elements with the same value
        if valueRange == 0 {
            return [min, min == max ? max + 1 : max]
        }
        
        let stepSize = valueRange / Double(yValueDescriptorsAmount)
        
        var yDescriptionValues = [Double]()
        yDescriptionValues.append(min)
        for _ in 0..<yValueDescriptorsAmount {
            
            yDescriptionValues.append((yDescriptionValues.last ?? min) + stepSize)
        }
        
        return yDescriptionValues
    }
    
    /// - Parameters:
    ///     - datasets: All datasets you want to show in this view.
    ///     - currentSelectedDatasetIndex: The initial dataset you want to show. By default / fallback the first is shown.
    ///     - globalStyle: Define a global style to override the individual styles of each dataset.
    public init(datasets: [Dataset],
                currentSelectedDatasetIndex: UInt = 0,
                globalStyle: LineChartStyle? = nil) {
        self.datasets = datasets
        guard datasets.count > currentSelectedDatasetIndex else {
            fatalError("Created a LineChartModel without a dataset to work with! Or provided an invalid index!")
        }
        let currentDataset = datasets[Int(currentSelectedDatasetIndex)]
        self.currentDataset = currentDataset
        
        if let style = globalStyle {
            self.datasets.indices.forEach { index in
                self.datasets[index].style = style
            }
            self.currentDataset = self.datasets[Int(currentSelectedDatasetIndex)]
        }
    }
    
    private func updateModelForCurrentDataset() {
        currentSelectedDataPoint = nil
        setFrame(for: totalSize)
    }
    
    func setFrame(for size: CGSize, yAxisDescriptionWidth: CGFloat? = nil) {
        if let yAxisDescriptionWidth = yAxisDescriptionWidth,
           currentDataset.legendStyle.useDynamicYAxisDescriptionWidth {
            currentDataset.legendStyle.yAxisDescriptionWidth = yAxisDescriptionWidth
        }
        totalSize = size
        let x = currentDataset.legendStyle.showYAxis
            ? currentDataset.legendStyle.yAxisDescriptionWidth + currentDataset.legendStyle.pathFrameEdgeInsets.leading
            : 0
        
        var width: CGFloat {
            if currentDataset.legendStyle.showYAxis {
                return size.width - currentDataset.legendStyle.yAxisDescriptionWidth - currentDataset.legendStyle.pathFrameEdgeInsets.leading
            } else {
                return size.width
            }
        }
        
        var height: CGFloat {
            if currentDataset.legendStyle.showXAxis {
                return size.height - currentDataset.legendStyle.xAxisDescriptionHeight - currentDataset.legendStyle.pathFrameEdgeInsets.bottom
            } else {
                return size.height
            }
        }
        pathFrame = CGRect(x: x,
                           y: 0,
                           width: width,
                           height: height)
        
        currentSelectedDataPoint = nil
        
    }
    
    var aidLines: [Path] {
        let yStepSize = pathFrame.height / CGFloat(yValueDescriptorsAmount)
        var yPos = pathFrame.minY
        var paths = [Path]()
        for _ in 0..<Int(yValueDescriptorsAmount + 1) {
            var path = Path()
            path.move(to: CGPoint(x: pathFrame.minX, y: yPos))
            path.addLine(to: CGPoint(x: pathFrame.maxX, y: yPos))
            paths.append(path)
            yPos += yStepSize
        }
        return paths
    }
    
    ///Returns an array for the coordinates combined with theire associated data point
    var points: [(position: CGPoint, dataPoint: ChartData.DataPoint)] {
        var points = [(CGPoint, ChartData.DataPoint)]()
        let xStepSize = pathFrame.width / CGFloat(currentDataset.chartData.dataPoints.count - 1)
        var xPos = pathFrame.minX
        
        guard let min = currentDataset.legendStyle.minimumYValue, let max = currentDataset.legendStyle.maximumYValue else {
            print("No Data Points available!")
            return points
        }
        for dataPoint in currentDataset.chartData.dataPoints {
            var yPos: CGFloat = 0.0
            if min != max {
                //TODO: special case if negative values
                //interpolate the yPos in the graph
                let entireYDistance = max - min
                let distanceToMin = max - dataPoint.value
                let distancePercentage = distanceToMin / entireYDistance
                yPos = (CGFloat(distancePercentage) * pathFrame.height) + pathFrame.minY
            } else {
                //Because origin is top-left and yPos should be our minimum we need maxY
                yPos = pathFrame.maxY
            }
            
            points.append((CGPoint(x: xPos, y: yPos), dataPoint))
            xPos += xStepSize
        }
        return points
    }
    
    func setCurrentSelectedDataPoint(_ dataPoint: ChartData.DataPoint) {
        currentSelectedDataPoint = dataPoint
    }
}

extension LineChartModel {
    static var mock: LineChartModel {
        LineChartModel(datasets: [
            Dataset(title: "Random Data Point Example",
                    chartData: .sampleDataPoints())
        ])
    }
    
    static var mock2Datasets: LineChartModel {
        LineChartModel(datasets: [
            Dataset(title: "Letzten 5 Spiele",
                    chartData: .sampleDataPoints(5)),
            Dataset(title: "Letzten 10 Spiele",
                    chartData: .sampleDataPoints(10, in: -10..<10))
        ])
    }
}
