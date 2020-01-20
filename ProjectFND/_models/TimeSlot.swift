//
//  TimeSlot.swift
//  ProjectFND
//
//  Created by Elly Richardson on 1/19/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import CoreData
import UIKit
import os.log

/*
 Time slots are every 15 minutes
 */
class TimeSlot {
    var startOfTimeSlot: Date
    var endOfTimeSlot: Date
    // slotCodes e.g. "1A", "2B", "3C"
    var slotCode: String
    
    // MARK: Initialization
    init?(startOfTimeSlot: Date, endOfTimeSlot: Date){
        self.startOfTimeSlot = startOfTimeSlot
        self.endOfTimeSlot = endOfTimeSlot
        self.slotCode = ""
        // Work around of not being able to call a function to a self variable directly
        setSlotCode(generatedSlotCode: generateSlotCode(startOfTimeSlot: startOfTimeSlot))
    }
    
    func setSlotCode(generatedSlotCode: String) {
        self.slotCode = generatedSlotCode
    }
    
    func getStartTime() -> Date {
        return self.startOfTimeSlot
    }
    
    func getEndTime() -> Date {
        return self.endOfTimeSlot
    }
    
    func getSlotCode() -> String {
        return self.slotCode
    }
    
    // Takes a start of fifteen minutes interval and creates a slotCode based of it
    func generateSlotCode(startOfTimeSlot: Date) -> String {
        let calendar = Calendar.current
        var hourCode: String
        var minuteCode: String
        
        // Gets the hour component of a time
        let hour = calendar.component(.hour, from: startOfTimeSlot)
        // Gets the minute component of a time
        let minute = calendar.component(.minute, from: startOfTimeSlot)
        
        // Assigns the hourCode for the slotCode
        hourCode = String(hour)
        
        // Assigns the letter code as the minuteCode based of which interval within the hour does the minute component fall
        if minute == 15 {
            minuteCode = "A"
        }
        else if minute == 30 {
            minuteCode = "B"
        }
        else if minute == 45 {
            minuteCode = "C"
        }
        else {
            minuteCode = "D"
        }
        
        // "1B"
        return hourCode + minuteCode
    }
}
