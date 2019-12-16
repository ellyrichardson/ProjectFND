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
    private var toDoProcessHelper: ToDoProcessHelper = ToDoProcessHelper()
    //var availableIntervals: [Date] = [Date]()
        
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
        
        // Not a minute still, could be minutes (DUMMY TRACKER)
        var intervalToDoMinutesTracker = toDoIntervalEnd.timeIntervalSince(toDoIntervalStart)
        
        // DUMMY lines
        // REMINDER: Don't have a checker if nothing is available yet.
        let intervalToDoForCheck = checkToDo(toDoToCheck: intervalToDo, toDoIntervalStart: toDoIntervalStart, toDoIntervalEnd: toDoIntervalEnd)
        
        while intervalToDoMinutesTracker > 0 {
            // Checks if workDate is earlier than dueDate
            if intervalToDoForCheck?.dueDate.compare((intervalToDoForCheck?.workDate)!) == ComparisonResult.orderedDescending {
                // Break loop
                break
            }
            
            if intervalToDoForCheck == nil {
                // Assign the date
                let intervalOfAssignedDate = intervalToDoForCheck?.dueDate.timeIntervalSince((intervalToDoForCheck?.workDate)!)
                // Substracts the remaining interval
                intervalToDoMinutesTracker -= intervalOfAssignedDate!
            }
            else {
                // Adding the interval 15 mins
                intervalToDoForCheck?.workDate = (intervalToDoForCheck?.workDate.addingTimeInterval(15.0 * 60.0))!
                // TODO: May need to also take into account adding time interval of the due date. Maybe restructure ToDo Model with the time length in it?
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
         (NOTE: Have a special case to stop assigning if there is nothing available and intervals are still not done.)
         */
        
        // BIG TODO:
        /*
         CHECKER FOR AVAILABLE DATES
         - If the bDate reaches the dueDate interval, first reduce it.
            - If there is still no available interval, then there is no available dates anymore
         
         - (A1) Since the bDate checker increments by 15 mins, if the bDate to be checked with doesn't fall between the two dates of a toDo, a ToDo's workdate and duedate for the current day, then save the start and end of it as a list. Also, check the end, which is pretty much checking the next 15 mins, of the listed time to know the duration. Must be atleast 15 mins.
            (NOTE: Check if + or - 15 mins from the chosen bDate have a ToDo to determine if it is at least 15 mins or not. If it is not atleast 15 mins, then discard the bDate (A3).)
         
         - (A2) If the bDate ended up having to reduce the work time, then use these listed dates. The listed dates that can be used is only if these dates, if consecutive, will be half an hour, as a minimum of half an hour is needed for every ToDo.
            (NOTE: Its pretty much like concatenating dates, and if they are consecutive, then good.)
         
         - (A3) To check if the dates are consecutive, since there will be list of bDates that doesn't fall between a ToDo's work and due date time, determine if the next date in the list is 15 mins or less from the previous or next date. If it is maximum of 15 mins, then it is consecutive, if not, then it is not consecutive.
            (NOTE: Keep checking if these dates fall under a taken ToDo time. This 15 minutes time checking is constrained by the data used.)
            - Have some kind of a tracker for consecutive dates (Linked List)
         
         - STAR IDEA (KEEP): Check every 15 min period of the date if the ToDo has to be reduced. Call it bDate. If bDate does not fall between the work interval of a ToDo in currentDay, then check the next 15 mins.
            - If the next 15 mins does not fall under a ToDo work interval, then list this time that tells the start and the end like (4:00 pm - 4:15 pm).
            - List all of the 15 min available intervals found.
            - To check if some of the 15 mins are consecutive, check if the end and start date of one listed interval is the same as this will mean they are consecutives.
                (Note: ToDos can only be auto scheduled if it has at least 30 mins work time.)
            - Determine these consecutives, if they exist, and use the one with longest interval and assign it as a time for the reduced ToDo.
                - If there are other reduced ToDos, find the next longest interval consecutive and assign it.
         */
        
        
    }
    
    // NOTE: Can be placed in a different file
    private func checkIntervalsIfOccupied(checkDateIntervals: [Date], dayChosenToCheck: Date) -> [Date] {
        var availableIntervals: [Date] = [Date]()
        let toDoItemsToCheckWith: [ToDo] = toDoProcessHelper.retrieveToDoItemsByDay(toDoDate: dayChosenToCheck, toDoItems: toDoProcessHelper.loadToDos()!)
        
        // If else statements based on the value of the squares of checkDateIntervals and toDoItemsToCheckWith
        if checkDateIntervals.count > toDoItemsToCheckWith.count {
            for intervalToCheck in checkDateIntervals {
                for toDo in toDoItemsToCheckWith {
                    assignIntervalToList(toDoStartDate: toDo.workDate, toDoEndDate: toDo.dueDate, intervalToCheck: intervalToCheck, listOfAvailableIntervals: &availableIntervals)
                }
            }
        } else {
            for toDo in toDoItemsToCheckWith {
                for intervalToCheck in checkDateIntervals {
                    assignIntervalToList(toDoStartDate: toDo.workDate, toDoEndDate: toDo.dueDate, intervalToCheck: intervalToCheck, listOfAvailableIntervals: &availableIntervals)
                }
            }
        }
        
        return availableIntervals
    }
    
    private func assignIntervalToList(toDoStartDate: Date, toDoEndDate: Date, intervalToCheck: Date, listOfAvailableIntervals: inout [Date]) {
        if !(toDoStartDate ... toDoEndDate).contains(intervalToCheck) {
            let endOfInterval = intervalToCheck.addingTimeInterval(15.0 * 60.0)
            // If the end of interval is not between a ToDo start date and end date
            if !(toDoStartDate ... toDoEndDate).contains(endOfInterval) {
                listOfAvailableIntervals.append(intervalToCheck)
            }
        }
    }
    
    private func getAvailableIntervalsForDay(startDateOfToDo: Date, dayToCheck: Date) -> [Date] {
        var toDoStartDateToCheck: Date = startDateOfToDo
        
        // TODO: Update endDate check to 15 mins prior the endDate as checking will increment by 15 mins
        var dateIntervalsToCheck: [Date] = [Date]()
        
        while toDoStartDateToCheck <= dayToCheck {
            dateIntervalsToCheck.append(toDoStartDateToCheck)
            toDoStartDateToCheck = toDoStartDateToCheck.addingTimeInterval(15.0 * 60.0)
        }
        
        return checkIntervalsIfOccupied(checkDateIntervals: dateIntervalsToCheck, dayChosenToCheck: dayToCheck)
    }
    
    private func isDateEqualToAnotherDate(dateToCheck: Date, anotherDate: Date) -> Bool {
        if dateToCheck == anotherDate {
            return true
        }
        return false
    }
    
    private func getLongestConsecutiveInterval(intervalList: [Date]) -> [Date] {
        var listOfIntervalsList: [[Date]] = [[Date]]()
        var preIntervalList: [Date] = [Date]()
        var endOfLastInterval: Date = Date()
        var iterationCounter: Int = 0
        
        // Returns an empty list of date if the intervalList is empty
        if intervalList.count < 1 {
            return [Date]()
        }
        
        for interval in intervalList {
            // If the iteration is at the very first item of intervalList
            if iterationCounter < 1 {
                let endOfInterval = interval.addingTimeInterval(15.0 * 60.0)
                // If the endOfInterval doesn't overlap with the start of the next interval
                checkIfIntervalOverlapsWithNext(endOfInterval: endOfInterval, intervalList: &preIntervalList, endOfLastInterval: &endOfLastInterval, iterationCounter: iterationCounter, currentInterval: interval)
                
                iterationCounter += 1
            } else {
                // Checks if the interval being checked is consecutive to the previous interval
                if intervalList[iterationCounter - 1] == endOfLastInterval {
                    let endOfInterval = interval.addingTimeInterval(15.0 * 60.0)
                    // If the endOfInterval doesn't overlap with the start of the next interval
                    checkIfIntervalOverlapsWithNext(endOfInterval: endOfInterval, intervalList: &preIntervalList, endOfLastInterval: &endOfLastInterval, iterationCounter: iterationCounter, currentInterval: interval)
                    
                    iterationCounter += 1
                } else {
                    // If a consecutive interval ends, then add to the list of consecutive intervals.
                    listOfIntervalsList.append(preIntervalList)
                }
            }
        }
        return checkForLongestInterval(listOfIntervalsList: listOfIntervalsList)
    }
    
    // Checks if an interval overlaps with the next interval
    private func checkIfIntervalOverlapsWithNext(endOfInterval: Date, intervalList: inout [Date], endOfLastInterval: inout Date, iterationCounter: Int, currentInterval: Date) {
        if endOfInterval <= intervalList[iterationCounter + 1] {
            intervalList.append(currentInterval)
            // Tracks the end of previous interval
            endOfLastInterval = endOfInterval
        }
    }
    
    // Checks for the longest consecutive interval in a list of intervals
    private func checkForLongestInterval(listOfIntervalsList: [[Date]]) -> [Date] {
        var longestInterval = listOfIntervalsList[0]
        for intervalList in listOfIntervalsList {
            if intervalList.count > longestInterval.count {
                longestInterval = intervalList
            }
        }
        return longestInterval
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
