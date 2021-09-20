//
//  ChartData.swift
//  SwiftyCharts
//
//  Created by Alex Borchers on 17.09.21.
//

import Foundation

public struct ChartData {
    public typealias DataPoint = (description: String,
                                  value: Double)
    
    var dataPoints: [DataPoint]
    
    var onlyYValues: [Double] {
        dataPoints.map { $0.value }
    }
    
    var onlyXValues: [String] {
        dataPoints.map { $0.description }
    }
    
    public init(dataPoints: [(String, Int)]) {
        self.dataPoints = dataPoints.map { ($0.0, Double($0.1)) }
    }
    
    public init(dataPoints: [(String, Double)]) {
        self.dataPoints = dataPoints
    }
    
    /// Only use this initilizer in combination with a legend style with showXAxis = false.
    public init(dataPoints: [Int]) {
        self.dataPoints = dataPoints.map { ("", Double($0) ) }
    }
    
    /// Only use this initilizer in combination with a legend style with showXAxis = false.
    public init(dataPoints: [Double]) {
        self.dataPoints = dataPoints.map { ("", $0 ) }
    }
}

// MARK: - Mock Data

extension ChartData {
    static func sampleDataPoints(_ amount: Int = 7, in range: Range<Int> = (0..<11)) -> ChartData {
        return ChartData(dataPoints: (0..<amount).map {
            ($0.description, Int.random(in: range))
        })
    }
}
