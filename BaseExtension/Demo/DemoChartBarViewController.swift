//
//  DemoChartBarViewController.swift
//  BaseExtension
//
//  Created by Chu Van Truong on 6/18/21.
//  Copyright © 2021 Chu Van Truong. All rights reserved.
//

import UIKit
import Charts

class DemoChartBarViewController: UIViewController, ChartViewDelegate {
    
    let barChartView = BarChartView()
    let countAxis = 7

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setupChartView()
    }

    private func setupChartView() {
        barChartView.frame = .init(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width)
        barChartView.center = view.center
        
        barChartView.pinchZoomEnabled = false
        barChartView.doubleTapToZoomEnabled = false
        barChartView.legend.enabled = true
        barChartView.barData?.setValueFont(UIFont.systemFont(ofSize: 16, weight: .bold))
        
        var dataEntries1 = [BarChartDataEntry]()
        var valueFormat = [String]()
        for x in 0..<countAxis {
            valueFormat.append("\(x+1)")
            let entry = BarChartDataEntry(x: Double(x), y: Double.random(in: 0...40))
            dataEntries1.append(entry)
        }

        let setData1 = BarChartDataSet(entries: dataEntries1, label: "")
        setData1.setColor(NSUIColor(cgColor: UIColor.orange.cgColor))
        setData1.valueTextColor = UIColor.red
        setData1.valueFont = .systemFont(ofSize: 16, weight: .regular)
        
        let dataSet = BarChartData(dataSets: [setData1])
        barChartView.data = dataSet
        view.addSubview(barChartView)
        barChartView.barData?.barWidth = 0.6
        barChartView.delegate = nil

        barChartView.rightAxis.enabled = false
        barChartView.drawBarShadowEnabled = false
        barChartView.highlightPerTapEnabled = false
        
        
        let xAxis = barChartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 20)
        xAxis.granularity = 1
        xAxis.labelCount = countAxis
        xAxis.drawGridLinesEnabled = false
        xAxis.valueFormatter = IndexAxisValueFormatter(values: valueFormat)
        
        let leftAxis = barChartView.leftAxis
        leftAxis.labelFont = .systemFont(ofSize: 10)
        leftAxis.drawAxisLineEnabled = true
        leftAxis.drawGridLinesEnabled = false
        leftAxis.axisMinimum = 0
        
        barChartView.animate(yAxisDuration: 0.5)
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
        print("entry: \(entry.y)")

    }
}


public class DayAxisValueFormatter: NSObject, IAxisValueFormatter {
    weak var chart: BarLineChartViewBase?
    let months = ["Jan", "Feb", "Mar",
                  "Apr", "May", "Jun",
                  "Jul", "Aug", "Sep",
                  "Oct", "Nov", "Dec"]
    
    init(chart: BarLineChartViewBase) {
        self.chart = chart
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        print("value >>>>> \(value)")
        let days = Int(value)
        return months[days]
    }
}
