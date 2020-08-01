//
//  TimeSlotsAssignmentViewController.swift
//  ProjectFND
//
//  Created by Elly Richardson on 6/18/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import SwiftEntryKit
import UIKit

// Maybe call this time slot selector instead?
class TimeSlotsAssignmentViewController: UIViewController {
    
    final let PLACE_HOLDER_DATE = "2020/01/15 00:00"
    
    @IBOutlet weak var startTimeUiView: UIView!
    @IBOutlet weak var endTimeUiView: UIView!
    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var endTimePicker: UIDatePicker!
    @IBOutlet weak var acceptButton: LongOvalButton!
    @IBOutlet weak var cancelButton: LongOvalButton!
    
    private var schedlngAsstncHelper = SchedulingAssistanceHelper()
    private var minimumTime: Date?, maximumTime: Date?
    private let dateUtil = DateUtils()
    private var selectedOter: Oter?
    
    // MARK: - Observable Items
    
    private var observableOterController = ObservableOterController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Task Time"
        
        configureTimePickers()
        configureButtons()
    }
    
    func setObservableOterController(observableOterController: ObservableOterController) {
        self.observableOterController = observableOterController
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
        self.startTimePicker.maximumDate = schedlngAsstncHelper.adjustTaskEndTimeIf12AMNextDay(endTime: self.maximumTime!)
    }
    
    private func setEndTimePickerMinAndMax() {
        self.endTimePicker.minimumDate =    self.minimumTime
        
        // This is so that the max time is 11:59 PM of the same day, not 12:00 AM of the next day
        self.endTimePicker.maximumDate = schedlngAsstncHelper.adjustTaskEndTimeIf12AMNextDay(endTime: self.maximumTime!)
    }
    
    private func areTimesSameDay(earlyTime: Date, laterTime: Date) -> Bool {
        if dateUtil.daysBetweenTwoDates(earlyDate: earlyTime, laterDate: laterTime) > 0 {
            return false
        }
        return true
    }
    
    func setMinAndMaxTime(minTime: Date, maxTime: Date) {
        setMinTime(minTime: minTime)
        setMaxTime(maxTime: maxTime)
    }
    
    func setMinTime(minTime: Date) {
        self.minimumTime = minTime
    }
    
    func setMaxTime(maxTime: Date) {
        self.maximumTime = maxTime
    }
    
    func setSelectedOter(selectedOter: Oter) {
        self.selectedOter = selectedOter
    }
    
    // MARK: - IB Actions
    
    @IBAction func acceptButtonAction(_ sender: UIButton) {
        self.observableOterController.updateOter(updatedOter: Oter(startDate: self.startTimePicker.date, endDate: self.endTimePicker.date, ownerTaskId: self.selectedOter!.ownerTaskId, occupancyType: TSOType.OCCUPIED))
        SwiftEntryKit.dismiss()
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        SwiftEntryKit.dismiss()
    }
}
