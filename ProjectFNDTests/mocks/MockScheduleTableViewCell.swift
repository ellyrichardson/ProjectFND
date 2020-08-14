//
//  MockScheduleTableViewCell.swift
//  ProjectFND
//
//  Created by Elly Richardson on 8/13/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

class MockScheduleTableViewCell: ScheduleTableViewCellProtocol {
    
    private var taskName = ""
    private var startTime = ""
    private var endTime = ""
    private var taskTag = ""
    private var checkBoxButton = CheckBoxButton()
    private var expandButton = ExpandButton()
    private var importantButton = ImportantButton()
    private var notifyButton = NotificationButton()
    
    func setTaskName(taskName: String) {
        self.taskName = taskName
    }
    
    func setStartTime(startTime: String) {
        self.startTime = startTime
    }
    
    func setEndTime(endTime: String) {
        self.endTime = endTime
    }
    
    func setTaskTag(taskTag: String) {
        self.taskTag = taskTag
    }
    
    func getTaskName() -> String {
        return taskName
    }
    
    func getStartTime() -> String {
        return startTime
    }
    
    func getEndTime() -> String {
        return endTime
    }
    
    func getTaskTag() -> String {
        return taskTag
    }
    
    func getCheckBoxButton() -> CheckBoxButton {
        return checkBoxButton
    }
    
    func getExpandButton() -> ExpandButton {
        return expandButton
    }
    
    func getImportantButton() -> ImportantButton {
        return importantButton
    }
    
    func getNotifyButton() -> NotificationButton {
        return notifyButton
    }
}
