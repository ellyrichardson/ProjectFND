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
    
    private var minimumTime: Date?, maximumTime: Date?
    private let dateUtil = DateUtils()
    private var selectedOter: Oter?
    
    // MARK: - Observable Items
    
    private var observableOterController = ObservableOterController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Task Time"
        navigationController?.setNavigationBarHidden(true, animated: false)
        
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
        startTimePicker.addTarget(self, action: #selector(self.startTimePickerValueChanged(_:)), for: .valueChanged)
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
        startTimePicker.minimumDate = self.minimumTime
        startTimePicker.maximumDate = self.maximumTime
    }
    
    // There is no maximum and minimum for EndTimePicker because it is manually handled with updateTimeBasedOnStartTimePickerMinAndMax function
    private func setEndTimePickerMinAndMax() {
        self.endTimePicker.date = updateTimeBasedOnStartTimePickerMinAndMax(dateTime: maximumTime!)
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
    
    @IBAction func startTimePickerValueChanged(_ sender: UIDatePicker) {
        self.endTimePicker.date = updateTimeBasedOnStartTimePickerMinAndMax(dateTime: endTimePicker.date)
        self.endTimePicker.reloadInputViews()
    }
    
    @IBAction func endTimePickerValueChanged(_ sender: UIDatePicker) {
        self.endTimePicker.date = updateTimeBasedOnStartTimePickerMinAndMax(dateTime: endTimePicker.date)
        self.endTimePicker.reloadInputViews()
    }
    
    // This function was made to adjust the EndTimePicker values. Mainly to allow 12 AM selection for the next day without creating a custom PickerView
    private func updateTimeBasedOnStartTimePickerMinAndMax(dateTime: Date) -> Date {
        var updatedTime = dateTime
        if dateUtil.isDate12AM(dateTime: maximumTime!) {
            if !dateUtil.isDate12AM(dateTime: dateTime) {
                if dateTime > startTimePicker.maximumDate! || dateTime < startTimePicker.date {
                    updatedTime = startTimePicker.date
                }
            }
            else {
                updatedTime = startTimePicker.maximumDate!
            }
        }
        else {
            if dateTime > maximumTime! {
                updatedTime = maximumTime!
            }
            else if dateTime < startTimePicker.date {
                updatedTime = startTimePicker.date
            }
        }
        return updatedTime
    }
}
