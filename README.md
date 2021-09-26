# SwiftyCharts

First version is here 🎉 Time to check it out!
Makes creating charts simple, but highly customizable. 📈

The charts are implemented exclusively with **SwiftUI**.

## How you get it

The minimum requirements are iOS 14.0*, watchOS 8.0* and macOS 11.0*. Also visible in the `Package.swift`.

SwiftyCharts is only avialable via Xcode's **package manager**.
Open your project and navigate to `File -> Swift Packages -> Add Package Dependency...`
Enter the repository url: `https://github.com/MrBobbel/SwiftyCharts.git`
Click next. Under version select **exact** and enter version you want. Latest version is `1.0.0` and an overview of all versions can be found [here](https://github.com/MrBobbel/SwiftyCharts/releases).

Congratulation you can now use the package in your projects.
```swift
import SwiftyCharts
```

## Examples

SwiftyCharts provides animations and interactions with the charts.

### Line charts

In your view you can create a chart like this:
```swift
import SwiftUI
import SwiftyCharts

struct ContentView: View {
    var body: some View {
        LineChartView(viewModel:
                        LineChartModel(datasets: [
                            LineChartModel.Dataset(title: "Your custom dataset 1",
                                                   chartData: ChartData(dataPoints: [1, 2, 6, 4, 9, 8]))
                        ]))
    }
}
```

Check out the initilizers to experiment with custom styles.

To selected the individual data points on the graph, make a horizontal DragGesture. The indicator which displays the current selected data point is comletely customizable. You can define your own view with your own animations. The LineChart init provides a ViewBuilder for this particular case. The closure provides you with an indicator information tuple.

If you just want to highlight the current selected datapoint in a seperate view below or above the chart, you can do so with the currentSelectedDataPoint publisher on the LineChartModel.

For the individual look, you can create a custom style and legend for each dataset in your LineChartModel.


![Alt text](/../Resources/Images/Images/LineChartRainbow.png?raw=true)
![Alt text](/../Resources/Images/Images/LineChartBlue.png?raw=true)
