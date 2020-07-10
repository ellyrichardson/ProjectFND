//
//  DateOperationsHelper.swift
//  ProjectFND
//
//  Created by Elly Richardson on 1/18/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import CoreData
import UIKit
import os.log

class DateUtils{
    private let dateFormatter = DateFormatter()
    private let calendar = Calendar.current
    
    func changeDateFormatToMDYY(dateToChange: Date) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d/yy"
        let dateString = dateFormatter.string(from: dateToChange)
        return dateFormatter.date(from: dateString)!
    }
    
    func addMinutesToDate(date: Date, minutes: Double) -> Date {
        // Adds minutes (minutes * 60) to the date that needs to increase
        return date.addingTimeInterval(minutes * 60.0)
    }
    
    func addHoursToDate(date: Date, hours: Double) -> Date {
        // Adds hours (hours * (60 * 60)) to the date that needs to increase
        return date.addingTimeInterval(hours * (60.0 * 60.0))
    }
    
    func subtractHoursToDate(date: Date, hours: Double) -> Date {
        // Adds hours (hours * (60 * 60)) to the date that needs to increase
        return date.addingTimeInterval(-(hours) * (60.0 * 60.0))
    }
    
    func addDayToDate(date: Date, days: Double) -> Date {
        // Adds days (day * (60 * 60 * 24)) to the date that needs to increase
        return date.addingTimeInterval(days * (60.0 * 60.0 * 24.0))
    }
    
    /*
     Example date: "2020/01/15 16:30"
     */
    func createDate(dateString: String) -> Date{
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        return dateFormatter.date(from: dateString)!
    }
    
    func minutesBetweenTwoDates(earlyDate: Date, laterDate: Date) -> Int {
        return calendar.dateComponents([.minute], from: earlyDate, to: laterDate).minute!
    }
    
    func hoursBetweenTwoDates(earlyDate: Date, laterDate: Date) -> Int {
        return calendar.dateComponents([.hour], from: earlyDate, to: laterDate).hour!
    }
    
    func daysBetweenTwoDates(earlyDate: Date, laterDate: Date) -> Int {
        return calendar.dateComponents([.day], from: earlyDate, to: laterDate).day!
    }
    
    func areTimesInSameDay(earlyTime: Date, laterTime: Date) -> Bool {
        if daysBetweenTwoDates(earlyDate: earlyTime, laterDate: laterTime) > 0 {
            return false
        }
        return true
    }
    
    func getDayAsString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd" // i.e. 12 AM
        return dateFormatter.string(from: date)
    }
    
    func revertDateToZeroHours(date: Date) -> Date {
        let stringDate = getDayAsString(date: date)
        let formattedDate = createDate(dateString: stringDate + " 00:00")
        
        return formattedDate
    }
}
