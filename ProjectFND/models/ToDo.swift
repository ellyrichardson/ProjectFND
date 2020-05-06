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
    var taskId, intervalId, taskType: String
    var taskName, taskDescription, estTime: String
    var workDate, dueDate, intervalDueDate: Date
    var finished, intervalized: Bool
    var important, notifying: Bool
    var intervalLength, intervalIndex: String
    
    // MARK: - Repeating Properties
    var repeating: Bool
    var repeatingStartDate, repeatingEndDate: Date
    var repeatingFrequencyCode: String
    
    // MARK: - Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("Focus-N-Do: ToDos")
    
    // MARK: - Types
    struct PropertyKey {
        static let taskId = "taskId"
        static let taskName = "taskName"
        static let taskType = "taskType"
        static let taskDescription = "taskDescription"
        static let workDate = "workDate"
        static let estTime = "estTime"
        static let dueDate = "dueDate"
        //static let doneCheckBox = "doneCheckBox"
        static let finished = "finished"
        static let intervalId = "intervalId"
        static let intervalized = "intervalized"
        static let intervalLength = "intervalLength"
        static let intervalIndex =  "intervalIndex"
        static let intervalDueDate = "intervalDueDate"
        static let important = "important"
        static let notifying = "notifying"
        static let repeating = "repeating"
        static let repeatingStartDate = "repeatingStartDate"
        static let repeatingEndDate = "repeatingEndDate"
        static let repeatingFrequencyCode = "repeatingFrequencyCode"
    }
    
    // MARK: - Initialization
    init?(taskId: String, taskName: String, taskType: String = TaskTypes.PERSONAL.rawValue,taskDescription: String, workDate: Date, estTime: String, dueDate: Date, finished: Bool, intervalized: Bool = false, intervalId: String = "", intervalLength: Int = 0, intervalIndex: Int = 0, intervalDueDate: Date = Date(), important: Bool = false, notifying: Bool = false, repeating: Bool = false, repeatingStartDate: Date = Date(), repeatingEndDate: Date = Date(), repeatingFrequencyCode: String = "") {
        
        
        // To fail init if one of them is empty
        if taskId.isEmpty || taskName.isEmpty || workDate == nil || estTime.isEmpty || dueDate == nil {
            return nil
        }
        
        // Init stored properties
        self.taskId = taskId
        self.taskName = taskName
        self.taskType = taskType
        self.taskDescription = taskDescription
        self.workDate = workDate
        self.estTime = estTime
        self.dueDate = dueDate
        self.finished = finished
        self.intervalized = intervalized
        self.intervalId = intervalId
        self.intervalLength = String(intervalLength)
        self.intervalIndex = String(intervalIndex)
        self.intervalDueDate = intervalDueDate
        self.important = important
        self.notifying = notifying
        self.repeating = repeating
        self.repeatingStartDate = repeatingStartDate
        self.repeatingEndDate = repeatingEndDate
        self.repeatingFrequencyCode = repeatingFrequencyCode
    }
    
    override init() {
        // Init stored properties
        self.taskId = UUID().uuidString
        self.taskName = ""
        self.taskType = TaskTypes.PERSONAL.rawValue
        self.taskDescription = ""
        self.workDate = Date()
        self.estTime = ""
        self.dueDate = Date()
        self.finished = false
        self.intervalized = false
        self.intervalId = ""
        self.intervalLength = String(0)
        self.intervalIndex = String(0)
        self.intervalDueDate = Date()
        self.important = false
        self.notifying = false
        self.repeating = false
        self.repeatingStartDate = Date()
        self.repeatingEndDate = Date()
        self.repeatingFrequencyCode = ""
    }
    
    // MARK: - NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(taskId, forKey: PropertyKey.taskId)
        aCoder.encode(taskName, forKey: PropertyKey.taskName)
        aCoder.encode(taskType, forKey: PropertyKey.taskType)
        aCoder.encode(taskDescription, forKey: PropertyKey.taskDescription)
        aCoder.encode(workDate, forKey: PropertyKey.workDate)
        aCoder.encode(estTime, forKey: PropertyKey.estTime)
        aCoder.encode(dueDate, forKey: PropertyKey.dueDate)
        aCoder.encode(finished, forKey: PropertyKey.finished)
        aCoder.encode(intervalId, forKey: PropertyKey.intervalId)
        aCoder.encode(intervalized, forKey: PropertyKey.intervalized)
        aCoder.encode(intervalLength, forKey: PropertyKey.intervalLength)
        aCoder.encode(intervalIndex, forKey: PropertyKey.intervalIndex)
        aCoder.encode(intervalDueDate, forKey: PropertyKey.intervalDueDate)
        aCoder.encode(important, forKey: PropertyKey.important)
        aCoder.encode(notifying, forKey: PropertyKey.notifying)
        aCoder.encode(repeating, forKey: PropertyKey.repeating)
        aCoder.encode(repeatingStartDate, forKey: PropertyKey.repeatingStartDate)
        aCoder.encode(repeatingEndDate, forKey: PropertyKey.repeatingEndDate)
        aCoder.encode(repeatingFrequencyCode, forKey: PropertyKey.repeatingFrequencyCode)
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
        
        guard let taskType = aDecoder.decodeObject(forKey: PropertyKey.taskType) as? String
            else {
                os_log("Unable to decode the type for a ToDo object.", log: OSLog.default, type: .debug)
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
        
        guard let intervalId = aDecoder.decodeObject (forKey: PropertyKey.intervalId) as? String
            else {
                os_log("Unable to decode the intervalId for a ToDo object.", log: OSLog.default, type: .debug)
                return nil
        }
        
        let intervalized = Bool(aDecoder.decodeBool(forKey: PropertyKey.intervalized))
        if intervalized == nil {
            os_log("Unable to decode if ToDo object is intervalized.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let intervalLength = aDecoder.decodeObject (forKey: PropertyKey.intervalLength) as? String
            else {
                os_log("Unable to decode the intervalLength for a ToDo object.", log: OSLog.default, type: .debug)
                return nil
        }
        
        guard let intervalIndex = aDecoder.decodeObject (forKey: PropertyKey.intervalIndex) as? String
            else {
                os_log("Unable to decode the intervalIndex for a ToDo object.", log: OSLog.default, type: .debug)
                return nil
        }
        
        guard let intervalDueDate = aDecoder.decodeObject (forKey: PropertyKey.intervalDueDate) as? Date
            else {
                os_log("Unable to decode the interval due date for a ToDo object.", log: OSLog.default, type: .debug)
                return nil
        }
        
        let important = Bool(aDecoder.decodeBool(forKey: PropertyKey.important))
        if important == nil {
            os_log("Unable to decode if ToDo object is important.", log: OSLog.default, type: .debug)
            return nil
        }
        
        let notifying = Bool(aDecoder.decodeBool(forKey: PropertyKey.intervalized))
        if notifying == nil {
            os_log("Unable to decode if ToDo object is notifying.", log: OSLog.default, type: .debug)
            return nil
        }
        
        let repeating = Bool(aDecoder.decodeBool(forKey: PropertyKey.repeating))
        if repeating == nil {
            os_log("Unable to decode if ToDo object is repeating.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let repeatingStartDate = aDecoder.decodeObject (forKey: PropertyKey.repeatingStartDate) as? Date
            else {
                os_log("Unable to decode the repeating start date for a ToDo object.", log: OSLog.default, type: .debug)
                return nil
        }
        
        guard let repeatingEndDate = aDecoder.decodeObject (forKey: PropertyKey.repeatingEndDate) as? Date
            else {
                os_log("Unable to decode the repeating end date for a ToDo object.", log: OSLog.default, type: .debug)
                return nil
        }
        
        guard let repeatingFrequencyCode = aDecoder.decodeObject (forKey: PropertyKey.repeatingFrequencyCode) as? String
            else {
                os_log("Unable to decode the repeating frequency code for a ToDo object.", log: OSLog.default, type: .debug)
                return nil
        }
        
        // Must call designated initializer.
        self.init(taskId: taskId, taskName: taskName, taskType: taskType, taskDescription: taskDescription, workDate: workDate, estTime: estTime, dueDate: dueDate, finished: finished,  intervalized: intervalized, intervalId: intervalId, intervalLength: Int(intervalLength)!, intervalIndex: Int(intervalIndex)!, intervalDueDate: intervalDueDate, important: important, notifying: notifying, repeating: repeating, repeatingStartDate: repeatingStartDate, repeatingEndDate: repeatingEndDate, repeatingFrequencyCode: repeatingFrequencyCode)
    }
    
    func  getTaskId() -> String {
        return self.taskId
    }
    
    func getTaskName() -> String {
        return self.taskName
    }
    
    func getTaskType() -> String {
        return self.taskType
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
    
    func getIntervalId() -> String {
        return self.intervalId
    }
    
    func isIntervalized() -> Bool {
        return self.intervalized
    }
    
    func getIntervalLength() -> Int {
        return Int(self.intervalLength)!
    }
    
    func getIntervalIndex() -> Int {
        return Int(self.intervalIndex)!
    }
    
    func getIntervalDueDate() -> Date {
        return self.intervalDueDate
    }
    
    func isImportant() -> Bool {
        return self.important
    }
    
    func isNotifying() -> Bool {
        return self.notifying
    }
    
    func isRepeating() -> Bool {
        return self.repeating
    }
    
    func getRepeatingStartDate() -> Date {
        return self.repeatingStartDate
    }
    
    func getRepeatingEndDate() -> Date {
        return self.repeatingEndDate
    }
    
    func getRepeatingFrequencyCode() -> String {
        return self.repeatingFrequencyCode
    }
}
