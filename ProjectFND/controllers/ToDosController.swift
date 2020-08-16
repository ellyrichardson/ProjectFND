//
//  ToDoController.swift
//  ProjectFND
//
//  Created by Elly Richardson on 3/21/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import UIKit
import os.log

// This is a service
class ToDosController: TaskServiceProtocol {
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
        // NOTE: ToDos' value must be set up first.
        self.toDos.setValue(value: [String: ToDo]())
        for items in ToDoProcessUtils.loadToDos()! {
            self.toDos.updateValue(modificationType: ListModificationType.ADD, elementId: items.value.getTaskId(), element: items.value)
        }
    }
    
    func setInitialDummyToDos() {
        var theString = UUID().uuidString
        let dummyToDo = ToDo(taskId: theString, taskName: "Dummy stuff", startTime: Date(), endTime: Date(), dueDate: Date(), finished: false)
        var keyValueDummy: [String: ToDo] = [String: ToDo]()
        keyValueDummy[dummyToDo!.getTaskId()] = dummyToDo
        self.toDos.setValue(value: keyValueDummy)
        updateToDos(modificationType: ListModificationType.ADD, toDo: dummyToDo!)
        var itemz =  ToDoProcessUtils.loadToDos()
        var loadedToDo = [String:ToDo]()
        loadedToDo[theString] = itemz![theString]
        print("LOADED TODOS")
        self.toDos.setValue(value: loadedToDo)
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
    
    func getToDosByDay(dateChosen: Date) -> [String: ToDo] {
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
    
    // TODO: Unit test for this function (Working as of 04/02/20)
    func updateToDos(modificationType: ListModificationType, toDo: ToDo) {
        switch modificationType {
        case .UPDATE:
            let toDoToUpdate = getToDos()[toDo.getTaskId()]
            ToDoProcessUtils.updateToDo(toDoToUpdate: toDoToUpdate!, newToDo: toDo, updateType: 0)
        case .REMOVE:
            let toDoToDelete = getToDos()[toDo.getTaskId()]
            ToDoProcessUtils.deleteToDo(toDoToDelete: toDoToDelete!)
        case .FINISHNESS:
            let toDoToUpdate = getToDos()[toDo.getTaskId()]
            toDo.finished = !toDo.finished
            ToDoProcessUtils.updateToDo(toDoToUpdate: toDoToUpdate!, newToDo: toDo, updateType: 1)
        case .IMPORTANT:
            let toDoToUpdate = getToDos()[toDo.getTaskId()]
            toDo.important = !toDo.important
            ToDoProcessUtils.updateToDo(toDoToUpdate: toDoToUpdate!, newToDo: toDo, updateType: 2)
        case .NOTIFICATION:
            let toDoToUpdate = getToDos()[toDo.getTaskId()]
            toDo.notifying = !toDo.notifying
            ToDoProcessUtils.updateToDo(toDoToUpdate: toDoToUpdate!, newToDo: toDo, updateType: 3)
        default:
            ToDoProcessUtils.saveToDos(toDoItem: toDo)
        }
        self.toDos.updateValue(modificationType: modificationType, elementId: toDo.getTaskId(), element: toDo)
    }
}
