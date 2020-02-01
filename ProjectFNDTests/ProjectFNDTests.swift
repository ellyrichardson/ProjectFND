//
//  ProjectFNDTests.swift
//  ProjectFNDTests
//
//  Created by Elly Richardson on 9/3/19.
//  Copyright © 2019 EllyRichardson. All rights reserved.
//

import XCTest
import os.log
@testable import ProjectFND

class ProjectFNDTests: XCTestCase {
    
    // MARK: Mock datas
    
    var arrayOfToDos: [ToDo] = [ToDo]()
    let intervalAvailabilitiesHelper = IntervalAvailabilitiesCheckingOperations.init()
    let toDoProcessHelper = ToDoProcessHelper()
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
        intervalAvailabilitiesHelper.setAllOfTheToDos(toDoItems: arrayOfToDos)
        arrayOfToDos.append(ToDo(taskName: "Task Seven", taskDescription: "Task Seven Description", workDate: formatter.date(from: "2020/01/15 00:00")!, estTime: "7.0", dueDate: formatter.date(from: "2020/01/16 13:30")!, finished: false)!)
        intervalAvailabilitiesHelper.setAllOfTheToDos(toDoItems: arrayOfToDos)
    }
    
    // MARK: IntervalAvailabilitiesCheckingOperations Tests
    
    func testGettingTimeSlotsOfAToDo() {
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        /*
         Every ToDo's timeSlots and their attributes are being tested
         */
        var timeSlotDictionaryOne: [String: TimeSlot] = intervalAvailabilitiesHelper.getTimeSlotsOfAToDo(toDo: arrayOfToDos[0])
        // Test of timeSlot startTime
        XCTAssertEqual(timeSlotDictionaryOne["13-C"]?.getStartTime(), formatter.date(from: "2020/01/15 13:30")!)
        XCTAssertEqual(timeSlotDictionaryOne["13-D"]?.getStartTime(), formatter.date(from: "2020/01/15 13:45")!)
        XCTAssertEqual(timeSlotDictionaryOne["14-A"]?.getStartTime(), formatter.date(from: "2020/01/15 14:00")!)
        XCTAssertEqual(timeSlotDictionaryOne["14-B"]?.getStartTime(), formatter.date(from: "2020/01/15 14:15")!)
        XCTAssertEqual(timeSlotDictionaryOne["14-C"]?.getStartTime(), formatter.date(from: "2020/01/15 14:30")!)
        XCTAssertEqual(timeSlotDictionaryOne["14-D"]?.getStartTime(), formatter.date(from: "2020/01/15 14:45")!)
        XCTAssertEqual(timeSlotDictionaryOne["15-A"]?.getStartTime(), formatter.date(from: "2020/01/15 15:00")!)
        XCTAssertEqual(timeSlotDictionaryOne["15-B"]?.getStartTime(), formatter.date(from: "2020/01/15 15:15")!)
        // Test of timeSlot endTime
        XCTAssertEqual(timeSlotDictionaryOne["13-C"]?.getEndTime(), formatter.date(from: "2020/01/15 13:45")!)
        XCTAssertEqual(timeSlotDictionaryOne["13-D"]?.getEndTime(), formatter.date(from: "2020/01/15 14:00")!)
        XCTAssertEqual(timeSlotDictionaryOne["14-A"]?.getEndTime(), formatter.date(from: "2020/01/15 14:15")!)
        XCTAssertEqual(timeSlotDictionaryOne["14-B"]?.getEndTime(), formatter.date(from: "2020/01/15 14:30")!)
        XCTAssertEqual(timeSlotDictionaryOne["14-C"]?.getEndTime(), formatter.date(from: "2020/01/15 14:45")!)
        XCTAssertEqual(timeSlotDictionaryOne["14-D"]?.getEndTime(), formatter.date(from: "2020/01/15 15:00")!)
        XCTAssertEqual(timeSlotDictionaryOne["15-A"]?.getEndTime(), formatter.date(from: "2020/01/15 15:15")!)
        XCTAssertEqual(timeSlotDictionaryOne["15-B"]?.getEndTime(), formatter.date(from: "2020/01/15 15:30")!)
        
        var timeSlotDictionaryTwo: [String: TimeSlot] = intervalAvailabilitiesHelper.getTimeSlotsOfAToDo(toDo: arrayOfToDos[1])
        // Test of timeSlot startTime
        XCTAssertEqual(timeSlotDictionaryTwo["15-C"]?.getStartTime(), formatter.date(from: "2020/01/15 15:30")!)
        XCTAssertEqual(timeSlotDictionaryTwo["15-D"]?.getStartTime(), formatter.date(from: "2020/01/15 15:45")!)
        XCTAssertEqual(timeSlotDictionaryTwo["16-A"]?.getStartTime(), formatter.date(from: "2020/01/15 16:00")!)
        XCTAssertEqual(timeSlotDictionaryTwo["16-B"]?.getStartTime(), formatter.date(from: "2020/01/15 16:15")!)
        XCTAssertEqual(timeSlotDictionaryTwo["16-C"]?.getStartTime(), formatter.date(from: "2020/01/15 16:30")!)
        XCTAssertEqual(timeSlotDictionaryTwo["16-D"]?.getStartTime(), formatter.date(from: "2020/01/15 16:45")!)
        XCTAssertEqual(timeSlotDictionaryTwo["17-A"]?.getStartTime(), formatter.date(from: "2020/01/15 17:00")!)
        XCTAssertEqual(timeSlotDictionaryTwo["17-B"]?.getStartTime(), formatter.date(from: "2020/01/15 17:15")!)
        // Test of timeSlot endTime
        XCTAssertEqual(timeSlotDictionaryTwo["15-C"]?.getEndTime(), formatter.date(from: "2020/01/15 15:45")!)
        XCTAssertEqual(timeSlotDictionaryTwo["15-D"]?.getEndTime(), formatter.date(from: "2020/01/15 16:00")!)
        XCTAssertEqual(timeSlotDictionaryTwo["16-A"]?.getEndTime(), formatter.date(from: "2020/01/15 16:15")!)
        XCTAssertEqual(timeSlotDictionaryTwo["16-B"]?.getEndTime(), formatter.date(from: "2020/01/15 16:30")!)
        XCTAssertEqual(timeSlotDictionaryTwo["16-C"]?.getEndTime(), formatter.date(from: "2020/01/15 16:45")!)
        XCTAssertEqual(timeSlotDictionaryTwo["16-D"]?.getEndTime(), formatter.date(from: "2020/01/15 17:00")!)
        XCTAssertEqual(timeSlotDictionaryTwo["17-A"]?.getEndTime(), formatter.date(from: "2020/01/15 17:15")!)
        XCTAssertEqual(timeSlotDictionaryTwo["17-B"]?.getEndTime(), formatter.date(from: "2020/01/15 17:30")!)
        
        var timeSlotDictionaryThree: [String: TimeSlot] = intervalAvailabilitiesHelper.getTimeSlotsOfAToDo(toDo: arrayOfToDos[2])
        // Test of timeSlot startTime
        XCTAssertEqual(timeSlotDictionaryThree["16-C"]?.getStartTime(), formatter.date(from: "2020/01/16 16:30")!)
        XCTAssertEqual(timeSlotDictionaryThree["16-D"]?.getStartTime(), formatter.date(from: "2020/01/16 16:45")!)
        XCTAssertEqual(timeSlotDictionaryThree["17-A"]?.getStartTime(), formatter.date(from: "2020/01/16 17:00")!)
        XCTAssertEqual(timeSlotDictionaryThree["17-B"]?.getStartTime(), formatter.date(from: "2020/01/16 17:15")!)
        XCTAssertEqual(timeSlotDictionaryThree["17-C"]?.getStartTime(), formatter.date(from: "2020/01/16 17:30")!)
        XCTAssertEqual(timeSlotDictionaryThree["17-D"]?.getStartTime(), formatter.date(from: "2020/01/16 17:45")!)
        XCTAssertEqual(timeSlotDictionaryThree["18-A"]?.getStartTime(), formatter.date(from: "2020/01/16 18:00")!)
        XCTAssertEqual(timeSlotDictionaryThree["18-B"]?.getStartTime(), formatter.date(from: "2020/01/16 18:15")!)
        XCTAssertEqual(timeSlotDictionaryThree["18-C"]?.getStartTime(), formatter.date(from: "2020/01/16 18:30")!)
        XCTAssertEqual(timeSlotDictionaryThree["18-D"]?.getStartTime(), formatter.date(from: "2020/01/16 18:45")!)
        XCTAssertEqual(timeSlotDictionaryThree["19-A"]?.getStartTime(), formatter.date(from: "2020/01/16 19:00")!)
        XCTAssertEqual(timeSlotDictionaryThree["19-B"]?.getStartTime(), formatter.date(from: "2020/01/16 19:15")!)
        // Test of timeSlot endTime
        XCTAssertEqual(timeSlotDictionaryThree["16-C"]?.getEndTime(), formatter.date(from: "2020/01/16 16:45")!)
        XCTAssertEqual(timeSlotDictionaryThree["16-D"]?.getEndTime(), formatter.date(from: "2020/01/16 17:00")!)
        XCTAssertEqual(timeSlotDictionaryThree["17-A"]?.getEndTime(), formatter.date(from: "2020/01/16 17:15")!)
        XCTAssertEqual(timeSlotDictionaryThree["17-B"]?.getEndTime(), formatter.date(from: "2020/01/16 17:30")!)
        XCTAssertEqual(timeSlotDictionaryThree["17-C"]?.getEndTime(), formatter.date(from: "2020/01/16 17:45")!)
        XCTAssertEqual(timeSlotDictionaryThree["17-D"]?.getEndTime(), formatter.date(from: "2020/01/16 18:00")!)
        XCTAssertEqual(timeSlotDictionaryThree["18-A"]?.getEndTime(), formatter.date(from: "2020/01/16 18:15")!)
        XCTAssertEqual(timeSlotDictionaryThree["18-B"]?.getEndTime(), formatter.date(from: "2020/01/16 18:30")!)
        XCTAssertEqual(timeSlotDictionaryThree["18-C"]?.getEndTime(), formatter.date(from: "2020/01/16 18:45")!)
        XCTAssertEqual(timeSlotDictionaryThree["18-D"]?.getEndTime(), formatter.date(from: "2020/01/16 19:00")!)
        XCTAssertEqual(timeSlotDictionaryThree["19-A"]?.getEndTime(), formatter.date(from: "2020/01/16 19:15")!)
        XCTAssertEqual(timeSlotDictionaryThree["19-B"]?.getEndTime(), formatter.date(from: "2020/01/16 19:30")!)
        
        /*
         No tests for endTime attributes at this point as the ones from above has passed.
         */
        var timeSlotDictionaryFour: [String: TimeSlot] = intervalAvailabilitiesHelper.getTimeSlotsOfAToDo(toDo: arrayOfToDos[3])
        XCTAssertEqual(timeSlotDictionaryFour["19-C"]?.getStartTime(), formatter.date(from: "2020/01/16 19:30")!)
        XCTAssertEqual(timeSlotDictionaryFour["19-D"]?.getStartTime(), formatter.date(from: "2020/01/16 19:45")!)
        XCTAssertEqual(timeSlotDictionaryFour["20-A"]?.getStartTime(), formatter.date(from: "2020/01/16 20:00")!)
        XCTAssertEqual(timeSlotDictionaryFour["20-B"]?.getStartTime(), formatter.date(from: "2020/01/16 20:15")!)
        XCTAssertEqual(timeSlotDictionaryFour["20-C"]?.getStartTime(), formatter.date(from: "2020/01/16 20:30")!)
        XCTAssertEqual(timeSlotDictionaryFour["20-D"]?.getStartTime(), formatter.date(from: "2020/01/16 20:45")!)
        XCTAssertEqual(timeSlotDictionaryFour["21-A"]?.getStartTime(), formatter.date(from: "2020/01/16 21:00")!)
        XCTAssertEqual(timeSlotDictionaryFour["21-B"]?.getStartTime(), formatter.date(from: "2020/01/16 21:15")!)
        
        var timeSlotDictionaryFive: [String: TimeSlot] = intervalAvailabilitiesHelper.getTimeSlotsOfAToDo(toDo: arrayOfToDos[4])
        XCTAssertEqual(timeSlotDictionaryFive["21-C"]?.getStartTime(), formatter.date(from: "2020/01/16 21:30")!)
        XCTAssertEqual(timeSlotDictionaryFive["21-D"]?.getStartTime(), formatter.date(from: "2020/01/16 21:45")!)
        XCTAssertEqual(timeSlotDictionaryFive["22-A"]?.getStartTime(), formatter.date(from: "2020/01/16 22:00")!)
        XCTAssertEqual(timeSlotDictionaryFive["22-B"]?.getStartTime(), formatter.date(from: "2020/01/16 22:15")!)
        XCTAssertEqual(timeSlotDictionaryFive["22-C"]?.getStartTime(), formatter.date(from: "2020/01/16 22:30")!)
        XCTAssertEqual(timeSlotDictionaryFive["22-D"]?.getStartTime(), formatter.date(from: "2020/01/16 22:45")!)
        XCTAssertEqual(timeSlotDictionaryFive["23-A"]?.getStartTime(), formatter.date(from: "2020/01/16 23:00")!)
        XCTAssertEqual(timeSlotDictionaryFive["23-B"]?.getStartTime(), formatter.date(from: "2020/01/16 23:15")!)
        XCTAssertEqual(timeSlotDictionaryFive["23-C"]?.getStartTime(), formatter.date(from: "2020/01/16 23:30")!)
        XCTAssertEqual(timeSlotDictionaryFive["23-D"]?.getStartTime(), formatter.date(from: "2020/01/16 23:45")!)
    }
    
    func testGetEndOfToDoWorkTimeForTheDay() {
        let toDoEstTimeLength = arrayOfToDos[0].getEstTime()
        /*
         Starting date of ToDo is 2020/01/15 13:30
         Expecting result of 2020/01/15 15:30
         */
        let expectedResult: Date = arrayOfToDos[0].getStartDate().addingTimeInterval(Double(toDoEstTimeLength)! * (60.0 * 60.0))
        XCTAssertEqual(intervalAvailabilitiesHelper.getEndOfToDoWorkTimeForTheDay(toDo: arrayOfToDos[0], toDoWorkTimeLength: Double(arrayOfToDos[0].getEstTime())!), expectedResult)
    }
    
    func testCheckTimeIfLastFifteenMinutes() {
        let baseStartTimeOfToDoForTheDay: Date = arrayOfToDos[0].getStartDate()
        let lastFifteenMinOfToDoForTheDay: Date = baseStartTimeOfToDoForTheDay.addingTimeInterval(105.0 * 60.0)
        let estTimeOfToDoForTheDay: String = arrayOfToDos[0].getEstTime()
        let correctEndTimeOfToDoForTheDay: Date = baseStartTimeOfToDoForTheDay.addingTimeInterval(Double(estTimeOfToDoForTheDay)! * (60.0 * 60.0))
        // Asserts that this timeSlot is not the last fifteen minutes
        XCTAssertEqual(intervalAvailabilitiesHelper.checkTimeIfLastFifteenMinutes(timeToBeChecked: baseStartTimeOfToDoForTheDay, endingWorkTimeForTheDay: correctEndTimeOfToDoForTheDay), false)
        // Asserts that this timeSlot is the last fifteen minutes
        XCTAssertEqual(intervalAvailabilitiesHelper.checkTimeIfLastFifteenMinutes(timeToBeChecked: lastFifteenMinOfToDoForTheDay, endingWorkTimeForTheDay: correctEndTimeOfToDoForTheDay), true)
    }
    
    func testGetLongestConsecutiveTimeSlotsForDay() {
        formatter.dateFormat = "yyyy/MM/dd"
        let otherDict = intervalAvailabilitiesHelper.getOccupiedTimeSlots(collectionOfToDosForTheDay: arrayOfToDos, dayDateOfTheCollection: formatter.date(from: "2020/01/15")!)
        let longestTimeSlots = intervalAvailabilitiesHelper.getLongestConsecutiveTimeSlot(timeSlotDictionary: otherDict, dayToCheck: formatter.date(from: "2020/01/15")!)
        print(longestTimeSlots)
    }
    
    /*
     DEFECT: Issue with this algorithm is that the timeSlots that get past midnight get put for the day instead.
     */
    func testGetOccupiedTimeSlots() {
        // Initial DateFormat
        formatter.dateFormat = "yyyy/MM/dd"
        let dateOfTheDay: Date = formatter.date(from: "2020/01/15")!
        let toDosForADay: [ToDo] = toDoProcessHelper.retrieveToDoItemsByDay(toDoDate: dateOfTheDay, toDoItems: arrayOfToDos)
        var occupiedTimeSlots: [String: TimeSlot] = intervalAvailabilitiesHelper.getOccupiedTimeSlots(collectionOfToDosForTheDay: toDosForADay, dayDateOfTheCollection: dateOfTheDay)
        
        // DateFormat for the assertions
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        // Test of timeSlot startTime
        XCTAssertEqual(occupiedTimeSlots["13-C"]?.getStartTime(), formatter.date(from: "2020/01/15 13:30")!)
        XCTAssertEqual(occupiedTimeSlots["13-D"]?.getStartTime(), formatter.date(from: "2020/01/15 13:45")!)
        XCTAssertEqual(occupiedTimeSlots["14-A"]?.getStartTime(), formatter.date(from: "2020/01/15 14:00")!)
        XCTAssertEqual(occupiedTimeSlots["14-B"]?.getStartTime(), formatter.date(from: "2020/01/15 14:15")!)
        XCTAssertEqual(occupiedTimeSlots["14-C"]?.getStartTime(), formatter.date(from: "2020/01/15 14:30")!)
        XCTAssertEqual(occupiedTimeSlots["14-D"]?.getStartTime(), formatter.date(from: "2020/01/15 14:45")!)
        XCTAssertEqual(occupiedTimeSlots["15-A"]?.getStartTime(), formatter.date(from: "2020/01/15 15:00")!)
        XCTAssertEqual(occupiedTimeSlots["15-B"]?.getStartTime(), formatter.date(from: "2020/01/15 15:15")!)
        // Test of timeSlot endTime
        XCTAssertEqual(occupiedTimeSlots["13-C"]?.getEndTime(), formatter.date(from: "2020/01/15 13:45")!)
        XCTAssertEqual(occupiedTimeSlots["13-D"]?.getEndTime(), formatter.date(from: "2020/01/15 14:00")!)
        XCTAssertEqual(occupiedTimeSlots["14-A"]?.getEndTime(), formatter.date(from: "2020/01/15 14:15")!)
        XCTAssertEqual(occupiedTimeSlots["14-B"]?.getEndTime(), formatter.date(from: "2020/01/15 14:30")!)
        XCTAssertEqual(occupiedTimeSlots["14-C"]?.getEndTime(), formatter.date(from: "2020/01/15 14:45")!)
        XCTAssertEqual(occupiedTimeSlots["14-D"]?.getEndTime(), formatter.date(from: "2020/01/15 15:00")!)
        XCTAssertEqual(occupiedTimeSlots["15-A"]?.getEndTime(), formatter.date(from: "2020/01/15 15:15")!)
        XCTAssertEqual(occupiedTimeSlots["15-B"]?.getEndTime(), formatter.date(from: "2020/01/15 15:30")!)
        
        // Test of timeSlot startTime
        XCTAssertEqual(occupiedTimeSlots["15-C"]?.getStartTime(), formatter.date(from: "2020/01/15 15:30")!)
        XCTAssertEqual(occupiedTimeSlots["15-D"]?.getStartTime(), formatter.date(from: "2020/01/15 15:45")!)
        XCTAssertEqual(occupiedTimeSlots["16-A"]?.getStartTime(), formatter.date(from: "2020/01/15 16:00")!)
        XCTAssertEqual(occupiedTimeSlots["16-B"]?.getStartTime(), formatter.date(from: "2020/01/15 16:15")!)
        XCTAssertEqual(occupiedTimeSlots["16-C"]?.getStartTime(), formatter.date(from: "2020/01/15 16:30")!)
        XCTAssertEqual(occupiedTimeSlots["16-D"]?.getStartTime(), formatter.date(from: "2020/01/15 16:45")!)
        XCTAssertEqual(occupiedTimeSlots["17-A"]?.getStartTime(), formatter.date(from: "2020/01/15 17:00")!)
        XCTAssertEqual(occupiedTimeSlots["17-B"]?.getStartTime(), formatter.date(from: "2020/01/15 17:15")!)
        // Test of timeSlot endTime
        XCTAssertEqual(occupiedTimeSlots["15-C"]?.getEndTime(), formatter.date(from: "2020/01/15 15:45")!)
        XCTAssertEqual(occupiedTimeSlots["15-D"]?.getEndTime(), formatter.date(from: "2020/01/15 16:00")!)
        XCTAssertEqual(occupiedTimeSlots["16-A"]?.getEndTime(), formatter.date(from: "2020/01/15 16:15")!)
        XCTAssertEqual(occupiedTimeSlots["16-B"]?.getEndTime(), formatter.date(from: "2020/01/15 16:30")!)
        XCTAssertEqual(occupiedTimeSlots["16-C"]?.getEndTime(), formatter.date(from: "2020/01/15 16:45")!)
        XCTAssertEqual(occupiedTimeSlots["16-D"]?.getEndTime(), formatter.date(from: "2020/01/15 17:00")!)
        XCTAssertEqual(occupiedTimeSlots["17-A"]?.getEndTime(), formatter.date(from: "2020/01/15 17:15")!)
        XCTAssertEqual(occupiedTimeSlots["17-B"]?.getEndTime(), formatter.date(from: "2020/01/15 17:30")!)
    }

    func testGetConsecutiveTimeSlotsFromATimeSlotDictionary() {
        // Initial DateFormat
        formatter.dateFormat = "yyyy/MM/dd"
        let dateOfTheDay: Date = formatter.date(from: "2020/01/15")!
        let toDosForADay: [ToDo] = toDoProcessHelper.retrieveToDoItemsByDay(toDoDate: dateOfTheDay, toDoItems: arrayOfToDos)
        //var occupiedTimeSlots: [String: TimeSlot] = intervalAvailabilitiesHelper.getOccupiedTimeSlots(collectionOfToDosForTheDay: toDosForADay, dayDateOfTheCollection: dateOfTheDay)
        //var sortedDictionary = Array
        //print(intervalAvailabilitiesHelper.getConsecutiveTimeSlotsFromATimeSlotDictionary(timeSlotDictionary: occupiedTimeSlots))
    }
    /*
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

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
