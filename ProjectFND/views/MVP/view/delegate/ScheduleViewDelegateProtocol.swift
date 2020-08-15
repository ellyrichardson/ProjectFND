//
//  ScheduleViewDelegateProtocol.swift
//  ProjectFND
//
//  Created by Elly Richardson on 8/15/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import UIKit

protocol ScheduleViewDelegate: NSObjectProtocol {
    func updateScheduleCalendar()
    func updateTasksTable()
    //func getTabBarController() -> UITabBarController?
    //func setTaskTableViewRowCount(rowCount: Int)
    func getSelectedDate() -> Date
}
