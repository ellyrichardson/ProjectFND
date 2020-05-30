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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Due Date"
        // Do any additional setup after loading the view.
        setDueDatePickerValue()
    }

    @IBAction func dueDatePickerValueChanged(_ sender: UIDatePicker) {
        self.changedDateTo = sender.date
    }
    
    @IBAction func acceptButton(_ sender: UIButton) {
        self.observableDueDateController.updateDate(updatedDate: changedDateTo)
        SwiftEntryKit.dismiss()
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        SwiftEntryKit.dismiss()
    }
    
    func setObservableDueDateController(observableDueDateController: ObservableDateController) {
        self.observableDueDateController = observableDueDateController
    }
    
    private func setDueDatePickerValue() {
        /*
        if let date = self.observableDueDate.value {
            self.dueDatePicker.date = Date()
        }
        else {
            self.dueDatePicker.date = Date()
        }*/
        self.dueDatePicker.date = Date()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
