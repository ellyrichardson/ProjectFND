//
//  MockScheduleViewDelegate.swift
//  ProjectFND
//
//  Created by Elly Richardson on 8/15/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import Foundation

class MockScheduleViewDelegate: NSObject, ScheduleViewDelegate {
    
    var scheduleTableViewData = [ScheduleViewData]()
    var onProgressTaskExist = false
    var finishedTaskExist = false
    var overdueTaskExist = false
    var selectedDate = Date()
    
    func setScheduleTableViewDataForDay(sData: [ScheduleViewData]) {
        self.scheduleTableViewData = sData
    }
    
    func setOnProgressTaskExist(exists: Bool) {
        self.onProgressTaskExist = exists
    }
    
    func setFinishedTaskExist(exists: Bool) {
        self.finishedTaskExist = exists
    }
    
    func setOverdueTaskExist(exists: Bool) {
        self.overdueTaskExist = exists
    }
    
    func getSelectedDate() -> Date {
        return selectedDate
    }
    
    func setSelectedDate(selectedDate: Date) {
        self.selectedDate = selectedDate
    }
}
