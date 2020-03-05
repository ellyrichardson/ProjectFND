//
//  ItemInfoTableViewController.swift
//  ProjectFND
//
//  Created by Elly Richardson on 9/4/19.
//  Copyright © 2019 EllyRichardson. All rights reserved.
//

import UIKit
import os.log

class ItemInfoTableViewController: UITableViewController, UITextViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var taskNameDescriptionLabel: UILabel!
    @IBOutlet weak var taskNameField: UITextField!
    @IBOutlet weak var taskDescriptionView: UITextView!
    @IBOutlet weak var estTimeLabel: UILabel!
    @IBOutlet weak var estTimeField: UITextField!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var intervalSchedulingHourField: UITextField!
    @IBOutlet weak var intervalSchedulingDayField: UITextField!
    @IBOutlet weak var intervalSchedulingSetupButton: UIButton!
    
    private var taskItemCells = [StaticTableCell]()
    var toDo: ToDo?
    var toDoIntervals: [ToDo] = [ToDo]()
    var toDoIntervalsExist: Bool = false
    private var finished: Bool
    private var chosenWorkDate: Date
    private var chosenDueDate: Date
    private var schedulerWasSet: Bool
    
    required init?(coder aDecoder: NSCoder) {
        self.chosenWorkDate = Date()
        self.chosenDueDate = Date()
        self.finished = false
        self.schedulerWasSet = false

        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nav = self.navigationController?.navigationBar
        
        // Sets the navigation bar to color black with tintColor of yellow.
        nav?.barStyle = UIBarStyle.black
        nav?.tintColor = UIColor(red:1.00, green:0.89, blue:0.00, alpha:1.0)
        
        startDatePicker.setValue(UIColor.white, forKey: "textColor")
        endDatePicker.setValue(UIColor.white, forKey: "textColor")
        
        // Auto resizing the height of the cell
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.tableFooterView = UIView()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d/yy, h:mm a"
        
        taskItemCells = [
            StaticTableCell(name: "Task Details"),
            StaticTableCell(name: "Work Date"),
            StaticTableCell(name: "Estimated Time"),
            StaticTableCell(name: "Due Date"),
            StaticTableCell(name: "Interval Scheduling"),
        ]

        taskNameField.delegate = self
        taskDescriptionView.delegate = self
        estTimeField.delegate = self
        
        // Set up views if editing an existing ToDo.
        if let toDo = toDo {
            navigationItem.title = toDo.taskName
            taskNameField.text = toDo.taskName
            taskDescriptionView.text = toDo.taskDescription
            taskNameDescriptionLabel.text = "Task Details: " + toDo.taskName
            startDateLabel.text = "Work Date: " + dateFormatter.string(from: toDo.workDate)
            startDatePicker.date = toDo.workDate
            estTimeLabel.text = "Estmated Time: " + toDo.estTime
            estTimeField.text = toDo.estTime
            endDateLabel.text = "Due Date: " + dateFormatter.string(from: toDo.dueDate)
            endDatePicker.date = toDo.dueDate
        }
        
        updateSaveButtonState()
    }
    
    // MARK: - Setters
    
    func setChosenWorkDate(chosenWorkDate: Date) {
        self.chosenWorkDate = chosenWorkDate
    }
    
    func setChosenDueDate(chosenDueDate: Date) {
        self.chosenDueDate = chosenDueDate
    }
    
    func setIsFinished(isFinished: Bool) {
        self.finished = isFinished
    }
    
    // MARK: - Getters
    
    func getIsFinished() -> Bool {
        return self.finished
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // Determines which of the textfield is it working
        if textField == taskNameField {
            taskNameDescriptionLabel.text = "Task Details: " + textField.text!
        }
        else if textField == estTimeField {
            estTimeLabel.text = "Estimated Time: " + textField.text!
        }
        
        updateSaveButtonState()
    }

    // MARK: - Actions
    
    @IBAction func startDatePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        setChosenWorkDate(chosenWorkDate: sender.date)
        let strDate = dateFormatter.string(from: chosenWorkDate)
        startDateLabel.text = "Start Date: " + strDate
    }
    
    @IBAction func endDatePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        setChosenDueDate(chosenDueDate: sender.date)
        let strDate = dateFormatter.string(from: chosenDueDate)
        endDateLabel.text = "End Date: " + strDate
    }
    
    // NOTE: Don't delete this!
    @IBAction func setupIntervalSchedule(_ sender: UIButton) {
        var toDoProcessHelper = ToDoProcessUtils()
        
        var intervalHours = intervalSchedulingHourField.text
        var intervalDays = intervalSchedulingDayField.text
        
        // Send the interval hours and days from here to next view!
 
    }
    
    // MARK: - Table view data source
    
    // Collapses and expands table view cells
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if taskItemCells[0].collapsed {
                taskItemCells[0].collapsed = false
            } else {
                taskItemCells[0].collapsed = true
                // Uncollapse all other table rows
                taskItemCells[1].collapsed = false
                taskItemCells[2].collapsed = false
                taskItemCells[3].collapsed = false
            }
            tableView.beginUpdates()
            tableView.endUpdates()
        }
        if indexPath.row == 1 {
            if taskItemCells[1].collapsed {
                taskItemCells[1].collapsed = false
            } else {
                taskItemCells[1].collapsed = true
                // Uncollapse all other table rows
                taskItemCells[0].collapsed = false
                taskItemCells[2].collapsed = false
                taskItemCells[3].collapsed = false
                taskItemCells[4].collapsed = false
            }
            tableView.beginUpdates()
            tableView.endUpdates()
        }
        if indexPath.row == 2 {
            if taskItemCells[2].collapsed {
                taskItemCells[2].collapsed = false
            } else {
                taskItemCells[2].collapsed = true
                // Uncollapse all other table rows
                taskItemCells[0].collapsed = false
                taskItemCells[1].collapsed = false
                taskItemCells[3].collapsed = false
                taskItemCells[4].collapsed = false
            }
            tableView.beginUpdates()
            tableView.endUpdates()
        }
        if indexPath.row == 3 {
            if taskItemCells[3].collapsed {
                taskItemCells[3].collapsed = false
            } else {
                taskItemCells[3].collapsed = true
                // Uncollapse all other table rows
                taskItemCells[0].collapsed = false
                taskItemCells[1].collapsed = false
                taskItemCells[2].collapsed = false
                taskItemCells[4].collapsed = false
            }
            tableView.beginUpdates()
            tableView.endUpdates()
        }
        if indexPath.row == 4 {
            if taskItemCells[4].collapsed {
                taskItemCells[4].collapsed = false
            } else {
                taskItemCells[4].collapsed = true
                // Uncollapse all other table rows
                taskItemCells[0].collapsed = false
                taskItemCells[1].collapsed = false
                taskItemCells[2].collapsed = false
                taskItemCells[3].collapsed = false
            }
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    // Determines the height of the expansion of the table view cells
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            if taskItemCells[0].collapsed {
                return 210
            }
        }
        if indexPath.row == 1 {
            if taskItemCells[1].collapsed {
                return 100
            }
        }
        if indexPath.row == 2 {
            if taskItemCells[2].collapsed {
                return 170
            }
        }
        if indexPath.row == 3 {
            if taskItemCells[3].collapsed {
                return 170
            }
        }
        if indexPath.row == 4 {
            if taskItemCells[4].collapsed {
                return 210
            }
        }
        return 50
    }
    
    // MARK: - Navigation
    
    // Prepares view controller before it gets presented
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "setupIntervals" {
            guard let intervalSchedulingPreviewController = segue.destination as? IntervalSchedulingPreviewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            let intervalHours = intervalSchedulingHourField.text
            let intervalDays = intervalSchedulingDayField.text
            let taskName = taskNameField.text
            let taskDescription = taskDescriptionView.text
            let workDate = chosenWorkDate
            let estTime = estTimeField.text
            let dueDate = chosenDueDate
            
            updateSaveButtonState()
            navigationItem.title = taskName
            
            // TODO: REMOVE TIGHT COUPLING!
            
            // Set the ToDo to be passed to ToDoListTableViewController after pressing save with unwind segue
            intervalSchedulingPreviewController.setIntervalAmount(intervalAmount: intervalDays!)
            intervalSchedulingPreviewController.setIntervalLength(intervalLength: intervalHours!)
            intervalSchedulingPreviewController.setToDoStartDate(toDoStartDate: workDate)
            intervalSchedulingPreviewController.setToDoEndDate(toDoEndDate: dueDate)
            intervalSchedulingPreviewController.setToDoToBeIntervalized(toDo: ToDo(taskName: taskName!, taskDescription: taskDescription!, workDate: workDate, estTime: estTime!, dueDate: dueDate, finished: getIsFinished())!)
            
        } else {
            // Only prepare view controller when the save button is pressed
            guard let button = sender as? UIBarButtonItem, button === saveButton else {
                os_log("The save button was not pressed, cancelling new item", log: OSLog.default,
                       type: .debug)
                return
            }
            
            let taskName = taskNameField.text
            let taskDescription = taskDescriptionView.text
            let workDate = chosenWorkDate
            let estTime = estTimeField.text
            let dueDate = chosenDueDate
            
            updateSaveButtonState()
            navigationItem.title = taskName
            
            // Set the ToDo to be passed to ToDoListTableViewController after pressing save with unwind segue
            toDo = ToDo(taskName: taskName!, taskDescription: taskDescription!, workDate: workDate, estTime: estTime!, dueDate: dueDate, finished: getIsFinished())
        }
    }
    
    // TODO: Remove tight coupling
    @IBAction func unwindToItemInfo(sender:UIStoryboardSegue) {
        if let sourceViewController = sender.source as? IntervalSchedulingPreviewController {
            self.toDoIntervalsExist = true
            self.toDoIntervals  = sourceViewController.getToDoIntervalsToAssign()
        }
    }
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddToDoMode = presentingViewController is UINavigationController
        
        if isPresentingInAddToDoMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The ItemInfoTableViewController is not inside a navigation controller.")
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Private Methods
    
    // Disable the save button if the text field is empty
    private func updateSaveButtonState() {
        saveButton.isEnabled = false
        
        // Task name or estimated time fields are empty
        if !(taskNameField.text?.isEmpty)! && !(estTimeField.text?.isEmpty)! {
            saveButton.isEnabled = true
        }
        
        // Only allow saveButton if textFields are not empty
        taskNameField.addTarget(self, action: #selector(textFieldsAreNotEmpty), for: .editingChanged)
        estTimeField.addTarget(self, action: #selector(textFieldsAreNotEmpty), for: .editingChanged)
    }
    
    // MARK: - Observers
    
    // Only allow saveButton if textFields are not empty
    @objc func textFieldsAreNotEmpty(sender: UITextField) {
        guard
            let taskName = taskNameField.text, !taskName.isEmpty,
            let estTime = estTimeField.text, !estTime.isEmpty
            else {
                self.saveButton.isEnabled = false
                return
        }
        // Enable save button if all conditions are met
        saveButton.isEnabled = true
    }
    
    // MARK: - Getters
    
    func getToDoIntervals() -> [ToDo] {
        return self.toDoIntervals
    }
    
    func isToDoIntervalsExist() -> Bool {
        return self.toDoIntervalsExist
    }
}
