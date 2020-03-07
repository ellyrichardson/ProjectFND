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
    // Sorts ToDo items by date
    static func sortToDoItemsByDate(toDoItems: [ToDo]) -> [ToDo] {
        var toDosToBeSorted = toDoItems
        toDosToBeSorted = toDosToBeSorted.sorted(by: {
            $1.workDate > $0.workDate
        })
        return toDosToBeSorted
    }
    
    // Gets ToDo items that meets the day selected in calendar
    static func retrieveToDoItemsByDay(toDoDate: Date, toDoItems: [ToDo]) -> [ToDo] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d/yy"
        var matchedToDosByDate: [ToDo] = [ToDo]()
        for toDo in toDoItems {
            if dateFormatter.string(from: toDo.workDate) == dateFormatter.string(from: toDoDate) {
                matchedToDosByDate.append(toDo)
            }
        }
        return sortToDoItemsByDate(toDoItems: matchedToDosByDate)
    }
    
    static func loadToDos() -> [ToDo]? {
        var loadedToDos: [ToDo] = [ToDo]()
        var loadedToDo: ToDo?
        
        // Container is set up in the AppDelegate so it needs to refer to that container.
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        // Context needs to be created in this container
        let managedContext = appDelegate!.persistentContainer.viewContext
        
        // Prepare the request of type NSTypeRequest for the entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FND_ToDo")
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            
            // If result is not empty,
            if result.count > 0 {
                for toDo in result as! [NSManagedObject] {
                    loadedToDo = ToDo(taskName: toDo.value(forKey: "taskName") as! String, taskDescription: toDo.value(forKey: "taskDescription") as! String, workDate: toDo.value(forKey: "startDate") as! Date, estTime: toDo.value(forKey: "estTime") as! String, dueDate: toDo.value(forKey: "dueDate") as! Date, finished: (toDo.value(forKey: "finished") as! Bool))
                    loadedToDos.append(loadedToDo!)
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
        let toDoEntity = NSEntityDescription.entity(forEntityName: "FND_ToDo", in: managedContext)
        
        // Adding data to newly created record
        let toDoToSave = NSManagedObject(entity: toDoEntity!, insertInto: managedContext)
        toDoToSave.setValue(toDoItem.taskName, forKey: "taskName")
        toDoToSave.setValue(toDoItem.taskDescription, forKey: "taskDescription")
        toDoToSave.setValue(toDoItem.estTime, forKey: "estTime")
        toDoToSave.setValue(toDoItem.workDate, forKey: "startDate")
        toDoToSave.setValue(toDoItem.dueDate, forKey: "dueDate")
        toDoToSave.setValue(toDoItem.finished, forKey: "finished")
        
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
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "FND_ToDo")
        
        // Assigning different filters for the ToDo to be updated
        let taskNamePredicate = NSPredicate(format: "taskName = %@", toDoToUpdate.taskName)
        let taskDescriptionPredicate = NSPredicate(format: "taskDescription = %@", toDoToUpdate.taskDescription)
        let estTimePredicate = NSPredicate(format: "estTime = %@", toDoToUpdate.estTime)
        let startDatePredicate = NSPredicate(format: "startDate == %@", toDoToUpdate.workDate as NSDate)
        let dueDatePredicate = NSPredicate(format: "dueDate == %@", toDoToUpdate.dueDate as NSDate)
        var statusPredicate = NSPredicate(format: "finished = %d", toDoToUpdate.finished)
        
        if updateType == 1 {
            statusPredicate = NSPredicate(format: "finished = %d", !toDoToUpdate.finished)
        }
        
        // Combines different filters to one filter
        let propertiesPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [taskNamePredicate, taskDescriptionPredicate, estTimePredicate, startDatePredicate, dueDatePredicate, statusPredicate])
        
        fetchRequest.predicate = propertiesPredicate
        
        do {
            let toDoItem = try managedContext.fetch(fetchRequest)
            
            let objectUpdate = toDoItem[0] as! NSManagedObject
            objectUpdate.setValue(newToDo.taskName, forKey: "taskName")
            objectUpdate.setValue(newToDo.taskDescription, forKey: "taskDescription")
            objectUpdate.setValue(newToDo.estTime, forKey: "estTime")
            objectUpdate.setValue(newToDo.workDate, forKey: "startDate")
            objectUpdate.setValue(newToDo.dueDate, forKey: "dueDate")
            objectUpdate.setValue(newToDo.finished, forKey: "finished")
            
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
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FND_ToDo")
        
        // Assigning different filters for the ToDo to be updated
        let taskNamePredicate = NSPredicate(format: "taskName = %@", toDoToDelete.taskName)
        let taskDescriptionPredicate = NSPredicate(format: "taskDescription = %@", toDoToDelete.taskDescription)
        let estTimePredicate = NSPredicate(format: "estTime = %@", toDoToDelete.estTime)
        let startDatePredicate = NSPredicate(format: "startDate == %@", toDoToDelete.workDate as NSDate)
        let dueDatePredicate = NSPredicate(format: "dueDate == %@", toDoToDelete.dueDate as NSDate)
        let statusPredicate = NSPredicate(format: "finished = %d", toDoToDelete.finished)
        
        // Combines different filters to one filter
        let propertiesPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [taskNamePredicate, taskDescriptionPredicate, estTimePredicate, startDatePredicate, dueDatePredicate, statusPredicate])
        
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
    
    static func addToDoItem(toDoItemToAdd: ToDo, toDoItemCollection: inout [ToDo]) {
        toDoItemCollection.append(toDoItemToAdd)
    }
    
    static func removeToDoItem(toDoItemIndexToRemove: Int, toDoItemCollection: inout [ToDo]) {
        toDoItemCollection.remove(at: toDoItemIndexToRemove)
    }
    
    static func addSelectedIndexPath(indexPath: IndexPath, selectedIndexPaths: inout [IndexPath]) {
        selectedIndexPaths.append(indexPath)
    }
    
    static func removeSelectedIndexPath(indexPathAsInt: Int, selectedIndexPaths: inout [IndexPath]) {
        selectedIndexPaths.remove(at: indexPathAsInt)
    }
    
    static func removeAllSelectedIndexPaths(selectedIndexPaths: inout [IndexPath]) {
        selectedIndexPaths.removeAll()
    }
    
    // Retrieves the index of the ToDo from the base ToDo List instead of by day
    static func retrieveRealIndexOfToDo(toDoItem: ToDo, toDoItemCollection: [ToDo]) -> Int {
        let toDoItems: [ToDo] = toDoItemCollection
        let retrievedIndex: Int = toDoItems.firstIndex(of: toDoItem)!
        return retrievedIndex
    }
    
    // Replaces a ToDo item based on its index from an array
    static func replaceToDoItemInBaseList(editedToDoItem: ToDo, editedToDoItemIndex: Int, toDoItemCollection: inout [ToDo]) {
        //self.toDos[editedToDoItemIndex] = editedToDoItem
        removeToDoItem(toDoItemIndexToRemove: editedToDoItemIndex, toDoItemCollection: &toDoItemCollection)
        addToDoItem(toDoItemToAdd: editedToDoItem, toDoItemCollection: &toDoItemCollection)
    }
}
