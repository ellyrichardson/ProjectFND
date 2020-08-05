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
 NOTES:
 Add a taskJustBeingCreated state tracker in this object and remove the worrying of task only being created in ViewControllers. Look at FND-00001
 */

/*
 ToDo automatically accesses the storage when its object is being accessed because of
 */
class ToDo: NSObject, NSCoding, NSCopying {
    
    // MARK: - Properties
    var taskId, intervalId: String
    var taskName, taskNotes, taskTag: String
    var startTime, endTime, dueDate, intervalDueDate: Date
    var finished, intervalized, dueDateSet: Bool
    var important, notifying: Bool
    var intervalLength, intervalIndex: String
    
    // MARK: - Repeating Properties
    var repeating: Bool
    var repeatingStartDate, repeatingEndDate: Date
    var repeatingId, repeatingFrequencyCode: String
    
    // MARK: - Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("Focus-N-Do: ToDos")
    
    // MARK: - Types
    struct PropertyKey {
        static let taskId = "taskId"
        static let taskName = "taskName"
        static let taskNotes = "taskNotes"
        static let taskTag = "taskTag"
        static let startTime = "startTime"
        static let endTime = "endTime"
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
        static let repeatingId = "repeatingId"
        static let repeatingFrequencyCode = "repeatingFrequencyCode"
        static let dueDateSet = "dueDateSet"
    }
    
    // MARK: - Initialization
    init?(taskId: String, taskName: String, taskNotes: String = "", taskTag: String = "", startTime: Date, endTime: Date, dueDate: Date, finished: Bool, dueDateSet: Bool = false, intervalized: Bool = false, intervalId: String = "", intervalLength: Int = 0, intervalIndex: Int = 0, intervalDueDate: Date = Date(), important: Bool = false, notifying: Bool = false, repeating: Bool = false, repeatingStartDate: Date = Date(), repeatingEndDate: Date = Date(), repeatingId: String = "", repeatingFrequencyCode: String = "") {
        
        
        // To fail init if one of them is empty
        if taskId.isEmpty || taskName.isEmpty || startTime == nil || endTime == nil || dueDate == nil {
            return nil
        }
        
        // Init stored properties
        self.taskId = taskId
        self.taskName = taskName
        self.taskNotes = taskNotes
        self.taskTag = taskTag
        self.startTime = startTime
        self.endTime = endTime
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
        self.repeatingId = repeatingId
        self.repeatingFrequencyCode = repeatingFrequencyCode
        self.dueDateSet = dueDateSet
    }
    
    override init() {
        // Init stored properties
        //self.taskId = UUID().uuidString
        self.taskId = "empty-id-please-dont-use"
        self.taskName = ""
        self.taskNotes = ""
        self.taskTag = ""
        self.startTime = Date()
        self.endTime = Date()
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
        self.repeatingId = ""
        self.repeatingFrequencyCode = ""
        self.dueDateSet = false
    }
    
