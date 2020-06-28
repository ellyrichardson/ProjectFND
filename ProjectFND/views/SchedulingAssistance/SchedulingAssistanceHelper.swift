//
//  SchedulingAssistanceHelper.swift
//  ProjectFND
//
//  Created by Elly Richardson on 6/20/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import UIKit

class SchedulingAssistanceHelper {
    let dateUtil = DateUtils()
    
    // This is so that the end time is 11:59 PM of the same day, not 12:00 AM of the next day
    func adjustTaskEndTimeIf12AMNextDay(startTime: Date, endTime: Date) -> Date {
        if dateUtil.areTimesInSameDay(earlyTime: startTime, laterTime: endTime) {
            let dayWith12AM =  dateUtil.createDate(dateString: "2020/01/15 00:00")
            let timeOf12AM = Calendar.current.dateComponents([.hour, .minute], from: dayWith12AM)
            let timeTarget = Calendar.current.dateComponents([.hour, .minute], from: endTime)
            
            if timeOf12AM == timeTarget {
                return dateUtil.addMinutesToDate(date: endTime, minutes: -(1.0))
            }
        }
        return endTime
    }
}
