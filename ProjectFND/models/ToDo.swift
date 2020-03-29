//
//  ToDo.swift
//  ProjectFND
//
//  Created by Elly Richardson on 9/3/19.
//  Copyright © 2019 EllyRichardson. All rights reserved.
//

import UIKit
import os.log

/*
 ToDo automatically accesses the storage when its object is being accessed because of
 */
class ToDo: NSObject, NSCoding {
    // MARK: - Properties
    var taskId: String
    var taskName, taskDescription, estTime: String
    var workDate, dueDate: Date
    var finished: Bool
    
    // MARK: - Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("Focus-N-Do: ToDos")
    
    // MARK: - Types
    struct PropertyKey {
        static let taskId = "taskId"
        static let taskName = "taskName"
        static let taskDescription = "taskDescription"
        static let workDate = "workDate"
        static let estTime = "estTime"
        static let dueDate = "dueDate"
        //static let doneCheckBox = "doneCheckBox"
        static let finished = "finished"
    }
    
    // MARK: - Initialization
    init?(taskId: String, taskName: String, taskDescription: String, workDate: Date, estTime: String, dueDate: Date, finished: Bool) {
        
        
        // To fail init if one of them is empty
        if taskId.isEmpty || taskName.isEmpty || workDate == nil || estTime.isEmpty || dueDate == nil {
            return nil
        }
        
        // Init stored properties
        self.taskId = UUID().uuidString
        self.taskName = taskName
        self.taskDescription = taskDescription
        self.workDate = workDate
        self.estTime = estTime
        self.dueDate = dueDate
        self.finished = finished
    }
    
    override init() {
        // Init stored properties
        self.taskId = UUID().uuidString
        self.taskName = ""
        self.taskDescription = ""
        self.workDate = Date()
        self.estTime = ""
        self.dueDate = Date()
        self.finished = false
    }
    
    // MARK: - NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(taskId, forKey: PropertyKey.taskId)
        aCoder.encode(taskName, forKey: PropertyKey.taskName)
        aCoder.encode(taskDescription, forKey: PropertyKey.taskDescription)
        aCoder.encode(workDate, forKey: PropertyKey.workDate)
        aCoder.encode(estTime, forKey: PropertyKey.estTime)
        aCoder.encode(dueDate, forKey: PropertyKey.dueDate)
        aCoder.encode(finished, forKey: PropertyKey.finished)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let taskId = aDecoder.decodeObject(forKey: PropertyKey.taskId) as? String
            else {
                os_log("Unable to decode the name for a ToDo object.", log: OSLog.default, type: .debug)
                return nil
        }
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let taskName = aDecoder.decodeObject(forKey: PropertyKey.taskName) as? String
            else {
                os_log("Unable to decode the name for a ToDo object.", log: OSLog.default, type: .debug)
                return nil
        }
        
        // Because taskDescription is a required property of ToDo, although can be empty, just use conditional cast.
        guard let taskDescription = aDecoder.decodeObject(forKey: PropertyKey.taskDescription) as? String
            else {
                os_log("Unable to decode the description for a ToDo object.", log: OSLog.default, type: .debug)
                return nil
        }
        
        // Because workDate is a required property of ToDo, just use conditional cast.
        guard let workDate = aDecoder.decodeObject(forKey: PropertyKey.workDate) as? Date
            else {
                os_log("Unable to decode the work date for a ToDo object.", log: OSLog.default, type: .debug)
                return nil
        }
        
        // Because estTime is a required property of ToDo, just use conditional cast.
        guard let estTime = aDecoder.decodeObject (forKey: PropertyKey.estTime) as? String
            else {
                os_log("Unable to decode the estimated time for a ToDo object.", log: OSLog.default, type: .debug)
                return nil
        }
        
        
        // Because dueDate is a required property of ToDo, just use conditional cast.
        guard let dueDate = aDecoder.decodeObject (forKey: PropertyKey.dueDate) as? Date
            else {
                os_log("Unable to decode the due date for a ToDo object.", log: OSLog.default, type: .debug)
                return nil
        }
        
        let finished = Bool(aDecoder.decodeBool(forKey: PropertyKey.finished))
        if finished == nil {
            os_log("Unable to decode if ToDo object is finished.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Must call designated initializer.
        self.init(taskId: taskId, taskName: taskName, taskDescription: taskDescription, workDate: workDate, estTime: estTime, dueDate: dueDate, finished: finished)
    }
    
    func  getTaskId() -> String {
        return self.taskId
    }
    
    func getTaskName() -> String {
        return self.taskName
    }
    
    func getTaskDescription() -> String {
        return self.taskDescription
    }
    
    func getEstTime() -> String {
        return self.estTime
    }
    
    func getStartDate() -> Date {
        return self.workDate
    }
    
    func getEndDate() -> Date {
        return self.dueDate
    }
    
    func isFinished() -> Bool {
        return self.finished
    }
}