    // MARK: - NSCopying
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = ToDo(taskId: self.taskId, taskName: self.taskName, taskNotes: self.taskNotes, taskTag: self.taskTag, startTime: self.startTime, endTime: self.endTime, dueDate: self.dueDate, finished: self.finished, dueDateSet: self.dueDateSet, intervalized: self.intervalized, intervalId: self.intervalId, intervalLength: Int(self.intervalLength)!, intervalIndex: Int(self.intervalIndex)!, intervalDueDate: self.intervalDueDate, important: self.important, notifying: self.notifying, repeating: self.repeating, repeatingStartDate: self.repeatingStartDate, repeatingEndDate: self.repeatingEndDate, repeatingId: self.repeatingId, repeatingFrequencyCode: self.repeatingFrequencyCode)
        return copy as Any
    }
    
    // MARK: - NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(taskId, forKey: PropertyKey.taskId)
        aCoder.encode(taskName, forKey: PropertyKey.taskName)
        aCoder.encode(taskNotes, forKey: PropertyKey.taskNotes)
        aCoder.encode(taskTag, forKey: PropertyKey.taskTag)
        aCoder.encode(startTime, forKey: PropertyKey.startTime)
        aCoder.encode(endTime, forKey: PropertyKey.endTime)
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
        aCoder.encode(repeatingId, forKey: PropertyKey.repeatingId)
        aCoder.encode(repeatingFrequencyCode, forKey: PropertyKey.repeatingFrequencyCode)
        aCoder.encode(dueDateSet, forKey: PropertyKey.dueDateSet)
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
        
        
        // The notes is required. If we cannot decode a name string, the initializer should fail.
        guard let taskNotes = aDecoder.decodeObject(forKey: PropertyKey.taskNotes) as? String
            else {
                os_log("Unable to decode the notes for a ToDo object.", log: OSLog.default, type: .debug)
                return nil
        }
        
        guard let taskTag = aDecoder.decodeObject(forKey: PropertyKey.taskTag) as? String
            else {
                os_log("Unable to decode the tag for a ToDo object.", log: OSLog.default, type: .debug)
                return nil
        }
        
        // Because taskDescription is a required property of ToDo, although can be empty, just use conditional cast.
        /*
        guard let taskDescription = aDecoder.decodeObject(forKey: PropertyKey.taskDescription) as? String
            else {
                os_log("Unable to decode the description for a ToDo object.", log: OSLog.default, type: .debug)
                return nil
        }*/
        
        // Because startTime is a required property of ToDo, just use conditional cast.
        guard let startTime = aDecoder.decodeObject (forKey: PropertyKey.startTime) as? Date
            else {
                os_log("Unable to decode the start time for a ToDo object.", log: OSLog.default, type: .debug)
                return nil
        }
        
        // Because endTime is a required property of ToDo, just use conditional cast.
        guard let endTime = aDecoder.decodeObject (forKey: PropertyKey.endTime) as? Date
            else {
                os_log("Unable to decode the end time for a ToDo object.", log: OSLog.default, type: .debug)
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
        
        let dueDateSet = Bool(aDecoder.decodeBool(forKey: PropertyKey.dueDateSet))
        if dueDateSet == nil {
            os_log("Unable to decode if ToDo object has dueDateSet.", log: OSLog.default, type: .debug)
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
        
        guard let repeatingId = aDecoder.decodeObject (forKey: PropertyKey.repeatingId) as? String
            else {
                os_log("Unable to decode the repeatingId for a ToDo object.", log: OSLog.default, type: .debug)
                return nil
        }
        
        // Must call designated initializer.
        self.init(taskId: taskId, taskName: taskName, taskNotes: taskNotes, taskTag: taskTag, startTime: startTime, endTime: endTime, dueDate: dueDate, finished: finished, dueDateSet: dueDateSet, intervalized: intervalized, intervalId: intervalId, intervalLength: Int(intervalLength)!, intervalIndex: Int(intervalIndex)!, intervalDueDate: intervalDueDate, important: important, notifying: notifying, repeating: repeating, repeatingStartDate: repeatingStartDate, repeatingEndDate: repeatingEndDate, repeatingId: repeatingId, repeatingFrequencyCode: repeatingFrequencyCode)
    }
    
    func  getTaskId() -> String {
        return self.taskId
    }
    
    func getTaskName() -> String {
        return self.taskName
    }
    
    func getTaskNotes() -> String {
        return self.taskNotes
    }
    
    func getTaskTag() -> String {
        return self.taskTag
    }
    
    func getStartTime() -> Date {
        return self.startTime
    }
    
    func getEndTime() -> Date {
        return self.endTime
    }
    
    // FROM getEndDate()
    func getDueDate() -> Date {
        return self.dueDate
    }
    
    func isFinished() -> Bool {
        return self.finished
    }
    
    func isDueDateSet() -> Bool {
        return self.dueDateSet
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
    
    func getRepeatingId() -> String {
        return self.repeatingId
    }
    
    func getRepeatingFrequencyCode() -> String {
        return self.repeatingFrequencyCode
    }
}
