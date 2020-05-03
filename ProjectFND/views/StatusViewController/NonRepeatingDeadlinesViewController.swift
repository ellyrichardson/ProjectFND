//
//  NonRepeatingDeadlinesViewController.swift
//  ProjectFND
//
//  Created by Elly Richardson on 4/16/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import UIKit
import Charts

class NonRepeatingDeadlinesViewController: UIViewController {
    
    @IBOutlet weak var summaryBarChart: BarChartView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateChartWithData()

        // Do any additional setup after loading the view.
    }
    
    func updateChartWithData() {
        let greenColor = UIColor(red:0.08, green:0.85, blue:0.42, alpha:1.0)
        let yellowColor = UIColor(red:1.00, green:0.89, blue:0.00, alpha:1.0)
        let orangeColor = UIColor(red:1.00, green:0.5, blue:0.0, alpha:1.0)
        let toDoBarChartColors = [orangeColor, yellowColor, greenColor]
        
        var dataEntries: [BarChartDataEntry] = []
        let dataEntry = BarChartDataEntry(x: Double(3), y: Double(4))
        let dataEntry2 = BarChartDataEntry(x: Double(2), y: Double(6))
        let dataEntry3 = BarChartDataEntry(x: Double(1), y: Double(2))
        dataEntries.append(dataEntry)
        dataEntries.append(dataEntry2)
        dataEntries.append(dataEntry3)
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Test")
        chartDataSet.colors  = toDoBarChartColors
        let chartData = BarChartData(dataSet: chartDataSet)
        
        summaryBarChart.data = chartData
        summaryBarChart.pinchZoomEnabled = false
        summaryBarChart.doubleTapToZoomEnabled = false
        summaryBarChart.rightAxis.drawGridLinesEnabled = false
        summaryBarChart.rightAxis.drawLabelsEnabled = false
        summaryBarChart.leftAxis.drawGridLinesEnabled = false
        //summaryBarChart.leftAxis.drawLabelsEnabled = false
        summaryBarChart.xAxis.drawGridLinesEnabled = false
        summaryBarChart.xAxis.drawLabelsEnabled = false
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
