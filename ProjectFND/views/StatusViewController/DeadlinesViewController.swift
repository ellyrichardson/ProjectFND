//
//  DeadlinesViewController.swift
//  ProjectFND
//
//  Created by Elly Richardson on 3/17/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import UIKit
import Charts

class DeadlinesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, Observer {
    private var _observerId: Int = 1
    private var toDosController: ToDosController!
    private let formatter = DateFormatter()
    
    var observerId: Int {
        get {
            return self._observerId
        }
    }
    
    func update<T>(with newValue: T) {
        //setToDoItems(toDoItems: newValue as! [ToDo])
        print("ToDo Items for ScheduleViewController has been updated")
    }
    
    @IBOutlet weak var deadlinesTableView: UITableView!
    private var toDos: [String: ToDo] = [String: ToDo]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableViewDelegates()
        populateToDos()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        populateToDos()
        //self.toDos = toDosController.getToDos()
        self.deadlinesTableView.reloadData()
        print("Deadlines View Controller Will Appear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        print("Deadlines View Controller Will Disappear")
    }
    
    // MARK: - Private Functions
    private func populateToDos() {
        let tempToDos = ToDoProcessUtils.loadToDos()
        if tempToDos != nil {
            self.toDos = tempToDos!
        }
    }
    
    private func setupTableViewDelegates() {
        // Do any additional setup after loading the view, typically from a nib.
        self.deadlinesTableView.delegate = self
        self.deadlinesTableView.dataSource = self
        self.deadlinesTableView.backgroundColor = UIColor.clear
    }
    
    // MARK: - Getters
    private func getToDos() -> [String: ToDo] {
        return self.toDos
    }

    // MARK: - Table View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Gets the ToDos that fall under the selected day in calendar
        let toDoItems: [String: ToDo] = getToDos()
        let intervalizedToDoItems = ToDoProcessUtils.retrieveAllIntervalizedTodos(toDoItems: toDoItems)
        let tupledIntervalizedToDoItems = ToDoProcessUtils.sortToDoItemsByDate(toDoItems: intervalizedToDoItems)
        return tupledIntervalizedToDoItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dateCellIdentifier = "DeadlinesTableViewCell"
        formatter.dateFormat = "MMM dd"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: dateCellIdentifier, for: indexPath) as? DeadlinesTableViewCell else {
            fatalError("The dequeued cell is not an instance of ScheduleTableViewCell.")
        }
        
        let toDoItems: [String: ToDo] = getToDos()
        let intervalizedToDoItems = ToDoProcessUtils.retrieveAllIntervalizedTodos(toDoItems: toDoItems)
        let tupledIntervalizedToDoItems = ToDoProcessUtils.sortToDoItemsByDate(toDoItems: intervalizedToDoItems)
        let cellColor = colorForIntervalsSummary(toDoItem: tupledIntervalizedToDoItems[indexPath.row].value)//.cgColor
        let intervalizedToDo = tupledIntervalizedToDoItems[indexPath.row].value
        
        cell.intervalizedToDoLabel.text = intervalizedToDo.getTaskName()
        cell.intervalizedToDoLabel.textColor = cellColor
        cell.intervalizedToDoTypeLabel.text = intervalizedToDo.getTaskType()
        cell.intervalToDoTypeBorder.backgroundColor = cellColor
        cell.intervalizedToDoEstTimeLabel.text = String(Double(getTotalHoursOfIntervalizedToDo(intervalId: intervalizedToDo.getIntervalId()))) + " Hours"
        cell.intervalizedToDoEndingTimeLabel.text = "Due " + formatter.string(from: intervalizedToDo.getIntervalDueDate())
        cell.intervalizedToDoIntervalAmount.text = String(intervalizedToDo.getIntervalLength())
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        ToDoTableViewUtils.makeCellMoveUpWithFade(cell: cell, indexPath: indexPath)
        
        //let toDoItems: [String: ToDo] = getToDos()
        //let sortedToDoItems = ToDoProcessUtils.sortToDoItemsByDate(toDoItems: toDoItems)
        /*
        let intervalizedToDoItems = ToDoProcessUtils.retrieveAllIntervalizedTodos(toDoItems: toDoItems)*/
        
        cell.contentView.layer.masksToBounds = true
        
        /*
         NOTE: If this is not set `shadowPath` you'll notice laggy scrolling. Mysterious code too.  It just make the shadow stuff work
         */
        let radius = cell.contentView.layer.cornerRadius
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: radius).cgPath
    }
    
    private func colorForIntervalsSummary(toDoItem: ToDo) -> UIColor {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d/yy, h:mm a"
        
        let intervalizedToDoItems = ToDoProcessUtils.retrieveIntervalizedToDosById(toDoItems: getToDos(), intervalizedTodoId: toDoItem.getIntervalId())
        let tupledIntervalizedToDoItems = ToDoProcessUtils.sortToDoItemsByDate(toDoItems: intervalizedToDoItems)
        
        let yellowColor = UIColor(red:1.00, green:0.89, blue:0.00, alpha:1.0)
        let greenColor = UIColor(red:0.08, green:0.85, blue:0.42, alpha:1.0)
        let orangeColor = UIColor(red:1.00, green:0.5, blue:0.0, alpha:1.0)
        
        // Neutral status - if ToDo hasn't met due date yet
        if !checkIfToDoTupleIsAllFinished(toDoTuple: tupledIntervalizedToDoItems) && currentDate < toDoItem.getIntervalDueDate() {
            return yellowColor
        }
        // Finished - if ToDo is finished
        // If the whole set of intervals are finished
        else if checkIfToDoTupleIsAllFinished(toDoTuple: tupledIntervalizedToDoItems) {
            return greenColor
        }
        // Late - if ToDo hasn't finished yet and is past due date
        else {
            return orangeColor
        }
    }
    
    private func checkIfToDoTupleIsAllFinished(toDoTuple: [(key: String, value: ToDo)]) -> Bool {
        var allFinished = true
        for item in toDoTuple {
            if !item.value.isFinished() {
                allFinished = false
            }
        }
        return allFinished
    }
    
    private func getTotalHoursOfIntervalizedToDo(intervalId: String) -> Int {
        let intervalizedToDoItems = ToDoProcessUtils.retrieveIntervalizedToDosById(toDoItems: getToDos(), intervalizedTodoId: intervalId)
        var totalIntervalizedToDoTimeLength: Int = 0
        for toDoItem in intervalizedToDoItems {
            totalIntervalizedToDoTimeLength += Int(Double(toDoItem.value.getEstTime())!)
        }
        return totalIntervalizedToDoTimeLength
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
