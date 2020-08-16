//
//  TaskPackager.swift
//  ProjectFND
//
//  Created by Elly Richardson on 6/11/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import UIKit

class TaskPackager {
    private var dateUtils = DateUtils()
    func packageFiveTasksThatAreLessThanAnHourWithinADay() -> [String: ToDo] {
        var taskDict = [String: ToDo]()
        let task1 = ToDo(taskId: UUID().uuidString, taskName: "Test Task 1", startTime: dateUtils.createDate(dateString: "2020/01/15 09:30"), endTime: dateUtils.createDate(dateString: "2020/01/15 10:15"), dueDate: dateUtils.createDate(dateString: "2020/01/15 10:15"), finished: false)
        let task2 = ToDo(taskId: UUID().uuidString, taskName: "Test Task 2", startTime: dateUtils.createDate(dateString: "2020/01/15 10:15"), endTime: dateUtils.createDate(dateString: "2020/01/15 10:45"), dueDate: dateUtils.createDate(dateString: "2020/01/15 10:45"), finished: false)
        let task3 = ToDo(taskId: UUID().uuidString, taskName: "Test Task 3", startTime: dateUtils.createDate(dateString: "2020/01/15 11:15"), endTime: dateUtils.createDate(dateString: "2020/01/15 12:00"), dueDate: dateUtils.createDate(dateString: "2020/01/15 12:00"), finished: false)
        let task4 = ToDo(taskId: UUID().uuidString, taskName: "Test Task 4", startTime: dateUtils.createDate(dateString: "2020/01/15 13:00"), endTime: dateUtils.createDate(dateString: "2020/01/15 13:45"), dueDate: dateUtils.createDate(dateString: "2020/01/15 13:45"), finished: false)
        let task5 = ToDo(taskId: UUID().uuidString, taskName: "Test Task 5", startTime: dateUtils.createDate(dateString: "2020/01/15 13:45"), endTime: dateUtils.createDate(dateString: "2020/01/15 14:30"), dueDate: dateUtils.createDate(dateString: "2020/01/15 14:30"), finished: false)
        taskDict[(task1?.getTaskId())!] = task1
        taskDict[(task2?.getTaskId())!] = task2
        taskDict[(task3?.getTaskId())!] = task3
        taskDict[(task4?.getTaskId())!] = task4
        taskDict[(task5?.getTaskId())!] = task5
        
        return taskDict
    }
    
    func packageFiveTasksWithVaryingLengthForEveryOtherDay() -> [String: ToDo] {
        var taskDict = [String: ToDo]()
        let task1 = ToDo(taskId: UUID().uuidString, taskName: "Test Task 1", startTime: dateUtils.createDate(dateString: "2020/01/15 09:30"), endTime: dateUtils.createDate(dateString: "2020/01/15 10:15"), dueDate: dateUtils.createDate(dateString: "2020/01/15 10:15"), finished: false)
        let task2 = ToDo(taskId: UUID().uuidString, taskName: "Test Task 2", startTime: dateUtils.createDate(dateString: "2020/01/15 10:15"), endTime: dateUtils.createDate(dateString: "2020/01/15 10:45"), dueDate: dateUtils.createDate(dateString: "2020/01/15 10:45"), finished: false)
        let task3 = ToDo(taskId: UUID().uuidString, taskName: "Test Task 3", startTime: dateUtils.createDate(dateString: "2020/01/17 11:15"), endTime: dateUtils.createDate(dateString: "2020/01/17 12:00"), dueDate: dateUtils.createDate(dateString: "2020/01/17 12:00"), finished: false)
        let task4 = ToDo(taskId: UUID().uuidString, taskName: "Test Task 4", startTime: dateUtils.createDate(dateString: "2020/01/17 13:00"), endTime: dateUtils.createDate(dateString: "2020/01/17 13:45"), dueDate: dateUtils.createDate(dateString: "2020/01/17 13:45"), finished: false)
        let task5 = ToDo(taskId: UUID().uuidString, taskName: "Test Task 5", startTime: dateUtils.createDate(dateString: "2020/01/17 13:45"), endTime: dateUtils.createDate(dateString: "2020/01/17 14:30"), dueDate: dateUtils.createDate(dateString: "2020/01/17 14:30"), finished: false)
        taskDict[(task1?.getTaskId())!] = task1
        taskDict[(task2?.getTaskId())!] = task2
        taskDict[(task3?.getTaskId())!] = task3
        taskDict[(task4?.getTaskId())!] = task4
        taskDict[(task5?.getTaskId())!] = task5
        
        return taskDict
    }
    
