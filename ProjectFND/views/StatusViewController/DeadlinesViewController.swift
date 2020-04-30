//
//  DeadlinesViewController.swift
//  ProjectFND
//
//  Created by Elly Richardson on 3/17/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import UIKit

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
        let randomColor = colorForIntervalsSummary(toDoItem: tupledIntervalizedToDoItems[indexPath.row].value)//.cgColor
        let intervalizedToDo = tupledIntervalizedToDoItems[indexPath.row].value
        
        cell.intervalizedToDoLabel.text = intervalizedToDo.getTaskName()
        cell.intervalizedToDoLabel.textColor = randomColor
        cell.intervalizedToDoTypeLabel.text = intervalizedToDo.getTaskType()
        cell.intervalToDoTypeBorder.backgroundColor = randomColor
        cell.intervalizedToDoEstTimeLabel.text = String(Double(getTotalHoursOfIntervalizedToDo(intervalId: intervalizedToDo.getIntervalId()))) + " Hours"
        cell.intervalizedToDoEndingTimeLabel.text = "Due " + formatter.string(from: intervalizedToDo.getIntervalDueDate())
        cell.intervalizedToDoIntervalAmount.text = String(intervalizedToDo.getIntervalLength())
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        ToDoTableViewUtils.makeCellMoveUpWithFade(cell: cell, indexPath: indexPath)
        
        var toDoItems: [String: ToDo] = getToDos()
        //let sortedToDoItems = ToDoProcessUtils.sortToDoItemsByDate(toDoItems: toDoItems)
        let intervalizedToDoItems = ToDoProcessUtils.retrieveAllIntervalizedTodos(toDoItems: toDoItems)
        let tupledIntervalizedToDoItems = ToDoProcessUtils.sortToDoItemsByDate(toDoItems: intervalizedToDoItems)
        cell.contentView.layer.masksToBounds = true
        
        /*
         NOTE: If this is not set `shadowPath` you'll notice laggy scrolling. Mysterious code too.  It just make the shadow stuff work
         */
        let radius = cell.contentView.layer.cornerRadius
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: radius).cgPath
    }
    
    // TODO: Make this colorForIntervalsSummary() in the future!
    private func colorForIntervalsSummary(toDoItem: ToDo) -> UIColor {
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "M/d/yy, h:mm a"
        
        //let toDoItem = toDoItems[toDoRowIndex]
        
        // Neutral status - if ToDo hasn't met due date yet
        if toDoItem.finished == false && currentDate < toDoItem.dueDate {
            // Yellowish color
            return UIColor(red:1.00, green:0.89, blue:0.00, alpha:1.0)
        }
            // Finished - if ToDo is finished
        else if toDoItem.finished == true {
            // Greenish color
            return UIColor(red:0.08, green:0.85, blue:0.42, alpha:1.0)
        }
            // Late - if ToDo hasn't finished yet and is past due date
        else {
            // Reddish orange color
            return UIColor(red:1.00, green:0.5, blue:0.0, alpha:1.0)
        }
    }
    
    private func getTotalHoursOfIntervalizedToDo(intervalId: String) -> Int {
        let intervalizedToDoItems = ToDoProcessUtils.retrieveIntervalizedToDosById(toDoItems: getToDos(), intervalizedTodoId: intervalId)
        var totalIntervalizedToDoTimeLength: Int = 0
        for toDoItem in intervalizedToDoItems {
            totalIntervalizedToDoTimeLength += Int(Double(toDoItem.value.getEstTime())!)
        }
        return totalIntervalizedToDoTimeLength
    }
}
