//
//  ObservableTimespanController.swift
//  ProjectFND
//
//  Created by Elly Richardson on 6/20/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import UIKit
import os.log

class ObservableOterController {
    private var oter = ObservableItem<Oter>()
    
    // MARK: - Controller Essentials
    
    // For initial observers
    func haveObservables() -> Bool {
        if self.oter.getObservers().count > 0 {
            return true
        }
        return false
    }
    
    func checkIfContainsObservable(observerId: Int) -> Bool {
        for observable in self.oter.getObservers() {
            if observable.observerId == observerId {
                return true
            }
        }
        return false
    }
    
    // MARK: - Setters
    
    
    // NOTE: Must be called first thing for the controller
    func setupData() {
        self.oter.observableType = ObservableType.OTER
        self.oter.setValue(value: Oter(startDate: Date(), endDate: Date(), ownerTaskId: "default", occupancyType: TSOType.FILLER))
    }
    
    func setObservers(observers: [Observer]) {
        for observer in observers {
            if !checkIfContainsObservable(observerId: observer.observerId) {
                self.oter.addObserver(observer: observer)
            }
        }
    }
    
    func getObservers() -> [Observer] {
        return oter.getObservers()
    }
    
    // MARK: - Getters
    
    func getDueDate() -> Oter {
        return self.oter.getValue()
    }
    
    // MARK: - Controller Operation
    
    func updateOter(updatedOter: Oter) {
        self.oter.setValue(value: updatedOter)
    }
}
