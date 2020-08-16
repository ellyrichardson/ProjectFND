//
//  ScheduleViewPresenter.swift
//  ProjectFND
//
//  Created by Elly Richardson on 8/15/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import Foundation

class ScheduleViewPresenter {
    private let taskService: TaskServiceProtocol
    weak private var scheduleViewDelegate: ScheduleViewDelegate?
    
    init(taskService: TaskServiceProtocol) {
        self.taskService = taskService
        //self.taskService.setInitialToDos()
        configureTaskService()
    }
    
    private func configureTaskService() {
        taskService.setInitialToDos()
        var observerVCList: [Observer] = [Observer]()
        //Fix these commented out items later
        //let barViewController = scheduleViewDelegate?.getTabBarController()
        //let nav1 = barViewController!.viewControllers?[1] as! UINavigationController
        //let statusViewController = nav1.topViewController as! ParentStatusViewController
        //statusViewController.setToDosController(toDosController: toDosController)
        //observerVCList.append(statusViewController)
        //self.toDosController.setObservers(observers: observerVCList)
    }
    
    private func configureConnectionToOtherPresenter() {
        
    }
    
    func setViewDelegate(scheduleViewDelegate: ScheduleViewDelegate) {
        self.scheduleViewDelegate = scheduleViewDelegate
        configureViewDelegate()
    }
    
    private func configureViewDelegate() {
        //scheduleViewDelegate?.setTaskTableViewRowCount(rowCount: getTasksOnSelectedDay().count)
    }
    
    func deleteTaskFromSystem(row: Int) {
        let taskToBeDeleted = getSortedTasksByDateOnSelectedDay()[row]
        taskService.updateToDos(modificationType: ListModificationType.REMOVE, toDo: taskToBeDeleted.value)
    }
    
    func getTasksOnTargetDate(targetDate: Date) -> [String : ToDo] {
        return taskService.getToDosByDay(dateChosen: targetDate)
    }
    
    func getTasksOnSelectedDay() -> [String : ToDo] {
        return getTasksOnTargetDate(targetDate: (scheduleViewDelegate?.getSelectedDate())!)
    }
    
    func getSortedTasksByDateOnTargetDate(targetDate: Date) -> [(key: String, value: ToDo)] {
        return ToDoProcessUtils.sortToDoItemsByDate(toDoItems: getTasksOnTargetDate(targetDate: targetDate))
    }
    
    func getSortedTasksByDateOnSelectedDay() -> [(key: String, value: ToDo)] {
        return ToDoProcessUtils.sortToDoItemsByDate(toDoItems: getTasksOnSelectedDay())
    }
    
    func taskUpdated(taskItem: ToDo) {
        taskService.updateToDos(modificationType: ListModificationType.UPDATE, toDo: taskItem)
    }
    
    func taskAdded(taskItem: ToDo) {
        taskService.updateToDos(modificationType: ListModificationType.ADD, toDo: taskItem)
    }
    
    func taskFinishedOnDate(day: Date, tableRowIndex: Int) {
        let tasksByDay = getSortedTasksByDateOnTargetDate(targetDate: day)
        let tempTaskItem: ToDo = tasksByDay[tableRowIndex].value
        let newTaskItem = tempTaskItem
        
        taskService.updateToDos(modificationType: ListModificationType.FINISHNESS, toDo: newTaskItem)
    }
    
    func taskMarkedImportantOnDate(day: Date, tableRowIndex: Int) {
        let tasksByDay = getSortedTasksByDateOnTargetDate(targetDate: day)
        let tempTaskItem: ToDo = tasksByDay[tableRowIndex].value
        let newTaskItem = tempTaskItem
        
        taskService.updateToDos(modificationType: ListModificationType.IMPORTANT, toDo: newTaskItem)
    }
    
    func taskIsNotifyingOnDate(day: Date, tableRowIndex: Int) {
        let tasksByDay = getSortedTasksByDateOnTargetDate(targetDate: day)
        let tempTaskItem: ToDo = tasksByDay[tableRowIndex].value
        let newTaskItem = tempTaskItem
        
        taskService.updateToDos(modificationType: ListModificationType.NOTIFICATION, toDo: newTaskItem)
    }
    
    func checkTasksForCalendarCellIndicatorsForDay(targetDate: Date) {
        
        // Gets the Tasks based on the target date
        let tasksForTheDay = getTasksOnTargetDate(targetDate: targetDate)
        
        // Checks if these kinds of Tasks exist for the target date.
        /*
         Task will be identified as onProgress if due date is not set
         */
        let onProgressTask = tasksForTheDay.first(where: {(Date() < $0.value.getDueDate() || !$0.value.isDueDateSet()) && !$0.value.isFinished() })
        let finishedTask = tasksForTheDay.first(where: {$0.value.isFinished() == true})
        let overdueTask = tasksForTheDay.first(where: {(Date() > $0.value.getDueDate() && !$0.value.isFinished()) && $0.value.isDueDateSet()})
        
        // Sets boolean variables if types of Tasks exist.
        if onProgressTask != nil {
            scheduleViewDelegate?.setOnProgressTaskExist(exists: true)
        }
        else {
            scheduleViewDelegate?.setOnProgressTaskExist(exists: false)
        }
        
        if finishedTask != nil {
            scheduleViewDelegate?.setFinishedTaskExist(exists: true)
        }
        else {
            scheduleViewDelegate?.setFinishedTaskExist(exists: false)
        }
        
        if overdueTask != nil {
            scheduleViewDelegate?.setOverdueTaskExist(exists: true)
        }
        else {
            scheduleViewDelegate?.setOverdueTaskExist(exists: false)
        }
    }
    
    func getTasksToDisplay() {
        let tasksToDisplay = convertTasksOfDayToScheduleViewData(taskItems: getSortedTasksByDateOnSelectedDay())
        scheduleViewDelegate?.setScheduleTableViewDataForDay(sData: tasksToDisplay)
    }
    
    func convertTasksOfDayToScheduleViewData(taskItems: [(key: String, value: ToDo)]) -> [ScheduleViewData] {
        var tasksForDisplay = [ScheduleViewData]()
        for task in taskItems {
            let taskValue = task.value
            let timeSpan = TimeSpan(startDate: taskValue.getStartTime(), endDate: taskValue.getEndTime())
            let dueDateStatus = ToDoDate(dateValue: taskValue.getDueDate(), assigned: taskValue.isDueDateSet())
            tasksForDisplay.append(ScheduleViewData(taskName: taskValue.getTaskName(), taskTag: taskValue.getTaskTag(), timeSpan: timeSpan, dueDate: dueDateStatus, finished: taskValue.isFinished(), important: taskValue.isImportant(), notifying: taskValue.isNotifying()))
        }
        return tasksForDisplay
    }
}
