//
//  ChartsContainer.swift
//  MensaGuthaben
//
//  Created by Johannes Kreutz on 24.09.19.
//  Copyright © 2019 - 2020 Johannes Kreutz. All rights reserved.
//
//  This file is part of MensaGuthaben.
//
//  MensaGuthaben is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  MensaGuthaben is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with MensaGuthaben. If not, see <http://www.gnu.org/licenses/>.
//

import SwiftUI
import Charts

struct ChartsContainer: UIViewRepresentable {
    let historyData: [HistoryEntry]
    
    // MARK: View Representable functions
    func makeUIView(context: UIViewRepresentableContext<ChartsContainer>) -> LineChartView {
        // Create and configure line chart
        let lineChartView: LineChartView = LineChartView()
        lineChartView.translatesAutoresizingMaskIntoConstraints = false
        lineChartView.animate(xAxisDuration: 0.5, yAxisDuration: 0.5, easingOption: .easeOutSine)
        lineChartView.noDataTextColor = UIColor.label
        lineChartView.noDataText = "Nicht genug Scans vorhanden."
        lineChartView.isUserInteractionEnabled = false
        lineChartView.legend.enabled = false
        lineChartView.xAxis.enabled = false
        lineChartView.leftAxis.enabled = false
        lineChartView.rightAxis.enabled = false
        lineChartView.minOffset = 15
        // Create initial data
        setupChartData(chart: lineChartView)
        return lineChartView
    }
    
    func updateUIView(_ uiView: LineChartView, context: UIViewRepresentableContext<ChartsContainer>) {
        setupChartData(chart: uiView)
    }
    
    // MARK: Chart data setup
    func setupChartData(chart: LineChartView) {
        // Create point array
        var entry: [ChartDataEntry] = []
        var c: Int = (historyData.count > 7) ? 7 : (historyData.count - 1)
        while (c >= 0) {
            entry.append(ChartDataEntry(x: Double(10 - c), y: historyData[c].balance.currentDouble))
            c -= 1
        }
        // Create and configure chart data set
        let dataSet: LineChartDataSet = LineChartDataSet(entries: entry, label: "balance history")
        let data: LineChartData = LineChartData()
        data.addDataSet(dataSet)
        data.setDrawValues(true)
        dataSet.colors = [UIColor.systemBlue]
        dataSet.setCircleColor(UIColor.systemBlue)
        dataSet.circleHoleColor = UIColor.systemBlue
        dataSet.circleRadius = 6.0
        // Gradient colors
        let gradientColors = [UIColor.systemBlue.cgColor, UIColor.clear.cgColor] as CFArray
        guard let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: [1.0, 0.0]) else {
            return
        }
        dataSet.fill = Fill.fillWithLinearGradient(gradient, angle: 90.0)
        dataSet.drawFilledEnabled = true
        dataSet.label = "Test"
        // Setup formatter
        dataSet.valueFormatter = ChartFormatter()
        dataSet.valueFont = .systemFont(ofSize: 10.0)
        dataSet.valueTextColor = .label
        // Apply data to chart
        if (entry.count > 1) {
            chart.data = data
        }
    }
    
}

class ChartFormatter: NSObject, IValueFormatter {
    
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        return String(format: "%.2f", value).replacingOccurrences(of: ".", with: ",")
    }
    
}
