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

class ItemInfoTableViewController: UITableViewController, UITextViewDelegate, UITextFieldDelegate, Observer, DetachedVCDelegate {
    
    
    
    
    
    @IBOutlet weak var taskNameField: UITextField!
    
    
    //@IBOutlet weak var taskTypeLabel: UILabel!
    // NOTE: Make the description like the notes
    // UI UPDATE - @IBOutlet weak var taskDescriptionView: UITextView!
    // UI UPDATE - @IBOutlet weak var estTimeLabel: UILabel!
    // UI UPDATE - @IBOutlet weak var estTimeField: UITextField!
    // UI UPDATE - @IBOutlet weak var startDateLabel: UILabel!
    // UI UPDATE - @IBOutlet weak var startDatePicker: UIDatePicker!
    // UI UPDATE - @IBOutlet weak var endDateLabel: UILabel!
    // UI UPDATE - @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    // UI UPDATE - @IBOutlet weak var intervalSchedulingHourField: UITextField!
    // UI UPDATE - @IBOutlet weak var intervalSchedulingDayField: UITextField!
    // UI UPDATE - @IBOutlet weak var intervalSchedulingSetupButton: UIButton!
    
    
    // UI UPDATE - @IBOutlet weak var taskTypePicker: UIPickerView!
    @IBOutlet weak var intervalizedTaskButton: IntervalizedTaskButton!
    @IBOutlet weak var regularTaskButton: RegularTaskButton!
    
    
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    
    private var taskItemCells = [StaticTableCell]()
    //private var taskTypePickerData: [String] = [String]()
    
    var toDo: ToDo?
    private var toDos = [String: ToDo]()
    var toDoIntervals: [String: ToDo] = [String: ToDo]()
    var toDoIntervalsExist: Bool = false
    private var finished: Bool
    private var chosenWorkDate: Date
    private var chosenDueDate: Date
    private var schedulerWasSet: Bool
    
    private var dataSource = PresetsDataSource()
    
    // MARK: - Helpers
    
    private var dateUtil = DateUtils()
    
    // MARK: - Start/End Date UIView
    
    @IBOutlet weak var startDateUIView: ItemInfoView!
    @IBOutlet weak var endDateUIView: ItemInfoView!
    @IBOutlet weak var startDateStringValue: UILabel!
    @IBOutlet weak var endDateStringValue: UILabel!
    
    // MARK: - Trackers
    // NOTE: These trackers need to be categorized
    private var selectedTaskTypePickerData: String = String()
    private var repeatingStatus: Bool = Bool()
    
    // Intervalizer Trackers
    private var intervalHours = 0
    private var intervalDays = 0
    
    // Date Label Trackers
    private var startTimeTracker = Date()
    private var endTimeTracker = Date()
    private var dueDateTracker = Date()
    
    // Tag Tracker
    private var taskTagTracker = String()
    
    // In Queue Task Trackers
    private var inQueueTask = ToDo()
    private var inQueueTaskContainsNewValue = false
    
    // Pressed Items Trackers
    private var isSchedulingAssistancePressedTracker = false
    private var isDueDatePickerPressedTracker = false
    private var didSelectInTagSelectionTracker = false
    
    // MARK: - Due Date Observable
    
    private var observableDueDateController = ObservableDateController()
    
    // MARK: - Tags Observable
    
    private var observableTagsController = ObservableTagsController()
    
    // MARK: - Task Observable
    
    private var observableTaskController = ObservableTaskController()
    
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
            dateFormatter.dateFormat = "MM/dd/yy, h:mm a"
            
