//
//  ScheduleViewPresenter.swift
//  ProjectFND
//
//  Created by Elly Richardson on 8/15/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import Foundation

class ScheduleViewPresenter {
    private let taskService: ToDosController
    weak private var scheduleViewDelegate: ScheduleViewDelegate?
    
    init(taskService: ToDosController) {
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
}
