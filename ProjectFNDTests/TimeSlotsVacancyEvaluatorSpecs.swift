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
        //var taskList: [ToDo]!
        var taskPackager: TaskPackager!
        var tsve: TimeSlotsVacancyEvaluator!
        var dateUtils: DateUtils!
        
        describe("otd") {
            context("populating") {
                
                beforeEach {
                    taskPackager = TaskPackager()
                    tsve = TimeSlotsVacancyEvaluator()
                    dateUtils = DateUtils()
                }
                
                it("should have appropriate otd for 5 tasks within a day") {
                    let keyFor9AM = "09 AM"
                    let keyFor10AM = "10 AM"
                    let keyFor11AM = "11 AM"
                    let keyFor01PM = "01 PM"
                    
                    let june15Start = dateUtils.createDate(dateString: "2020/01/15 00:00")
                    let june16Start = dateUtils.createDate(dateString: "2020/01/16 00:00")
                    
                    let taskItems = taskPackager.packageFiveTasksThatAreLessThanAnHourWithinADay()
                    let sortedTaskDict = ToDoProcessUtils.sortToDoItemsByDate(toDoItems: taskItems)
                    
                    tsve.setTaskItems(tasks: sortedTaskDict)
                    tsve.populateOtd(timeSpanStart: june15Start, timeSpanEnd: june16Start)
                    
                    expect(tsve.getOtd().count).to(be(4))
                    
                    expect(tsve.getOtd()[keyFor9AM]?.count).to(be(1))
                    expect(tsve.getOtd()[keyFor9AM]?[0].getStartDate()).to(be(dateUtils.createDate(dateString: "2020/01/15 09:30")))
                    expect(tsve.getOtd()[keyFor9AM]?[0].getEndDate()).to(be(dateUtils.createDate(dateString: "2020/01/15 10:15")))
                    
                    expect(tsve.getOtd()[keyFor10AM]?.count).to(be(1))
                    expect(tsve.getOtd()[keyFor10AM]?[0].getStartDate()).to(be(dateUtils.createDate(dateString: "2020/01/15 10:15")))
                    expect(tsve.getOtd()[keyFor10AM]?[0].getEndDate()).to(be(dateUtils.createDate(dateString: "2020/01/15 10:45")))
                    
                    expect(tsve.getOtd()[keyFor11AM]?.count).to(be(1))
                    expect(tsve.getOtd()[keyFor11AM]?[0].getStartDate()).to(be(dateUtils.createDate(dateString: "2020/01/15 11:15")))
                    expect(tsve.getOtd()[keyFor11AM]?[0].getEndDate()).to(be(dateUtils.createDate(dateString: "2020/01/15 12:00")))
                    
                    expect(tsve.getOtd()[keyFor01PM]?.count).to(be(2))
                    expect(tsve.getOtd()[keyFor01PM]?[0].getStartDate()).to(be(dateUtils.createDate(dateString: "2020/01/15 13:00")))
                    expect(tsve.getOtd()[keyFor01PM]?[0].getEndDate()).to(be(dateUtils.createDate(dateString: "2020/01/15 13:45")))
                    expect(tsve.getOtd()[keyFor01PM]?[1].getStartDate()).to(be(dateUtils.createDate(dateString: "2020/01/15 13:45")))
                    expect(tsve.getOtd()[keyFor01PM]?[1].getEndDate()).to(be(dateUtils.createDate(dateString: "2020/01/15 14:30")))
                }
                
                it("should have empty otd if no task for day") {
                    let june15Start = dateUtils.createDate(dateString: "2020/01/15 00:00")
                    let june16Start = dateUtils.createDate(dateString: "2020/01/16 00:00")
                    
                    let emptyTaskItems = [String: ToDo]()
                    let sortedTaskDict = ToDoProcessUtils.sortToDoItemsByDate(toDoItems: emptyTaskItems)
                    
                    tsve.setTaskItems(tasks: sortedTaskDict)
                    tsve.populateOtd(timeSpanStart: june15Start, timeSpanEnd: june16Start)
                    
                    expect(tsve.getOtd()).to(beEmpty())
                }
            }
            
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
                    
                    tsve.setTaskItems(tasks: sortedTaskDict)
                    tsve.populateOtd(timeSpanStart: june15Start, timeSpanEnd: june16Start)
                    tsve.evaluateOtd(timeSpanStart: june15Start, timeSpanEnd: june16Start)
                    
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
                
                it("should have empty oter if no task for day") {
                    let june15Start = dateUtils.createDate(dateString: "2020/01/15 00:00")
                    let june16Start = dateUtils.createDate(dateString: "2020/01/16 00:00")
                    
                    let emptyTaskItems = [String: ToDo]()
                    let sortedTaskDict = ToDoProcessUtils.sortToDoItemsByDate(toDoItems: emptyTaskItems)
                    
                    tsve.setTaskItems(tasks: sortedTaskDict)
                    tsve.populateOtd(timeSpanStart: june15Start, timeSpanEnd: june16Start)
                    tsve.evaluateOtd(timeSpanStart: june15Start, timeSpanEnd: june16Start)
                    
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
