//
//  ScheduleViewData.swift
//  ProjectFND
//
//  Created by Elly Richardson on 8/15/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

struct ScheduleViewData {
    var taskName: String
    var taskTag: String
    var timeSpan: TimeSpan
    var dueDate: ToDoDate
    var finished: Bool
    var important: Bool
    var notifying: Bool
}
