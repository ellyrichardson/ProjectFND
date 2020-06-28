//
//  ObservableTagsController.swift
//  ProjectFND
//
//  Created by Elly Richardson on 5/31/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import UIKit
import os.log

class ObservableTagsController {
    private var toDoTag = ObservableItem<ToDoTags>()
    
    // MARK: - Controller Essentials
    
    // For initial observers
    func haveObservables() -> Bool {
        if self.toDoTag.getObservers().count > 0 {
            return true
        }
        return false
    }
    
    func checkIfContainsObservable(observerId: Int) -> Bool {
        for observable in self.toDoTag.getObservers() {
            if observable.observerId == observerId {
                return true
            }
        }
        return false
    }
    
    // MARK: - Setters
    
    
    // NOTE: Must be called first thing for the controller
    func setupData() {
        self.toDoTag.observableType = ObservableType.TODO_TAG
        self.toDoTag.setValue(value: ToDoTags(tagValue: "", assigned: false))
    }
    
    func setObservers(observers: [Observer]) {
        for observer in observers {
            if !checkIfContainsObservable(observerId: observer.observerId) {
                self.toDoTag.addObserver(observer: observer)
            }
        }
    }
    
    // MARK: - Getters
    
    func getTag() -> ToDoTags {
        return self.toDoTag.getValue()
    }
    
    // MARK: - Controller Operation
    
    func updateTag(updatedDate: ToDoTags) {
        self.toDoTag.setValue(value: updatedDate)
    }
}
