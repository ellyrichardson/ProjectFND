//
//  OccupiedAndUnoccupiedTimesRetrieving.swift
//  ProjectFND
//
//  Created by Elly Richardson on 6/7/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import CoreData
import UIKit
import os.log

class OccupiedAndUnoccupiedTimesOperations {
    private var sortedTasksByDay = [(key: String, value:ToDo)]()
    private var occupiedTimesDict = [String: Set<ToDo>]() // Otd
    
    // MARK: - Populating Otd
    func populateOtd(timeSpanStart: Date, timeSpanEnd: Date) {
        var currentDate = timeSpanStart
        let dateUtil = DateUtils()
        while currentDate < timeSpanEnd {
            assignTasksThatStartsUnderHourOfToOtd(date: currentDate)
            currentDate = dateUtil.addHoursToDate(date: currentDate, hours: 1.0)
        }
    }
    
    func addTaskToOtd(otdKey: String, taskSet: Set<ToDo>) {
        self.occupiedTimesDict[otdKey] = taskSet
    }
    
    // MARK: - Utilities
    private func assignTasksThatStartsUnderHourOfToOtd(date: Date) {
        var taskSet = Set<ToDo>()
        var otdKey = String()
        for taskItem in self.sortedTasksByDay {
            let taskValue = taskItem.value
            if doesTaskStartUnderHourOf(date: date, taskItem: taskValue) {
                taskSet.insert(taskValue)
                otdKey = getCurrentHourOfDateAsString(date: taskValue.getStartDate())
            }
        }
        addTaskToOtd(otdKey: otdKey, taskSet: taskSet)
    }
    
    private func doesTaskStartUnderHourOf(date: Date, taskItem: ToDo) -> Bool {
        return getCurrentHourOfDateAsString(date: date) == getCurrentHourOfDateAsString(date: taskItem.getStartDate())
    }
    
    private func getCurrentHourOfDateAsString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh a" // i.e. 12 AM
        return dateFormatter.string(from: date)
    }
    
    // MARK: - Setters
    func setTaskItems(tasks: [(key: String, value:ToDo)]) {
        self.sortedTasksByDay = tasks
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // Should just be called for time span of days
    // 1st Called
    func retrieveAllTasksInATimeSpan(startDate: Date, endDate: Date, taskItems: [String: ToDo]) -> [String: ToDo] {
        var tasksFromTimeSpan: [String: ToDo] = [String: ToDo]()
        var currentDate = startDate
        
        while currentDate < endDate {
            let dateUtils = DateUtils()
            let tasksFromCurrentDate = ToDoProcessUtils.retrieveToDoItemsByDay(toDoDate: currentDate, toDoItems: taskItems)
            ToDoProcessUtils.addToDoDictionaryToAToDoDictionary(toDoDictionary: &tasksFromTimeSpan, toDosToBeAdded: tasksFromCurrentDate)
            currentDate = dateUtils.addDayToDate(date: currentDate, days: 1.0)
        }
        
        return tasksFromTimeSpan
    }
    
    // Actual 2nd Called
    func retrieveOccupiedTimesByMinutesOfATaskItem(taskItem: ToDo) -> [TimeInterval: StartToEndInterval] {
        var taskStartDate = taskItem.getEndDate()
        let taskEndDate = taskItem.getStartDate()
        var occupiedTimes = [TimeInterval: StartToEndInterval]()
        
        while taskStartDate < taskEndDate {
            let dateUtils = DateUtils()
            let taskTimeInterval = taskStartDate.timeIntervalSince1970
            let newSTEInterval = StartToEndInterval(startOfInterval: taskStartDate, endOfInterval: taskEndDate, taskId: taskItem.getTaskId(), occupied: true)
            
            occupiedTimes[taskTimeInterval] = newSTEInterval
            taskStartDate = dateUtils.addMinutesToDate(date: taskStartDate, minutes: 1.0)
        }
        
        return occupiedTimes
    }
    
    
    
    // 2nd Called (Might have to rewrite this to utilize dictionaries for speed)
    func retrieveStartToEndIntervalsOfTaskItems(taskItems: [String: ToDo]) -> [StartToEndInterval] {
        let sortedTaskItemsByDate = ToDoProcessUtils.sortToDoItemsByDate(toDoItems: taskItems)
        var startToEndIntervals = [StartToEndInterval]()
        
        for taskItem in sortedTaskItemsByDate {
            let taskItemValue = taskItem.value
            /*
            let newSTEInterval = StartToEndInterval(startOfInterval: taskItemValue.workDate, endOfInterval: taskItemValue.dueDate, occupied: true)
            startToEndIntervals.append(newSTEInterval)*/
        }
        
        return startToEndIntervals
    }
    
    
    // Might delete later
    func retrieveEveryMinutesOfTimeSpanNOTSURETHENAMEYET(startDate: Date, endDate: Date) {
        var everyMinuteOfTimeSpan = [String: TimeInterval]()
        var currentTime = startDate
        
        while currentTime < endDate {
            let dateUtils = DateUtils()
            
            currentTime = dateUtils.addMinutesToDate(date: currentTime, minutes: 1.0)
        }
    }
    
    // 3rd called
    func isTimeOccupiedByIntervals(timeToCheck: Date, occupyingIntervals: [StartToEndInterval]) -> Bool {
        for occupyingInterval in occupyingIntervals {
            if timeToCheck >= occupyingInterval.startOfInterval || timeToCheck <= occupyingInterval.endOfInterval {
                return true
            }
        }
        return false
    }
    
    // Might need to reconsider the whole Dictionary stuff (HOLDING OFF)
    func retrieveTaskIntervalStatusForTimeSpan(startDate: Date, endDate: Date, taskItems: [String: ToDo]) {
        
    }
}

struct StartToEndInterval {
    var startOfInterval: Date
    var endOfInterval: Date
    var taskId: String
    var occupied: Bool
}
