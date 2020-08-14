//
//  ScheduleView.swift
//  ProjectFND
//
//  Created by Elly Richardson on 8/13/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import UIKit

protocol ScheduleViewProtocol {
    func getTaskScheduleTableView() -> TaskScheduleTableViewProtocol
    func getScheduleCalendarView() -> ScheduleCalendarViewProtocol
}
