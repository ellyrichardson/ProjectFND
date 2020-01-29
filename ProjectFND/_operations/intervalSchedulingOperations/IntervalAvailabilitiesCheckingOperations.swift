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
    private var allOfTheToDos: [ToDo]
    
    init() {
        let toDoProcessHelper = ToDoProcessHelper()
        self.allOfTheToDos = toDoProcessHelper.loadToDos()!
    }
    
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
     DESCRIPTION: Gets the longest available consecutive time slots for day so that it can be used by ToDo interval scheduling
     TEST: Failed
     */
    func getLongestAvailableConsecutiveTimeSlotsForDay(dayToCheck: Date) -> [String: TimeSlot] {
        let toDoProcessHelper = ToDoProcessHelper()
        // Gets all the ToDos
        //let allOfTheToDos = toDoProcessHelper.loadToDos()
        // Gets all the ToDos from the collection of the ToDos that belongs to the dayToCheck
        let toDosForTheDay: [ToDo] = toDoProcessHelper.retrieveToDoItemsByDay(toDoDate: dayToCheck, toDoItems: getAllOfTheToDos())
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
            else if occupiedTimeSlotsDictionary[secondFifteenSlotCode] != nil {
                let tempTimeSlot = TimeSlot(timeSlotCode: secondFifteenSlotCode, timeSlotCodeDay: dayToCheck)
                availableTimeSlotsDictionary[tempTimeSlot!.getSlotCode()] = tempTimeSlot
            }
            else if occupiedTimeSlotsDictionary[thirdFifteenSlotCode] != nil {
                let tempTimeSlot = TimeSlot(timeSlotCode: thirdFifteenSlotCode, timeSlotCodeDay: dayToCheck)
                availableTimeSlotsDictionary[tempTimeSlot!.getSlotCode()] = tempTimeSlot
            }
            else if occupiedTimeSlotsDictionary[fourthFifteenSlotCode] != nil {
                let tempTimeSlot = TimeSlot(timeSlotCode: fourthFifteenSlotCode, timeSlotCodeDay: dayToCheck)
                availableTimeSlotsDictionary[tempTimeSlot!.getSlotCode()] = tempTimeSlot
            }
            // Iterates to the next codeHour possible by incrementing the timeSlotCodeHourIterator by 1
            timeSlotCodeHourIterator = timeSlotCodeHourIterator + 1
        }
        
        // Gets a collection of consecutive timeSlots for the day
        let collectionOfConsecutiveTimeSlots: [[String: TimeSlot]] = getConsecutiveTimeSlotsFromATimeSlotDictionary(timeSlotDictionary: availableTimeSlotsDictionary)
        var longestConsecutiveTimeSlotsForTheDay: [String: TimeSlot] = [String: TimeSlot]()
        // Gets the longest consecutive timeSlots for the day from the collection of consecutive time slots
        if let collectionOfConsecutiveTimeSlotsForTheDay: [String: TimeSlot] = collectionOfConsecutiveTimeSlots.max(by: {$1.count > $0.count}) {
            // Assigns the longest consecutive timeSlots for the day
            longestConsecutiveTimeSlotsForTheDay = collectionOfConsecutiveTimeSlotsForTheDay
        }
        
        return longestConsecutiveTimeSlotsForTheDay
    }
    
    // MARK: Assisting Private Functions
    
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
    
    /*
     TEST: Untested
     */
    func getConsecutiveTimeSlotsFromATimeSlotDictionary(timeSlotDictionary: [String: TimeSlot]) -> [[String: TimeSlot]] {
        var collectionOfConsecutiveTimeSlots: [[String: TimeSlot]] = [[String: TimeSlot]]()
        var singleConsecutiveTimeSlots: [String: TimeSlot] = [String: TimeSlot]()
        var timeSlotCodeHourIterator: Int = 0
        // While the timeSlotCodeHourIterator is less than the whole day hours
        while timeSlotCodeHourIterator < 24 {
            // Possible timeSlot codes
            let firstFifteenSlotCode = String(timeSlotCodeHourIterator) + "-" + "A"
            let secondFifteenSlotCode = String(timeSlotCodeHourIterator) + "-" + "B"
            let thirdFifteenSlotCode = String(timeSlotCodeHourIterator) + "-" + "C"
            let fourthFifteenSlotCode = String(timeSlotCodeHourIterator) + "-" + "D"
            
            // If timeSlot is occupied, based on the dictionary
            if timeSlotDictionary[firstFifteenSlotCode] != nil {
                // Temporary storage of the accessed timeSlot and the next timeSlot to it
                var currentAndNextTimeSlot: [TimeSlot] = [TimeSlot]()
                let accessedTimeSlot: TimeSlot = timeSlotDictionary[firstFifteenSlotCode]!
                currentAndNextTimeSlot.append(accessedTimeSlot)
                
                // Assigns and add timeSlots to their appropriate data structures: e.g. dictionaries
                assignAndAddTimeSlotsToTheirAppropriateDataStructures(currentAndNextTimeSlot: &currentAndNextTimeSlot, timeSlotDictionary: timeSlotDictionary, timeSlotCodeHourIterator: timeSlotCodeHourIterator, currentTimeSlot: accessedTimeSlot, collectionOfConsecutiveTimeSlots: &collectionOfConsecutiveTimeSlots, singleConsecutiveTimeSlots: &singleConsecutiveTimeSlots)
            }
            if timeSlotDictionary[secondFifteenSlotCode] != nil {
                var currentAndNextTimeSlot: [TimeSlot] = [TimeSlot]()
                let accessedTimeSlot: TimeSlot = timeSlotDictionary[firstFifteenSlotCode]!
                currentAndNextTimeSlot.append(accessedTimeSlot)
                
                assignAndAddTimeSlotsToTheirAppropriateDataStructures(currentAndNextTimeSlot: &currentAndNextTimeSlot, timeSlotDictionary: timeSlotDictionary, timeSlotCodeHourIterator: timeSlotCodeHourIterator, currentTimeSlot: accessedTimeSlot, collectionOfConsecutiveTimeSlots: &collectionOfConsecutiveTimeSlots, singleConsecutiveTimeSlots: &singleConsecutiveTimeSlots)
            }
            if timeSlotDictionary[thirdFifteenSlotCode] != nil {
                var currentAndNextTimeSlot: [TimeSlot] = [TimeSlot]()
                let accessedTimeSlot: TimeSlot = timeSlotDictionary[firstFifteenSlotCode]!
                currentAndNextTimeSlot.append(accessedTimeSlot)
                
                assignAndAddTimeSlotsToTheirAppropriateDataStructures(currentAndNextTimeSlot: &currentAndNextTimeSlot, timeSlotDictionary: timeSlotDictionary, timeSlotCodeHourIterator: timeSlotCodeHourIterator, currentTimeSlot: accessedTimeSlot, collectionOfConsecutiveTimeSlots: &collectionOfConsecutiveTimeSlots, singleConsecutiveTimeSlots: &singleConsecutiveTimeSlots)
            }
            if timeSlotDictionary[fourthFifteenSlotCode] != nil {
                var currentAndNextTimeSlot: [TimeSlot] = [TimeSlot]()
                let accessedTimeSlot: TimeSlot = timeSlotDictionary[firstFifteenSlotCode]!
                currentAndNextTimeSlot.append(accessedTimeSlot)
    
                assignAndAddTimeSlotsToTheirAppropriateDataStructures(currentAndNextTimeSlot: &currentAndNextTimeSlot, timeSlotDictionary: timeSlotDictionary, timeSlotCodeHourIterator: timeSlotCodeHourIterator, currentTimeSlot: accessedTimeSlot, collectionOfConsecutiveTimeSlots: &collectionOfConsecutiveTimeSlots, singleConsecutiveTimeSlots: &singleConsecutiveTimeSlots)
            }
            timeSlotCodeHourIterator = timeSlotCodeHourIterator + 1
        }
        return collectionOfConsecutiveTimeSlots
    }
    
    /*
     DESCRIPTION: This function accepts by reference a currentAndNextTimeSlot array. The next timeSlot will be assigned based on the currentTimeSlot accessed. The potential next timeSlotCodes that will be compared to the currentTimeSlot is needed. The dictionary the timeSlots were being retrieved will also be needed. The current iteration of the slotCode combinations is needed to determine the next timeSlot, too.
     TEST: Untested
     */
    func assignTheNextTimeSlotToCurrentAndNextTimeSlotArray(currentAndNextTimeSlot: inout [TimeSlot], timeSlotDictionary: [String: TimeSlot], timeSlotCodeHourIterator: Int, currentTimeSlot: TimeSlot, timeSlotCodeForPotentialNextTimeSlot: String) {
        
        // If there is a next timeSlot, then assign it as the next timeSlot so that it can be compared against accessedTimeSlot
        if timeSlotDictionary[timeSlotCodeForPotentialNextTimeSlot] != nil {
            let nextToAccessedTimeSlot: TimeSlot = timeSlotDictionary[timeSlotCodeForPotentialNextTimeSlot]!
            currentAndNextTimeSlot.append(nextToAccessedTimeSlot)
        } else {
            // Just put the same timeSlot as next so that it fails and will be marked as end of interval when checked.
            currentAndNextTimeSlot.append(currentTimeSlot)
        }
    }
    
    /*
     TEST: Untested
     */
    func checkIfTimeSlotEndTimeOverlapsWithNextTimeSlotStartTime(firstTimeSlot: TimeSlot, secondTimeSlot: TimeSlot) -> Bool {
        // Checks if the endTime of the firstTimeSlot overlaps with the startTime of secondTimeSlot
        if firstTimeSlot.getEndTime() == secondTimeSlot.getStartTime() {
            return true
        }
        return false
    }
    
    /*
     DESCRIPTION: Adds time slot dictionary to the collection of timeSlotDictionary appropriately
     TEST: Untested
     */
    func addTimeSlotDictionaryToCollectionOfTimeSlotDictionaryAppropriately(currentAndNextTimeSlot: inout [TimeSlot], collectionOfTimeSlotDictionary: inout [[String: TimeSlot]], singleConsecutiveTimeSlots: inout [String: TimeSlot]) {
        if !checkIfTimeSlotEndTimeOverlapsWithNextTimeSlotStartTime(firstTimeSlot: currentAndNextTimeSlot[0], secondTimeSlot: currentAndNextTimeSlot[1]) {
            // Adds the accessed time Slot [0] to the singleConsecutiveTimeSlot
            singleConsecutiveTimeSlots[currentAndNextTimeSlot[0].getSlotCode()] = currentAndNextTimeSlot[0]
        }
        else {
            // Adds the current singleConsecutiveTimeSlots to the timeSlotDictionaryCollection
            collectionOfTimeSlotDictionary.append(singleConsecutiveTimeSlots)
            // Removes all elements in the singleConsecutiveTimeSlots to start a new singleConsecutiveTimeSlots
            singleConsecutiveTimeSlots.removeAll()
        }
    }
    
    // TEST: Untested
    func assignAndAddTimeSlotsToTheirAppropriateDataStructures(currentAndNextTimeSlot: inout [TimeSlot], timeSlotDictionary: [String: TimeSlot], timeSlotCodeHourIterator: Int, currentTimeSlot: TimeSlot, collectionOfConsecutiveTimeSlots: inout [[String: TimeSlot]], singleConsecutiveTimeSlots: inout [String: TimeSlot]) {
        
        var potentialNextTimeSlotTimeSlotCode = ""
        
        // Conditional statements to determine the key for the next time slot
        if currentTimeSlot.getSlotCode() == String(timeSlotCodeHourIterator) + "-" + "A" {
            potentialNextTimeSlotTimeSlotCode = String(timeSlotCodeHourIterator) + "-" + "B"
        }
        else if currentTimeSlot.getSlotCode() == String(timeSlotCodeHourIterator) + "-" + "B" {
            potentialNextTimeSlotTimeSlotCode = String(timeSlotCodeHourIterator) + "-" + "C"
        }
        else if currentTimeSlot.getSlotCode() == String(timeSlotCodeHourIterator) + "-" + "C" {
            potentialNextTimeSlotTimeSlotCode = String(timeSlotCodeHourIterator) + "-" + "D"
        }
        else if currentTimeSlot.getSlotCode() == String(timeSlotCodeHourIterator) + "-" + "D" {
            potentialNextTimeSlotTimeSlotCode = String(timeSlotCodeHourIterator + 1) + "-" + "A"
        }
        
        // Assigns the next timeSlot to currentAndNextTimeSlot array.
        assignTheNextTimeSlotToCurrentAndNextTimeSlotArray(currentAndNextTimeSlot: &currentAndNextTimeSlot, timeSlotDictionary: timeSlotDictionary, timeSlotCodeHourIterator: timeSlotCodeHourIterator, currentTimeSlot: currentTimeSlot, timeSlotCodeForPotentialNextTimeSlot: potentialNextTimeSlotTimeSlotCode)
        
        // Adds timeSlotDictionary to the collection of timeSlot dictionary appropriately.
        addTimeSlotDictionaryToCollectionOfTimeSlotDictionaryAppropriately(currentAndNextTimeSlot: &currentAndNextTimeSlot, collectionOfTimeSlotDictionary: &collectionOfConsecutiveTimeSlots, singleConsecutiveTimeSlots: &singleConsecutiveTimeSlots)
    }
    
    /*
     Description: Puts all the timeSlots in the collection of timeSlot collections to a single collection.
     Usage: Put a collection of timeSlot collections in the parameter. Put the date of the day that the single dictionary for timeSlots will belong to
     Returns: A single dictionary of all occupied timeSlots from a collection of occupied timeSlot collections
     TEST: Untested by itself, but tested through getOccupiedTimeSlots()
     */
    func putContentsOfOccupiedTimeSlotsDictionariesInOneSingleDictionary(collectionOfTimeSlotDictionary: [[String:TimeSlot]], dayDateForTimeSlotsDictionary: Date) -> [String:TimeSlot] {
        var singleDictionaryOfTimeSlots: [String:TimeSlot] = [String:TimeSlot]()
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
                    // Adding the timeSlot to the available timeSlots dictionary
                    let tempTimeSlot = TimeSlot(timeSlotCode: firstFifteenSlotCode, timeSlotCodeDay: dayDateForTimeSlotsDictionary)
                    singleDictionaryOfTimeSlots[tempTimeSlot!.getSlotCode()] = tempTimeSlot
                }
                // If timeSlot hour code is the second 15 mins. This is because if timeSlotDictionary key-value is nil, it means the timeSlot is not occupied
                if timeSlotDictionary[secondFifteenSlotCode] != nil {
                    // Adding the timeSlot to the available timeSlots dictionary
                    let tempTimeSlot = TimeSlot(timeSlotCode: secondFifteenSlotCode, timeSlotCodeDay: dayDateForTimeSlotsDictionary)
                    singleDictionaryOfTimeSlots[tempTimeSlot!.getSlotCode()] = tempTimeSlot
                }
                // If timeSlot hour code is the third 15 mins. This is because if timeSlotDictionary key-value is nil, it means the timeSlot is not occupied
                if timeSlotDictionary[thirdFifteenSlotCode] != nil {
                    // Adding the timeSlot to the available timeSlots dictionary
                    let tempTimeSlot = TimeSlot(timeSlotCode: thirdFifteenSlotCode, timeSlotCodeDay: dayDateForTimeSlotsDictionary)
                    singleDictionaryOfTimeSlots[tempTimeSlot!.getSlotCode()] = tempTimeSlot
                }
                // If timeSlot hour code is the fourth 15 mins. This is because if timeSlotDictionary key-value is nil, it means the timeSlot is not occupied
                if timeSlotDictionary[fourthFifteenSlotCode] != nil {
                    // Adding the timeSlot to the available timeSlots dictionary
                    let tempTimeSlot = TimeSlot(timeSlotCode: fourthFifteenSlotCode, timeSlotCodeDay: dayDateForTimeSlotsDictionary)
                    singleDictionaryOfTimeSlots[tempTimeSlot!.getSlotCode()] = tempTimeSlot
                }
                // Increments the timeSlotCode hour iterator
                timeSlotCodeHourIterator = timeSlotCodeHourIterator + 1
            }
        }
        return singleDictionaryOfTimeSlots
    }
    
    // MARK: Setters
    
    // Really just for testing purposes
    func setAllOfTheToDos(toDoItems: [ToDo]) {
        self.allOfTheToDos = toDoItems
    }
    
    // MARK: Getters
    func getAllOfTheToDos() -> [ToDo] {
        return self.allOfTheToDos
    }
}
