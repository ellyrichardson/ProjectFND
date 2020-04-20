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
        return getToDos().count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dateCellIdentifier = "DeadlinesTableViewCell"
        
        /*
        let dueDateFormatter = DateFormatter()
        let workDateFormatter = DateFormatter()
        dueDateFormatter.dateFormat = "h:mm a"
        workDateFormatter.dateFormat = "h:mm a"
 */
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: dateCellIdentifier, for: indexPath) as? DeadlinesTableViewCell else {
            fatalError("The dequeued cell is not an instance of ScheduleTableViewCell.")
        }
        
        var toDoItems: [String: ToDo] = getToDos()
        let sortedToDoItems = ToDoProcessUtils.sortToDoItemsByDate(toDoItems: toDoItems)
        let randomColor = randomColorGenerator()//.cgColor
        
        cell.intervalizedToDoLabel.text = sortedToDoItems[indexPath.row].value.getTaskName()
        cell.intervalizedToDoLabel.textColor = randomColor
        cell.intervalizedToDoTypeLabel.text = randomTypeGenerator()
        cell.intervalToDoTypeBorder.backgroundColor = randomColor
        cell.intervalizedToDoEstTimeLabel.text = sortedToDoItems[indexPath.row].value.getEstTime() + " Hours"
        //cell.intervalizedToDoEndingTimeLabel.text =  so
        /*
        cell.taskNameLabel.text = sortedToDoItems[indexPath.row].value.getTaskName()
        cell.taskTypeLabel.text = "Personal"
        cell.deadlineDateLabel.text = "12 January, 2020"*/
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.contentView.layer.masksToBounds = true
        let randomColor = randomColorGenerator().cgColor
        //cell.contentView.layer.backgroundColor = randomColor
        //cell.layer.backgroundColor = randomColor
        
        /*
         NOTE: If this is not set `shadowPath` you'll notice laggy scrolling. Mysterious code too.  It just make the shadow stuff work
         */
        let radius = cell.contentView.layer.cornerRadius
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: radius).cgPath
    }
    
    func randomColorGenerator() -> UIColor {
        let randomInt = Int.random(in: 0..<3)
        // Neutral status - if ToDo hasn't met due date yet
        if randomInt == 0 {
            // Yellowish color
            return UIColor(red:1.00, green:0.89, blue:0.00, alpha:1.0)
        }
            // Finished - if ToDo is finished
        else if randomInt == 1 {
            // Greenish color
            return UIColor(red:0.08, green:0.85, blue:0.42, alpha:1.0)
        }
            // Late - if ToDo hasn't finished yet and is past due date
        else {
            // Reddish orange color
            return UIColor(red:1.00, green:0.5, blue:0.0, alpha:1.0)
        }
    }
    
    func randomTypeGenerator() -> String {
        let randomInt = Int.random(in: 0..<3)
        if randomInt == 0 {
            return "Personal"
        }
        else if randomInt == 1 {
            return "Work"
        }
        else {
            return "School"
        }
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
