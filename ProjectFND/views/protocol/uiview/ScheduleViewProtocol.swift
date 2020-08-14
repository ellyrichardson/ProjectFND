//
//  ScheduleView.swift
//  ProjectFND
//
//  Created by Elly Richardson on 8/13/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import UIKit
import JTAppleCalendar

protocol ScheduleViewProtocol: BaseViewProtocol {
    func getTaskScheduleTableView() -> UITableView
    func getScheduleCalendarView() -> JTAppleCalendarView
}
