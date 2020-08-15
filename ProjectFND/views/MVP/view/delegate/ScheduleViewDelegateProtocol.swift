//
//  ScheduleViewDelegateProtocol.swift
//  ProjectFND
//
//  Created by Elly Richardson on 8/15/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import Foundation

protocol ScheduleViewDelegate: NSObjectProtocol {
    func updateScheduleCalendar()
    func updateTasksTable()
}
