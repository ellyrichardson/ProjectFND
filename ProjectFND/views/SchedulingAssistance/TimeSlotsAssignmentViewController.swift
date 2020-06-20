//
//  TimeSlotsAssignmentViewController.swift
//  ProjectFND
//
//  Created by Elly Richardson on 6/18/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import SwiftEntryKit
import UIKit

class TimeSlotsAssignmentViewController: UIViewController {
    @IBOutlet weak var startTimeUiView: UIView!
    @IBOutlet weak var endTimeUiView: UIView!
    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var endTimePicker: UIDatePicker!
    @IBOutlet weak var acceptButton: LongOvalButton!
    @IBOutlet weak var cancelButton: LongOvalButton!
    
    private var schedlngAsstncHelper = SchedulingAssistanceHelper()
    private var minimumTime: Date?, maximumTime: Date?
    private let dateUtil = DateUtils()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Task Time"
        
        configureTimePickers()
        configureButtons()
    }

    private func configureTimePickers() {
        self.startTimePicker.datePickerMode = .time
        self.endTimePicker.datePickerMode = .time
        self.startTimePicker.setDate(self.minimumTime!, animated: false)
        configurePickerMinAndMax()
    }
    
    private func configurePickerMinAndMax() {
        setStartTimePickerMinAndMax()
        setEndTimePickerMinAndMax()
    }
    
    private func configureButtons() {
        self.acceptButton.backgroundColor = ColorUtils.classicGreen()
        self.cancelButton.backgroundColor = ColorUtils.classicOrange()
    }
    
    private func setStartTimePickerMinAndMax() {
        self.startTimePicker.minimumDate = self.minimumTime
        
        // This is so that the max time is 11:59 PM of the same day, not 12:00 AM of the next day
        self.startTimePicker.maximumDate = schedlngAsstncHelper.adjustTaskEndTimeIf12AMNextDay(startTime: self.minimumTime!, endTime: self.maximumTime!)
    }
    
    private func setEndTimePickerMinAndMax() {
        self.endTimePicker.minimumDate = self.minimumTime
        
        // This is so that the max time is 11:59 PM of the same day, not 12:00 AM of the next day
        self.endTimePicker.maximumDate = schedlngAsstncHelper.adjustTaskEndTimeIf12AMNextDay(startTime: self.minimumTime!, endTime: self.maximumTime!)
    }
    
    private func areTimesSameDay(earlyTime: Date, laterTime: Date) -> Bool {
        if dateUtil.daysBetweenTwoDates(earlyDate: earlyTime, laterDate: laterTime) > 0 {
            return false
        }
        return true
    }
    
    func setMinAndMaxTime(minTime: Date, maxTime: Date) {
        self.minimumTime = minTime
        self.maximumTime = maxTime
    }
    
    // MARK: - IB Actions
    
    @IBAction func acceptButtonAction(_ sender: UIButton) {
        SwiftEntryKit.dismiss()
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        SwiftEntryKit.dismiss()
    }
}
