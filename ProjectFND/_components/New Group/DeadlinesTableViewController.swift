//
//  DeadlinesTableViewController.swift
//  ProjectFND
//
//  Created by Elly Richardson on 11/10/19.
//  Copyright © 2019 EllyRichardson. All rights reserved.
//

import UIKit

class DeadlinesTableViewController: UITableViewController {
    
    var toDos = [ToDo]()
    var toDoDeadlineGroup = [String]()
    var toDoSections = [ToDoDateSection]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.toDoSections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let toDoSection = self.toDoSections[section]
        return toDoSection.toDos.count
    }
    
    // Creates the date of a ToDo as a section header.
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // Have section header if section is not empty.
        if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
            let toDoSection = self.toDoSections[section]
            let toDoDate = toDoSection.toDoDate
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM dd, yyyy"
            return dateFormatter.string(from: toDoDate)
        }
            // Remove header if section is empty
        else {
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let dateCellIdentifier = "ToDoTableViewCell"
        
        let dueDateFormatter = DateFormatter()
        let workDateFormatter = DateFormatter()
        dueDateFormatter.dateFormat = "M/d/yy, h:mm a"
        workDateFormatter.dateFormat = "h:mm a"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: dateCellIdentifier, for: indexPath) as? ToDoDeadlineGroupCell else {
            fatalError("The dequeued cell is not an instance of ToDoTableViewCell.")
        }
        
        let toDo = self.toDoSections[indexPath.section].toDos[indexPath.row]
        
        cell.taskNameLabel.text = toDo.taskName
        cell.startDateLabel.text = "Start: " + workDateFormatter.string(from: toDo.workDate)
        cell.estTimeLabel.text = "Est. Time: " + toDo.estTime
        cell.endDateLabel.text = "Due: " + dueDateFormatter.string(from: toDo.dueDate)
        
        print(indexPath.row)
        print(toDo.finished)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if toDoSections[indexPath.section].collapsed {
            return 0
        }
        return 51
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let toDoToBeDeleted = toDoSections[indexPath.section].toDos[indexPath.row]
            
            // Delete the row from the current toDoSection
            toDoSections[indexPath.section].toDos.remove(at: indexPath.row)
            
            // Delete ToDo from the actual ToDos data, not just toDoSection
            //deleteToDoFromSections(toDoToBeDeleted: toDoToBeDeleted)
            //saveToDos()
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UITableViewHeaderFooterView()
        /*
        let tapRecognizer = HeaderTapGesture(target: self, action: #selector(handleTap))
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        tapRecognizer.section = section
         */
        // Was supposed to make background color of headers orange
        headerView.backgroundColor = UIColor.orange
        //headerView.addGestureRecognizer(tapRecognizer)
        
        return headerView
    }
    
    // MARK: - Navigation

    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}
