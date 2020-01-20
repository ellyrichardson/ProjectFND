//
//  intervalSchedulingHelper.swift
//  ProjectFND
//
//  Created by Elly Richardson on 12/16/19.
//  Copyright © 2019 EllyRichardson. All rights reserved.
//

import UIKit
import CoreData
import os.log

class IntervalSchedulingHelper {
    private var toDoProcessHelper: ToDoProcessHelper = ToDoProcessHelper()
    
    // NOTE: Can be placed in a different file
    func checkIntervalsIfOccupied(checkDateIntervals: [Date], dayChosenToCheck: Date) -> [Date] {
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
    
    func assignIntervalToList(toDoStartDate: Date, toDoEndDate: Date, intervalToCheck: Date, listOfAvailableIntervals: inout [Date]) {
        if !(toDoStartDate ... toDoEndDate).contains(intervalToCheck) {
            let endOfInterval = intervalToCheck.addingTimeInterval(15.0 * 60.0)
            // If the end of interval is not between a ToDo start date and end date
            if !(toDoStartDate ... toDoEndDate).contains(endOfInterval) {
                listOfAvailableIntervals.append(intervalToCheck)
            }
        }
    }
    
    // TEST CODE
    func justTest() {
        var timeSlotOfObject = "timeslot"
        
    }
    
    // Checks for available intervals from the start of the day.
    func getAvailableIntervalsForDay(dayToCheck: Date) -> [Date] {
        // var toDoStartDateToCheck: Date = startDateOfToDo
        
        // TODO: Update endDate check to 15 mins prior the endDate as checking will increment by 15 mins
        var dateIntervalsToCheck: [Date] = [Date]()
        let calendarObject = Calendar(identifier: .gregorian)
        
        var toDoStartDateToCheck: Date = calendarObject.startOfDay(for: dayToCheck)
        
        while toDoStartDateToCheck <= dayToCheck {
            dateIntervalsToCheck.append(toDoStartDateToCheck)
            toDoStartDateToCheck = toDoStartDateToCheck.addingTimeInterval(15.0 * 60.0)
        }
        
        return checkIntervalsIfOccupied(checkDateIntervals: dateIntervalsToCheck, dayChosenToCheck: dayToCheck)
    }
    
    func isDateEqualToAnotherDate(dateToCheck: Date, anotherDate: Date) -> Bool {
        if dateToCheck == anotherDate {
            return true
        }
        return false
    }
    
    func getLongestConsecutiveInterval(intervalList: [Date]) -> [Date] {
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
    func checkIfIntervalOverlapsWithNext(endOfInterval: Date, intervalList: inout [Date], endOfLastInterval: inout Date, iterationCounter: Int, currentInterval: Date) {
        if endOfInterval <= intervalList[iterationCounter + 1] {
            intervalList.append(currentInterval)
            // Tracks the end of previous interval
            endOfLastInterval = endOfInterval
        }
    }
    
    // Checks for the longest consecutive interval in a list of intervals
    func checkForLongestInterval(listOfIntervalsList: [[Date]]) -> [Date] {
        var longestInterval = listOfIntervalsList[0]
        for intervalList in listOfIntervalsList {
            if intervalList.count > longestInterval.count {
                longestInterval = intervalList
            }
        }
        return longestInterval
    }
}
