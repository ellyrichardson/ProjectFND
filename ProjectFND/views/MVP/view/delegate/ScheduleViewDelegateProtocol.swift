//
//  ScheduleViewDelegateProtocol.swift
//  ProjectFND
//
//  Created by Elly Richardson on 8/15/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import UIKit

protocol ScheduleViewDelegate: NSObjectProtocol {
    //func updateScheduleCalendar()
    //func updateTasksTable()
    
    //func getTabBarController() -> UITabBarController?
    //func setTaskTableViewRowCount(rowCount: Int)
    func setScheduleTableViewDataForDay(sData: [ScheduleViewData])
    func getSelectedDate() -> Date
    func setOnProgressTaskExist(exists: Bool)
    func setFinishedTaskExist(exists: Bool)
    func setOverdueTaskExist(exists: Bool)
}
