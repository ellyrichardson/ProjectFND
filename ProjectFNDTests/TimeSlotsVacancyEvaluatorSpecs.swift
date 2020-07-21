//
//  TimeSlotsVacancyEvaluatorTest.swift
//  ProjectFNDTests
//
//  Created by Elly Richardson on 6/11/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import Quick
import Nimble
@testable import ProjectFND

class TimeSlotsVacancyEvaluatorSpecs: QuickSpec {
    override func spec() {
        var taskPackager: TaskPackager!
        var tsve: TimeSlotsVacancyEvaluator!
        var dateUtils: DateUtils!
        
        describe("otd") {
            
            // MARK: - Populating Tests
            
            context("populating") {
                
                beforeEach {
                    taskPackager = TaskPackager()
                    tsve = TimeSlotsVacancyEvaluator()
                    dateUtils = DateUtils()
                }
                
                it("should have appropriate otd for 5 tasks within a day") {
                    let keyFor9AM = "2020/01/15 09 AM"
                    let keyFor10AM = "2020/01/15 10 AM"
                    let keyFor11AM = "2020/01/15 11 AM"
                    let keyFor01PM = "2020/01/15 01 PM"
                    
                    let june15Start = dateUtils.createDate(dateString: "2020/01/15 00:00")
                    let june16Start = dateUtils.createDate(dateString: "2020/01/16 00:00")
                    
                    let dayTimeSpan = TimeSpan(startDate: june15Start, endDate: june16Start)
                    
                    let taskItems = taskPackager.packageFiveTasksThatAreLessThanAnHourWithinADay()
                    let sortedTaskDict = ToDoProcessUtils.sortToDoItemsByDate(toDoItems: taskItems)
                    
                    tsve.setTaskItems(tasks: sortedTaskDict)
                    tsve.populateOtd(timeSpan: dayTimeSpan)
                    
                    expect(tsve.getOtd().count).to(be(4))
                    
                    expect(tsve.getOtd()[keyFor9AM]?.count).to(be(1))
                    expect(tsve.getOtd()[keyFor9AM]?[0].getStartTime()).to(be(dateUtils.createDate(dateString: "2020/01/15 09:30")))
                    expect(tsve.getOtd()[keyFor9AM]?[0].getEndTime()).to(be(dateUtils.createDate(dateString: "2020/01/15 10:15")))
                    
                    expect(tsve.getOtd()[keyFor10AM]?.count).to(be(1))
                    expect(tsve.getOtd()[keyFor10AM]?[0].getStartTime()).to(be(dateUtils.createDate(dateString: "2020/01/15 10:15")))
                    expect(tsve.getOtd()[keyFor10AM]?[0].getEndTime()).to(be(dateUtils.createDate(dateString: "2020/01/15 10:45")))
                    
                    expect(tsve.getOtd()[keyFor11AM]?.count).to(be(1))
                    expect(tsve.getOtd()[keyFor11AM]?[0].getStartTime()).to(be(dateUtils.createDate(dateString: "2020/01/15 11:15")))
                    expect(tsve.getOtd()[keyFor11AM]?[0].getEndTime()).to(be(dateUtils.createDate(dateString: "2020/01/15 12:00")))
                    
                    expect(tsve.getOtd()[keyFor01PM]?.count).to(be(2))
                    expect(tsve.getOtd()[keyFor01PM]?[0].getStartTime()).to(be(dateUtils.createDate(dateString: "2020/01/15 13:00")))
                    expect(tsve.getOtd()[keyFor01PM]?[0].getEndTime()).to(be(dateUtils.createDate(dateString: "2020/01/15 13:45")))
                    expect(tsve.getOtd()[keyFor01PM]?[1].getStartTime()).to(be(dateUtils.createDate(dateString: "2020/01/15 13:45")))
                    expect(tsve.getOtd()[keyFor01PM]?[1].getEndTime()).to(be(dateUtils.createDate(dateString: "2020/01/15 14:30")))
                }
                
                it("should have appropriate otd for 5 tasks scattered every other day") {
                    let keyFor9AM = "2020/01/15 09 AM"
                    let keyFor10AM = "2020/01/15 10 AM"
                    let keyFor11AM = "2020/01/17 11 AM"
                    let keyFor01PM = "2020/01/17 01 PM"
                    
                    let june15Start = dateUtils.createDate(dateString: "2020/01/15 00:00")
                    let june18Start = dateUtils.createDate(dateString: "2020/01/18 00:00")
                    
                    let dayTimeSpan = TimeSpan(startDate: june15Start, endDate: june18Start)
                    
                    let taskItems = taskPackager.packageFiveTasksWithVaryingLengthForEveryOtherDay()
                    let sortedTaskDict = ToDoProcessUtils.sortToDoItemsByDate(toDoItems: taskItems)
                    
                    tsve.setTaskItems(tasks: sortedTaskDict)
                    tsve.populateOtd(timeSpan: dayTimeSpan)
                    
                    expect(tsve.getOtd().count).to(be(4))
                    
                    expect(tsve.getOtd()[keyFor9AM]?.count).to(be(1))
                    expect(tsve.getOtd()[keyFor9AM]?[0].getStartTime()).to(be(dateUtils.createDate(dateString: "2020/01/15 09:30")))
                    expect(tsve.getOtd()[keyFor9AM]?[0].getEndTime()).to(be(dateUtils.createDate(dateString: "2020/01/15 10:15")))
                    
                    expect(tsve.getOtd()[keyFor10AM]?.count).to(be(1))
                    expect(tsve.getOtd()[keyFor10AM]?[0].getStartTime()).to(be(dateUtils.createDate(dateString: "2020/01/15 10:15")))
                    expect(tsve.getOtd()[keyFor10AM]?[0].getEndTime()).to(be(dateUtils.createDate(dateString: "2020/01/15 10:45")))
                    
                    expect(tsve.getOtd()[keyFor11AM]?.count).to(be(1))
                    expect(tsve.getOtd()[keyFor11AM]?[0].getStartTime()).to(be(dateUtils.createDate(dateString: "2020/01/17 11:15")))
                    expect(tsve.getOtd()[keyFor11AM]?[0].getEndTime()).to(be(dateUtils.createDate(dateString: "2020/01/17 12:00")))
                    
                    expect(tsve.getOtd()[keyFor01PM]?.count).to(be(2))
                    expect(tsve.getOtd()[keyFor01PM]?[0].getStartTime()).to(be(dateUtils.createDate(dateString: "2020/01/17 13:00")))
                    expect(tsve.getOtd()[keyFor01PM]?[0].getEndTime()).to(be(dateUtils.createDate(dateString: "2020/01/17 13:45")))
                    expect(tsve.getOtd()[keyFor01PM]?[1].getStartTime()).to(be(dateUtils.createDate(dateString: "2020/01/17 13:45")))
                    expect(tsve.getOtd()[keyFor01PM]?[1].getEndTime()).to(be(dateUtils.createDate(dateString: "2020/01/17 14:30")))
                }
                
                it("should have 1 otd for a single half day task") {
                    let keyFor9AM = "2020/01/15 09 AM"
                    
                    let june15Start = dateUtils.createDate(dateString: "2020/01/15 00:00")
                    let june16Start = dateUtils.createDate(dateString: "2020/01/16 00:00")
                    
                    let dayTimeSpan = TimeSpan(startDate: june15Start, endDate: june16Start)
                    
                    let taskItems = taskPackager.packageSingleHalfDayTask()
                    let sortedTaskDict = ToDoProcessUtils.sortToDoItemsByDate(toDoItems: taskItems)
                    
                    tsve.setTaskItems(tasks: sortedTaskDict)
                    tsve.populateOtd(timeSpan: dayTimeSpan)
                    
                    expect(tsve.getOtd().count).to(be(1))
                    
                    expect(tsve.getOtd()[keyFor9AM]?.count).to(be(1))
                    expect(tsve.getOtd()[keyFor9AM]?[0].getStartTime()).to(be(dateUtils.createDate(dateString: "2020/01/15 09:30")))
                    expect(tsve.getOtd()[keyFor9AM]?[0].getEndTime()).to(be(dateUtils.createDate(dateString: "2020/01/15 21:30")))
                }
                
                it("should have 1 otd for a single half day task starting 12 AM") {
                    let keyFor12AM = "2020/01/15 12 AM"
                    
                    let june15Start = dateUtils.createDate(dateString: "2020/01/15 00:00")
                    let june16Start = dateUtils.createDate(dateString: "2020/01/16 00:00")
                    
                    let dayTimeSpan = TimeSpan(startDate: june15Start, endDate: june16Start)
                    
                    let taskItems = taskPackager.packageSingleHalfDayTaskStarting12AM()
                    let sortedTaskDict = ToDoProcessUtils.sortToDoItemsByDate(toDoItems: taskItems)
                    
                    tsve.setTaskItems(tasks: sortedTaskDict)
                    tsve.populateOtd(timeSpan: dayTimeSpan)
                    
                    expect(tsve.getOtd().count).to(be(1))
                    
                    expect(tsve.getOtd()[keyFor12AM]?.count).to(be(1))
                    expect(tsve.getOtd()[keyFor12AM]?[0].getStartTime()).to(be(dateUtils.createDate(dateString: "2020/01/15 00:00")))
                    expect(tsve.getOtd()[keyFor12AM]?[0].getEndTime()).to(be(dateUtils.createDate(dateString: "2020/01/15 12:00")))
                }
                
                it("should have 1 otd for a single half day task ending at next day's 12 AM") {
                    let keyFor12PM = "2020/01/15 12 PM"
                    
                    let jan15Start = dateUtils.createDate(dateString: "2020/01/15 00:00")
                    let jan16Start = dateUtils.createDate(dateString: "2020/01/16 00:00")
                    
                    let dayTimeSpan = TimeSpan(startDate: jan15Start, endDate: jan16Start)
                    
                    let taskItems = taskPackager.packageSingleHalfDayTaskEnding12AMNextDay()
                    let sortedTaskDict = ToDoProcessUtils.sortToDoItemsByDate(toDoItems: taskItems)
                    
                    tsve.setTaskItems(tasks: sortedTaskDict)
                    tsve.populateOtd(timeSpan: dayTimeSpan)
                    
                    expect(tsve.getOtd().count).to(be(1))
                    
                    expect(tsve.getOtd()[keyFor12PM]?.count).to(be(1))
                    expect(tsve.getOtd()[keyFor12PM]?[0].getStartTime()).to(be(dateUtils.createDate(dateString: "2020/01/15 12:00")))
                    expect(tsve.getOtd()[keyFor12PM]?[0].getEndTime()).to(be(dateUtils.createDate(dateString: "2020/01/16 00:00")))
                }
                
                it("should have 1 otd for a single full day task starting 12 AM current day to 12 AM next day") {
                    let keyFor12AM = "2020/01/15 12 AM"
                    
                    let jan15Start = dateUtils.createDate(dateString: "2020/01/15 00:00")
                    let jan16Start = dateUtils.createDate(dateString: "2020/01/16 00:00")
                    
                    let dayTimeSpan = TimeSpan(startDate: jan15Start, endDate: jan16Start)
                    
                    let taskItems = taskPackager.packageSingleFullDayTask()
                    let sortedTaskDict = ToDoProcessUtils.sortToDoItemsByDate(toDoItems: taskItems)
                    
                    tsve.setTaskItems(tasks: sortedTaskDict)
                    tsve.populateOtd(timeSpan: dayTimeSpan)
                    
                    expect(tsve.getOtd().count).to(be(1))
                    
                    expect(tsve.getOtd()[keyFor12AM]?.count).to(be(1))
                    expect(tsve.getOtd()[keyFor12AM]?[0].getStartTime()).to(be(dateUtils.createDate(dateString: "2020/01/15 00:00")))
                    expect(tsve.getOtd()[keyFor12AM]?[0].getEndTime()).to(be(dateUtils.createDate(dateString: "2020/01/16 00:00")))
                }
                
                it("should have 1 otd for a single full day task starting 12 AM current day to 12 AM next day") {
                    let keyFor12AM = "2020/01/15 12 AM"
                    
                    let jan15Start = dateUtils.createDate(dateString: "2020/01/15 00:00")
                    let jan16Start = dateUtils.createDate(dateString: "2020/01/16 00:00")
                    
                    let dayTimeSpan = TimeSpan(startDate: jan15Start, endDate: jan16Start)
                    
                    let taskItems = taskPackager.packageSingleFullDayTask()
                    let sortedTaskDict = ToDoProcessUtils.sortToDoItemsByDate(toDoItems: taskItems)
                    
                    tsve.setTaskItems(tasks: sortedTaskDict)
                    tsve.populateOtd(timeSpan: dayTimeSpan)
                    
                    expect(tsve.getOtd().count).to(be(1))
                    
                    expect(tsve.getOtd()[keyFor12AM]?.count).to(be(1))
                    expect(tsve.getOtd()[keyFor12AM]?[0].getStartTime()).to(be(dateUtils.createDate(dateString: "2020/01/15 00:00")))
                    expect(tsve.getOtd()[keyFor12AM]?[0].getEndTime()).to(be(dateUtils.createDate(dateString: "2020/01/16 00:00")))
                }
                
                it("should have 3 otd for three single full day task from 12 AM to 12 AM") {
                    let keyFor12AM1 = "2020/01/15 12 AM"
                    let keyFor12AM2 = "2020/01/16 12 AM"
                    let keyFor12AM3 = "2020/01/17 12 AM"
                    
                    let jan15Start = dateUtils.createDate(dateString: "2020/01/15 00:00")
                    let jan18Start = dateUtils.createDate(dateString: "2020/01/18 00:00")
                    
                    let dayTimeSpan = TimeSpan(startDate: jan15Start, endDate: jan18Start)
                    
                    let taskItems = taskPackager.packageThreeConsecutiveFullDayTasks()
                    let sortedTaskDict = ToDoProcessUtils.sortToDoItemsByDate(toDoItems: taskItems)
                    
                    tsve.setTaskItems(tasks: sortedTaskDict)
                    tsve.populateOtd(timeSpan: dayTimeSpan)
                    
                    expect(tsve.getOtd().count).to(be(3))
                    
                    expect(tsve.getOtd()[keyFor12AM1]?.count).to(be(1))
                    expect(tsve.getOtd()[keyFor12AM1]?[0].getStartTime()).to(be(dateUtils.createDate(dateString: "2020/01/15 00:00")))
                    expect(tsve.getOtd()[keyFor12AM1]?[0].getEndTime()).to(be(dateUtils.createDate(dateString: "2020/01/16 00:00")))
                    
                    expect(tsve.getOtd()[keyFor12AM2]?.count).to(be(1))
                    expect(tsve.getOtd()[keyFor12AM2]?[0].getStartTime()).to(be(dateUtils.createDate(dateString: "2020/01/16 00:00")))
                    expect(tsve.getOtd()[keyFor12AM2]?[0].getEndTime()).to(be(dateUtils.createDate(dateString: "2020/01/17 00:00")))
                    
                    expect(tsve.getOtd()[keyFor12AM3]?.count).to(be(1))
                    expect(tsve.getOtd()[keyFor12AM3]?[0].getStartTime()).to(be(dateUtils.createDate(dateString: "2020/01/17 00:00")))
                    expect(tsve.getOtd()[keyFor12AM3]?[0].getEndTime()).to(be(dateUtils.createDate(dateString: "2020/01/18 00:00")))
                }
                
                it("should have empty otd if no task for day") {
                    let june15Start = dateUtils.createDate(dateString: "2020/01/15 00:00")
                    let june16Start = dateUtils.createDate(dateString: "2020/01/16 00:00")
                    
                    let emptyTaskItems = [String: ToDo]()
                    let sortedTaskDict = ToDoProcessUtils.sortToDoItemsByDate(toDoItems: emptyTaskItems)
                    
                    let dayTimeSpan = TimeSpan(startDate: june15Start, endDate: june16Start)
                    
                    tsve.setTaskItems(tasks: sortedTaskDict)
                    tsve.populateOtd(timeSpan: dayTimeSpan)
                    
                    expect(tsve.getOtd()).to(beEmpty())
                }
            }
            
            // MARK: - Evaluating Tests
            
            context("evaluating") {
                
                beforeEach {
                    taskPackager = TaskPackager()
                    tsve = TimeSlotsVacancyEvaluator()
                    dateUtils = DateUtils()
                }
                
                it("should have appropriate oter with 5 tasks within a day") {
                    
                    let june15Start = dateUtils.createDate(dateString: "2020/01/15 00:00")
                    let june16Start = dateUtils.createDate(dateString: "2020/01/16 00:00")
                    
                    let taskItems = taskPackager.packageFiveTasksThatAreLessThanAnHourWithinADay()
                    let sortedTaskDict = ToDoProcessUtils.sortToDoItemsByDate(toDoItems: taskItems)
                    
                    let dayTimeSpan = TimeSpan(startDate: june15Start, endDate: june16Start)
                    
                    tsve.setTaskItems(tasks: sortedTaskDict)
                    tsve.populateOtd(timeSpan: dayTimeSpan)
                    tsve.evaluateOtd(timeSpan: dayTimeSpan)
                    
                    let tsveTimeSlot1 = tsve.getOterAvailabilities()[0]
                    let tsveTimeSlot2 = tsve.getOterAvailabilities()[1]
                    let tsveTimeSlot3 = tsve.getOterAvailabilities()[2]
                    let tsveTimeSlot4 = tsve.getOterAvailabilities()[3]
                    let tsveTimeSlot5 = tsve.getOterAvailabilities()[4]
                    let tsveTimeSlot6 = tsve.getOterAvailabilities()[5]
                    let tsveTimeSlot7 = tsve.getOterAvailabilities()[6]
                    let tsveTimeSlot8 = tsve.getOterAvailabilities()[7]
                    let tsveTimeSlot9 = tsve.getOterAvailabilities()[8]
                    
                    expect(tsve.getOterAvailabilities().count).to(be(9))
                    
                    expect(tsveTimeSlot1.occupancyType == TSOType.VACANT).to(beTrue())
                    expect(tsveTimeSlot1.startDate).to(be(dateUtils.createDate(dateString: "2020/01/15 00:00")))
                    expect(tsveTimeSlot1.endDate).to(be(dateUtils.createDate(dateString: "2020/01/15 09:30")))
                    expect(tsveTimeSlot1.ownerTaskId.isEmpty).to(beTrue())
                    
                    expect(tsveTimeSlot2.occupancyType == TSOType.OCCUPIED).to(beTrue())
                    expect(tsveTimeSlot2.startDate).to(be(dateUtils.createDate(dateString: "2020/01/15 09:30")))
                    expect(tsveTimeSlot2.endDate).to(be(dateUtils.createDate(dateString: "2020/01/15 10:15")))
                    expect(tsveTimeSlot2.ownerTaskId.isEmpty).to(beFalse())
                    
                    expect(tsveTimeSlot3.occupancyType == TSOType.OCCUPIED).to(beTrue())
                    expect(tsveTimeSlot3.startDate).to(be(dateUtils.createDate(dateString: "2020/01/15 10:15")))
                    expect(tsveTimeSlot3.endDate).to(be(dateUtils.createDate(dateString: "2020/01/15 10:45")))
                    expect(tsveTimeSlot3.ownerTaskId.isEmpty).to(beFalse())
                    
                    expect(tsveTimeSlot4.occupancyType == TSOType.VACANT).to(beTrue())
                    expect(tsveTimeSlot4.startDate).to(be(dateUtils.createDate(dateString: "2020/01/15 10:45")))
                    expect(tsveTimeSlot4.endDate).to(be(dateUtils.createDate(dateString: "2020/01/15 11:15")))
                    expect(tsveTimeSlot4.ownerTaskId.isEmpty).to(beTrue())
                    
                    expect(tsveTimeSlot5.occupancyType == TSOType.OCCUPIED).to(beTrue())
                    expect(tsveTimeSlot5.startDate).to(be(dateUtils.createDate(dateString: "2020/01/15 11:15")))
                    expect(tsveTimeSlot5.endDate).to(be(dateUtils.createDate(dateString: "2020/01/15 12:00")))
                    expect(tsveTimeSlot5.ownerTaskId.isEmpty).to(beFalse())
                    
                    expect(tsveTimeSlot6.occupancyType == TSOType.VACANT).to(beTrue())
                    expect(tsveTimeSlot6.startDate).to(be(dateUtils.createDate(dateString: "2020/01/15 12:00")))
                    expect(tsveTimeSlot6.endDate).to(be(dateUtils.createDate(dateString: "2020/01/15 13:00")))
                    expect(tsveTimeSlot6.ownerTaskId.isEmpty).to(beTrue())
                    
                    expect(tsveTimeSlot7.occupancyType == TSOType.OCCUPIED).to(beTrue())
                    expect(tsveTimeSlot7.startDate).to(be(dateUtils.createDate(dateString: "2020/01/15 13:00")))
                    expect(tsveTimeSlot7.endDate).to(be(dateUtils.createDate(dateString: "2020/01/15 13:45")))
                    expect(tsveTimeSlot7.ownerTaskId.isEmpty).to(beFalse())
                    
                    expect(tsveTimeSlot8.occupancyType == TSOType.OCCUPIED).to(beTrue())
                    expect(tsveTimeSlot8.startDate).to(be(dateUtils.createDate(dateString: "2020/01/15 13:45")))
                    expect(tsveTimeSlot8.endDate).to(be(dateUtils.createDate(dateString: "2020/01/15 14:30")))
                    expect(tsveTimeSlot8.ownerTaskId.isEmpty).to(beFalse())
                    
                    expect(tsveTimeSlot9.occupancyType == TSOType.VACANT).to(beTrue())
                    expect(tsveTimeSlot9.startDate).to(be(dateUtils.createDate(dateString: "2020/01/15 14:30")))
                    expect(tsveTimeSlot9.endDate).to(be(dateUtils.createDate(dateString: "2020/01/16 00:00")))
                    expect(tsveTimeSlot9.ownerTaskId.isEmpty).to(beTrue())
                }
                
                it("should have appropriate oter for 5 tasks scattered for every other day") {
                    
                    let june15Start = dateUtils.createDate(dateString: "2020/01/15 00:00")
                    let june18Start = dateUtils.createDate(dateString: "2020/01/18 00:00")
                    
                    let taskItems = taskPackager.packageFiveTasksWithVaryingLengthForEveryOtherDay()
                    let sortedTaskDict = ToDoProcessUtils.sortToDoItemsByDate(toDoItems: taskItems)
                    
                    let dayTimeSpan = TimeSpan(startDate: june15Start, endDate: june18Start)
                    
                    tsve.setTaskItems(tasks: sortedTaskDict)
                    tsve.populateOtd(timeSpan: dayTimeSpan)
                    tsve.evaluateOtd(timeSpan: dayTimeSpan)
                    
                    let tsveTimeSlot1 = tsve.getOterAvailabilities()[0]
                    let tsveTimeSlot2 = tsve.getOterAvailabilities()[1]
                    let tsveTimeSlot3 = tsve.getOterAvailabilities()[2]
                    let tsveTimeSlot4 = tsve.getOterAvailabilities()[3]
                    let tsveTimeSlot5 = tsve.getOterAvailabilities()[4]
                    let tsveTimeSlot6 = tsve.getOterAvailabilities()[5]
                    let tsveTimeSlot7 = tsve.getOterAvailabilities()[6]
                    let tsveTimeSlot8 = tsve.getOterAvailabilities()[7]
                    let tsveTimeSlot9 = tsve.getOterAvailabilities()[8]
                    
                    expect(tsve.getOterAvailabilities().count).to(be(9))
                    
                    expect(tsveTimeSlot1.occupancyType == TSOType.VACANT).to(beTrue())
                    expect(tsveTimeSlot1.startDate).to(be(dateUtils.createDate(dateString: "2020/01/15 00:00")))
                    expect(tsveTimeSlot1.endDate).to(be(dateUtils.createDate(dateString: "2020/01/15 09:30")))
                    expect(tsveTimeSlot1.ownerTaskId.isEmpty).to(beTrue())
                    
                    expect(tsveTimeSlot2.occupancyType == TSOType.OCCUPIED).to(beTrue())
                    expect(tsveTimeSlot2.startDate).to(be(dateUtils.createDate(dateString: "2020/01/15 09:30")))
                    expect(tsveTimeSlot2.endDate).to(be(dateUtils.createDate(dateString: "2020/01/15 10:15")))
                    expect(tsveTimeSlot2.ownerTaskId.isEmpty).to(beFalse())
                    
                    expect(tsveTimeSlot3.occupancyType == TSOType.OCCUPIED).to(beTrue())
                    expect(tsveTimeSlot3.startDate).to(be(dateUtils.createDate(dateString: "2020/01/15 10:15")))
                    expect(tsveTimeSlot3.endDate).to(be(dateUtils.createDate(dateString: "2020/01/15 10:45")))
                    expect(tsveTimeSlot3.ownerTaskId.isEmpty).to(beFalse())
                    
                    expect(tsveTimeSlot4.occupancyType == TSOType.VACANT).to(beTrue())
                    expect(tsveTimeSlot4.startDate).to(be(dateUtils.createDate(dateString: "2020/01/15 10:45")))
                    expect(tsveTimeSlot4.endDate).to(be(dateUtils.createDate(dateString: "2020/01/17 11:15")))
                    expect(tsveTimeSlot4.ownerTaskId.isEmpty).to(beTrue())
                    
                    expect(tsveTimeSlot5.occupancyType == TSOType.OCCUPIED).to(beTrue())
                    expect(tsveTimeSlot5.startDate).to(be(dateUtils.createDate(dateString: "2020/01/17 11:15")))
                    expect(tsveTimeSlot5.endDate).to(be(dateUtils.createDate(dateString: "2020/01/17 12:00")))
                    expect(tsveTimeSlot5.ownerTaskId.isEmpty).to(beFalse())
                    
                    expect(tsveTimeSlot6.occupancyType == TSOType.VACANT).to(beTrue())
                    expect(tsveTimeSlot6.startDate).to(be(dateUtils.createDate(dateString: "2020/01/17 12:00")))
                    expect(tsveTimeSlot6.endDate).to(be(dateUtils.createDate(dateString: "2020/01/17 13:00")))
                    expect(tsveTimeSlot6.ownerTaskId.isEmpty).to(beTrue())
                    
                    expect(tsveTimeSlot7.occupancyType == TSOType.OCCUPIED).to(beTrue())
                    expect(tsveTimeSlot7.startDate).to(be(dateUtils.createDate(dateString: "2020/01/17 13:00")))
                    expect(tsveTimeSlot7.endDate).to(be(dateUtils.createDate(dateString: "2020/01/17 13:45")))
                    expect(tsveTimeSlot7.ownerTaskId.isEmpty).to(beFalse())
                    
                    expect(tsveTimeSlot8.occupancyType == TSOType.OCCUPIED).to(beTrue())
                    expect(tsveTimeSlot8.startDate).to(be(dateUtils.createDate(dateString: "2020/01/17 13:45")))
                    expect(tsveTimeSlot8.endDate).to(be(dateUtils.createDate(dateString: "2020/01/17 14:30")))
                    expect(tsveTimeSlot8.ownerTaskId.isEmpty).to(beFalse())
                    
                    expect(tsveTimeSlot9.occupancyType == TSOType.VACANT).to(beTrue())
                    expect(tsveTimeSlot9.startDate).to(be(dateUtils.createDate(dateString: "2020/01/17 14:30")))
                    expect(tsveTimeSlot9.endDate).to(be(dateUtils.createDate(dateString: "2020/01/18 00:00")))
                    expect(tsveTimeSlot9.ownerTaskId.isEmpty).to(beTrue())
                }
                
                it("should have 3 oter for a mid-day single half day task") {
                    
                    let jan15Start = dateUtils.createDate(dateString: "2020/01/15 00:00")
                    let jan16Start = dateUtils.createDate(dateString: "2020/01/16 00:00")
                    
                    let taskItems = taskPackager.packageSingleHalfDayTask()
                    let sortedTaskDict = ToDoProcessUtils.sortToDoItemsByDate(toDoItems: taskItems)
                    
                    let dayTimeSpan = TimeSpan(startDate: jan15Start, endDate: jan16Start)
                    
                    tsve.setTaskItems(tasks: sortedTaskDict)
                    tsve.populateOtd(timeSpan: dayTimeSpan)
                    tsve.evaluateOtd(timeSpan: dayTimeSpan)
                    
                    let tsveTimeSlot1 = tsve.getOterAvailabilities()[0]
                    let tsveTimeSlot2 = tsve.getOterAvailabilities()[1]
                    let tsveTimeSlot3 = tsve.getOterAvailabilities()[2]
                    
                    expect(tsve.getOterAvailabilities().count).to(be(3))
                    
                    expect(tsveTimeSlot1.occupancyType == TSOType.VACANT).to(beTrue())
                    expect(tsveTimeSlot1.startDate).to(be(dateUtils.createDate(dateString: "2020/01/15 00:00")))
                    expect(tsveTimeSlot1.endDate).to(be(dateUtils.createDate(dateString: "2020/01/15 09:30")))
                    expect(tsveTimeSlot1.ownerTaskId.isEmpty).to(beTrue())
                    
                    expect(tsveTimeSlot2.occupancyType == TSOType.OCCUPIED).to(beTrue())
                    expect(tsveTimeSlot2.startDate).to(be(dateUtils.createDate(dateString: "2020/01/15 09:30")))
                    expect(tsveTimeSlot2.endDate).to(be(dateUtils.createDate(dateString: "2020/01/15 21:30")))
                    expect(tsveTimeSlot2.ownerTaskId.isEmpty).to(beFalse())

                    expect(tsveTimeSlot3.occupancyType == TSOType.VACANT).to(beTrue())
                    expect(tsveTimeSlot3.startDate).to(be(dateUtils.createDate(dateString: "2020/01/15 21:30")))
                    expect(tsveTimeSlot3.endDate).to(be(dateUtils.createDate(dateString: "2020/01/16 00:00")))
                    expect(tsveTimeSlot3.ownerTaskId.isEmpty).to(beTrue())
                }
                
                it("should have 2 oter for a single half day task starting 12 AM") {
                    
                    let jan15Start = dateUtils.createDate(dateString: "2020/01/15 00:00")
                    let jan16Start = dateUtils.createDate(dateString: "2020/01/16 00:00")
                    
                    let taskItems = taskPackager.packageSingleHalfDayTaskStarting12AM()
                    let sortedTaskDict = ToDoProcessUtils.sortToDoItemsByDate(toDoItems: taskItems)
                    
                    let dayTimeSpan = TimeSpan(startDate: jan15Start, endDate: jan16Start)
                    
                    tsve.setTaskItems(tasks: sortedTaskDict)
                    tsve.populateOtd(timeSpan: dayTimeSpan)
                    tsve.evaluateOtd(timeSpan: dayTimeSpan)
                    
                    let tsveTimeSlot1 = tsve.getOterAvailabilities()[0]
                    let tsveTimeSlot2 = tsve.getOterAvailabilities()[1]
                    
                    expect(tsve.getOterAvailabilities().count).to(be(2))
                    
                    expect(tsveTimeSlot1.occupancyType == TSOType.OCCUPIED).to(beTrue())
                    expect(tsveTimeSlot1.startDate).to(be(dateUtils.createDate(dateString: "2020/01/15 00:00")))
                    expect(tsveTimeSlot1.endDate).to(be(dateUtils.createDate(dateString: "2020/01/15 12:00")))
                    expect(tsveTimeSlot1.ownerTaskId.isEmpty).to(beFalse())
                    
                    expect(tsveTimeSlot2.occupancyType == TSOType.VACANT).to(beTrue())
                    expect(tsveTimeSlot2.startDate).to(be(dateUtils.createDate(dateString: "2020/01/15 12:00")))
                    expect(tsveTimeSlot2.endDate).to(be(dateUtils.createDate(dateString: "2020/01/16 00:00")))
                    expect(tsveTimeSlot2.ownerTaskId.isEmpty).to(beTrue())
                }
                
                it("should have 2 oter for a single half day task ending at next day's 12 AM") {
                    
                    let jan15Start = dateUtils.createDate(dateString: "2020/01/15 00:00")
                    let jan16Start = dateUtils.createDate(dateString: "2020/01/16 00:00")
                    
                    let taskItems = taskPackager.packageSingleHalfDayTaskEnding12AMNextDay()
                    let sortedTaskDict = ToDoProcessUtils.sortToDoItemsByDate(toDoItems: taskItems)
                    
                    let dayTimeSpan = TimeSpan(startDate: jan15Start, endDate: jan16Start)
                    
                    tsve.setTaskItems(tasks: sortedTaskDict)
                    tsve.populateOtd(timeSpan: dayTimeSpan)
                    tsve.evaluateOtd(timeSpan: dayTimeSpan)
                    
                    let tsveTimeSlot1 = tsve.getOterAvailabilities()[0]
                    let tsveTimeSlot2 = tsve.getOterAvailabilities()[1]
                    
                    expect(tsve.getOterAvailabilities().count).to(be(2))
                    
                    expect(tsveTimeSlot1.occupancyType == TSOType.VACANT).to(beTrue())
                    expect(tsveTimeSlot1.startDate).to(be(dateUtils.createDate(dateString: "2020/01/15 00:00")))
                    expect(tsveTimeSlot1.endDate).to(be(dateUtils.createDate(dateString: "2020/01/15 12:00")))
                    expect(tsveTimeSlot1.ownerTaskId.isEmpty).to(beTrue())
                    
                    expect(tsveTimeSlot2.occupancyType == TSOType.OCCUPIED).to(beTrue())
                    expect(tsveTimeSlot2.startDate).to(be(dateUtils.createDate(dateString: "2020/01/15 12:00")))
                    expect(tsveTimeSlot2.endDate).to(be(dateUtils.createDate(dateString: "2020/01/16 00:00")))
                    expect(tsveTimeSlot2.ownerTaskId.isEmpty).to(beFalse())
                }
                
                it("should have 1 oter for a single full day task starting 12 AM current day and ending 12 AM next day") {
                    
                    let jan15Start = dateUtils.createDate(dateString: "2020/01/15 00:00")
                    let jan16Start = dateUtils.createDate(dateString: "2020/01/16 00:00")
                    
                    let taskItems = taskPackager.packageSingleFullDayTask()
                    let sortedTaskDict = ToDoProcessUtils.sortToDoItemsByDate(toDoItems: taskItems)
                    
                    let dayTimeSpan = TimeSpan(startDate: jan15Start, endDate: jan16Start)
                    
                    tsve.setTaskItems(tasks: sortedTaskDict)
                    tsve.populateOtd(timeSpan: dayTimeSpan)
                    tsve.evaluateOtd(timeSpan: dayTimeSpan)
                    
                    let tsveTimeSlot1 = tsve.getOterAvailabilities()[0]
                    
                    expect(tsve.getOterAvailabilities().count).to(be(1))
                    
                    expect(tsveTimeSlot1.occupancyType == TSOType.OCCUPIED).to(beTrue())
                    expect(tsveTimeSlot1.startDate).to(be(dateUtils.createDate(dateString: "2020/01/15 00:00")))
                    expect(tsveTimeSlot1.endDate).to(be(dateUtils.createDate(dateString: "2020/01/16 00:00")))
                    expect(tsveTimeSlot1.ownerTaskId.isEmpty).to(beFalse())
                }
                
                it("should have oter only for the day covered by TimeSpan, even if other days have tasks") {
                    
                    let june15Start = dateUtils.createDate(dateString: "2020/01/15 00:00")
                    let june16Start = dateUtils.createDate(dateString: "2020/01/16 00:00")
                    
                    let taskItems = taskPackager.packageFiveTasksWithVaryingLengthForEveryOtherDay()
                    let sortedTaskDict = ToDoProcessUtils.sortToDoItemsByDate(toDoItems: taskItems)
                    
                    let dayTimeSpan = TimeSpan(startDate: june15Start, endDate: june16Start)
                    
                    tsve.setTaskItems(tasks: sortedTaskDict)
                    tsve.populateOtd(timeSpan: dayTimeSpan)
                    tsve.evaluateOtd(timeSpan: dayTimeSpan)
                    
                    let tsveTimeSlot1 = tsve.getOterAvailabilities()[0]
                    let tsveTimeSlot2 = tsve.getOterAvailabilities()[1]
                    let tsveTimeSlot3 = tsve.getOterAvailabilities()[2]
                    let tsveTimeSlot4 = tsve.getOterAvailabilities()[3]
                    
                    expect(tsve.getOterAvailabilities().count).to(be(4))
                    
                    expect(tsveTimeSlot1.occupancyType == TSOType.VACANT).to(beTrue())
                    expect(tsveTimeSlot1.startDate).to(be(dateUtils.createDate(dateString: "2020/01/15 00:00")))
                    expect(tsveTimeSlot1.endDate).to(be(dateUtils.createDate(dateString: "2020/01/15 09:30")))
                    expect(tsveTimeSlot1.ownerTaskId.isEmpty).to(beTrue())
                    
                    expect(tsveTimeSlot2.occupancyType == TSOType.OCCUPIED).to(beTrue())
                    expect(tsveTimeSlot2.startDate).to(be(dateUtils.createDate(dateString: "2020/01/15 09:30")))
                    expect(tsveTimeSlot2.endDate).to(be(dateUtils.createDate(dateString: "2020/01/15 10:15")))
                    expect(tsveTimeSlot2.ownerTaskId.isEmpty).to(beFalse())
                    
                    expect(tsveTimeSlot3.occupancyType == TSOType.OCCUPIED).to(beTrue())
                    expect(tsveTimeSlot3.startDate).to(be(dateUtils.createDate(dateString: "2020/01/15 10:15")))
                    expect(tsveTimeSlot3.endDate).to(be(dateUtils.createDate(dateString: "2020/01/15 10:45")))
                    expect(tsveTimeSlot3.ownerTaskId.isEmpty).to(beFalse())
                    
                    expect(tsveTimeSlot4.occupancyType == TSOType.VACANT).to(beTrue())
                    expect(tsveTimeSlot4.startDate).to(be(dateUtils.createDate(dateString: "2020/01/15 10:45")))
                    expect(tsveTimeSlot4.endDate).to(be(dateUtils.createDate(dateString: "2020/01/16 00:00")))
                    expect(tsveTimeSlot4.ownerTaskId.isEmpty).to(beTrue())
                }
                
                it("should have empty oter if no task for day") {
                    let june15Start = dateUtils.createDate(dateString: "2020/01/15 00:00")
                    let june16Start = dateUtils.createDate(dateString: "2020/01/16 00:00")
                    
                    let emptyTaskItems = [String: ToDo]()
                    let sortedTaskDict = ToDoProcessUtils.sortToDoItemsByDate(toDoItems: emptyTaskItems)
                    
                    let dayTimeSpan = TimeSpan(startDate: june15Start, endDate: june16Start)
                    
                    tsve.setTaskItems(tasks: sortedTaskDict)
                    tsve.populateOtd(timeSpan: dayTimeSpan)
                    tsve.evaluateOtd(timeSpan: dayTimeSpan)
                    
                    let tsveTimeSlots = tsve.getOterAvailabilities()
                    
                    expect(tsve.getOterAvailabilities().count).to(be(1))
                    
                    expect(tsveTimeSlots[0].occupancyType == TSOType.VACANT).to(beTrue())
                    expect(tsveTimeSlots[0].startDate).to(be(june15Start))
                    expect(tsveTimeSlots[0].endDate).to(be(june16Start))
                    expect(tsveTimeSlots[0].ownerTaskId.isEmpty).to(beTrue())
                }
            }
        }
    }
}
