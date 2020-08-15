//
//  ScheduleViewPresenter.swift
//  ProjectFND
//
//  Created by Elly Richardson on 8/15/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import Foundation

class ScheduleViewPresenter {
    private let taskService: ToDosController
    weak private var scheduleViewDelegate: ScheduleViewDelegate?
    
    init(taskService: ToDosController) {
        self.taskService = taskService
    }
    
    func setViewDelegate(scheduleViewDelegate: ScheduleViewDelegate) {
        self.scheduleViewDelegate = scheduleViewDelegate
    }
}
