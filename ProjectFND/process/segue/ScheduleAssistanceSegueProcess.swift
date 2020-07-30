//
//  SchedulingAssistanceSegueProcess.swift
//  ProjectFND
//
//  Created by Elly Richardson on 7/27/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import UIKit
import SwiftEntryKit
import os.log

class SchedulingAssistanceSegueProcess  {
    private var observableTaskController = ObservableTaskController()
    private var taskItem: ToDo?
    private var startTime: Date
    private var inQueueTask: ToDo
    private var inQueueTaskContainsNewValue: Bool
    private var taskItemsForSelectedDay: [String: ToDo]
    
    init?(taskItem: ToDo?, startTime: Date, inQueueTask: ToDo, inQueueTaskContainsNewValue: Bool, taskItemsForSelectedDay: [String: ToDo], observerVCs: [Observer]) {
        self.taskItem = taskItem
        self.startTime = startTime
        self.inQueueTask = inQueueTask
        self.inQueueTaskContainsNewValue = inQueueTaskContainsNewValue
        self.taskItemsForSelectedDay = taskItemsForSelectedDay
        
        self.observableTaskController.setupData()
        self.observableTaskController.setObservers(observers: observerVCs)
    }
    
    func segueToSchedulingAssistance(segue: UIStoryboardSegue) {
        guard let navigationController = segue.destination as? UINavigationController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
        let schedulingAstncViewController = navigationController.viewControllers.first as! SchedulingAssistanceViewController
        schedulingAstncViewController.setDayToAssist(dayDate: startTime)
        if taskItem == nil {
            configureSchedAstncForNewTask(vc: schedulingAstncViewController)
        }
        else {
            configureSchedAstncForExistingTask(vc: schedulingAstncViewController)
        }
        schedulingAstncViewController.setTargetTask(taskItem: inQueueTask)
        schedulingAstncViewController.setObservableTaskController(observableTaskController: observableTaskController)
    }
    
    private func configureSchedAstncForNewTask(vc: SchedulingAssistanceViewController) {
        vc.setTaskItems(taskItems: taskItemsForSelectedDay)
        
        // TODO: Refactor the having of TargetTaskJustCreated being set in this controller, to just setting it in the ToDo Task itself.
        if !self.inQueueTaskContainsNewValue {
            self.inQueueTask = ToDo(taskId: UUID().uuidString, taskName: "TEST_NAME", startTime: Date(), endTime: Date(), dueDate: Date(), finished: false)!
            vc.setTargetTaskJustCreated(targetTaskJustCreated: true)
        }
    }
    
    private func configureSchedAstncForExistingTask(vc: SchedulingAssistanceViewController) {
        vc.setTaskItems(taskItems: taskItemsForSelectedDay)
        // Need a copy so that this actual self.ToDo don't get updated in the next viewController and reflect on the main page
        if !inQueueTaskContainsNewValue {
            inQueueTask = self.taskItem!.copy() as! ToDo
        }
    }
}
