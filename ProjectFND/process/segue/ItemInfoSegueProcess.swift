//
//  ItemInfoSegueProcess.swift
//  ProjectFND
//
//  Created by Elly Richardson on 7/28/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import UIKit
import SwiftEntryKit
import os.log

// REFACTOR: Put this in a base segue process, where a `segue` variable is defaulted so that destinations can be set
class ItemInfoSegueProcess  {
    
    let segue: UIStoryboardSegue
    let navController: UINavigationController
    let itemInfoTVC: ItemInfoTableViewController
    
    init?(segue: UIStoryboardSegue) {
        self.segue = segue
        self.navController = (segue.destination as? UINavigationController)!
        self.itemInfoTVC = navController.viewControllers.first as! ItemInfoTableViewController
    }
    
    func segueToItemInfoVCForAddingTask(tasks: [String: ToDo]) {
        itemInfoTVC.setToDos(toDos: tasks)
        os_log("Adding a new ToDo item.", log: OSLog.default, type: .debug)
    }
    
    func segueToItemInfoVCForShowingTaskDetails(selectedDate: Date, tasksController: ToDosController, sender: Any?, taskListTableView: UITableView) {
        let tasksByDay = ToDoProcessUtils.sortToDoItemsByDate(toDoItems: tasksController.getToDosByDay(dateChosen: selectedDate))
        
        guard let selectedToDoItemCell = sender as? ScheduleTableViewCell else {
            fatalError("Unexpected sender: \(String(describing: sender))")
        }
        
        guard let indexPath = taskListTableView.indexPath(for: selectedToDoItemCell) else {
            fatalError("The selected cell is not being displayed by the table")
        }
        let selectedToDoItem = tasksByDay[indexPath.row].value
        itemInfoTVC.toDo = selectedToDoItem
        // Sets the chosen work and due date in the itemInfoTableViewController to avoid its reset
        itemInfoTVC.setChosenWorkDate(chosenWorkDate: selectedToDoItem.getStartTime())
        itemInfoTVC.setChosenDueDate(chosenDueDate: selectedToDoItem.getEndTime())
        // Sets the finish status of the todo in the itemInfoTableViewController to avoid its reset
        itemInfoTVC.setIsFinished(isFinished: selectedToDoItem.isFinished())
        itemInfoTVC.setSelectedTaskType(selectedTaskTypePickerData: selectedToDoItem.getTaskTag())
        itemInfoTVC.setToDos(toDos: ToDoProcessUtils.retrieveToDoItemsByDay(toDoDate: selectedDate, toDoItems: tasksController.getToDos()))
        os_log("Showing details for the selected ToDo item.", log: OSLog.default, type: .debug)
    }
}
