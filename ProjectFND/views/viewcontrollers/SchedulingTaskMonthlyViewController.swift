//
//  ScheduleTaskMonthlyViewController.swift
//  ProjectFND
//
//  Created by Elly Richardson on 5/29/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import SwiftEntryKit
import UIKit

class SchedulingTaskMonthlyViewController: UIViewController {

    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var acceptButton: LongOvalButton!
    @IBOutlet weak var cancelButton: LongOvalButton!
    
    private var observableDueDateController = ObservableDateController()
    
    // MARK: - Unsaved Changes Trackers
    private var changedDateTo: Date = Date()
    
    // MARK: - Selection Tracker
    private var selectedDueDateTracker = Date()
    private var isDueDatePreSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Due Date" // THIS IS THE DUE DATE VIEW
        // Do any additional setup after loading the view.
        setDueDatePickerValue()
        setButtonColors()
    }

    @IBAction func dueDatePickerValueChanged(_ sender: UIDatePicker) {
        self.changedDateTo = sender.date
    }
    
    @IBAction func acceptButton(_ sender: UIButton) {
        
        self.observableDueDateController.updateDate(updatedDate: ToDoDate(dateValue: self.changedDateTo, assigned: true))
        SwiftEntryKit.dismiss()
    }
    
    // Rename this to be a "Remove" button
    @IBAction func cancelButton(_ sender: UIButton) {
        self.observableDueDateController.updateDate(updatedDate: ToDoDate(dateValue: self.changedDateTo, assigned: false))
        SwiftEntryKit.dismiss()
    }
    
    func setObservableDueDateController(observableDueDateController: ObservableDateController) {
        self.observableDueDateController = observableDueDateController
    }
    
    private func setButtonColors() {
        //self.acceptButton =
        self.acceptButton.backgroundColor = ColorUtils.classicGreen()
        self.cancelButton.backgroundColor =  ColorUtils.classicOrange()
    }
    
    func setSelectedDate(dateVal: Date) {
        self.selectedDueDateTracker = dateVal
        self.isDueDatePreSelected = true
    }
    
    private func setDueDatePickerValue() {
        let dateReceived: ToDoDate = self.observableDueDateController.getDueDate()
        if !dateReceived.assigned {
            
            if self.isDueDatePreSelected {
                self.dueDatePicker.date = self.selectedDueDateTracker
                self.isDueDatePreSelected = false
            } else {
                self.dueDatePicker.date = Date()
            }
            
        } else {
            self.dueDatePicker.date = dateReceived.dateValue!
        }
    }
}
