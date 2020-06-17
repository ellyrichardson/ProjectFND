//
//  ItemInfoTableViewController.swift
//  ProjectFND
//
//  Created by Elly Richardson on 9/4/19.
//  Copyright © 2019 EllyRichardson. All rights reserved.
//

import UIKit
import SwiftEntryKit
import os.log

class ItemInfoTableViewController: UITableViewController, UITextViewDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, Observer {
    
    
    
    @IBOutlet weak var taskNameField: UITextField!
    @IBOutlet weak var taskTypeLabel: UILabel!
    // NOTE: Make the description like the notes
    //@IBOutlet weak var taskDescriptionView: UITextView!
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
    @IBOutlet weak var taskTypePicker: UIPickerView!
    //@IBOutlet weak var repeatingSwitch: UISwitch!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    
    private var taskItemCells = [StaticTableCell]()
    private var taskTypePickerData: [String] = [String]()
    
    var toDo: ToDo?
    private var toDos = [String: ToDo]()
    var toDoIntervals: [String: ToDo] = [String: ToDo]()
    var toDoIntervalsExist: Bool = false
    private var finished: Bool
    private var chosenWorkDate: Date
    private var chosenDueDate: Date
    private var schedulerWasSet: Bool
    
    private var dataSource = PresetsDataSource()
    
    // MARK: - Start/End Date UIView
    
    @IBOutlet weak var startDateUIView: ItemInfoView!
    @IBOutlet weak var endDateUIView: ItemInfoView!
    @IBOutlet weak var startDateStringValue: UILabel!
    @IBOutlet weak var endDateStringValue: UILabel!
    
    // MARK: - Trackers
    private var selectedTaskTypePickerData: String = String()
    private var repeatingStatus: Bool = Bool()
    
    // MARK: - Due Date Observable
    
    private var observableDueDateController = ObservableDateController()
    
    // MARK: - Tags Observable
    
    private var observableTagsController = ObservableTagsController()
    
    // MARK: - Observable Essentials
    
    private var _observerId: Int = 0
    
    // Id of the ViewController as an Observer
    var observerId: Int {
        get {
            return self._observerId
        }
    }
    
    // NOTE: Must use the DateObserver class, or something similar
    func update<T>(with newValue: T, with observableType: ObservableType) {
        if observableType == ObservableType.TODO_DUE_DATE {
            let newValueDate = newValue as! ToDoDate
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy, h:mm a"
            
            self.dueDateLabel.text = "Due Date: " + dateFormatter.string(from: newValueDate.dateValue!)
            self.tableView.reloadData()
        }
        else if observableType == ObservableType.TODO_TAG {
            let newValueTag = newValue as! ToDoTags
            self.tagsLabel.text = "Tags: " + newValueTag.tagValue!
            print("TAG WAS UPDATED")
        }
    }
    
    // MARK: - Essentials
    
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
        
        self.taskTypePicker.delegate = self
        self.taskTypePicker.dataSource = self
        
        // NOTE: Observable area
        let observerVCs: [Observer] = [self]
        self.observableDueDateController.setupData()
        self.observableDueDateController.setObservers(observers: observerVCs)
        self.observableTagsController.setupData()
        self.observableTagsController.setObservers(observers: observerVCs)

        taskTypePickerData = ["Personal", "Work", "School"]
        //setPickerViewSelectedRow()
        
        // Sets the navigation bar to color black with tintColor of yellow.
        nav?.barStyle = UIBarStyle.black
        nav?.tintColor = UIColor(red:1.00, green:0.89, blue:0.00, alpha:1.0)
        
        startDatePicker.setValue(UIColor.white, forKey: "textColor")
        endDatePicker.setValue(UIColor.white, forKey: "textColor")
        
        /*
        self.repeatingSwitch.addTarget(self, action: #selector(checkRepeatingSwitchState), for: .valueChanged)*/
        
        
        // Auto resizing the height of the cell
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.tableFooterView = UIView()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d/yy, h:mm a"
        
        taskItemCells = [
            StaticTableCell(name: "Task Details"),
            StaticTableCell(name: "Task Type"),
            StaticTableCell(name: "Work Date"),
            StaticTableCell(name: "Estimated Time"),
            StaticTableCell(name: "Due Date"),
            StaticTableCell(name: "Interval Scheduling"),
        ]

        taskNameField.delegate = self
        //taskDescriptionView.delegate = self
        estTimeField.delegate = self
        
