//
//  Interval.swift
//  ProjectFND
//
//  Created by Elly Richardson on 3/28/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import UIKit
import os.log

/*
 ToDo automatically accesses the storage when its object is being accessed because of
 */
class ToDoInterval: NSObject, NSCoding {
    // MARK: - Properties
    var taskId, intervalId: String
    var intervalIndex: Int
    var firstInterval, lastInterval: Bool
    
    // MARK: - Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("Focus-N-Do: ToDoIntervals")
    
    // MARK: - Types
    struct PropertyKey {
        static let taskId = "taskId"
        static let intervalId = "intervalId"
        static let intervalIndex = "intervalIndex"
        static let firstInterval = "isFirstInterval"
        static let lastInterval = "isLastInterval"
    }
    
    // MARK: - Initialization
    init?(taskId: String, intervalId: String, intervalIndex: Int, firstInterval: Bool, lastInterval: Bool) {
        
        
        // To fail init if one of them is empty
        if taskId.isEmpty || intervalId.isEmpty || intervalIndex < 0 || intervalIndex == nil || firstInterval == nil || lastInterval == nil {
            return nil
        }
        
        // Init stored properties
        self.taskId = UUID().uuidString
        self.intervalId = intervalId
        self.intervalIndex = intervalIndex
        self.firstInterval = firstInterval
        self.lastInterval = lastInterval
    }
    
    override init() {
        // Init stored properties
        self.taskId = ""
        self.intervalId = ""
        self.intervalIndex = -1
        self.firstInterval = false
        self.lastInterval = false
    }
    
    // MARK: - NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(taskId, forKey: PropertyKey.taskId)
        aCoder.encode(intervalId, forKey: PropertyKey.intervalId)
        aCoder.encode(intervalIndex, forKey: PropertyKey.intervalIndex)
        aCoder.encode(firstInterval, forKey: PropertyKey.firstInterval)
        aCoder.encode(lastInterval, forKey: PropertyKey.lastInterval)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let taskId = aDecoder.decodeObject(forKey: PropertyKey.taskId) as? String
            else {
                os_log("Unable to decode the name for a ToDoInterval object.", log: OSLog.default, type: .debug)
                return nil
        }
        
        guard let intervalId = aDecoder.decodeObject(forKey: PropertyKey.intervalId) as? String
            else {
                os_log("Unable to decode the name for a ToDoInterval object.", log: OSLog.default, type: .debug)
                return nil
        }
        
        guard let intervalIndex = aDecoder.decodeObject(forKey: PropertyKey.intervalIndex) as? Int
            else {
                os_log("Unable to decode the name for a ToDoInterval object.", log: OSLog.default, type: .debug)
                return nil
        }
        
        let firstInterval = Bool(aDecoder.decodeBool(forKey: PropertyKey.firstInterval))
        if firstInterval == nil {
            os_log("Unable to decode if ToDoInterval object is finished.", log: OSLog.default, type: .debug)
            return nil
        }
        
        let lastInterval = Bool(aDecoder.decodeBool(forKey: PropertyKey.lastInterval))
        if lastInterval == nil {
            os_log("Unable to decode if ToDoInterval object is finished.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Must call designated initializer.
        self.init(taskId: taskId, intervalId: intervalId, intervalIndex: intervalIndex, firstInterval: firstInterval, lastInterval: lastInterval)
    }
    
    func getTaskId() -> String {
        return self.taskId
    }
    
    func getIntervalId() -> String {
        return self.intervalId
    }
    
    func getIntervalIndex() -> Int {
        return self.intervalIndex
    }
    
    func isFirstInterval() -> Bool {
        return self.firstInterval
    }
    
    func isLastInterval() -> Bool {
        return self.lastInterval
    }
}
