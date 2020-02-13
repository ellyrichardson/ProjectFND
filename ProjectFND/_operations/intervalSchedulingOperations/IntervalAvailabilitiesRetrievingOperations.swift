//
//  IntervalAvailabilitiesRetrievingOperations.swift
//  ProjectFND
//
//  Created by Elly Richardson on 2/1/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import CoreData
import UIKit
import os.log

class IntervalAvailabilitiesRetrievalOperations {
    var dateArithmeticOps = DateArithmeticOperations()
    //private var allOfTheToDos: [ToDo]
    
    // MARK: Essential Functions
    
    // TEST: Passed
    func getStartTimeOfConsecutiveTimeSlots(consecutiveTimeSlot: [String: TimeSlot], dayOfConcern: Date) -> TimeSlot {
        var timeSlotCodeHourIterator: Int = 0
        var earliestAssignedNumberComponent: Int = 24
        var earliestAssignedLetterComponentAsInt: Int = 4
        // Iterates through every possible hourCode component of a timeSlotCode
        while timeSlotCodeHourIterator < 24 {
            let firstFifteenSlotCode = String(timeSlotCodeHourIterator) + "-" + "A"
            let secondFifteenSlotCode = String(timeSlotCodeHourIterator) + "-" + "B"
            let thirdFifteenSlotCode = String(timeSlotCodeHourIterator) + "-" + "C"
            let fourthFifteenSlotCode = String(timeSlotCodeHourIterator) + "-" + "D"
            // If the key-value does not exist in this occupiedTimeSlot dictionary, it means the timeSlot is available. The available timeSlot (key-value) gets added to the availableTimeSlotDictionary.
            if consecutiveTimeSlot[firstFifteenSlotCode] != nil {
                mutateComponentsForSlotCodeStartTime(slotCode: firstFifteenSlotCode, earliestAssignedNumberComponent: &earliestAssignedNumberComponent, earliestAssignedLetterComponentAsInt: &earliestAssignedLetterComponentAsInt)
            }
            if consecutiveTimeSlot[secondFifteenSlotCode] != nil {
                mutateComponentsForSlotCodeStartTime(slotCode: secondFifteenSlotCode, earliestAssignedNumberComponent: &earliestAssignedNumberComponent, earliestAssignedLetterComponentAsInt: &earliestAssignedLetterComponentAsInt)
            }
            if consecutiveTimeSlot[thirdFifteenSlotCode] != nil {
                mutateComponentsForSlotCodeStartTime(slotCode: thirdFifteenSlotCode, earliestAssignedNumberComponent: &earliestAssignedNumberComponent, earliestAssignedLetterComponentAsInt: &earliestAssignedLetterComponentAsInt)
            }
            if consecutiveTimeSlot[fourthFifteenSlotCode] != nil {
                mutateComponentsForSlotCodeStartTime(slotCode: fourthFifteenSlotCode, earliestAssignedNumberComponent: &earliestAssignedNumberComponent, earliestAssignedLetterComponentAsInt: &earliestAssignedLetterComponentAsInt)
            }
            // Iterates to the next codeHour possible by incrementing the timeSlotCodeHourIterator by 1
            timeSlotCodeHourIterator = timeSlotCodeHourIterator + 1
        }
        var timeSlotCodeReady: String = String()
        if earliestAssignedLetterComponentAsInt == 0 {
            timeSlotCodeReady = String(earliestAssignedNumberComponent) + "-" + "A"
        }
        else if earliestAssignedLetterComponentAsInt == 1 {
            timeSlotCodeReady = String(earliestAssignedNumberComponent) + "-" + "B"
        }
        else if earliestAssignedLetterComponentAsInt == 2 {
            timeSlotCodeReady = String(earliestAssignedNumberComponent) + "-" + "C"
        }
        else if earliestAssignedLetterComponentAsInt == 3 {
            timeSlotCodeReady = String(earliestAssignedNumberComponent) + "-" + "D"
        }
        return TimeSlot(timeSlotCode: timeSlotCodeReady, timeSlotCodeDay: dayOfConcern)!
    }
    