            self.dueDateLabel.text = "Due Date: " + dateFormatter.string(from: newValueDate.dateValue!)
            self.dueDateTracker = newValueDate.dateValue!
            self.isDueDatePickerPressedTracker = true
            self.tableView.reloadData()
        }
        else if observableType == ObservableType.TODO_TAG {
            let newValueTag = newValue as! ToDoTags
            self.tagsLabel.text = newValueTag.tagValue!
            self.taskTagTracker = newValueTag.tagValue!
            self.didSelectInTagSelectionTracker = true
            print("TAG WAS UPDATED")
        }
        else if observableType == ObservableType.TASK {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yy h:mm a"
            let newValueTask = newValue as! ToDo
            
            self.inQueueTask = newValueTask
            self.inQueueTaskContainsNewValue = true
            self.startDateStringValue.text = dateFormatter.string(from: newValueTask.getStartTime())
            self.endDateStringValue.text = dateFormatter.string(from: newValueTask.getEndTime())
            self.startTimeTracker = newValueTask.getStartTime()
            self.endTimeTracker = newValueTask.getEndTime()
            self.isSchedulingAssistancePressedTracker = true
        }
    }
    
    // MARK: - DetachedVCDelegate
    func transitionToNextVC() {
        performSegue(withIdentifier: "SegueToIntervalizerVC", sender: self)
    }
    
    func setIntervalHours(intervalHours: Int) {
        self.intervalHours = intervalHours
    }
    
    func setIntervalDays(intervalDays: Int) {
        self.intervalDays = intervalDays
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
        
        configureObservableControllers()
        configureNavBar()
        configureTableViews()
        configureUiValues()
        configureUiObjects()
        configureGestureRecognizers()
        updateSaveButtonState()
    }
    
    // MARK: - Configurations
    
    private func configureUiValues() {
        // Set up views if editing an existing ToDo.
        if let toDo = toDo {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yy, h:mm a"
            
            navigationItem.title = toDo.taskName
            taskNameField.text = toDo.taskName
            self.startDateStringValue.text = dateFormatter.string(from: toDo.getStartTime())
            self.endDateStringValue.text = dateFormatter.string(from: toDo.getEndTime())
            self.dueDateLabel.text = "Due Date: " + dateFormatter.string(from: toDo.getDueDate())
            self.tagsLabel.text = toDo.getTaskTag()
            if toDo.getTaskTag() == "" {
                self.tagsLabel.text = "Tags "
            }
        }
        // Simply proceed if not editing an existing ToDo
    }
    
    private func configureObservableControllers() {
        let observerVCs: [Observer] = [self]
        self.observableDueDateController.setupData()
        self.observableDueDateController.setObservers(observers: observerVCs)
        self.observableTagsController.setupData()
        self.observableTagsController.setObservers(observers: observerVCs)
        self.observableTaskController.setupData()
        self.observableTaskController.setObservers(observers: observerVCs)
    }
    
    private func configureNavBar() {
        let nav = self.navigationController?.navigationBar
        
        let yellowColor = UIColor(red:1.00, green:0.89, blue:0.00, alpha:1.0)
        
        // Sets the navigation bar to color black with tintColor of yellow.
        nav?.barStyle = UIBarStyle.black
        nav?.tintColor = yellowColor
    }
    
    private func configureUiObjects() {
        self.taskNameField.delegate = self
        self.startDateUIView.cornerRadius = 10
        self.endDateUIView.cornerRadius = 10
    }
    
    private func configureVcObjets() {
        if let toDo = toDo {
            self.startTimeTracker = toDo.getStartTime()
            self.endTimeTracker = toDo.getEndTime()
            self.dueDateTracker = toDo.getDueDate()
            self.taskTagTracker = toDo.getTaskTag()
        }
    }
    
    private func configureGestureRecognizers() {
        let gestureRecSD = UITapGestureRecognizer(target: self, action:  #selector (self.segueToSchedulingAssistance(sender:)))
        let gestureRecED = UITapGestureRecognizer(target: self, action:  #selector (self.segueToSchedulingAssistance(sender:)))
        startDateUIView.addGestureRecognizer(gestureRecSD)
        endDateUIView.addGestureRecognizer(gestureRecED)
    }
    
    private func configureTableViews() {
        // Auto resizing the height of the cell
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - Picker Utilities
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
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
        
        updateSaveButtonState()
    }

    // MARK: - Actions
    
    @IBAction func startDatePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        setChosenWorkDate(chosenWorkDate: sender.date)
        let strDate = dateFormatter.string(from: chosenWorkDate)
    }
    
    @IBAction func endDatePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        setChosenDueDate(chosenDueDate: sender.date)
        let strDate = dateFormatter.string(from: chosenDueDate)
    }
    
    /*
    @IBAction func checkRepeatingSwitchState(_ sender: UISwitch) {
        self.repeatingSwitchStatus = sender.isOn
    }*/
    
    
    // NOTE: Don't delete this!
    @IBAction func setupIntervalSchedule(_ sender: UIButton) {
        var toDoProcessHelper = ToDoProcessUtils()
        
        //var intervalHours = intervalSchedulingHourField.text
        //var intervalDays = intervalSchedulingDayField.text
        
        // Send the interval hours and days from here to next view!
 
    }
    
    // MARK: - Selector Functions
    
    @objc func segueToSchedulingAssistance(sender:UITapGestureRecognizer){
        performSegue(withIdentifier: "SegueToSchedulingAssistance", sender: self)
    }
    
    // MARK: - Table view data source
    
    // Collapses and expands table view cells
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 4 {
            let viewController = SchedulingTaskMonthlyViewController()
            viewController.setObservableDueDateController(observableDueDateController: self.observableDueDateController)
            
            setDueDatePopupView(viewController: viewController)
            
            let navigationController = SchedulingTaskMonthlyNavViewController(rootViewController: viewController)
            SwiftEntryKit.display(entry: navigationController, using: PresetsDataSource.getCustomPreset())
        }
    }
    
    // Determines the height of the expansion of the table view cells
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 2 {
            return 124
        }
        return 50
    }
    
    // MARK: - Due Date Utilities
    
    private func setDueDatePopupView(viewController: SchedulingTaskMonthlyViewController) {
        if let toDo = toDo {
            print("The due DATE")
            print(toDo.getDueDate())
            viewController.setSelectedDate(dateVal: toDo.getDueDate())
        }
    }
    
    // MARK: - Navigation
    
    // Prepares view controller before it gets presented
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "SegueToIntervalizerVC" {
            guard let scheduleIntervalizerVC = segue.destination as? IntervalSchedulingPreviewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            scheduleIntervalizerVC.setToDos(toDos: self.toDos)
            let taskName = taskNameField.text
            let workDate = chosenWorkDate
            let dueDate = chosenDueDate
            let taskType = self.selectedTaskTypePickerData
            
            updateSaveButtonState()
            navigationItem.title = taskName
            
            // TODO: REMOVE TIGHT COUPLING!
            let stringedUUID = UUID().uuidString
            print(getToDos())
            scheduleIntervalizerVC.setToDos(toDos: getToDos())
            /*
            if toDo == nil {
                stringedUUID = UUID().uuidString
            }
 */
            
            // Set the ToDo to be passed to ToDoListTableViewController after pressing save with unwind segue
            scheduleIntervalizerVC.setIntervalHours(intervalHours: self.intervalHours)
            scheduleIntervalizerVC.setIntervalDays(intervalDays: self.intervalDays)
            scheduleIntervalizerVC.setToDoStartDate(toDoStartDate: workDate)
            scheduleIntervalizerVC.setToDoEndDate(toDoEndDate: dueDate)
            if toDo == nil {
                // Set the ToDo to be intervalized to be passed to ToDoListTableViewController after pressing save with unwind segue, IF the ToDo was only being created
                //scheduleIntervalizerVC.setToDoToBeIntervalized(toDo: ToDo(taskId: stringedUUID, taskName: taskName!, taskType: taskType, taskDescription: "", workDate: workDate, estTime: "0.0", dueDate: dueDate, finished: getIsFinished())!)
            }
            else {
                // Set the ToDo to be intervalized to be passed to ToDoListTableViewController after pressing save with unwind segue, IF the ToDo was only being modified and is already  created
                //scheduleIntervalizerVC.setToDoToBeIntervalized(toDo: ToDo(taskId: (self.toDo?.getTaskId())!,taskName: taskName!, taskType: taskType, taskDescription: "", workDate: workDate, estTime: "0.0", dueDate: dueDate, finished: getIsFinished(), intervalized: (toDo?.isIntervalized())!, intervalId: (toDo?.getIntervalId())!, intervalLength: (toDo?.getIntervalLength())! ,intervalIndex: (toDo?.getIntervalIndex())!, intervalDueDate: (toDo?.getIntervalDueDate())!)!)
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
            // This tracker gets assigned if there is new ToDo and the selected in the selection for the first time, or if editing an existing ToDo
            if toDo?.getTaskTag() != "" && toDo != nil {
                toDoTagsTVC.setAssignedTag(tagName: (toDo?.getTaskTag())!)
            }
            print("SegueToToDoTagsTVC wowowowo")
        }
            
        else if segue.identifier == "SegueToSchedulingAssistance" {
            // NOTE: PLEASE clean this thing up
            guard let navigationController = segue.destination as? UINavigationController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            let schedulingAstncViewController = navigationController.viewControllers.first as! SchedulingAssistanceViewController
            // NOTE: CLEAN UP THE USE OF CHOSENWORKDATE,  NOT GOOD, USED JUST FOR TEST
            schedulingAstncViewController.setDayToAssist(dayDate: self.chosenWorkDate)
            if toDo == nil {
                schedulingAstncViewController.setTaskItems(taskItems: ToDoProcessUtils.retrieveToDoItemsByDay(toDoDate: self.chosenWorkDate, toDoItems: [String: ToDo]()))
                
                // TODO: Refactor the having of TargetTaskJustCreated being set in this controller, to just setting it in the ToDo Task itself.
                if !self.inQueueTaskContainsNewValue {
                    self.inQueueTask = ToDo(taskId: UUID().uuidString, taskName: "TEST_NAME", startTime: Date(), endTime: Date(), dueDate: Date(), finished: false)!
                    schedulingAstncViewController.setTargetTaskJustCreated(targetTaskJustCreated: true)
                }
                //self.inQueueTask = self.toDo!.copy() as! ToDo
                schedulingAstncViewController.setTargetTask(taskItem: self.inQueueTask)
                schedulingAstncViewController.setObservableTaskController(observableTaskController: self.observableTaskController)
            }
            else {
                schedulingAstncViewController.setTaskItems(taskItems: ToDoProcessUtils.retrieveToDoItemsByDay(toDoDate: self.chosenWorkDate, toDoItems: getToDos()))
                // Need a copy so that this actual self.ToDo don't get updated in the next viewController and reflect on the main page
                
                /*
                if self.inQueueTaskContainsNewValue {
                    schedulingAstncViewController.setTargetTask(taskItem: self.inQueueTask)
                } else {
                    schedulingAstncViewController.setTargetTask(taskItem: self.toDo!.copy() as! ToDo)
                }*/
                if !self.inQueueTaskContainsNewValue {
                    self.inQueueTask = self.toDo!.copy() as! ToDo
                }
                //self.inQueueTask = self.toDo!.copy() as! ToDo
                schedulingAstncViewController.setTargetTask(taskItem: self.inQueueTask)
                schedulingAstncViewController.setObservableTaskController(observableTaskController: self.observableTaskController) 
            }
        }
        else {
            // Only prepare view controller when the save button is pressed
            guard let button = sender as? UIBarButtonItem, button === saveButton else {
                os_log("The save button was not pressed, cancelling new item", log: OSLog.default,
                       type: .debug)
                return
            }
            
            let taskName = taskNameField.text
            
            //let estTime = estTimeField.text
            
            let repeating = self.repeatingStatus
            
            updateSaveButtonState()
            navigationItem.title = taskName
            
            if toDo == nil  {
                // Set the Non-Intervalized ToDo to be passed to ToDoListTableViewController after pressing save with unwind segue, IF the ToDo was only being created
                
                toDo = ToDo(taskId: UUID().uuidString, taskName: taskName!, taskTag: self.taskTagTracker, startTime: self.startTimeTracker, endTime: self.endTimeTracker, dueDate: self.dueDateTracker, finished: getIsFinished(), repeating: repeating)
                
            } else {
                // Set the Non-Intervalized ToDo to be passed to ToDoListTableViewController after pressing save with unwind segue, IF the ToDo was only being modified and is already  created
                
                // This is to track if anything has changed and the Save button was pressed.
                var dueDate = toDo?.getDueDate()
                var startTime = toDo?.getStartTime()
                var endTime = toDo?.getEndTime()
                var taskTag = toDo?.getTaskTag()
                
                // The trackers gets assigned with something if the Popups were selected
                if self.isDueDatePickerPressedTracker {
                    dueDate = self.dueDateTracker
                }
                if self.isSchedulingAssistancePressedTracker {
                    startTime = self.startTimeTracker
                    endTime = self.endTimeTracker
                }
                if self.didSelectInTagSelectionTracker {
                    taskTag = self.taskTagTracker
                }
                
                toDo = ToDo(taskId: (self.toDo?.taskId)!, taskName: taskName!, taskTag: taskTag!, startTime: startTime!, endTime: endTime!, dueDate: dueDate!, finished: getIsFinished(), repeating: repeating)
            }
        }
    }
    
    // TODO: Remove tight coupling
    @IBAction func unwindToItemInfo(sender:UIStoryboardSegue) {
        if let sourceViewController = sender.source as? IntervalSchedulingPreviewController {
            self.toDoIntervalsExist = true
            //self.toDoIntervals  = sourceViewController.getToDoIntervalsToAssign()
        }
    }
    
    @IBAction func regularTaskButton(_ sender: Any) {
    }
    
    @IBAction func intervalizedTaskButton(_ sender: IntervalizedTaskButton) {
        let viewController = ScheduleIntervalizerVC()
        viewController.detachedVCDelegate = self
        //viewController.setObservableDueDateController(observableDueDateController: self.observableDueDateController)
        let navigationController = ScheduleIntervalizerNavVC(rootViewController: viewController)
        SwiftEntryKit.display(entry: navigationController, using: PresetsDataSource.getSmallerCustomPreset())
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
    
    // NOTES: Probably not being used
    @IBAction func recurrencePatternButton(_ sender: UIButton) {
        showRecurrenceSelection(with: PresetsDataSource.getCustomPreset())
    }
    // MARK: - Private Methods
    
    // Disable the save button if the text field is empty
    private func updateSaveButtonState() {
        saveButton.isEnabled = false
        
        // Task name or estimated time fields are empty
        if !(taskNameField.text?.isEmpty)! {
            saveButton.isEnabled = true
        }
        
        // Only allow saveButton if textFields are not empty
        taskNameField.addTarget(self, action: #selector(textFieldsAreNotEmpty), for: .editingChanged)
    }
    
    // MARK: - Observers
    
    // Only allow saveButton if textFields are not empty
    @objc func textFieldsAreNotEmpty(sender: UITextField) {
        guard
            let taskName = taskNameField.text, !taskName.isEmpty
            else {
                self.saveButton.isEnabled = false
                return
        }
        // Enable save button if all conditions are met
        saveButton.isEnabled = true
    }
    
    // MARK: - Popups
    
    private func showRecurrenceSelection(with attributes: EKAttributes) {
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
        return self.toDos
    }
}