    func packageFiveTasksWithSimpleIDs() -> [String: ToDo] {
        var taskDict = [String: ToDo]()
        let task1 = ToDo(taskId: "task1", taskName: "Test Task 1", startTime: dateUtils.createDate(dateString: "2020/01/15 09:30"), endTime: dateUtils.createDate(dateString: "2020/01/15 10:15"), dueDate: dateUtils.createDate(dateString: "2020/01/15 10:15"), finished: false)
        let task2 = ToDo(taskId: "task2", taskName: "Test Task 2", startTime: dateUtils.createDate(dateString: "2020/01/15 10:15"), endTime: dateUtils.createDate(dateString: "2020/01/15 10:45"), dueDate: dateUtils.createDate(dateString: "2020/01/15 10:45"), finished: false)
        let task3 = ToDo(taskId: "task3", taskName: "Test Task 3", startTime: dateUtils.createDate(dateString: "2020/01/17 11:15"), endTime: dateUtils.createDate(dateString: "2020/01/17 12:00"), dueDate: dateUtils.createDate(dateString: "2020/01/17 12:00"), finished: false)
        let task4 = ToDo(taskId: "task4", taskName: "Test Task 4", startTime: dateUtils.createDate(dateString: "2020/01/17 13:00"), endTime: dateUtils.createDate(dateString: "2020/01/17 13:45"), dueDate: dateUtils.createDate(dateString: "2020/01/17 13:45"), finished: false)
        let task5 = ToDo(taskId: "task5", taskName: "Test Task 5", startTime: dateUtils.createDate(dateString: "2020/01/17 13:45"), endTime: dateUtils.createDate(dateString: "2020/01/17 14:30"), dueDate: dateUtils.createDate(dateString: "2020/01/17 14:30"), finished: false)
        taskDict[(task1?.getTaskId())!] = task1
        taskDict[(task2?.getTaskId())!] = task2
        taskDict[(task3?.getTaskId())!] = task3
        taskDict[(task4?.getTaskId())!] = task4
        taskDict[(task5?.getTaskId())!] = task5
        
        return taskDict
    }
    
    func packageSingleHalfDayTask() -> [String: ToDo] {
        var taskDict = [String: ToDo]()
        let task1 = ToDo(taskId: UUID().uuidString, taskName: "Test Task 1", startTime: dateUtils.createDate(dateString: "2020/01/15 09:30"), endTime: dateUtils.createDate(dateString: "2020/01/15 21:30"), dueDate: dateUtils.createDate(dateString: "2020/01/15 21:30"), finished: false)
        taskDict[(task1?.getTaskId())!] = task1
        
        return taskDict
    }
    
    func packageSingleHalfDayTaskStarting12AM() -> [String: ToDo] {
        var taskDict = [String: ToDo]()
        let task1 = ToDo(taskId: UUID().uuidString, taskName: "Test Task 1", startTime: dateUtils.createDate(dateString: "2020/01/15 00:00"), endTime: dateUtils.createDate(dateString: "2020/01/15 12:00"), dueDate: dateUtils.createDate(dateString: "2020/01/15 12:00"), finished: false)
        taskDict[(task1?.getTaskId())!] = task1
        
        return taskDict
    }
    
    func packageSingleHalfDayTaskEnding12AMNextDay() -> [String: ToDo] {
        var taskDict = [String: ToDo]()
        let task1 = ToDo(taskId: UUID().uuidString, taskName: "Test Task 1", startTime: dateUtils.createDate(dateString: "2020/01/15 12:00"), endTime: dateUtils.createDate(dateString: "2020/01/16 00:00"), dueDate: dateUtils.createDate(dateString: "2020/01/16 00:00"), finished: false)
        taskDict[(task1?.getTaskId())!] = task1
        
        return taskDict
    }
    
    func packageSingleFullDayTask() -> [String: ToDo] {
        var taskDict = [String: ToDo]()
        let task1 = ToDo(taskId: UUID().uuidString, taskName: "Test Task 1", startTime: dateUtils.createDate(dateString: "2020/01/15 00:00"), endTime: dateUtils.createDate(dateString: "2020/01/16 00:00"), dueDate: dateUtils.createDate(dateString: "2020/01/16 00:00"), finished: false)
        taskDict[(task1?.getTaskId())!] = task1
        
        return taskDict
    }
    
    func packageThreeConsecutiveFullDayTasks() -> [String: ToDo] {
        var taskDict = [String: ToDo]()
        let task1 = ToDo(taskId: UUID().uuidString, taskName: "Test Task 1", startTime: dateUtils.createDate(dateString: "2020/01/15 00:00"), endTime: dateUtils.createDate(dateString: "2020/01/16 00:00"), dueDate: dateUtils.createDate(dateString: "2020/01/16 00:00"), finished: false)
        let task2 = ToDo(taskId: UUID().uuidString, taskName: "Test Task 2", startTime: dateUtils.createDate(dateString: "2020/01/16 00:00"), endTime: dateUtils.createDate(dateString: "2020/01/17 00:00"), dueDate: dateUtils.createDate(dateString: "2020/01/17 00:00"), finished: false)
        let task3 = ToDo(taskId: UUID().uuidString, taskName: "Test Task 3", startTime: dateUtils.createDate(dateString: "2020/01/17 00:00"), endTime: dateUtils.createDate(dateString: "2020/01/18 00:00"), dueDate: dateUtils.createDate(dateString: "2020/01/18 00:00"), finished: false)
        taskDict[(task1?.getTaskId())!] = task1
        taskDict[(task2?.getTaskId())!] = task2
        taskDict[(task3?.getTaskId())!] = task3
        
        return taskDict
    }
}
