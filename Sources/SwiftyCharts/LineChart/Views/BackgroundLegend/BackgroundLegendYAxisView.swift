//
//  BackgroundLegendYAxisView.swift
//  SwiftyCharts
//
//  Created by Alex Borchers on 25.09.21.
//

import SwiftUI

struct BackgroundLegendYAxisView: View {
    @ObservedObject var viewModel: LineChartModel
    
    var body: some View {
        Group {
            // y-Axis
            if viewModel.currentDataset.legendStyle.showYAxis,
               let yAxisDescriptionValues = viewModel.yAxisDescriptionValues {
                HStack(spacing: 0) {
                    VStack(alignment: .trailing, spacing: 0) {
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
                                .frame(maxWidth: viewModel.currentDataset.legendStyle.useDynamicYAxisDescriptionWidth
                                        ? nil
                                        : viewModel.currentDataset.legendStyle.yAxisDescriptionWidth,
                                       alignment: .trailing)
                        }
                    }
                    .background(
                        GeometryReader { geometry in
                            Color.clear
                                .preference(key: YAxisDescriptionWidthKey.self,
                                            value: geometry.size.width)
                        }
                    )
                    .onPreferenceChange(YAxisDescriptionWidthKey.self) { width in
                        viewModel.setFrame(for: viewModel.totalSize, yAxisDescriptionWidth: width)
                    }
                    Spacer()
                }
            } else {
                Spacer()
            }
        }
    }
    
    struct YAxisDescriptionWidthKey: PreferenceKey {
        static var defaultValue: CGFloat = .zero
        
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value += nextValue()
        }
    }
}

struct BackgroundLegendYAxisView_Previews: PreviewProvider {
    static var previews: some View {
        LineChartView(viewModel: LineChartModel(datasets: [.init(title: "Test",
                                                                 chartData: .sampleDataPoints(),
                                                                 legendStyle: .init(yAxisValueFormat: "%.6f"))]))
            .padding()
    }
}
