//
//  ToDoMonthSection.swift
//  Focus-N-Do
//
//  Created by Elly Richardson on 11/10/19.
//  Copyright © 2019 EllyRichardson. All rights reserved.
//

import UIKit

struct ToDoDateSection : Comparable {
    var toDoDate: Date
    var toDos: [ToDo]
    var collapsed: Bool
    
    static func < (lhs: ToDoDateSection, rhs: ToDoDateSection) -> Bool {
        return lhs.toDoDate < rhs.toDoDate
    }
    
    // Do I really need this??
    static func == (lhs: ToDoDateSection, rhs: ToDoDateSection) -> Bool {
        return lhs.toDoDate == rhs.toDoDate
    }
}
