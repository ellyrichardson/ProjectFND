//
//  ToDoProcessHelper.swift
//  ProjectFND
//
//  Created by Elly Richardson on 9/12/19.
//  Copyright © 2019 EllyRichardson. All rights reserved.
//

import CoreData
import UIKit
import os.log

class ToDoProcessUtils {
    /*
    static func sortedToDoKeys(isOrderedBefore:(String, String) -> Bool) -> [String] {
        return Array(self.keys).sort(isOrderedBefore)
    }
 
 */
    
    // Sorts ToDo items by date
    static func sortToDoItemsByDate(toDoItems: [String: ToDo]) -> [(key: String, value: ToDo)] {
        let toDosToBeSorted = toDoItems
        // Converts dictionary to sorted tuples
        let sortedToDos = toDosToBeSorted.sorted{
            return $1.value.getStartDate() > $0.value.getStartDate()
        }
        // Converts sorted tuples to sorted dictionary
        //return sortedToDos.reduce(into: [:]) { $0[$1.0] = $1.1 }
        return sortedToDos
    }
    
    /*
    static func retrieveToDosAsSortedTuples(toDoItems: [String: ToDo]) -> [(key: String, value: ToDo)] {
        let toDosToBeSorted = toDoItems
        // Converts dictionary to sorted tuples
        let sortedToDos = toDosToBeSorted.sorted{
            return $1.value.getStartDate() > $0.value.getStartDate()
        }
        return sortedToDos
    }*/
    
    /*
    // Gets ToDo items that meets the day selected in calendar
    static func retrieveSortedToDoItemsByDay(toDoDate: Date, toDoItems: [String: ToDo]) -> [(key: String, value: ToDo)] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d/yy"
        var matchedToDosByDate: [String: ToDo] = [String: ToDo]()

        let toDoKeys = toDoItems // This is a [String:int] dictionary
            .filter { (k, v) -> Bool in dateFormatter.string(from: v.getStartDate()) == dateFormatter.string(from: toDoDate) }
            .map { (k, v) -> String in k }
        
        for toDoKey in toDoKeys {
            matchedToDosByDate[toDoKey] = toDoItems[toDoKey]
        }
        
        
        return sortToDoItemsByDate(toDoItems: matchedToDosByDate)
    }
 */
    
    // Gets ToDo items that meets the day selected in calendar
    static func retrieveToDoItemsByDay(toDoDate: Date, toDoItems: [String: ToDo]) -> [String: ToDo] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d/yy"
        var matchedToDosByDate: [String: ToDo] = [String: ToDo]()
        
        let toDoKeys = toDoItems // This is a [String:int] dictionary
            .filter { (k, v) -> Bool in dateFormatter.string(from: v.getStartDate()) == dateFormatter.string(from: toDoDate) }
            .map { (k, v) -> String in k }
        
        for toDoKey in toDoKeys {
            matchedToDosByDate[toDoKey] = toDoItems[toDoKey]
        }
        
