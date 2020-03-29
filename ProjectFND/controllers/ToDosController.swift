//
//  ToDoController.swift
//  ProjectFND
//
//  Created by Elly Richardson on 3/21/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import UIKit
import os.log

class ToDosController {
    private var toDos = ObservableList<ToDo>()
    
    // MARK: - Controller Essentials
    
    // For initial value
    func haveValues() -> Bool {
        if self.toDos.getValue().count > 0 {
            return true
        }
        return false
    }
    
    // For initial observers
    func haveObservables() -> Bool {
        if self.toDos.getObservers().count > 0 {
            return true
        }
        return false
    }
    
    func checkIfContainsObservable(observerId: Int) -> Bool {
        for observable in self.toDos.getObservers() {
            if observable.observerId == observerId {
                return true
            }
        }
        return false
    }
    
    // MARK: - Setters
    
    func setInitialToDos() {
        for items in ToDoProcessUtils.loadToDos()! {
            self.toDos.updateValue(modificationType: ListModificationType.ADD, elementId: items.taskId, element: items)
        }
    }
    
    func setObservers(observers: [Observer]) {
        for observer in observers {
            if !checkIfContainsObservable(observerId: observer.observerId) {
                self.toDos.addObserver(observer: observer)
            }
        }
    }
    
    // MARK: - Getters
    
    func getToDos() -> [String: ToDo] {
        if !haveValues() {
            setInitialToDos()
        }
        return self.toDos.getValue()
    }
    
    // MARK: - Controller Operations
    
    func updateToDo(modificationType: ListModificationType, toDo: ToDo) {
        switch modificationType {
        case .UPDATE:
            ToDoProcessUtils.updateToDo(toDoToUpdate: <#T##ToDo#>, newToDo: <#T##ToDo#>, updateType: <#T##Int#>)
            
        case .REMOVE:
            ToDoProcessUtils.deleteToDo(toDoToDelete: toDo)
        default:
            ToDoProcessUtils.saveToDos(toDoItem: toDo)
        }
        self.toDos.updateValue(modificationType: modificationType, elementId: toDo.taskId, element: toDo)
    }
}
