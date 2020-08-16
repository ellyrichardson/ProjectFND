//
//  ScheduleViewDelegateProtocol.swift
//  ProjectFND
//
//  Created by Elly Richardson on 8/15/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import UIKit

protocol ScheduleViewDelegate: NSObjectProtocol {
    func setScheduleTableViewDataForDay(sData: [ScheduleViewData])
    func setOnProgressTaskExist(exists: Bool)
    func setFinishedTaskExist(exists: Bool)
    func setOverdueTaskExist(exists: Bool)
    
    func getSelectedDate() -> Date
}