        //repeatingSwitch.isOn = false
        
        // Set up views if editing an existing ToDo.
        if let toDo = toDo {
            navigationItem.title = toDo.taskName
            taskNameField.text = toDo.taskName
            //taskDescriptionView.text = toDo.taskDescription
            //taskNameDescriptionLabel.text = "Task Details: " + toDo.taskName
            startDateLabel.text = "Work Date: " + dateFormatter.string(from: toDo.workDate)
            startDatePicker.date = toDo.workDate
            estTimeLabel.text = "Estmated Time: " + toDo.estTime
            estTimeField.text = toDo.estTime
            endDateLabel.text = "Due Date: " + dateFormatter.string(from: toDo.dueDate)
            endDatePicker.date = toDo.dueDate
            taskTypeLabel.text = "Task Type: " + toDo.getTaskType()
            //self.repeatingSwitch.isOn = toDo.isRepeating()
            // TODO: Fix the selecting of already selected Rows!
            //setPickerViewSelectedRow()
        }
        // Path if not editing an existing ToDo
        
        // NOTE: UIView area
        startDateUIView.cornerRadius = 10
        endDateUIView.cornerRadius = 10
        
        let gestureRecSD = UITapGestureRecognizer(target: self, action:  #selector (self.segueToSchedulingAssistance(sender:)))
        let gestureRecED = UITapGestureRecognizer(target: self, action:  #selector (self.segueToSchedulingAssistance(sender:)))
        startDateUIView.addGestureRecognizer(gestureRecSD)
        endDateUIView.addGestureRecognizer(gestureRecED)
        
        updateSaveButtonState()
    }
    
    
    // MARK: - Picker Utilities
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return taskTypePickerData.count
    }
    
