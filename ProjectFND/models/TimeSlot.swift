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
    //var timeLength: Double
    // slotCodes e.g. "1-A", "2-B", "3-C"
    var slotCode: String
    
    // MARK: Initialization
    init?() {
        self.startOfTimeSlot = Date()
        self.endOfTimeSlot = Date()
        self.slotCode = ""
        setSlotCode(generatedSlotCode: generateSlotCode(startOfTimeSlot: self.startOfTimeSlot))
    }
    
    init?(startOfTimeSlot: Date, endOfTimeSlot: Date){
        self.startOfTimeSlot = startOfTimeSlot
        self.endOfTimeSlot = endOfTimeSlot
        //self.timeLength = 0.0
        self.slotCode = ""
        // Workaround of not being able to call a function to a self variable directly
        setSlotCode(generatedSlotCode: generateSlotCode(startOfTimeSlot: startOfTimeSlot))
    }
    
    
    init?(timeSlotCode: String, timeSlotCodeDay: Date) {
        let dateArithmeticOps = DateUtils()
        self.startOfTimeSlot = Date()
        self.endOfTimeSlot = Date()
        //self.timeLength = 0.0
        self.slotCode = timeSlotCode
        // Workarounds of not being able to call a function to a self variable directly
        setStartOfTimeSlot(startTime: decodeStartDateOfSlotCode(slotCode: timeSlotCode, timeSlotDay: timeSlotCodeDay))
        setEndOfTimeSlot(endTime: dateArithmeticOps.addMinutesToDate(date: getStartTime(), minutes: 15.0))
    }
 
    func setStartOfTimeSlot(startTime: Date) {
        self.startOfTimeSlot = startTime
    }
    
    func setEndOfTimeSlot(endTime: Date) {
        self.endOfTimeSlot = endTime
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
    
    /*
    func getTimeLength() -> Double {
        let calendar = Calendar.current
        
        // Replace the hour (time) of both dates with 00:00
        let startTime = calendar.startOfDay(for: getStartTime())
        let endTime = calendar.startOfDay(for: getEndTime())
        
        let components = calendar.dateComponents([.minute], from: startTime, to: endTime)
        return self.timeLength
    }
     */
    
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
        if minute == 0 {
            minuteCode = "A"
        }
        else if minute == 15 {
            minuteCode = "B"
        }
        else if minute == 30 {
            minuteCode = "C"
        }
        else {
            minuteCode = "D"
        }
        
        // "1B"
        return hourCode + "-" + minuteCode
    }
    
    func decodeStartDateOfSlotCode(slotCode: String, timeSlotDay: Date) -> Date {
        let slotCodeArr = slotCode.components(separatedBy: "-")
        let hourCode    = slotCodeArr[0]
        let minuteCode = slotCodeArr[1]
        let hourValue = Int(hourCode)
        var startDate: Date = Date()
        if minuteCode == "A" {
            startDate = Calendar.current.date(bySettingHour: hourValue!, minute: 0, second: 0, of: timeSlotDay)!
        }
        else if minuteCode == "B" {
            startDate = Calendar.current.date(bySettingHour: hourValue!, minute: 15, second: 0, of: timeSlotDay)!
        }
        else if minuteCode == "C" {
            startDate = Calendar.current.date(bySettingHour: hourValue!, minute: 30, second: 0, of: timeSlotDay)!
        }
        else if minuteCode == "D" {
            startDate = Calendar.current.date(bySettingHour: hourValue!, minute: 45, second: 0, of: timeSlotDay)!
        }
        return startDate
    }
}
