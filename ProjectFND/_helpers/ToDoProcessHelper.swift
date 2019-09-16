//
//  ToDoProcessHelper.swift
//  ProjectFND
//
//  Created by Elly Richardson on 9/12/19.
//  Copyright © 2019 EllyRichardson. All rights reserved.
//

import UIKit

class ToDoProcessHelper {
    // Sorts ToDo items by date
    func sortToDoItemsByDate(toDoItems: [ToDo]) -> [ToDo] {
        var toDosToBeSorted = toDoItems
        toDosToBeSorted = toDosToBeSorted.sorted(by: {
            $1.workDate > $0.workDate
        })
        return toDosToBeSorted
    }
    
    // Gets ToDo items that meets the day selected in calendar
    func retrieveToDoItemsByDay(toDoDate: Date, toDoItems: [ToDo]) -> [ToDo] {
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
}
