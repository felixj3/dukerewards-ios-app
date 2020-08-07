//
//  ChartViewController.swift
//  DukeRewards
//
//  Created by codeplus on 6/4/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import UIKit
import Charts

class ChartViewController: UIViewController {
    
    // Storyboard chart connections
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var barChart: BarChartView!
    @IBOutlet weak var navBar: UINavigationItem!
    
    
    // Pie Chart data entries
    var athleticsDataEntryPie = PieChartDataEntry(value: 0)
    var diningDataEntryPie = PieChartDataEntry(value: 0)
    //var otherDataEntryPie = PieChartDataEntry(value: 0)
    
    // Bar Chart data entries
    var athleticsDataEntryBar = BarChartDataEntry(x: 0.5, y: 0)
    var diningDataEntryBar = BarChartDataEntry(x: 1.5, y: 0)
    //var totalDataEntryBar = BarChartDataEntry(x: 0, y: 0, data: "Total")
    
    // Initializing data entry for Pie Chart
    var numberOfEventsAttendedPie = [PieChartDataEntry]()
    
    // Initializing data entry for Bar Chart
    var events: [String]!
    var numberOfEventsAttendedBar = [BarChartDataEntry]()
    
    let userManager = UserManager()
    typealias Users = [User]
    var users = [User]()
    
    //var trial = 0.0
    
    var athleticsData = 0.0
    var diningData = 0.0
    var totalData = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userManager.callFetchData()
        userManager.reloadData = { data in
            for user in data {
                self.athleticsData = self.athleticsData + Double(user.accumulated_athletics_points ?? 0)
                  self.diningData = self.diningData + Double(user.accumulated_dining_points ?? 0)
                self.totalData = self.totalData + Double(user.accumulated_total_points ?? 0)
            }
            //self.updateChartData()
            
            self.athleticsDataEntryPie.value = ((self.athleticsData/self.totalData) * 100)
            //self.updateChartData()
            self.diningDataEntryPie.value = ((self.diningData/self.totalData) * 100)
            
            self.updateChartData()
            
            //self.athleticsDataEntryBar.x = Double("ATHLETICS") ?? 5
            self.athleticsDataEntryBar.y = self.athleticsData
            self.diningDataEntryBar.y = self.diningData
            self.numberOfEventsAttendedBar = [self.athleticsDataEntryBar, self.diningDataEntryBar]
            
            self.updateChartData()
        }
        
        // Pie Chart Data
        pieChart.chartDescription?.text = ""
        athleticsDataEntryPie.label = "ATHLETICS"
        
        diningDataEntryPie.label = "DINING"

        
        numberOfEventsAttendedPie = [athleticsDataEntryPie, diningDataEntryPie]
        
        // Bar Chart Data
        barChart.chartDescription?.text = ""
        //athleticsDataEntryBar.x = Double("ATHLETICS") ?? 5
        //athleticsDataEntryBar.y = 2000
               
       // diningDataEntryBar.x = Double("DINING") ?? 15
       // diningDataEntryBar.y = 15
            
//        totalDataEntryBar.x = Double("TOTAL") ?? 25
        //totalDataEntryBar.y = athleticsDataEntryBar.y + diningDataEntryBar.y
               
        numberOfEventsAttendedBar = [athleticsDataEntryBar, diningDataEntryBar]
        
        updateChartData()
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        createPointsLabel()
       
    }
    

    func createPointsLabel() {
        let rightBarButton = UIBarButtonItem(customView: UserManager.createPointsLabel())
        navBar.rightBarButtonItem = rightBarButton
    }
    
    func updateChartData(){
        // Load Pie Chart Data
        let chartDataSetPie = PieChartDataSet(entries: numberOfEventsAttendedPie, label: nil)
        let chartDataPie = PieChartData(dataSet: chartDataSetPie)
        
        // Formatting Colors
        var colorsPie: [UIColor] = []
        colorsPie.append(UIColor(red: 0.95, green: 0.33, blue: 0.33, alpha: 1.00))
        colorsPie.append(UIColor(red: 1.00, green: 0.80, blue: 0.31, alpha: 1.00))
        colorsPie.append(UIColor.gray)
        
        chartDataSetPie.colors = colorsPie
        
        // Formatting Numbers
        let formatterPie = NumberFormatter()
        formatterPie.numberStyle = .percent
        formatterPie.maximumFractionDigits = 1
        formatterPie.multiplier = 1.0
        chartDataPie.setValueFormatter(DefaultValueFormatter(formatter: formatterPie))
        
        
        pieChart.data = chartDataPie
        
        // Load Bar Chart Data
        let chartDataSetBar = BarChartDataSet(entries: numberOfEventsAttendedBar, label: nil)
        let chartDataBar = BarChartData(dataSet: chartDataSetBar)
        
        // Formatting Colors
        var colorsBar: [UIColor] = []
        colorsBar.append(UIColor(red: 0.95, green: 0.33, blue: 0.33, alpha: 1.00))
        colorsBar.append(UIColor(red: 1.00, green: 0.80, blue: 0.31, alpha: 1.00))
        colorsBar.append(UIColor.gray)
        
        chartDataSetBar.colors = colorsBar
        
        // Formatting Numbers
        let formatterBar = NumberFormatter()
        formatterBar.numberStyle = .decimal
        formatterBar.maximumFractionDigits = 0
        chartDataBar.setValueFormatter(DefaultValueFormatter(formatter: formatterBar))
        chartDataBar.setValueFont(.systemFont(ofSize: 16))
        chartDataBar.barWidth = 0.7
        
        // Formatting Chart
        let formatter = CustomLabelsAxisValueFormatter()
        formatter.eventTypes = ["ATHLETICS", "DINING"]
        barChart.largeContentTitle = "Total Attended Events: Athletics and Dining"
        barChart.xAxis.valueFormatter = formatter
        barChart.xAxis.setLabelCount(formatter.eventTypes.count, force: false)
//        barChart.scaleXEnabled = false
//        barChart.xAxis.forceLabelsEnabled = true
        barChart.xAxis.granularityEnabled = true
        barChart.xAxis.granularity = barChart.xAxis.axisMaximum / Double(formatter.eventTypes.count)
        barChart.xAxis.centerAxisLabelsEnabled = true
        barChart.xAxis.axisMaximum = 1.0
        barChart.leftAxis.resetCustomAxisMax()
        barChart.xAxis.axisMinimum = 1.0
//        barChart.xAxis.labelCount = formatter.eventTypes.count
        barChart.legend.enabled = false
        barChart.leftAxis.drawGridLinesEnabled = true
        barChart.leftAxis.drawAxisLineEnabled = true
        barChart.rightAxis.enabled = false
        barChart.xAxis.centerAxisLabelsEnabled = true
        barChart.xAxis.labelPosition = .bottom
        barChart.xAxis.labelFont = UIFont(name: "Avenir-Heavy", size: 12.0)!
        barChart.animate(yAxisDuration: 1.5)
        
        barChart.data = chartDataBar

    }
    class CustomLabelsAxisValueFormatter: NSObject, IAxisValueFormatter{
        var eventTypes: [String] = []
        func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            let count = self.eventTypes.count
            
            guard let axis = axis, count > 0 else {
                return ""
            }
            let factor = axis.axisMaximum / Double(count)
            
            let index = Int((value/factor).rounded())
            
            if index >= 0 && index < count {
                return self.eventTypes[index]
            }
            return ""
        }
    }
}