    // Returns the taskTypePickerData to the TaskTypePicker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return taskTypePickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedTaskTypePickerData = taskTypePickerData[row]
        self.taskTypeLabel.text = "Task Type: " + self.selectedTaskTypePickerData
    }
    
    func setPickerViewSelectedRow() {
        let selectedTaskType = toDo?.getTaskType()
        switch selectedTaskType {
        case "Work":
            self.taskTypePicker.selectedRow(inComponent: 1)
        case "School":
            self.taskTypePicker.selectedRow(inComponent: 2)
        default:
            self.taskTypePicker.selectedRow(inComponent: 0)
        }
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
    
    func setSelectedTaskType(selectedTaskTypePickerData: String) {
        self.selectedTaskTypePickerData = selectedTaskTypePickerData
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
            //taskNameDescriptionLabel.text = "Task Details: " + textField.text!
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
    
    /*
    @IBAction func checkRepeatingSwitchState(_ sender: UISwitch) {
        self.repeatingSwitchStatus = sender.isOn
    }*/
    
    
    // NOTE: Don't delete this!
    @IBAction func setupIntervalSchedule(_ sender: UIButton) {
        var toDoProcessHelper = ToDoProcessUtils()
        
        var intervalHours = intervalSchedulingHourField.text
        var intervalDays = intervalSchedulingDayField.text
        
        // Send the interval hours and days from here to next view!
 
    }
    
    // MARK: - Selector Functions
    
    @objc func segueToSchedulingAssistance(sender:UITapGestureRecognizer){
        performSegue(withIdentifier: "SegueToSchedulingAssistance", sender: self)
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
                taskItemCells[5].collapsed = false
            }
            tableView.beginUpdates()
            tableView.endUpdates()
        }
        if indexPath.row == 2 {
            if taskItemCells[2].collapsed {
                taskItemCells[2].collapsed = false
            } else {
                taskItemCells[1].collapsed = false
                // Uncollapse all other table rows
                taskItemCells[0].collapsed = false
                taskItemCells[2].collapsed = true
                taskItemCells[3].collapsed = false
                taskItemCells[4].collapsed = false
                taskItemCells[5].collapsed = false
            }
            tableView.beginUpdates()
            tableView.endUpdates()
        }
        if indexPath.row == 3 {
            if taskItemCells[3].collapsed {
                taskItemCells[3].collapsed = false
            } else {
                taskItemCells[2].collapsed = false
                // Uncollapse all other table rows
                taskItemCells[0].collapsed = false
                taskItemCells[1].collapsed = false
                taskItemCells[3].collapsed = true
                taskItemCells[4].collapsed = false
                taskItemCells[5].collapsed = false
            }
            tableView.beginUpdates()
            tableView.endUpdates()
        }
        if indexPath.row == 4 {
            /*
            if taskItemCells[4].collapsed {
                taskItemCells[4].collapsed = false
            } else {
                taskItemCells[3].collapsed = false
                // Uncollapse all other table rows
                taskItemCells[0].collapsed = false
                taskItemCells[1].collapsed = false
                taskItemCells[2].collapsed = false
                taskItemCells[4].collapsed = true
                taskItemCells[5].collapsed = false
            }
            tableView.beginUpdates()
            tableView.endUpdates()*/
            //SwiftEntryKit.display(entry: SchedulingTaskMonthlyView(), using: PresetsDataSource.getCustomPreset())
            let viewController = SchedulingTaskMonthlyViewController()
            viewController.setObservableDueDateController(observableDueDateController: self.observableDueDateController)
            let navigationController = SchedulingTaskMonthlyNavViewController(rootViewController: viewController)
            SwiftEntryKit.display(entry: navigationController, using: PresetsDataSource.getCustomPreset())
        }
        if indexPath.row == 5 {
            /*
            if taskItemCells[5].collapsed {
                taskItemCells[5].collapsed = false
            } else {
                taskItemCells[4].collapsed = false
                // Uncollapse all other table rows
                taskItemCells[0].collapsed = false
                taskItemCells[1].collapsed = false
                taskItemCells[2].collapsed = false
                taskItemCells[3].collapsed = false
                taskItemCells[5].collapsed = true
            }
            tableView.beginUpdates()
            tableView.endUpdates()
            */
        }
    }
    
    // Determines the height of the expansion of the table view cells
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 2 {
            return 124
        }
        /*
        if indexPath.row == 0 {
            if taskItemCells[0].collapsed {
                return 210
            }
        }
        if indexPath.row == 1 {
            if taskItemCells[1].collapsed {
                return 132
            }
        }
        if indexPath.row == 2 {
            if taskItemCells[2].collapsed {
                return 100
            }
        }
        if indexPath.row == 3 {
            if taskItemCells[3].collapsed {
                return 170
            }
        }
        if indexPath.row == 4 {
            if taskItemCells[4].collapsed {
                return 170
            }
        }
        if indexPath.row == 5 {
            if taskItemCells[5].collapsed {
                return 210
            }
        }*/
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
            //let taskDescription = taskDescriptionView.text
            let workDate = chosenWorkDate
            let estTime = estTimeField.text
            let dueDate = chosenDueDate
            let taskType = self.selectedTaskTypePickerData
            
            updateSaveButtonState()
            navigationItem.title = taskName
            
            // TODO: REMOVE TIGHT COUPLING!
            let stringedUUID = UUID().uuidString
            print(getToDos())
            intervalSchedulingPreviewController.setToDos(toDos: getToDos())
            /*
            if toDo == nil {
                stringedUUID = UUID().uuidString
            }
 */
            
            // Set the ToDo to be passed to ToDoListTableViewController after pressing save with unwind segue
            intervalSchedulingPreviewController.setIntervalAmount(intervalAmount: intervalDays!)
            intervalSchedulingPreviewController.setIntervalLength(intervalLength: intervalHours!)
            intervalSchedulingPreviewController.setToDoStartDate(toDoStartDate: workDate)
            intervalSchedulingPreviewController.setToDoEndDate(toDoEndDate: dueDate)
            if toDo == nil {
                // Set the ToDo to be intervalized to be passed to ToDoListTableViewController after pressing save with unwind segue, IF the ToDo was only being created
                intervalSchedulingPreviewController.setToDoToBeIntervalized(toDo: ToDo(taskId: stringedUUID, taskName: taskName!, taskType: taskType, taskDescription: "", workDate: workDate, estTime: estTime!, dueDate: dueDate, finished: getIsFinished())!)
            }
                /*
                (taskId: String, taskName: String, taskType: String = TaskTypes.PERSONAL.rawValue,taskDescription: String, workDate: Date, estTime: String, dueDate: Date, finished: Bool, intervalized: Bool = false, intervalId: String = "", intervalLength: Int = 0, intervalIndex: Int = 0, intervalDueDate: Date = Date())*/
            else {
                // Set the ToDo to be intervalized to be passed to ToDoListTableViewController after pressing save with unwind segue, IF the ToDo was only being modified and is already  created
                intervalSchedulingPreviewController.setToDoToBeIntervalized(toDo: ToDo(taskId: (self.toDo?.getTaskId())!,taskName: taskName!, taskType: taskType, taskDescription: "", workDate: workDate, estTime: estTime!, dueDate: dueDate, finished: getIsFinished(), intervalized: (toDo?.isIntervalized())!, intervalId: (toDo?.getIntervalId())!, intervalLength: (toDo?.getIntervalLength())! ,intervalIndex: (toDo?.getIntervalIndex())!, intervalDueDate: (toDo?.getIntervalDueDate())!)!)
            }
            
        }
        else if segue.identifier == "SegueToEstimatedEfforts" {
            guard let simpleItemsTVC = segue.destination as? SimpleItemsTableViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            simpleItemsTVC.setItemTypeToDisplay(itemTypeToDisplay: SimpleStaticTVCReturnType.ESTIMATED_EFFORT)
        }
        else if segue.identifier == "SegueToToDoTagsTVC" {
            guard let toDoTagsTVC = segue.destination as? TagsTableViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            toDoTagsTVC.setObservableTagsController(observableTagsController: self.observableTagsController)
            print("SegueToToDoTagsTVC wowowowo")
        }
            
        else if segue.identifier == "SegueToSchedulingAssistance" {
            // NOTE: PLEASE clean this thing up
            guard let navigationController = segue.destination as? UINavigationController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            let schedulingAstncViewController = navigationController.viewControllers.first as! SchedulingAssistanceViewController
            // NOTE: CLEAN UP THE USE OF CHOSENWORKDATE,  NOT GOOD, USED JUST FOR TEST
            schedulingAstncViewController.setTaskItems(taskItems: ToDoProcessUtils.retrieveToDoItemsByDay(toDoDate: self.chosenWorkDate, toDoItems: getToDos()))
            
            print("WEw")
            print(self.chosenWorkDate)
            schedulingAstncViewController.setDayToAssist(dayDate: self.chosenWorkDate)
        }
        else {
            // Only prepare view controller when the save button is pressed
            guard let button = sender as? UIBarButtonItem, button === saveButton else {
                os_log("The save button was not pressed, cancelling new item", log: OSLog.default,
                       type: .debug)
                return
            }
            
            let taskName = taskNameField.text
            //let taskDescription = taskDescriptionView.text
            let workDate = chosenWorkDate
            let estTime = estTimeField.text
            let dueDate = chosenDueDate
            let taskType = self.selectedTaskTypePickerData
            let repeating = self.repeatingStatus
            
            updateSaveButtonState()
            navigationItem.title = taskName
            
            if toDo == nil  {
                // Set the Non-Intervalized ToDo to be passed to ToDoListTableViewController after pressing save with unwind segue, IF the ToDo was only being created
                toDo = ToDo(taskId: UUID().uuidString, taskName: taskName!, taskType: taskType, taskDescription: "", workDate: workDate, estTime: estTime!, dueDate: dueDate, finished: getIsFinished(), repeating: repeating)
            } else {
                // Set the Non-Intervalized ToDo to be passed to ToDoListTableViewController after pressing save with unwind segue, IF the ToDo was only being modified and is already  created
                toDo = ToDo(taskId: (self.toDo?.taskId)!, taskName: taskName!, taskType: taskType, taskDescription: "", workDate: workDate, estTime: estTime!, dueDate: dueDate, finished: getIsFinished(), repeating: repeating)
            }
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
    
    @IBAction func recurrencePatternButton(_ sender: UIButton) {
        showRecurrenceSelection(with: PresetsDataSource.getCustomPreset())
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
    
    // MARK: - Popups
    
    private func showRecurrenceSelection(with attributes: EKAttributes) {
        /*
        let recurrenceViewController = RecurrenceSelectionPatternTableViewController()
        let recurrenceNavigationController = RecurrenceNavigationViewController(rootViewController: recurrenceViewController)
        SwiftEntryKit.display(entry: recurrenceNavigationController, using: attributes)*/
    }
    
    // MARK: - Setters
    
    func setToDos(toDos: [String: ToDo]) {
        self.toDos = toDos
    }
    
    // MARK: - Getters
    
    func getToDoIntervals() -> [String: ToDo] {
        return self.toDoIntervals
    }
    
    func isToDoIntervalsExist() -> Bool {
        return self.toDoIntervalsExist
    }
    
    func getToDos() -> [String: ToDo] {
        print(self.toDos)
        return self.toDos
    }
}
