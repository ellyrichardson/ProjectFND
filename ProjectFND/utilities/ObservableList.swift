//
//  ToDoListObservable.swift
//  ProjectFND
//
//  Created by Elly Richardson on 3/20/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import UIKit
import os.log

class ObservableList<T> : Observable {
    // The key is a string of the id of T
    private var _value: [String: T]! = nil
    private var _observers: [Observer] = []
    
    internal var value : [String: T] {
        get {
            return self._value
        }
        set {
            
            self._value = newValue
            self.notifyAllObservers(with: newValue)
        }
    }
    
    internal var observers : [Observer] {
        get {
            return self._observers
        }
        set {
            self._observers = newValue
        }
    }
    
    func setObservers(observers: [Observer]) {
        self.observers = observers
    }
    
    func getObservers() -> [Observer] {
        return self.observers
    }
    
    func addObserver(observer: Observer) {
        observers.append(observer)
    }
    
    func removeObserver(observer: Observer) {
        observers = observers.filter({$0.id != observer.id})
    }
    
    func notifyAllObservers<T>(with newValue: T) {
        for observer in observers {
            observer.update(with: newValue)
        }
    }
    
    func setValue(value: [String: T]) {
        self.value = value
    }
    
    func getValue() -> [String: T] {
        return self.value
    }
    
    func updateValue(modificationType: ListModificationType, elementId: String, element: T?) {
        switch modificationType {
        case .UPDATE:
            //if let oldValue = self._value.updateValue(element, forKey: elementId) {
            if let oldValue = self.value.updateValue(element!, forKey: elementId) {
                print("LOG: Updated element " + elementId)
            }
        case .REMOVE:
            if let oldValue = self.value.removeValue(forKey: elementId) {
                print("LOG: Updated element " + elementId)
            }
        default:
            //self._value[elementId] = element
            self.value[elementId] = element
            print("LOG: Added element " + elementId)
        }
    }
}
