//
//  ObservableDateController.swift
//  ProjectFND
//
//  Created by Elly Richardson on 5/30/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import UIKit
import os.log

class ObservableDateController {
    private var dueDate = ObservableObject<Date>()
    
    // MARK: - Controller Essentials
    
    // For initial observers
    func haveObservables() -> Bool {
        if self.dueDate.getObservers().count > 0 {
            return true
        }
        return false
    }
    
    func checkIfContainsObservable(observerId: Int) -> Bool {
        for observable in self.dueDate.getObservers() {
            if observable.observerId == observerId {
                return true
            }
        }
        return false
    }
    
    // MARK: - Setters
    
    func setInitialValue() {
        self.dueDate.setValue(value: Date())
    }
    
    func setObservers(observers: [Observer]) {
        for observer in observers {
            if !checkIfContainsObservable(observerId: observer.observerId) {
                self.dueDate.addObserver(observer: observer)
            }
        }
    }
    
    // MARK: - Getters
    
    func getDueDate() -> Date {
        return self.dueDate.getValue()
    }
    
    // MARK: - Controller Operation
    
    func updateDate(updatedDate: Date) {
        self.dueDate.setValue(value: updatedDate)
    }
}
