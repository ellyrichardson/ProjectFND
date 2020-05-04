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
    
    // MARK: - Properties
    //private let toDos = ToDoProcessUtils.loadToDos()
    private var toDos = [String: ToDo]()
    private var toDosController: ToDosController!
    
    @IBOutlet weak var nonRptngDeadlinesSummView: UIView!
    @IBOutlet weak var summaryBarChart: BarChartView!
    
    // MARK: - Utilities
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toDos = toDosController.getToDos()
        updateChartWithData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        updateChartWithData()
    }
    
    func updateChartWithData() {
        let greenColor = UIColor(red:0.08, green:0.85, blue:0.42, alpha:1.0)
        let yellowColor = UIColor(red:1.00, green:0.89, blue:0.00, alpha:1.0)
        let orangeColor = UIColor(red:1.00, green:0.5, blue:0.0, alpha:1.0)
        let toDoBarChartColors = [greenColor, yellowColor, orangeColor]
        
        var dataEntries: [BarChartDataEntry] = []
        let dataEntry = BarChartDataEntry(x: Double(3), y: Double(countFinishedToDoItems(toDoItems: toDos)))
        let dataEntry2 = BarChartDataEntry(x: Double(2), y: Double(countInProgressToDoItems(toDoItems: toDos)))
        let dataEntry3 = BarChartDataEntry(x: Double(1), y: Double(countOverdueToDoItems(toDoItems: toDos)))
        dataEntries.append(dataEntry)
        dataEntries.append(dataEntry2)
        dataEntries.append(dataEntry3)
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Intervalized ToDos")
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
        summaryBarChart.animate(xAxisDuration: 1)
        summaryBarChart.animate(yAxisDuration: 1)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? DeadlinesViewController,
                    segue.identifier == "NonRepeatingDeadlinesSummaryView" {
            vc.setToDosController(toDosController: toDosController)
        }
    }
    
    private func countFinishedToDoItems(toDoItems: [String: ToDo]) -> Int {
        return ToDoProcessUtils.retrieveIntervalizedToDosByStatus(toDoItems: toDos, taskStatus: TaskStatuses.FINISHED).count
    }
    
    private func countInProgressToDoItems(toDoItems: [String: ToDo]) -> Int {
        return ToDoProcessUtils.retrieveIntervalizedToDosByStatus(toDoItems: toDos, taskStatus: TaskStatuses.INPROGRESS).count
    }
    
    private func countOverdueToDoItems(toDoItems: [String: ToDo]) -> Int {
        return ToDoProcessUtils.retrieveIntervalizedToDosByStatus(toDoItems: toDos, taskStatus: TaskStatuses.OVERDUE).count
    }
    
    // MARK: - Setters
    
    func setToDosController(toDosController: ToDosController) {
        self.toDosController = toDosController
    }
    
    // MARK: - Getters
    
    func getToDosController() -> ToDosController {
        return self.toDosController
    }
}