    // TEST: Passed
    func getEndTimeOfConsecutiveTimeSlots(consecutiveTimeSlot: [String: TimeSlot], dayOfConcern: Date) -> TimeSlot {
        var timeSlotCodeHourIterator: Int = 0
        var latestAssignedNumberComponent: Int = 0
        var latestAssignedLetterComponentAsInt: Int = 0
        // Iterates through every possible hourCode component of a timeSlotCode
        while timeSlotCodeHourIterator < 24 {
            let firstFifteenSlotCode = String(timeSlotCodeHourIterator) + "-" + "A"
            let secondFifteenSlotCode = String(timeSlotCodeHourIterator) + "-" + "B"
            let thirdFifteenSlotCode = String(timeSlotCodeHourIterator) + "-" + "C"
            let fourthFifteenSlotCode = String(timeSlotCodeHourIterator) + "-" + "D"
            // If the key-value does not exist in this occupiedTimeSlot dictionary, it means the timeSlot is available. The available timeSlot (key-value) gets added to the availableTimeSlotDictionary.
            if consecutiveTimeSlot[firstFifteenSlotCode] != nil {
                mutateComponentsForSlotCodeEndTime(slotCode: firstFifteenSlotCode, latestAssignedNumberComponent: &latestAssignedNumberComponent, latestAssignedLetterComponentAsInt: &latestAssignedLetterComponentAsInt)
            }
            if consecutiveTimeSlot[secondFifteenSlotCode] != nil {
                mutateComponentsForSlotCodeEndTime(slotCode: secondFifteenSlotCode, latestAssignedNumberComponent: &latestAssignedNumberComponent, latestAssignedLetterComponentAsInt: &latestAssignedLetterComponentAsInt)
            }
            if consecutiveTimeSlot[thirdFifteenSlotCode] != nil {
                mutateComponentsForSlotCodeEndTime(slotCode: thirdFifteenSlotCode, latestAssignedNumberComponent: &latestAssignedNumberComponent, latestAssignedLetterComponentAsInt: &latestAssignedLetterComponentAsInt)
            }
            if consecutiveTimeSlot[fourthFifteenSlotCode] != nil {
                mutateComponentsForSlotCodeEndTime(slotCode: fourthFifteenSlotCode, latestAssignedNumberComponent: &latestAssignedNumberComponent, latestAssignedLetterComponentAsInt: &latestAssignedLetterComponentAsInt)
            }
            // Iterates to the next codeHour possible by incrementing the timeSlotCodeHourIterator by 1
            timeSlotCodeHourIterator = timeSlotCodeHourIterator + 1
        }
        // TODO: Some gnarly stuff. Should be fixed!
        if latestAssignedLetterComponentAsInt < 3 {
            latestAssignedLetterComponentAsInt = latestAssignedLetterComponentAsInt + 1
        }
        
        var timeSlotCodeReady: String = String()
        if latestAssignedLetterComponentAsInt == 0 {
            timeSlotCodeReady = String(latestAssignedNumberComponent) + "-" + "A"
        }
        else if latestAssignedLetterComponentAsInt == 1 {
            timeSlotCodeReady = String(latestAssignedNumberComponent) + "-" + "B"
        }
        else if latestAssignedLetterComponentAsInt == 2 {
            timeSlotCodeReady = String(latestAssignedNumberComponent) + "-" + "C"
        }
        else if latestAssignedLetterComponentAsInt == 3 {
            timeSlotCodeReady = String(latestAssignedNumberComponent) + "-" + "D"
        }
        return TimeSlot(timeSlotCode: timeSlotCodeReady, timeSlotCodeDay: dayOfConcern)!
    }
    
    // TEST: Untested directly, but tested through getStartTimeOfConsecutiveTimeSlots test
    func mutateComponentsForSlotCodeStartTime(slotCode: String, earliestAssignedNumberComponent: inout Int, earliestAssignedLetterComponentAsInt: inout Int) {
        let slotCodeComponents: [String] = slotCode.components(separatedBy: "-")
        let numberComponent = Int(slotCodeComponents[0])!
        let letterComponent = slotCodeComponents[1]
        // If the accessed number component is earlier than the assigned earliest number component
        if  numberComponent < earliestAssignedNumberComponent {
            earliestAssignedNumberComponent = numberComponent
            if letterComponent == "A" {
                earliestAssignedLetterComponentAsInt = 0
            }
            if letterComponent == "B" {
                earliestAssignedLetterComponentAsInt = 1
            }
            if letterComponent == "C" {
                earliestAssignedLetterComponentAsInt = 2
            }
            if letterComponent == "D" {
                earliestAssignedLetterComponentAsInt = 3
            }
        }
            // If accessed number component already equal to the assigned earliest number component, then check the accessed letter component
        else if numberComponent == earliestAssignedNumberComponent {
            if letterComponent == "A" {
                if 0 < earliestAssignedLetterComponentAsInt {
                    earliestAssignedLetterComponentAsInt = 0
                }
            }
            else if letterComponent == "B" {
                if 1 < earliestAssignedLetterComponentAsInt {
                    earliestAssignedLetterComponentAsInt = 1
                }
            }
            else if letterComponent == "C" {
                if 2 < earliestAssignedLetterComponentAsInt {
                    earliestAssignedLetterComponentAsInt = 2
                }
            }
            else if letterComponent == "D" {
                if 3 < earliestAssignedLetterComponentAsInt {
                    earliestAssignedLetterComponentAsInt = 3
                }
            }
        }
    }
    
    // TEST: Untested directly, but tested through getEndTimeOfConsecutiveTimeSlots test
    func mutateComponentsForSlotCodeEndTime(slotCode: String, latestAssignedNumberComponent: inout Int, latestAssignedLetterComponentAsInt: inout Int) {
        
        let slotCodeComponents: [String] = slotCode.components(separatedBy: "-")
        let numberComponent = Int(slotCodeComponents[0])!
        let letterComponent = slotCodeComponents[1]
        // If the accessed number component is later than the assigned latest number component
        if  numberComponent > latestAssignedNumberComponent {
            latestAssignedNumberComponent = numberComponent
            if letterComponent == "A" {
                latestAssignedLetterComponentAsInt = 0
            }
            if letterComponent == "B" {
                latestAssignedLetterComponentAsInt = 1
            }
            if letterComponent == "C" {
                latestAssignedLetterComponentAsInt = 2
            }
            if letterComponent == "D" {
                latestAssignedLetterComponentAsInt = 3
            }
        }
        // If accessed number component already equal to the assigned latest number component, then check the accessed letter component
        else if numberComponent == latestAssignedNumberComponent {
            if letterComponent == "B" {
                if 1 > latestAssignedLetterComponentAsInt {
                    latestAssignedLetterComponentAsInt = 1
                }
            }
            else if letterComponent == "C" {
                if 2 > latestAssignedLetterComponentAsInt {
                    latestAssignedLetterComponentAsInt = 2
                }
            }
            else if letterComponent == "D" {
                if 3 > latestAssignedLetterComponentAsInt {
                    latestAssignedLetterComponentAsInt = 3
                }
            }
            else {
                latestAssignedLetterComponentAsInt = 0
            }
        }
    }
}