        return matchedToDosByDate
        
        
        //return sortToDoItemsByDate(toDoItems: matchedToDosByDate)
    }
    
    static func loadToDos() -> [String: ToDo]? {
        var loadedToDos: [String: ToDo] = [String: ToDo]()
        var loadedToDo: ToDo?
        
        // Container is set up in the AppDelegate so it needs to refer to that container.
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        // Context needs to be created in this container
        let managedContext = appDelegate!.persistentContainer.viewContext
        
        // Prepare the request of type NSTypeRequest for the entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "IOS_ToDos")
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            
            
            
            // If result is not empty,
            if result.count > 0 {
                for toDo in result as! [NSManagedObject] {
                    let taskId = toDo.value(forKey: "taskId") as! String
                    loadedToDo = ToDo(taskId: taskId, taskName: toDo.value(forKey: "taskName") as! String, taskType: toDo.value(forKey: "taskType") as! String, taskDescription: toDo.value(forKey: "taskDescription") as! String, workDate: toDo.value(forKey: "startDate") as! Date, estTime: toDo.value(forKey: "estTime") as! String, dueDate: toDo.value(forKey: "dueDate") as! Date, finished: (toDo.value(forKey: "finished") as! Bool), intervalized: (toDo.value(forKey: "intervalized") as! Bool), intervalId: toDo.value(forKey: "intervalId") as! String, intervalLength: Int(toDo.value(forKey: "intervalLength") as! String)!, intervalIndex: Int(toDo.value(forKey: "intervalIndex") as! String)!, intervalDueDate: toDo.value(forKey: "intervalDueDate") as! Date)
                    loadedToDos[taskId] = loadedToDo
                }
            }
        } catch {
            os_log("Loading of a ToDo from SQLite didn't work", log: OSLog.default, type: .debug)
        }
        
        
        
        return loadedToDos
    }
    
    static func saveToDos(toDoItem: ToDo) {
        // Container is set up in the AppDelegate so it needs to refer to that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else  { return }
        
        // Context needs to be created in this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // Create an entity and new ToDo records
        let toDoEntity = NSEntityDescription.entity(forEntityName: "IOS_ToDos", in: managedContext)
        
        // Adding data to newly created record
        let toDoToSave = NSManagedObject(entity: toDoEntity!, insertInto: managedContext)
        toDoToSave.setValue(toDoItem.taskId, forKey: "taskId")
        toDoToSave.setValue(toDoItem.taskName, forKey: "taskName")
        toDoToSave.setValue(toDoItem.taskType, forKey: "taskType")
        toDoToSave.setValue(toDoItem.taskDescription, forKey: "taskDescription")
        toDoToSave.setValue(toDoItem.estTime, forKey: "estTime")
        toDoToSave.setValue(toDoItem.workDate, forKey: "startDate")
        toDoToSave.setValue(toDoItem.dueDate, forKey: "dueDate")
        toDoToSave.setValue(toDoItem.finished, forKey: "finished")
        toDoToSave.setValue(toDoItem.intervalized, forKey: "intervalized")
        toDoToSave.setValue(toDoItem.intervalId, forKey: "intervalId")
        toDoToSave.setValue(toDoItem.intervalLength, forKey: "intervalLength")
        toDoToSave.setValue(toDoItem.intervalIndex, forKey: "intervalIndex")
        toDoToSave.setValue(toDoItem.intervalDueDate, forKey: "intervalDueDate")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    static func updateToDo(toDoToUpdate: ToDo, newToDo: ToDo, updateType: Int) {
        // Container is set up in the AppDelegate so it needs to refer to that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else  { return }
        
        // Context needs to be created in this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "IOS_ToDos")
        
        // Assigning different filters for the ToDo to be updated
        let taskIdPredicate = NSPredicate(format: "taskId = %@", toDoToUpdate.taskId)
        let taskNamePredicate = NSPredicate(format: "taskName = %@", toDoToUpdate.taskName)
        let taskTypePredicate = NSPredicate(format: "taskType = %@", toDoToUpdate.taskType)
        let taskDescriptionPredicate = NSPredicate(format: "taskDescription = %@", toDoToUpdate.taskDescription)
        let estTimePredicate = NSPredicate(format: "estTime = %@", toDoToUpdate.estTime)
        let startDatePredicate = NSPredicate(format: "startDate == %@", toDoToUpdate.workDate as NSDate)
        let dueDatePredicate = NSPredicate(format: "dueDate == %@", toDoToUpdate.dueDate as NSDate)
        var statusPredicate = NSPredicate(format: "finished = %d", toDoToUpdate.finished)
        let intervalizedPredicate = NSPredicate(format: "intervalized = %@", toDoToUpdate.isIntervalized())
        let intervalIdPredicate = NSPredicate(format: "intervalId = %@", toDoToUpdate.getIntervalId())
        let intervalLengthPredicate = NSPredicate(format: "intervalLength = %@", toDoToUpdate.getIntervalLength())
        let intervalIndexPredicate = NSPredicate(format: "intervalIndex = %@", toDoToUpdate.getIntervalIndex())
        let intervalDueDatePredicate = NSPredicate(format: "intervalDueDate == %@", toDoToUpdate.intervalDueDate as NSDate)
        
        if updateType == 1 {
            statusPredicate = NSPredicate(format: "finished = %d", !toDoToUpdate.finished)
        }
        
        // Combines different filters to one filter
        let propertiesPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [taskIdPredicate, taskNamePredicate, taskTypePredicate, taskDescriptionPredicate, estTimePredicate, startDatePredicate, dueDatePredicate, statusPredicate, intervalizedPredicate, intervalIdPredicate, intervalLengthPredicate, intervalIndexPredicate, intervalDueDatePredicate])
        
        fetchRequest.predicate = propertiesPredicate
        
        do {
            let toDoItem = try managedContext.fetch(fetchRequest)
            
            let objectUpdate = toDoItem[0] as! NSManagedObject
            objectUpdate.setValue(newToDo.taskId, forKey: "taskId")
            objectUpdate.setValue(newToDo.taskName, forKey: "taskName")
            objectUpdate.setValue(newToDo.taskType, forKey: "taskType")
            objectUpdate.setValue(newToDo.taskDescription, forKey: "taskDescription")
            objectUpdate.setValue(newToDo.estTime, forKey: "estTime")
            objectUpdate.setValue(newToDo.workDate, forKey: "startDate")
            objectUpdate.setValue(newToDo.dueDate, forKey: "dueDate")
            objectUpdate.setValue(newToDo.finished, forKey: "finished")
            objectUpdate.setValue(newToDo.intervalized, forKey: "intervalized")
            objectUpdate.setValue(newToDo.intervalId, forKey: "intervalId")
            objectUpdate.setValue(newToDo.intervalLength, forKey: "intervalLength")
            objectUpdate.setValue(newToDo.intervalIndex, forKey: "intervalIndex")
            objectUpdate.setValue(newToDo.intervalDueDate, forKey: "intervalDueDate")
            
            do {
                try managedContext.save()
            } catch {
                os_log("Could not update ToDo.", log: OSLog.default, type: .debug)
            }
        } catch {
            os_log("Could not fetch ToDos.", log: OSLog.default, type: .debug)
        }
    }
    
    static func deleteToDo(toDoToDelete: ToDo) {
        // Container is set up in the AppDelegate so it needs to refer to that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else  { return }
        
        // Context needs to be created in this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "IOS_ToDos")
        
        // Assigning different filters for the ToDo to be updated
        let taskIdPredicate = NSPredicate(format: "taskId = %@", toDoToDelete.taskId)
        let taskNamePredicate = NSPredicate(format: "taskName = %@", toDoToDelete.taskName)
        let taskTypePredicate = NSPredicate(format: "taskType = %@", toDoToDelete.taskType)
        let taskDescriptionPredicate = NSPredicate(format: "taskDescription = %@", toDoToDelete.taskDescription)
        let estTimePredicate = NSPredicate(format: "estTime = %@", toDoToDelete.estTime)
        let startDatePredicate = NSPredicate(format: "startDate == %@", toDoToDelete.workDate as NSDate)
        let dueDatePredicate = NSPredicate(format: "dueDate == %@", toDoToDelete.dueDate as NSDate)
        let statusPredicate = NSPredicate(format: "finished = %d", toDoToDelete.finished)
        let intervalizedPredicate = NSPredicate(format: "intervalized = %@", toDoToDelete.isIntervalized())
        let intervalIdPredicate = NSPredicate(format: "intervalId = %@", toDoToDelete.getIntervalId())
        let intervalLengthPredicate = NSPredicate(format: "intervalLength = %@", toDoToDelete.getIntervalLength())
        let intervalIndexPredicate = NSPredicate(format: "intervalIndex = %@", toDoToDelete.getIntervalIndex())
        let intervalDueDatePredicate = NSPredicate(format: "intervalDueDate == %@", toDoToDelete.intervalDueDate as NSDate)
        
        // Combines different filters to one filter
        let propertiesPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [taskIdPredicate, taskNamePredicate, taskTypePredicate, taskDescriptionPredicate, estTimePredicate, startDatePredicate, dueDatePredicate, statusPredicate, intervalizedPredicate, intervalIdPredicate, intervalLengthPredicate, intervalIndexPredicate, intervalDueDatePredicate])
        
        fetchRequest.predicate = propertiesPredicate
        
        do {
            let toDoItem = try managedContext.fetch(fetchRequest)
            print("ToDo Items length")
            print(toDoItem.count)
            let objectToDelete = toDoItem[0] as! NSManagedObject
            managedContext.delete(objectToDelete)
            
            do {
                try managedContext.save()
            } catch {
                os_log("Could not delete ToDo.", log: OSLog.default, type: .debug)
            }
        } catch {
            os_log("Could not fetch ToDos.", log: OSLog.default, type: .debug)
        }
    }
    
    static func addToDoItem(toDoItemToAdd: ToDo, toDoItemCollection: inout [String: ToDo]) {
        toDoItemCollection[toDoItemToAdd.taskId] = toDoItemToAdd
    }
    
    static func removeToDoItem(toDoItemToRemove: ToDo, toDoItemCollection: inout [String: ToDo]) {
        toDoItemCollection.removeValue(forKey: toDoItemToRemove.taskId)
    }
    
    static func addSelectedIndexPath(indexPath: IndexPath, selectedIndexPaths: inout [IndexPath]) {
        selectedIndexPaths.append(indexPath)
    }
    
    // NOTE: Formerly addToDoArrayToAToDoArray
    static func addToDoArrayToAToDoArray(toDoDictionary: inout [String: ToDo], toDosToBeAdded: [String: ToDo]) {
        toDosToBeAdded.forEach { (k,v) in toDoDictionary[k] = v }
    }
    
    static func removeSelectedIndexPath(indexPathAsInt: Int, selectedIndexPaths: inout [IndexPath]) {
        selectedIndexPaths.remove(at: indexPathAsInt)
    }
    
    static func removeAllSelectedIndexPaths(selectedIndexPaths: inout [IndexPath]) {
        selectedIndexPaths.removeAll()
    }
    
    static func retrieveIntervalizedToDosLeadById(toDoItems: [String: ToDo], intervalizedToDoId: String) -> ToDo {
        var intervalizedToDosLead: ToDo = ToDo()
        
        let toDoKeys = toDoItems // This is a [String: int] dictionary
            .filter { (k, v) -> Bool in v.getIntervalId() == intervalizedToDoId  && v.getIntervalIndex()  == 0}
            .map { (k, v) -> String in k }
        
        for toDoKey in toDoKeys {
            // 0 indexes in intervals are the leads
            let candidate = toDoItems[toDoKey]
            if candidate?.getIntervalIndex() == 0 {
                intervalizedToDosLead = candidate!
            }
        }
        
        return intervalizedToDosLead
    }
    
    static func retrieveIntervalizedToDosById(toDoItems: [String: ToDo], intervalizedTodoId: String) -> [String: ToDo] {
        var intervalizedToDosGroupedById: [String: ToDo] = [String: ToDo]()
        
        let toDoKeys = intervalizedToDosGroupedById // This is a [String: int] dictionary
            .filter { (k, v) -> Bool in v.getIntervalId() == intervalizedTodoId}
            .map { (k, v) -> String in k }
        
        for toDoKey in toDoKeys {
            intervalizedToDosGroupedById[toDoKey] = toDoItems[toDoKey]
        }
        
        return intervalizedToDosGroupedById
    }
    
    static func retrieveAllIntervalizedTodos(toDoItems: [String: ToDo]) -> [String: ToDo] {
        var intervalizedToDos: [String: ToDo] = [String: ToDo]()
        
        /*
        let toDoKeys = toDoItems // This is a [String: int] dictionary
            .filter { (k, v) -> Bool in v.getIntervalId() != ""}
            .map { (k, v) -> String in k }*/
        
        intervalizedToDos = toDoItems.filter { $0.value.getIntervalId() != "" && $0.value.getIntervalIndex() == 0 }
        
        /*
        for toDoKey in toDoKeys {
            intervalizedToDos[toDoKey] = toDoItems[toDoKey]
        }*/
        
        return intervalizedToDos
    }
    
    /*
    // Retrieves the index of the ToDo from the base ToDo List instead of by day
    static func retrieveRealIndexOfToDo(toDoItem: ToDo, toDoItemCollection: [String: ToDo]) -> Int {
        let toDoItems: [String: ToDo] = toDoItemCollection
        let retrievedIndex: Int = toDoItems.firstIndex(of: toDoItem)!
        return retrievedIndex
    }
    
    // Replaces a ToDo item based on its index from an array
    static func replaceToDoItemInBaseList(editedToDoItem: ToDo, editedToDoItemIndex: Int, toDoItemCollection: inout [String: ToDo]) {
        //self.toDos[editedToDoItemIndex] = editedToDoItem
        removeToDoItem(toDoItemIndexToRemove: editedToDoItemIndex, toDoItemCollection: &toDoItemCollection)
        addToDoItem(toDoItemToAdd: editedToDoItem, toDoItemCollection: &toDoItemCollection)
    }*/
}
