//
//  ScheduleTableViewCellProtocol.swift
//  ProjectFND
//
//  Created by Elly Richardson on 8/13/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import UIKit

protocol ScheduleTableViewCellProtocol {
    func setTaskName(taskName: String)
    func setStartTime(startTime: String)
    func setEndTime(endTime: String)
    func setTaskTag(taskTag: String)

    func getTaskName() -> String
    func getStartTime() -> String
    func getEndTime() -> String
    func getTaskTag() -> String
    func getCheckBoxButton() -> CheckBoxButton
    func getExpandButton() -> ExpandButton
    func getImportantButton() -> ImportantButton
    func getNotifyButton() -> NotificationButton
}
