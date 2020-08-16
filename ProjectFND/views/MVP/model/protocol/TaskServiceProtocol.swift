//
//  TaskServiceProtocol.swift
//  ProjectFND
//
//  Created by Elly Richardson on 8/16/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import Foundation

protocol TaskServiceProtocol {
    func setInitialToDos()
    func getToDosByDay(dateChosen: Date) -> [String: ToDo]
    func updateToDos(modificationType: ListModificationType, toDo: ToDo)
}
