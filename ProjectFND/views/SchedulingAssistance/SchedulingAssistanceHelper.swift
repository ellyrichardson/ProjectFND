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
        if dateUtil.areTimesSameDay(earlyTime: startTime, laterTime: endTime) {
            return dateUtil.addMinutesToDate(date: endTime, minutes: -(1.0))
        }
        return endTime
    }
}
