//
//  LineView.swift
//  StressEating
//
//  Created by Alex Borchers on 11.11.20.
//  Copyright © 2020 FBL. All rights reserved.
//

import SwiftUI
import CoreGraphics

struct LineView<Indicator: View>: View {
    @ObservedObject private var viewModel: LineChartModel
    
    private let indicator: (IndicatorInformation) -> Indicator
    
    @State private var animateGraphIn = false
    @State private var isDragging = false
    @State private var closestPoint: CGPoint? = nil
    
    @State private var redIndicatorPointDiameterRange = Range<CGFloat>(uncheckedBounds: (7.0, 10.0))
            
    var body: some View {
        ZStack {
            //Aid Lines
            if viewModel.currentDataset.style.showAidLines {
                ForEach(0..<viewModel.aidLines.count, id: \.self) { index in
                    viewModel.aidLines[index]
                        .stroke(viewModel.currentDataset.style.secondaryColor,
                                style: StrokeStyle(lineWidth: 0.5, dash: [5]))
                }
            }
            
            //actual path
            Path { path in
                path.addLines(viewModel.points.map { $0.0 })
            }
            .trim(from: 0, to: animateGraphIn ? 1 : 0)
            .stroke(viewModel.currentDataset.style.gradientLineColor,
                    style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            
            //Fade to bottom
            Path { path in
                path.move(to: CGPoint(x: viewModel.pathFrame.minX, y: viewModel.pathFrame.maxY))
                path.addLines(viewModel.points.map { $0.0 })
                if viewModel.points.count > 1 {
                    path.addLine(to: CGPoint(x: viewModel.pathFrame.maxX, y: viewModel.pathFrame.maxY))
                    path.addLine(to: CGPoint(x: viewModel.pathFrame.minX, y: viewModel.pathFrame.maxY))
                }
            }
            .fill(viewModel.currentDataset.style.gradientLineColor)
            .opacity(viewModel.currentDataset.style.fillOpacity)

            //Indicator
            if let closestPoint = closestPoint,
               let dataPoint = viewModel.currentSelectedDataPoint {
                Group {
                    indicator((isDragging,
                               dataPoint,
                               closestPoint,
                               viewModel.pathFrame))
                }
            }
        }
        .onAppear(perform: {
            withAnimation(.easeInOut(duration: 1.5)) {
                animateGraphIn = true
            }
            //Set currentSelected at start
            closestPoint = getClosestXPosition(to: CGPoint.zero)
        })
        .onDisappear(perform: {
            closestPoint = nil
        })
        .contentShape(Rectangle())
        .gesture(DragGesture(minimumDistance: 20)
                    .onChanged({ value in
                        isDragging = true
                        closestPoint = getClosestXPosition(to: value.location)
                    })
                    .onEnded({ _ in
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                            withAnimation {
                                isDragging = false
                            }
                        }
                    })
        )
        .onChange(of: viewModel.currentDataset) { _ in
            animateGraphIn = false
            withAnimation(.easeInOut(duration: 1.5)) {
                animateGraphIn = true
            }
            
            closestPoint = getClosestXPosition(to: .zero)
        }
    }
    
    ///Gets the position of the data point that is the closest to the currents drag location of the user
    func getClosestXPosition(to location: CGPoint) -> CGPoint? {
        guard let firstPoint = viewModel.points.first?.position else {
            return nil
        }

        var closestPoint = firstPoint
        var distance = CGFloat.infinity
        
        for point in viewModel.points {
            if point.position.x.distance(to: location.x).magnitude < distance {
                distance = point.position.x.distance(to: location.x).magnitude
                closestPoint = point.position
                viewModel.setCurrentSelectedDataPoint(point.dataPoint)
            }
        }
        
        return closestPoint
    }
    
    init(viewModel: LineChartModel,
         @ViewBuilder indicator: @escaping (IndicatorInformation) -> Indicator) {
        self.viewModel = viewModel
        self.indicator = indicator
    }
}

struct LineView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LineChartView(viewModel: .mock)
        }
        .padding()
    }
}
