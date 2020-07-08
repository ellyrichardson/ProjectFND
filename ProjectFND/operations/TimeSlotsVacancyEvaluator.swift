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

/*
 NOTE:
 TimeSpans are used to determine the time span of the day the needs to be evaluated.
    (Many times these are 24 hrs of the day so that it is limited to only that day,
    and is not overlapping to next day, like 25 hrs)
 */

class TimeSlotsVacancyEvaluator {
    private var sortedTasksByDay = [(key: String, value:ToDo)]()
    private var occupiedTimesDict = [String: [ToDo]]() // Otd
    private var oterList = [Oter]()
    private var dayTimeSpans = [TimeSpan]()
    
    // MARK: - Event Trackers
    
    private var vacantTimeSlotStart = Date()
    
    // MARK: - Populating Otd Section
    
    func populateOtd(timeSpan: TimeSpan) {
        var currentDate = timeSpan.startDate
        let dateUtil = DateUtils()
        while currentDate <= timeSpan.endDate {
            assignTasksToOtdThatStartsUnderHourOf(date: currentDate)
            currentDate = dateUtil.addHoursToDate(date: currentDate, hours: 1.0)
        }
    }
    
    // MARK: - Populating Otd Utilities
    
    func addTaskToOtd(otdKey: String, taskSet: [ToDo]) {
        self.occupiedTimesDict[otdKey] = taskSet
    }
    
    private func assignTasksToOtdThatStartsUnderHourOf(date: Date) {
        var taskList = [ToDo]()
        var otdKey = String()
        for taskItem in self.sortedTasksByDay {
            let taskValue = taskItem.value
            if doesTaskStartUnderHourOf(date: date, taskItem: taskValue) {
                taskList.append(taskValue)
                otdKey = getCurrentHourOfDateAsString(date: taskValue.getStartDate())
            }
        }
        // If otdKey is not empty String, it means its got a value
        if otdKey != "" {
            addTaskToOtd(otdKey: otdKey, taskSet: taskList)
        }
    }
    
    private func doesTaskStartUnderHourOf(date: Date, taskItem: ToDo) -> Bool {
        return getCurrentHourOfDateAsString(date: date) == getCurrentHourOfDateAsString(date: taskItem.getStartDate())
    }
    
    // MARK: - Evaluate Otd Section
    
    func evaluateOtd(timeSpan: TimeSpan) {
        
        let dateUtil = DateUtils()
        var currentTime = timeSpan.startDate
        // Initiates the vacantTimeSlotStart
        self.vacantTimeSlotStart = timeSpan.startDate
        while currentTime <= timeSpan.endDate {
            let otdKey = getCurrentHourOfDateAsString(date: currentTime)
            if let otdVal = self.occupiedTimesDict[otdKey] {
                assignAppropriateOterObjects(forDate: currentTime, taskList: otdVal)
            }
            currentTime = dateUtil.addHoursToDate(date: currentTime, hours: 1.0)
        }
        assignVacantOter(oterSD: self.vacantTimeSlotStart, oterED: dateUtil.subtractHoursToDate(date: currentTime, hours: 1.0))
    }
    
    // MARK: - Evaluate Otd Utilities
    
    private func assignAppropriateOterObjects(forDate: Date, taskList: [ToDo]) {
        let firstTask = taskList[0]
        let oterStartDate = self.vacantTimeSlotStart
        let oterEndDate = firstTask.getStartDate()
        let lastTaskIndex = taskList.count-1
        
        assignVacantOter(oterSD: oterStartDate, oterED: oterEndDate)
        assignOcupiedOterFromTaskList(taskList: taskList)
        
        self.vacantTimeSlotStart = taskList[lastTaskIndex].getEndDate()
    }
    
    private func assignVacantOter(oterSD: Date, oterED: Date) {
        let dateUtil = DateUtils()
        if dateUtil.minutesBetweenTwoDates(earlyDate: oterSD, laterDate: oterED) > 0
        {
            let oterObject = Oter(startDate: oterSD, endDate: oterED, ownerTaskId: "", occupancyType: TSOType.VACANT)
            self.oterList.append(oterObject)
        }
    }
    
    private func assignOcupiedOterFromTaskList(taskList: [ToDo]) {
        for taskItem in taskList {
            let oterObject = Oter(startDate: taskItem.getStartDate(), endDate: taskItem.getEndDate(), ownerTaskId: taskItem.getTaskId(), occupancyType: TSOType.OCCUPIED)
            self.oterList.append(oterObject)
        }
    }
    
    // MARK: - Utilities
    
    private func getCurrentHourOfDateAsString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY/MM/DD hh a" // i.e. 12 AM
        return dateFormatter.string(from: date)
    }
    
    // MARK: - Setters
    func setTaskItems(tasks: [(key: String, value:ToDo)]) {
        self.sortedTasksByDay = tasks
    }
    
    // MARK: - Getters
    func getOterAvailabilities() -> [Oter] {
        return self.oterList
    }
    
    func getOtd() -> [String: [ToDo]] {
        return self.occupiedTimesDict
    }
    
    // MARK: - Notes
    /*
     TODO: Add a functionality where the algorithm won't have to iterate through a day without a task existing in it.
     */
}
