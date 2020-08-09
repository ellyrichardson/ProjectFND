//
//  ObservableTaskController.swift
//  ProjectFND
//
//  Created by Elly Richardson on 6/27/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import UIKit
import os.log


class ObservableTaskController {
    private var task = ObservableItem<ToDo>()
    
    // MARK: - Controller Essentials
    
    // For initial observers
    func haveObservables() -> Bool {
        if self.task.getObservers().count > 0 {
            return true
        }
        return false
    }
    
    func checkIfContainsObservable(observerId: Int) -> Bool {
        for observable in self.task.getObservers() {
            if observable.observerId == observerId {
                return true
            }
        }
        return false
    }
    
    // MARK: - Setters
    
    
    // NOTE: Must be called first thing for the controller
    func setupData() {
        self.task.observableType = ObservableType.TASK
        self.task.setValue(value: ToDo())
    }
    
    func setObservers(observers: [Observer]) {
        for observer in observers {
            if !checkIfContainsObservable(observerId: observer.observerId) {
                self.task.addObserver(observer: observer)
            }
        }
    }
    
    func getObservers() -> [Observer] {
        return self.task.getObservers()
    }
    
    // MARK: - Getters
    
    func getDueDate() -> ToDo {
        return self.task.getValue()
    }
    
    // MARK: - Controller Operation
    
    func updateTask(updatedTask: ToDo) {
        self.task.setValue(value: updatedTask)
    }
}
