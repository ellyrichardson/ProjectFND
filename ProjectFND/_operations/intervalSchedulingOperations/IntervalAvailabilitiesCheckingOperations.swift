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
    
    // MARK: Essential Functions
    
    // TEST: Passed
    func getTimeSlotsOfAToDo(toDo: ToDo) -> [String:TimeSlot] {
        var timeSlots: [String:TimeSlot] = [String:TimeSlot]()
        // Gets the starting time of the first fifteen minute interval of the ToDo
        var startingTimeOfToDoFifteenMinuteInterval: Date = toDo.workDate
        // Gets the endingTime of the ToDo workTime for the day
        let endingTimeOfToDoWorkTimeForTheDay: Date = getEndOfToDoWorkTimeForTheDay(toDo: toDo, toDoWorkTimeLength: Double(toDo.estTime)!)
        
        // While the timeToBeChecked is not the ending work time of the Todo, keep adding the fifteen minute interval to the timeSlots
        while !checkTimeIfLastFifteenMinutes(timeToBeChecked: startingTimeOfToDoFifteenMinuteInterval, endingWorkTimeForTheDay: endingTimeOfToDoWorkTimeForTheDay) {
            // Gets the time with added fifteen minutes
            let timeWithAddedFifteenMinutes: Date = dateArithmeticOps.addMinutesToDate(date: startingTimeOfToDoFifteenMinuteInterval, minutes: 15.0)
            // Appends the new time slot with the startingTime and the added 15 minutes to the timeSlots collection
            let tempTimeSlot = TimeSlot(startOfTimeSlot: startingTimeOfToDoFifteenMinuteInterval, endOfTimeSlot: timeWithAddedFifteenMinutes)!
            timeSlots[tempTimeSlot.getSlotCode()] = tempTimeSlot
            // Increases the startingTime by 15 minutes
            startingTimeOfToDoFifteenMinuteInterval = timeWithAddedFifteenMinutes
        }
        
        // Last timeSlot gets added with fifteen minutes to get its ending time.
        let lastTimeSlotWithAddedFifteenMinutes: Date = dateArithmeticOps.addMinutesToDate(date: startingTimeOfToDoFifteenMinuteInterval, minutes: 15.0)
        // Appends the last time slot with its startingTime and the added 15 minutes to the timeSlots collection
        let lastTimeSlot = TimeSlot(startOfTimeSlot: startingTimeOfToDoFifteenMinuteInterval, endOfTimeSlot: lastTimeSlotWithAddedFifteenMinutes)!
        timeSlots[lastTimeSlot.getSlotCode()] = lastTimeSlot
        
        return timeSlots
    }
    
    /*
     TODO: Only get timeSlots for the day, and not put the exceeding timeSlots at the end of the day to the start of the day
     Description: Gets all the occupied time slots for the day
     Usage: Put a collection of ToDos for a single Day as a parameter, also add the date of the day for the collection
     Logic: The collection of ToDos will be checked for their TimeSlots, and those TimeSlots will be placed in a single collection to be returned.
     TEST: Passed
     */
    func getOccupiedTimeSlots(collectionOfToDosForTheDay: [ToDo], dayDateOfTheCollection: Date) -> [String:TimeSlot] {
        // Collection of dictionaries
        var collectionOfTimeSlotCollections: [[String:TimeSlot]] = [[String:TimeSlot]]()
        // Iterates every ToDo in the ToDo Dictionary Collection
        for toDoInCollection in collectionOfToDosForTheDay {
            // Adds the timeSlot collection for a ToDo to a general collection of timeSlot dictionary
            collectionOfTimeSlotCollections.append(getTimeSlotsOfAToDo(toDo: toDoInCollection))
        }
        // Returns a timeSlot dictionary containing all the timeSlots in the collection of timeSlot dictionary
        return putContentsOfOccupiedTimeSlotsDictionariesInOneSingleDictionary(collectionOfTimeSlotDictionary: collectionOfTimeSlotCollections, dayDateForTimeSlotsDictionary: dayDateOfTheCollection)
    }
    
    /*
     DESCRIPTION: Gets the available time slots for day so that it can be used by ToDo interval scheduling
     TEST: Untested
     */
    func getAvailableTimeSlotsForDay(dayToCheck: Date, toDoItemsForDay: [ToDo]) -> [String: TimeSlot] {
        let toDoProcessHelper = ToDoProcessHelper()
        // Gets all the ToDos from the collection of the ToDos that belongs to the dayToCheck
        let toDosForTheDay: [ToDo] = toDoProcessHelper.retrieveToDoItemsByDay(toDoDate: dayToCheck, toDoItems: toDoItemsForDay)
        //let toDosForTheDay: [ToDo] = toDoItemsForDay
        // Gets all the occupied timeSlots as a dictionary for the dayToCheck
        var occupiedTimeSlotsDictionary: [String:TimeSlot] = getOccupiedTimeSlots(collectionOfToDosForTheDay: toDosForTheDay, dayDateOfTheCollection: dayToCheck)
        // To store available timeSlots for the day as a dictionary
        var availableTimeSlotsDictionary: [String:TimeSlot] = [String:TimeSlot]()
        var timeSlotCodeHourIterator: Int = 0
        // Iterates through every possible hourCode component of a timeSlotCode
        while timeSlotCodeHourIterator < 24 {
            let firstFifteenSlotCode = String(timeSlotCodeHourIterator) + "-" + "A"
            let secondFifteenSlotCode = String(timeSlotCodeHourIterator) + "-" + "B"
            let thirdFifteenSlotCode = String(timeSlotCodeHourIterator) + "-" + "C"
            let fourthFifteenSlotCode = String(timeSlotCodeHourIterator) + "-" + "D"
            // If the key-value does not exist in this occupiedTimeSlot dictionary, it means the timeSlot is available. The available timeSlot (key-value) gets added to the availableTimeSlotDictionary.
            if occupiedTimeSlotsDictionary[firstFifteenSlotCode] == nil {
                let tempTimeSlot = TimeSlot(timeSlotCode: firstFifteenSlotCode, timeSlotCodeDay: dayToCheck)
                availableTimeSlotsDictionary[tempTimeSlot!.getSlotCode()] = tempTimeSlot
            }
            if occupiedTimeSlotsDictionary[secondFifteenSlotCode] == nil {
                let tempTimeSlot = TimeSlot(timeSlotCode: secondFifteenSlotCode, timeSlotCodeDay: dayToCheck)
                availableTimeSlotsDictionary[tempTimeSlot!.getSlotCode()] = tempTimeSlot
            }
            if occupiedTimeSlotsDictionary[thirdFifteenSlotCode] == nil {
                let tempTimeSlot = TimeSlot(timeSlotCode: thirdFifteenSlotCode, timeSlotCodeDay: dayToCheck)
                availableTimeSlotsDictionary[tempTimeSlot!.getSlotCode()] = tempTimeSlot
            }
            if occupiedTimeSlotsDictionary[fourthFifteenSlotCode] == nil {
                let tempTimeSlot = TimeSlot(timeSlotCode: fourthFifteenSlotCode, timeSlotCodeDay: dayToCheck)
                availableTimeSlotsDictionary[tempTimeSlot!.getSlotCode()] = tempTimeSlot
            }
            // Iterates to the next codeHour possible by incrementing the timeSlotCodeHourIterator by 1
            timeSlotCodeHourIterator = timeSlotCodeHourIterator + 1
        }
    
         return availableTimeSlotsDictionary
    }
    
    /*
     DESCRIPTION: timeSlotDictionary parameter is assumed to have been occupiedTimeSlots, ideally
     TEST: Passed
     */
    func getLongestAvailableConsecutiveTimeSlot(timeSlotDictionary: [String: TimeSlot], dayToCheck: Date) -> [String: TimeSlot] {
        var tempSingleTimeSlotDictionary: [String: TimeSlot] = [String: TimeSlot]()
        var tempCollectionOfSingleTimeSlotDict: [[String: TimeSlot]] = [[String: TimeSlot]]()
        var timeSlotCodeHourIterator: Int = 0
        // Iterates through every possible hourCode component of a timeSlotCode
        while timeSlotCodeHourIterator < 24 {
            let firstFifteenSlotCode = String(timeSlotCodeHourIterator) + "-" + "A"
            let secondFifteenSlotCode = String(timeSlotCodeHourIterator) + "-" + "B"
            let thirdFifteenSlotCode = String(timeSlotCodeHourIterator) + "-" + "C"
            let fourthFifteenSlotCode = String(timeSlotCodeHourIterator) + "-" + "D"
            // If the key-value does not exist in this occupiedTimeSlot dictionary, it means the timeSlot is available. The available timeSlot (key-value) gets added to the availableTimeSlotDictionary.
            if timeSlotDictionary[firstFifteenSlotCode] == nil {
                let tempTimeSlot = TimeSlot(timeSlotCode: firstFifteenSlotCode, timeSlotCodeDay: dayToCheck)
                tempSingleTimeSlotDictionary[tempTimeSlot!.getSlotCode()] = tempTimeSlot
            } else {
                tempCollectionOfSingleTimeSlotDict.append(tempSingleTimeSlotDictionary)
                tempSingleTimeSlotDictionary.removeAll()
            }
            if timeSlotDictionary[secondFifteenSlotCode] == nil {
                let tempTimeSlot = TimeSlot(timeSlotCode: secondFifteenSlotCode, timeSlotCodeDay: dayToCheck)
                tempSingleTimeSlotDictionary[tempTimeSlot!.getSlotCode()] = tempTimeSlot
            } else {
                tempCollectionOfSingleTimeSlotDict.append(tempSingleTimeSlotDictionary)
                tempSingleTimeSlotDictionary.removeAll()
            }
            if timeSlotDictionary[thirdFifteenSlotCode] == nil {
                let tempTimeSlot = TimeSlot(timeSlotCode: thirdFifteenSlotCode, timeSlotCodeDay: dayToCheck)
                tempSingleTimeSlotDictionary[tempTimeSlot!.getSlotCode()] = tempTimeSlot
            } else {
                tempCollectionOfSingleTimeSlotDict.append(tempSingleTimeSlotDictionary)
                tempSingleTimeSlotDictionary.removeAll()
            }
            if timeSlotDictionary[fourthFifteenSlotCode] == nil {
                let tempTimeSlot = TimeSlot(timeSlotCode: fourthFifteenSlotCode, timeSlotCodeDay: dayToCheck)
                tempSingleTimeSlotDictionary[tempTimeSlot!.getSlotCode()] = tempTimeSlot
            } else {
                tempCollectionOfSingleTimeSlotDict.append(tempSingleTimeSlotDictionary)
                tempSingleTimeSlotDictionary.removeAll()
            }
            // Iterates to the next codeHour possible by incrementing the timeSlotCodeHourIterator by 1
            timeSlotCodeHourIterator = timeSlotCodeHourIterator + 1
        }
        // Gets the longest consecutive timeSlot
        var longestConsecutiveTimeSlot: [String: TimeSlot] = [String: TimeSlot]()
        if timeSlotDictionary.count > 0 {
            longestConsecutiveTimeSlot = tempCollectionOfSingleTimeSlotDict[0]
        }
        // Use the singleTimeSlotDictionary if timeSlotDictionary is empty
        else {
            longestConsecutiveTimeSlot = tempSingleTimeSlotDictionary
        }
        for timeSlotDict in tempCollectionOfSingleTimeSlotDict {
            if timeSlotDict.count > longestConsecutiveTimeSlot.count {
                longestConsecutiveTimeSlot = timeSlotDict
            }
        }
        return longestConsecutiveTimeSlot
    }
    
    /*
     Description: Checks if the timeToBeChecked is the last 15 minutes of the work time for the day
     Usage: The time to be checked must be inputted. The ending of the work time for a ToDo for the day must be inputted
     Logic: If 15 minutes is added to the timeToBeChecked and is equal to the endingTimeForTheWorkDay, then it is the last 15 mins.
     TEST: Passed
     */
    func checkTimeIfLastFifteenMinutes(timeToBeChecked: Date, endingWorkTimeForTheDay: Date) -> Bool {
        // Check if the timeToBeChecked + 15 minutes is the endingTime for the ToDo work time of the day
        if dateArithmeticOps.addMinutesToDate(date: timeToBeChecked, minutes: 15.0) == endingWorkTimeForTheDay {
            return true
        }
        return false
    }
    
    /*
     DESCRIPTION: Gets the end of work time of ToDo for the day.
     TEST: Passed
     */
    func getEndOfToDoWorkTimeForTheDay(toDo: ToDo, toDoWorkTimeLength: Double) -> Date {
        return dateArithmeticOps.addHoursToDate(date: toDo.workDate, hours: toDoWorkTimeLength)
    }
    
    func getStartTimeAndEndTimeOfConsecutiveTimeSlots(consecutiveTimeSlot: [String: TimeSlot]) {
        
    }
    
    /*
     Description: Puts all the timeSlots in the collection of timeSlot collections to a single collection.
     Usage: Put a collection of timeSlot collections in the parameter. Put the date of the day that the single dictionary for timeSlots will belong to
     Returns: A single dictionary of all occupied timeSlots from a collection of occupied timeSlot collections
     TEST: Untested by itself, but tested through getOccupiedTimeSlots()
     */
    private func putContentsOfOccupiedTimeSlotsDictionariesInOneSingleDictionary(collectionOfTimeSlotDictionary: [[String:TimeSlot]], dayDateForTimeSlotsDictionary: Date) -> [String:TimeSlot] {
        var singleDictionaryOfTimeSlots: [String:TimeSlot] = [String:TimeSlot]()
        let lastTimeSlotForTheDay = TimeSlot(timeSlotCode: "23-D", timeSlotCodeDay: dayDateForTimeSlotsDictionary)
        // Iterates through every single dictionaries within the collection of timeSlot dictionary
        for timeSlotDictionary in collectionOfTimeSlotDictionary {
            var timeSlotCodeHourIterator: Int = 0
            // Iterates through every possible timeSlot hour codes
            while timeSlotCodeHourIterator < 24 {
                let firstFifteenSlotCode = String(timeSlotCodeHourIterator) + "-" + "A"
                let secondFifteenSlotCode = String(timeSlotCodeHourIterator) + "-" + "B"
                let thirdFifteenSlotCode = String(timeSlotCodeHourIterator) + "-" + "C"
                let fourthFifteenSlotCode = String(timeSlotCodeHourIterator) + "-" + "D"
                // If timeSlot hour code is the first 15 mins. This is because if timeSlotDictionary key-value is nil, it means the timeSlot is not occupied
                if timeSlotDictionary[firstFifteenSlotCode] != nil  {
                    let accessedTimeSlotEndTime = timeSlotDictionary[firstFifteenSlotCode]?.getEndTime()
                    let lastTimeSlotEndTime = dateArithmeticOps.addMinutesToDate(date: (lastTimeSlotForTheDay?.getEndTime())!, minutes: 0.0)
                    if accessedTimeSlotEndTime! < lastTimeSlotEndTime {
                        // Adding the timeSlot to the available timeSlots dictionary
                        let tempTimeSlot = TimeSlot(timeSlotCode: firstFifteenSlotCode, timeSlotCodeDay: dayDateForTimeSlotsDictionary)
                        singleDictionaryOfTimeSlots[tempTimeSlot!.getSlotCode()] = tempTimeSlot
                    }
                }
                // If timeSlot hour code is the second 15 mins. This is because if timeSlotDictionary key-value is nil, it means the timeSlot is not occupied
                if timeSlotDictionary[secondFifteenSlotCode] != nil {
                    let accessedTimeSlotEndTime = timeSlotDictionary[secondFifteenSlotCode]?.getEndTime()
                    let lastTimeSlotEndTime = dateArithmeticOps.addMinutesToDate(date: (lastTimeSlotForTheDay?.getEndTime())!, minutes: 0.0)
                    if accessedTimeSlotEndTime! < lastTimeSlotEndTime {
                        // Adding the timeSlot to the available timeSlots dictionary
                        let tempTimeSlot = TimeSlot(timeSlotCode: secondFifteenSlotCode, timeSlotCodeDay: dayDateForTimeSlotsDictionary)
                        singleDictionaryOfTimeSlots[tempTimeSlot!.getSlotCode()] = tempTimeSlot
                    }
                }
                // If timeSlot hour code is the third 15 mins. This is because if timeSlotDictionary key-value is nil, it means the timeSlot is not occupied
                if timeSlotDictionary[thirdFifteenSlotCode] != nil {
                    let accessedTimeSlotEndTime = timeSlotDictionary[thirdFifteenSlotCode]?.getEndTime()
                    let lastTimeSlotEndTime = dateArithmeticOps.addMinutesToDate(date: (lastTimeSlotForTheDay?.getEndTime())!, minutes: 0.0)
                    if accessedTimeSlotEndTime! < lastTimeSlotEndTime {
                        // Adding the timeSlot to the available timeSlots dictionary
                        let tempTimeSlot = TimeSlot(timeSlotCode: thirdFifteenSlotCode, timeSlotCodeDay: dayDateForTimeSlotsDictionary)
                        singleDictionaryOfTimeSlots[tempTimeSlot!.getSlotCode()] = tempTimeSlot
                    }
                }
                // If timeSlot hour code is the fourth 15 mins. This is because if timeSlotDictionary key-value is nil, it means the timeSlot is not occupied
                if timeSlotDictionary[fourthFifteenSlotCode] != nil {
                    let accessedTimeSlotEndTime = timeSlotDictionary[fourthFifteenSlotCode]?.getEndTime()
                    let lastTimeSlotEndTime = dateArithmeticOps.addMinutesToDate(date: (lastTimeSlotForTheDay?.getEndTime())!, minutes: 0.0)
                    if accessedTimeSlotEndTime! < lastTimeSlotEndTime {
                        // Adding the timeSlot to the available timeSlots dictionary
                        let tempTimeSlot = TimeSlot(timeSlotCode: fourthFifteenSlotCode, timeSlotCodeDay: dayDateForTimeSlotsDictionary)
                        singleDictionaryOfTimeSlots[tempTimeSlot!.getSlotCode()] = tempTimeSlot
                    }
                }
                // Increments the timeSlotCode hour iterator
                timeSlotCodeHourIterator = timeSlotCodeHourIterator + 1
            }
        }
        return singleDictionaryOfTimeSlots
    }
}
