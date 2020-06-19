//
//  TimeSlotsAssignmentViewController.swift
//  ProjectFND
//
//  Created by Elly Richardson on 6/18/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import UIKit

class TimeSlotsAssignmentViewController: UIViewController {
    @IBOutlet weak var startTimeUiView: UIView!
    @IBOutlet weak var endTimeUiView: UIView!
    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var endTimePicker: UIDatePicker!
    @IBOutlet weak var acceptButton: LongOvalButton!
    @IBOutlet weak var cancelButton: LongOvalButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Task Time"
        
        configureTimePickers()
        configureButtons()
    }

    private func configureTimePickers() {
        self.startTimePicker.datePickerMode = .time
        self.endTimePicker.datePickerMode = .time
    }
    
    private func configureButtons() {
        self.acceptButton.backgroundColor = ColorUtils.classicGreen()
        self.cancelButton.backgroundColor = ColorUtils.classicOrange()
    }
}
