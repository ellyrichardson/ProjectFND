//
//  MockTaskService.swift
//  ProjectFND
//
//  Created by Elly Richardson on 8/16/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import Foundation

class MockTaskService: TaskServiceProtocol {
    
    var taskItems = [String : ToDo]()
    
    func setInitialToDos() {
        //
    }
    
    func getToDosByDay(dateChosen: Date) -> [String : ToDo] {
        return ToDoProcessUtils.retrieveToDoItemsByDay(toDoDate: dateChosen, toDoItems: taskItems)
    }
    
    func updateToDos(modificationType: ListModificationType, toDo: ToDo) {
        switch modificationType {
        case .UPDATE:
            taskItems[toDo.getTaskId()] = toDo
        case .REMOVE:
            taskItems[toDo.getTaskId()] = nil
        case .FINISHNESS:
            toDo.finished = !toDo.finished
            taskItems[toDo.getTaskId()] = toDo
        case .IMPORTANT:
            toDo.important = !toDo.important
            taskItems[toDo.getTaskId()] = toDo
        case .NOTIFICATION:
            toDo.notifying = !toDo.notifying
            taskItems[toDo.getTaskId()] = toDo
        default:
            taskItems[toDo.getTaskId()] = toDo
        }
    }
    
    func setTaskItems(taskItems: [String : ToDo]) {
        self.taskItems = taskItems
    }
}
