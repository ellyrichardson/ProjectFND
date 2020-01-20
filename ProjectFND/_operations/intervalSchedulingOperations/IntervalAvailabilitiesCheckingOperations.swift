//
//  IntervalAvailabilitiesCheckingOperations.swift
//  ProjectFND
//
//  Created by Elly Richardson on 1/19/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import CoreData
import UIKit
import os.log

class IntervalAvailabilitiesCheckingOperations {
    var dateArithmeticOps = DateArithmeticOperations()
    
    func getTimeSlotsOfAToDo(toDo: ToDo) -> [TimeSlot] {
        var timeSlots: [TimeSlot] = [TimeSlot]()
        // Gets the starting time of the first fifteen minute interval of the ToDo
        var startingTimeOfToDoFifteenMinuteInterval: Date = toDo.workDate
        // Gets the endingTime of the ToDo workTime for the day
        var endingTimeOfToDoWorkTimeForTheDay: Date = getEndOfToDoWorkTimeForTheDay(toDo: toDo, toDoWorkTimeLength: 2.0)
        
        // While the timeToBeChecked is not the ending work time of the Todo, keep adding the fifteen minute interval to the timeSlots
        while checkTimeIfLastFifteenMinutes(timeToBeChecked: startingTimeOfToDoFifteenMinuteInterval, endingWorkTimeForTheDay: endingTimeOfToDoWorkTimeForTheDay) == false {
            // Gets the time with added fifteen minutes
            let timeWithAddedFifteenMinutes: Date = dateArithmeticOps.addMinutesToDate(date: startingTimeOfToDoFifteenMinuteInterval, minutes: 15.0)
            // Appends the new time slot with the startingTime and the added 15 minutes to the timeSlots collection
            timeSlots.append(TimeSlot(startOfTimeSlot: startingTimeOfToDoFifteenMinuteInterval, endOfTimeSlot: timeWithAddedFifteenMinutes)!)
            // Increases the startingTime by 15 minutes
            startingTimeOfToDoFifteenMinuteInterval = timeWithAddedFifteenMinutes
        }
        return timeSlots
    }
    
    // Checks if the timeToBeChecked is the last 15 minutes of the work time for the day
    func checkTimeIfLastFifteenMinutes(timeToBeChecked: Date, endingWorkTimeForTheDay: Date) -> Bool {
        // Check if the timeToBeChecked + 15 minutes is the endingTime for the ToDo work time of the day
        if dateArithmeticOps.addMinutesToDate(date: timeToBeChecked, minutes: 15.0) == endingWorkTimeForTheDay {
            return true
        }
        return false
    }
    
    func getEndOfToDoWorkTimeForTheDay(toDo: ToDo, toDoWorkTimeLength: Double) -> Date {
        return dateArithmeticOps.addHoursToDate(date: toDo.workDate, hours: toDoWorkTimeLength)
    }
}
