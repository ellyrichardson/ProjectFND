//
//  ScheduleViewPresenterSpecs.swift
//  ProjectFNDTests
//
//  Created by Elly Richardson on 8/16/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import Quick
import Nimble
@testable import ProjectFND

class ScheduleViewPresenterSpecs: QuickSpec {
    
    override func spec() {
        var dateUtils = DateUtils()
        var taskPackager = TaskPackager()
        var mockScheduleViewDelegate: MockScheduleViewDelegate!
        var scheduleViewPresenter: ScheduleViewPresenter!
        var mockTaskService: MockTaskService!
        var taskItems: [String: ToDo]!
        
        let date1 = dateUtils.createDate(dateString: "2020/01/15 09:30")
        let date2 = dateUtils.createDate(dateString: "2020/01/15 11:00")
        
        describe("ScheduleViewPresenter") {
            
            // MARK: TASK UPDATE METHODS
            context("task update methods") {
                
                beforeEach {
                    taskItems = taskPackager.packageFiveTasksWithSimpleIDs()
                    mockScheduleViewDelegate = MockScheduleViewDelegate()
                    mockTaskService = MockTaskService()
                    mockTaskService.setTaskItems(taskItems: taskItems)
                    scheduleViewPresenter = ScheduleViewPresenter(taskService: mockTaskService)
                }
                
                it("should update task to important") {
                    let taskId = "task1"
                    let targetTask = mockTaskService.getToDosByDay(dateChosen: (taskItems[taskId]!.getStartTime()))[taskId]?.copy() as! ToDo
                    expect(targetTask.isImportant()).to(be(false))
                    
                    targetTask.important = true
                    scheduleViewPresenter.taskMarkedImportantOnDate(day: (targetTask.getStartTime()), tableRowIndex: 0)
                    
                    let resultTask = mockTaskService.getToDosByDay(dateChosen: (taskItems[taskId]!.getStartTime()))[taskId]
                    expect(resultTask?.isImportant()).to(be(true))
                }
                
                it("should update task that to UN-important") {
                    let taskId = "task1"
                    
                    mockTaskService.getToDosByDay(dateChosen: (taskItems[taskId]!.getStartTime()))[taskId]?.important = true
                    
                    let targetTask = mockTaskService.getToDosByDay(dateChosen: (taskItems[taskId]!.getStartTime()))[taskId]?.copy() as! ToDo
                    expect(targetTask.isImportant()).to(be(true))
                    
                    targetTask.important = false
                    scheduleViewPresenter.taskMarkedImportantOnDate(day: (targetTask.getStartTime()), tableRowIndex: 0)
                    
                    let resultTask = mockTaskService.getToDosByDay(dateChosen: (taskItems[taskId]!.getStartTime()))[taskId]
                    expect(resultTask?.isImportant()).to(be(false))
                }
                
                it("should update task that to finished") {
                    let taskId = "task1"
                    let targetTask = mockTaskService.getToDosByDay(dateChosen: (taskItems[taskId]!.getStartTime()))[taskId]?.copy() as! ToDo
                    expect(targetTask.isFinished()).to(be(false))
                    
                    targetTask.finished = true
                    scheduleViewPresenter.taskFinishedOnDate(day: (targetTask.getStartTime()), tableRowIndex: 0)
                    
                    let resultTask = mockTaskService.getToDosByDay(dateChosen: (taskItems[taskId]!.getStartTime()))[taskId]
                    expect(resultTask?.isFinished()).to(be(true))
                }
                
                it("should update task that to UN-finished") {
                    let taskId = "task1"
                    
                    mockTaskService.getToDosByDay(dateChosen: (taskItems[taskId]!.getStartTime()))[taskId]?.finished = true
                    
                    let targetTask = mockTaskService.getToDosByDay(dateChosen: (taskItems[taskId]!.getStartTime()))[taskId]?.copy() as! ToDo
                    expect(targetTask.isFinished()).to(be(true))
                    
                    targetTask.finished = false
                    scheduleViewPresenter.taskFinishedOnDate(day: (targetTask.getStartTime()), tableRowIndex: 0)
                    
                    let resultTask = mockTaskService.getToDosByDay(dateChosen: (taskItems[taskId]!.getStartTime()))[taskId]
                    expect(resultTask?.isFinished()).to(be(false))
                }
                
                it("should update task that to notifying") {
                    let taskId = "task1"
                    let targetTask = mockTaskService.getToDosByDay(dateChosen: (taskItems[taskId]!.getStartTime()))[taskId]?.copy() as! ToDo
                    expect(targetTask.isNotifying()).to(be(false))
                    
                    targetTask.notifying = true
                    scheduleViewPresenter.taskIsNotifyingOnDate(day: (targetTask.getStartTime()), tableRowIndex: 0)
                    
                    let resultTask = mockTaskService.getToDosByDay(dateChosen: (taskItems[taskId]!.getStartTime()))[taskId]
                    expect(resultTask?.isNotifying()).to(be(true))
                }
                
                it("should update task that to UN-notifying") {
                    let taskId = "task1"
                    
                    mockTaskService.getToDosByDay(dateChosen: (taskItems[taskId]!.getStartTime()))[taskId]?.notifying = true
                    
                    let targetTask = mockTaskService.getToDosByDay(dateChosen: (taskItems[taskId]!.getStartTime()))[taskId]?.copy() as! ToDo
                    expect(targetTask.isNotifying()).to(be(true))
                    
                    targetTask.notifying = false
                    scheduleViewPresenter.taskIsNotifyingOnDate(day: (targetTask.getStartTime()), tableRowIndex: 0)
                    
                    let resultTask = mockTaskService.getToDosByDay(dateChosen: (taskItems[taskId]!.getStartTime()))[taskId]
                    expect(resultTask?.isNotifying()).to(be(false))
                }
                
                it("should remove task") {
                    
                    let taskId = "task1"
                    let targetTask = mockTaskService.getToDosByDay(dateChosen: (taskItems[taskId]!.getStartTime()))[taskId]?.copy() as! ToDo
                    XCTAssertNotNil(targetTask)
                    
                    mockScheduleViewDelegate.selectedDate = targetTask.getStartTime()
                    scheduleViewPresenter.setViewDelegate(scheduleViewDelegate: mockScheduleViewDelegate)
                    scheduleViewPresenter.deleteTaskFromSystem(row: 0)
                    
                    let resultTask = mockTaskService.getToDosByDay(dateChosen: (taskItems[taskId]!.getStartTime()))[taskId]
                    expect(resultTask).to(beNil())
                }
            }
        }
    }
}
