//
//  DeadlinesViewController.swift
//  ProjectFND
//
//  Created by Elly Richardson on 3/17/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import UIKit

class DeadlinesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var deadlinesTableView: UITableView!
    private var toDos: [ToDo] = [ToDo]()

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
    private func getToDos() -> [ToDo] {
        return self.toDos
    }

    // MARK: - Table View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Gets the ToDos that fall under the selected day in calendar
        return getToDos().count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116
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
        
        var toDoItems: [ToDo] = getToDos()
        
        cell.taskNameLabel.text = toDoItems[indexPath.row].getTaskName()
        cell.taskTypeLabel.text = "Personal"
        cell.deadlineDateLabel.text = "12 January, 2020"
        
        return cell
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
