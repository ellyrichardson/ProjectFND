//
//  SchedulePreviewTableViewController.swift
//  ProjectFND
//
//  Created by Elly Richardson on 11/24/19.
//  Copyright © 2019 EllyRichardson. All rights reserved.
//

import UIKit
import CoreData
import os.log

class SchedulePreviewTableViewController: UITableViewController {
    
    private var toDo: ToDo?
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    func setBaseToDo(baseToDo: ToDo) {
        self.toDo = baseToDo
    }
    
    func theOperation(intervalToDo: ToDo) {
        // TODO: Really fix the logic of this function and the checkToDo
        // TODO: Still need to add function for dividing the dates
        var toDoIntervalStart: Date = intervalToDo.workDate
        var toDoIntervalEnd: Date = intervalToDo.dueDate
        
        // Not a minute still, could be minutes
        var intervalToDoMinutesTracker = toDoIntervalEnd.timeIntervalSince(toDoIntervalStart)
        
        while intervalToDoMinutesTracker > 0 {
            // DUMMY lines
            // REMINDER: Don't have a checker if nothing is available yet.
            var intervalToDoForCheck = checkToDo(toDoToCheck: intervalToDo, toDoIntervalStart: toDoIntervalStart, toDoIntervalEnd: toDoIntervalEnd)
            if intervalToDoForCheck == nil {
                // Assign the date
                let intervalOfAssignedDate = intervalToDoForCheck?.dueDate.timeIntervalSince((intervalToDoForCheck?.workDate)!)
                // Substracts the remaining interval
                intervalToDoMinutesTracker = intervalToDoMinutesTracker - intervalOfAssignedDate!
            }
            else {
                // Adding the interval 15 mins
                intervalToDoForCheck?.workDate.addingTimeInterval(15.0 * 60.0)
            }
        }
        
        // ALGORITHM GUIDE
        /*
         - Have a date that starts from the beginning interval called bDate
         - Have some kind of a tracker for remaining intervals
         - From bDate, check if the it is already taken in the Core Data.
         - Have some kind of a loop based on the remaining intervals
         - If it is taken, then increment the bDate, make sure that bDate don't do past the dueDate
            (Start every 15 mins, from the interval start, to assign tasks.)
            - Increment the bDate by 15 mins
         - If it is not taken, then assign that bDate in Core Data.
            - Decrement the tracker of remaining intervals by the amount of time bDate has
         - If the only available date doesn't fit the rest of the interval, then reduce bDate.
            - Assign bDate anyway, but inform the user that the ideal time wasn't possible
         - Start all over again until the interval is completed.
         (Have a special case to stop assigning if there is nothing available and intervals are still not done.)
         */
        
        // BIG TODO:
        /*
         CHECKER FOR AVAILABLE DATES
         - If the bDate reaches the dueDate interval, first reduce it.
            - If there is still no available interval, then there is no available dates anymore
         */
    }
    
    private func checkToDo(toDoToCheck: ToDo, toDoIntervalStart: Date, toDoIntervalEnd: Date) -> ToDo?  {
        var existingToDo: ToDo?
        // Container is set up in the AppDelegate so it needs to refer to that container.
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        // Context needs to be created in this container
        let managedContext = appDelegate!.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "FND_ToDo")
        
        // Assigning different filters for the ToDo to be checked
        let taskNamePredicate = NSPredicate(format: "taskName = %@", toDoToCheck.taskName)
        let taskDescriptionPredicate = NSPredicate(format: "taskDescription = %@", toDoToCheck.taskDescription)
        let estTimePredicate = NSPredicate(format: "estTime = %@", toDoToCheck.estTime)
        let startDatePredicate = NSPredicate(format: "startDate == %@", toDoToCheck.workDate as NSDate)
        let dueDatePredicate = NSPredicate(format: "dueDate == %@", toDoToCheck.dueDate as NSDate)
        //var statusPredicate = NSPredicate(format: "finished = %d", toDoToUpdate.finished)
        
        /*
        if updateType == 1 {
            statusPredicate = NSPredicate(format: "finished = %d", !toDoToUpdate.finished)
        }
        */
        
        // Combines different filters to one filter
        let propertiesPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [taskNamePredicate, taskDescriptionPredicate, estTimePredicate, startDatePredicate, dueDatePredicate])
        
        fetchRequest.predicate = propertiesPredicate
        
        do {
            let toDoItem = try managedContext.fetch(fetchRequest)
            
            //let objectUpdate = toDoItem[0] as! NSManagedObject
            
            // ANOMALY: Why is there a warning?
            if toDoItem[0] != nil {
                let objectCheck = toDoItem[0] as! NSManagedObject
                existingToDo = ToDo(taskName: objectCheck.value(forKey: "taskName") as! String, taskDescription: objectCheck.value(forKey: "taskDescription") as! String, workDate: objectCheck.value(forKey: "startDate") as! Date, estTime: objectCheck.value(forKey: "estTime") as! String, dueDate: objectCheck.value(forKey: "dueDate") as! Date, finished: (objectCheck.value(forKey: "finished") as! Bool))
                
                return existingToDo
            }
            /*
            objectUpdate.setValue(newToDo.taskName, forKey: "taskName")
            objectUpdate.setValue(newToDo.taskDescription, forKey: "taskDescription")
            objectUpdate.setValue(newToDo.estTime, forKey: "estTime")
            objectUpdate.setValue(newToDo.workDate, forKey: "startDate")
            objectUpdate.setValue(newToDo.dueDate, forKey: "dueDate")
            //objectUpdate.setValue(newToDo.finished, forKey: "finished")
            */
            
            /*
            do {
                try managedContext.save()
            } catch {
                os_log("Could not update ToDo.", log: OSLog.default, type: .debug)
            }
            */
        } catch {
            os_log("Could not fetch ToDos.", log: OSLog.default, type: .debug)
        }
        // If date didn't exist
        return nil
    }
    
}
