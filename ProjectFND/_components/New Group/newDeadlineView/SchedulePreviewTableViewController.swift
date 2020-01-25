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

/*
class SchedulePreviewTableViewController: UITableViewController {
    
    private var toDo: ToDo?
    private var toDoProcessHelper: ToDoProcessHelper = ToDoProcessHelper()
    //private var intervalSchedulingHelper: IntervalSchedulingHelper = IntervalSchedulingHelper()
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
    
    /*
     - To divide the ToDo into different intervals, convert the total hours to seconds (or minutes).
     - Keep track of the total seconds of the toDo, and then subtract the seconds of the assigned interval.
     - Get the available intervals, and measure its length in seconds (these are consecutive 15 mins dates).
     - If the to-be-assigned interval fits the length, then assign it within that consecutive interval by using the start of the first 15 min of interval.
     - Subtract the seconds of the assigned interval to the total seconds of the ToDo
     - As long as there is still seconds left to the ToDo, keep repeating the steps.
     */
    
    /*
     - Lets say the task is 11 hours, but the user wants to work on it with an ideal of 2 hours in a day, in an ideal span of 6 days
     - This has total of 12 hrs of work. Take this amount instead and try if it is possible.
     */
    
    // TODO: Utilize this function when it is finished so that ToDo intervals can be assigned
    // Kind of divides the tasks by its intervals based on ideal hours per day and days to work. May have to clean this code
    private func assignWorkIntervalsForToDo(toDo: ToDo, dayToCheck: Date, idealHoursPerDay: Int, idealDaysToWork: Int){
        
        // NOTE: Not converted to actual minutes yet
        
        /*
         Dividing the intervals
         
         */
        
        // To keep track of the total length of toDo in minutes
        // NOTE: Could be seconds RIGHT NOW!
        // Gets the total minutes of the undivided ToDo, not divided for intervals yet
        var remainingMinutes: TimeInterval = TimeInterval((Int(toDo.estTime)! * 3600) / 60)
        
        // First date to assign the beggining day of work ToDo
        var toDoDateToAssign: Date = toDo.workDate
        
        // Gets the amount of total intervals of ToDo, not the days to work, based on the ideal hours/minutes per day
        var remainingIntervals = remainingMinutes / TimeInterval(Int(idealHoursPerDay))
        
        let calendar = Calendar.current
        
        // NOTE: Needs a special case if interval wasn't assigned
        // As long as the toDoDateToAssign hasn't past due date
        while toDoDateToAssign <= toDo.dueDate {
            // Breaks loop if there is no interval of time left to assign for the ToDo
            if remainingIntervals <= 0 || remainingIntervals <= 0 {
                break
            }
            
            assignToDoIntervals(toDo: toDo, dayToCheck: toDoDateToAssign, remainingMinutesToAssign: &remainingMinutes, remainingIntervalsToAssign: &remainingIntervals)
            
            // Adds one more day ot the toDoDate for the while loop
            toDoDateToAssign = calendar.date(byAdding: .day, value: 1, to: toDoDateToAssign)!
            // TODO: If ToDo interval didn't get assigned cuz it didn't fit.
        }
    }
    
    // This is assigning ToDo interval
    // TODO: Have an option for cases of not fitting with an interval
    private func assignToDoIntervals(toDo: ToDo, dayToCheck: Date, remainingMinutesToAssign: inout TimeInterval, remainingIntervalsToAssign: inout TimeInterval) {
        // To keep track of the total length of toDo in minutes
        // NOTE: Could be seconds RIGHT NOW! AND THIS IS WRONG! This should use
        let toDoTimeLengthInMin: TimeInterval = TimeInterval((Int(toDo.estTime)! * 3600) / 60)
        
        // Total intervals available in minutes
        var totalMinuteIntervalAvailable: TimeInterval = TimeInterval(0)
        
        // To aid the iteration of checking availableIntervals in minutes
        var intervalIterationCounter = 0
        
        // Gets available intervals by the day to be checked
        var availableIntervals: [Date] = intervalSchedulingHelper.getLongestConsecutiveInterval(intervalList: intervalSchedulingHelper.getAvailableIntervalsForDay(dayToCheck: dayToCheck))
        
        let calendar = Calendar.current
        for _ in availableIntervals {
            // Add up the total length of the interval here from the availableIntervals array
            // NOTE: For now it is just adding
            if intervalIterationCounter < (availableIntervals.count - 1) {
                totalMinuteIntervalAvailable += TimeInterval(calendar.dateComponents([.minute], from: availableIntervals[intervalIterationCounter], to: availableIntervals[intervalIterationCounter + 1]).minute!)
                intervalIterationCounter += 1
            }
        }
        
        // If ToDo fits inside the toDoTimeIntervalAvailable
        if toDoTimeLengthInMin <= totalMinuteIntervalAvailable {
            // NOTE: No checking for special cases, just assumes the best scenario.
            // TODO: Assign the ToDo interval here! And Subtract the remaining interval by reference
            remainingMinutesToAssign -= toDoTimeLengthInMin
            remainingIntervalsToAssign -= 1
        }
    }
    
}*/
