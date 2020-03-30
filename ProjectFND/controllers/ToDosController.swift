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
            self.toDos.updateValue(modificationType: ListModificationType.ADD, elementId: items.value.getTaskId(), element: items.value)
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
    
    // MARK: - Getters
    
    func getToDosByDay(dateChosen: Date) -> [(key: String, value: ToDo)] {
        return ToDoProcessUtils.retrieveToDoItemsByDay(toDoDate: dateChosen, toDoItems: getToDos())
    }
    
    func getToDosByDayAsArray(dateChosen: Date) -> [ToDo] {
        var toDosByDay = [ToDo]()
        for toDo in getToDosByDay(dateChosen: dateChosen) {
            toDosByDay.append(toDo.value)
        }
        return toDosByDay
    }
    
    // NOTE: Formerly getToDoItemByIndex in ScheduleViewController
    // Gets ToDo item by its index in the base list.
    func getToDosByKey(toDoKey: String) -> ToDo {
        return self.toDos.getValue()[toDoKey]!
    }
    
    // MARK: - Controller Operations
    
    func updateToDos(modificationType: ListModificationType, toDo: ToDo) {
        switch modificationType {
        case .UPDATE:
            let toDoToUpdate = getToDos()[toDo.getTaskId()]
            if toDoToUpdate?.finished == toDo.finished {
                ToDoProcessUtils.updateToDo(toDoToUpdate: toDoToUpdate!, newToDo: toDo, updateType: 0)
            } else {
                ToDoProcessUtils.updateToDo(toDoToUpdate: toDoToUpdate!, newToDo: toDo, updateType: 1)
            }
        case .REMOVE:
            ToDoProcessUtils.deleteToDo(toDoToDelete: toDo)
        default:
            ToDoProcessUtils.saveToDos(toDoItem: toDo)
        }
        self.toDos.updateValue(modificationType: modificationType, elementId: toDo.getTaskId(), element: toDo)
    }
}
