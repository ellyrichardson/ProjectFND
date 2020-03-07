//
//  IntervalAvailabilitiesRetrievingOperationsTest.swift
//  ProjectFNDTests
//
//  Created by Elly Richardson on 2/1/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import XCTest
import os.log
@testable import ProjectFND

class IntervalAvailabilitiesRetrievalOperationsTest: XCTestCase {
    
    // MARK: Mock datas
    
    var arrayOfToDos: [ToDo] = [ToDo]()
    let intervalAvailabilitiesCheckingHelper = IntervalAvailabilitiesCheckingOperations.init()
    let intervalAvailabilitiesRetrievalHelper = IntervalAvailabilitiesRetrievalOperations()
    let toDoProcessHelper = ToDoProcessUtils()
    let formatter = DateFormatter()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        arrayOfToDos.append(ToDo(taskName: "Task One", taskDescription: "Task One Description", workDate: formatter.date(from: "2020/01/15 13:30")!, estTime: "2.0", dueDate: formatter.date(from: "2020/01/16 13:30")!, finished: false)!)
        arrayOfToDos.append(ToDo(taskName: "Task Two", taskDescription: "Task Two Description", workDate: formatter.date(from: "2020/01/15 15:30")!, estTime: "2.0", dueDate: formatter.date(from: "2020/01/16 13:30")!, finished: false)!)
        arrayOfToDos.append(ToDo(taskName: "Task Three", taskDescription: "Task Three Description", workDate: formatter.date(from: "2020/01/16 16:30")!, estTime: "3.0", dueDate: formatter.date(from: "2020/01/17 13:30")!, finished: false)!)
        arrayOfToDos.append(ToDo(taskName: "Task Four", taskDescription: "Task Four Description", workDate: formatter.date(from: "2020/01/16 19:30")!, estTime: "2.0", dueDate: formatter.date(from: "2020/01/17 13:30")!, finished: false)!)
        arrayOfToDos.append(ToDo(taskName: "Task Five", taskDescription: "Task Five Description", workDate: formatter.date(from: "2020/01/16 21:30")!, estTime: "2.5", dueDate: formatter.date(from: "2020/01/17 13:30")!, finished: false)!)
        // For getting longest consecutives
        arrayOfToDos.append(ToDo(taskName: "Task Six", taskDescription: "Task Six Description", workDate: formatter.date(from: "2020/01/15 21:30")!, estTime: "2.0", dueDate: formatter.date(from: "2020/01/16 13:30")!, finished: false)!)
        arrayOfToDos.append(ToDo(taskName: "Task Seven", taskDescription: "Task Seven Description", workDate: formatter.date(from: "2020/01/15 23:30")!, estTime: "2.0", dueDate: formatter.date(from: "2020/01/16 13:30")!, finished: false)!)
        arrayOfToDos.append(ToDo(taskName: "Task Seven", taskDescription: "Task Seven Description", workDate: formatter.date(from: "2020/01/15 00:00")!, estTime: "7.0", dueDate: formatter.date(from: "2020/01/16 13:30")!, finished: false)!)
    }
    
    func testGetStartTimeOfConsecutiveTimeSlots() {
        formatter.dateFormat = "yyyy/MM/dd"
        let dateOfTheDay: Date = formatter.date(from: "2020/01/15")!
        
        let toDosForADay: [ToDo] = toDoProcessHelper.retrieveToDoItemsByDay(toDoDate: dateOfTheDay, toDoItems: arrayOfToDos)
        let dictForTimeSlotsOfOneToDo: [String: TimeSlot] = intervalAvailabilitiesCheckingHelper.getTimeSlotsOfAToDo(toDo: arrayOfToDos[0])
        let oneToDoTimeSlot = intervalAvailabilitiesRetrievalHelper.getStartTimeOfConsecutiveTimeSlots(consecutiveTimeSlot: dictForTimeSlotsOfOneToDo, dayOfConcern: dateOfTheDay)
        // DateFormat for the assertions
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        // Assertion for the startTime of timeSlots of a ToDo
        XCTAssertEqual(oneToDoTimeSlot.getStartTime(), formatter.date(from: "2020/01/15 13:30")!)
        
        let dictForTimeSlotsOfAllToDoInDate = intervalAvailabilitiesCheckingHelper.getOccupiedTimeSlots(collectionOfToDosForTheDay: toDosForADay, dayDateOfTheCollection: dateOfTheDay)
        let availableTimeSlots = intervalAvailabilitiesCheckingHelper.getLongestAvailableConsecutiveTimeSlot(timeSlotDictionary: dictForTimeSlotsOfAllToDoInDate, dayToCheck: dateOfTheDay)
        let longestTimeSlots = intervalAvailabilitiesRetrievalHelper.getStartTimeOfConsecutiveTimeSlots(consecutiveTimeSlot: availableTimeSlots, dayOfConcern: dateOfTheDay)
        
        // Assertion for checking the startTime of longest available consecutive timeSlots from all of the ToDos in a date
        XCTAssertEqual(longestTimeSlots.getStartTime(), formatter.date(from: "2020/01/15 07:00")!)
    }
    
    func testGetEndTimeOfConsecutiveTimeSlots() {
        formatter.dateFormat = "yyyy/MM/dd"
        let dateOfTheDay: Date = formatter.date(from: "2020/01/15")!
        
        let toDosForADay: [ToDo] = toDoProcessHelper.retrieveToDoItemsByDay(toDoDate: dateOfTheDay, toDoItems: arrayOfToDos)
        let dictForTimeSlotsOfOneToDo: [String: TimeSlot] = intervalAvailabilitiesCheckingHelper.getTimeSlotsOfAToDo(toDo: arrayOfToDos[0])
        let oneToDoTimeSlot = intervalAvailabilitiesRetrievalHelper.getEndTimeOfConsecutiveTimeSlots(consecutiveTimeSlot: dictForTimeSlotsOfOneToDo, dayOfConcern: dateOfTheDay)
        // DateFormat for the assertions
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        // Assertion for the endTime of timeSlots of a ToDo
        XCTAssertEqual(oneToDoTimeSlot.getStartTime(), formatter.date(from: "2020/01/15 15:30")!)
        
        let dictForTimeSlotsOfAllToDoInDate = intervalAvailabilitiesCheckingHelper.getOccupiedTimeSlots(collectionOfToDosForTheDay: toDosForADay, dayDateOfTheCollection: dateOfTheDay)
        let availableTimeSlots = intervalAvailabilitiesCheckingHelper.getLongestAvailableConsecutiveTimeSlot(timeSlotDictionary: dictForTimeSlotsOfAllToDoInDate, dayToCheck: dateOfTheDay)
        let longestTimeSlots = intervalAvailabilitiesRetrievalHelper.getEndTimeOfConsecutiveTimeSlots(consecutiveTimeSlot: availableTimeSlots, dayOfConcern: dateOfTheDay)
        
        // Assertion for checking the endTime of longest available consecutive timeSlots from all of the ToDos in a date
        XCTAssertEqual(longestTimeSlots.getStartTime(), formatter.date(from: "2020/01/15 13:30")!)
    }
    /*
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
     */

}
