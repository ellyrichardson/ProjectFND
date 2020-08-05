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

    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    
    private var taskItemCells = [StaticTableCell]()
    
    var observerVCs: [Observer] = [Observer]()
    var toDo: ToDo?
    private var toDos = [String: ToDo]()
    var toDoIntervals: [String: ToDo] = [String: ToDo]()
    var toDoIntervalsExist: Bool = false
    private var finished: Bool
    private var chosenStartDate: Date = Date()
    private var schedulerWasSet: Bool
    
    private var dataSource = PresetsDataSource()
    
    @IBOutlet weak var notesUIView: UIView!
    
    
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
    private var isSchedulingAssistanceUtilized = false
    private var isDueDateSetTracker = false
    
    // Intervalizer Trackers (NOT USED??)
    private var intervalHours = 0
    private var intervalDays = 0
    
    // Date Label Trackers
    private var startTimeTracker = Date()
    private var endTimeTracker = Date()
    private var dueDateTracker = Date()
    
    // Tag Tracker
    private var currentSelectedTag = String()
    
    // In Queue Task Trackers
    private var inQueueTask = ToDo()
    private var inQueueTaskContainsNewValue = false
    
    // Pressed Items Trackers
    private var isSchedulingAssistancePressed = false
    private var isDueDatePickerPressedTracker = false
    private var tagSelectorAccessed = false
    
    // Notes Tracker
    
    private var notesTableViewCellHeightTracker = 0
    private var notesTextViewValue = ""
    
    // MARK: - Due Date Observable
    
    private var observableDueDateController = ObservableDateController()
    
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
            
            if newValueDate.assigned {
                self.isDueDateSetTracker = true
                configureDueDateLabel(dueDateString: dateFormatter.string(from: newValueDate.dateValue!), shouldRemove: false)
            } else {
                self.isDueDateSetTracker = false
                configureDueDateLabel(dueDateString: dateFormatter.string(from: newValueDate.dateValue!), shouldRemove: true)
            }
            
            self.tableView.reloadData()
        }
        else if observableType == ObservableType.TODO_TAG {
            let newValueTag = newValue as! ToDoTags
            
            if newValueTag.tagValue == "" {
                self.tagsLabel.text = "Tag"
            }
            else {
                self.tagsLabel.text = newValueTag.tagValue!
            }
            self.currentSelectedTag = newValueTag.tagValue!
            self.tagSelectorAccessed = true
            changeTagsLabelColor()
        }
        else if observableType == ObservableType.TASK {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a"
            let newValueTask = newValue as! ToDo
            let formattedStartTime = dateFormatter.string(from: newValueTask.getStartTime())
            let formattedEndTime = dateFormatter.string(from: newValueTask.getEndTime())
            
            if formattedStartTime == formattedEndTime {
                let isDate12AM = dateUtil.isDate12AM(dateTime: newValueTask.getEndTime())
                if isDate12AM {
                    setAppropriateTaskTimes(newValueTask: newValueTask, formattedStartTime: formattedStartTime, formattedEndTime: formattedEndTime, isDate12AM: isDate12AM)
                }
            } else {
                setAppropriateTaskTimes(newValueTask: newValueTask, formattedStartTime: formattedStartTime, formattedEndTime: formattedEndTime, isDate12AM: false)
            }
        }
    }
    
    private func setAppropriateTaskTimes(newValueTask: ToDo, formattedStartTime: String, formattedEndTime: String, isDate12AM: Bool) {
        self.inQueueTask = newValueTask
        self.inQueueTaskContainsNewValue = true
        self.startDateStringValue.text = formattedStartTime
        self.endDateStringValue.text = formattedEndTime
        self.startTimeTracker = newValueTask.getStartTime()
        self.endTimeTracker = newValueTask.getEndTime()
        if dateUtil.isDate12AM(dateTime: newValueTask.getEndTime()) {
            self.endTimeTracker = dateUtil.addDayToDate(date: newValueTask.getEndTime(), days: 1.0)
        }
        self.isSchedulingAssistancePressed = true
        self.isSchedulingAssistanceUtilized = true
        updateSaveButtonState()
        changeTaskNameFieldColor()
    }
    
    // NOTE: DON'T REMOVE THESE ITEMS UNDER THIS MARK! IT MAKES THINGS WEIRD IN A WEIRD WAY!
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
        configureNotesTextView()
    }
    
    // MARK: - Configurations
    
    private func configuteTableViews() {
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func configureUiValues() {
        taskNameField.textColor = UIColor.black
        
        // Set up views if editing an existing ToDo.
        if let toDo = toDo {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a"
            
            navigationItem.title = toDo.taskName
            taskNameField.text = toDo.taskName
            changeTaskNameFieldColor()  
            
            self.startDateStringValue.text = dateFormatter.string(from: toDo.getStartTime())
            self.endDateStringValue.text = dateFormatter.string(from: toDo.getEndTime())
            
            dateFormatter.dateFormat = "MM/dd/yy, h:mm a"
            
            self.isDueDateSetTracker = toDo.isDueDateSet()
            
            if toDo.isDueDateSet() {
                configureDueDateLabel(dueDateString: dateFormatter.string(from: toDo.getDueDate()), shouldRemove: false)
            }
            
            self.tagsLabel.text = toDo.getTaskTag()
            changeTagsLabelColor()
            if toDo.getTaskTag() == "" {
                self.tagsLabel.text = "Tags "
            }
            
            self.notesTextViewValue = toDo.getTaskNotes()
            
            // It is utilized because tasks can't exist without utilizing scheduling asst
            isSchedulingAssistanceUtilized = true
        } else {
            // If no Task exist, then jusg have a placeholder in the taskNameField
            taskNameField.attributedPlaceholder = NSAttributedString(string: "Task Name",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        }
    }
    
    private func configureDueDateLabel(dueDateString: String, shouldRemove: Bool) {
        if shouldRemove {
            self.dueDateLabel.text = "Due Date"
        } else {
            self.dueDateLabel.text = "Due Date: " + dueDateString
        }
        changeDueDateLabelColor(whiteColor: !shouldRemove)
    }
    
    private func configureObservableControllers() {
        observerVCs = [self]
        self.observableDueDateController.setupData()
        self.observableDueDateController.setObservers(observers: observerVCs)
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
        
        // Only allow saveButton if textFields are not empty
        taskNameField.addTarget(self, action: #selector(textFieldsAreNotEmpty), for: .editingChanged)
    }
    
    private func configureVcObjets() {
        if let toDo = toDo {
            self.startTimeTracker = toDo.getStartTime()
            self.endTimeTracker = toDo.getEndTime()
            self.dueDateTracker = toDo.getDueDate()
            self.currentSelectedTag = toDo.getTaskTag()
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
    
    private func configureNotesTextView() {
        let notesTextView = UITextView()
        notesTextView.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        
        notesTextView.backgroundColor = .darkGray
        
        if self.notesTextViewValue == "" || self.notesTextViewValue == "Notes" {
            notesTextView.text = "Notes"
            notesTextView.textColor = UIColor.lightGray
        } else {
            notesTextView.text = self.notesTextViewValue
            notesTextView.textColor = UIColor.black
        }
        
        notesTextView.translatesAutoresizingMaskIntoConstraints = false
        
        notesUIView.addSubview(notesTextView)
        [
            notesTextView.topAnchor.constraint(equalTo: notesUIView.safeAreaLayoutGuide.topAnchor),
            notesTextView.leadingAnchor.constraint(equalTo: notesUIView.leadingAnchor),
            notesTextView.trailingAnchor.constraint(equalTo: notesUIView.trailingAnchor),
            notesTextView.heightAnchor.constraint(equalToConstant: 50)
            ].forEach{ $0.isActive = true }
        
        notesTextView.font = UIFont.preferredFont(forTextStyle: .headline)
        
        notesTextView.delegate = self
        notesTextView.isScrollEnabled = false
        notesTextView.textContainer.lineFragmentPadding = 0
        
        textViewDidChange(notesTextView)
    }
    
    // MARK: - Text View Utilities
    
    func textViewDidChange(_ textView: UITextView) {
        print(textView.text)
        let size = CGSize(width: notesUIView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
        
        notesTableViewCellHeightTracker = Int(estimatedSize.height)
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
        self.notesTextViewValue = textView.text
    }
    
    // For removing the placeholder value of the NotesTextView
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    // To determine if placeholder value should be put back
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Notes"
            textView.textColor = UIColor.lightGray
        }
    }
    
    // MARK: - Picker Utilities
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
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

    // MARK: - Selector Functions
    
    @objc func segueToSchedulingAssistance(sender:UITapGestureRecognizer){
        performSegue(withIdentifier: "SegueToSchedulingAssistance", sender: self)
    }
    
    // MARK: - Table view data source
    
    // Collapses and expands table view cells
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            // NOTE: Put this in its own class about PopUp Preparation Process or something
            let viewController = SchedulingTaskMonthlyViewController()
            viewController.setObservableDueDateController(observableDueDateController: self.observableDueDateController)
            
            setDueDatePopupView(viewController: viewController)
            
            let navigationController = SchedulingTaskMonthlyNavViewController(rootViewController: viewController)
            SwiftEntryKit.display(entry: navigationController, using: PresetsDataSource.getCustomPreset())
        }
    }
    
    // Determines the height of the expansion of the table view cells
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 3 {
            return CGFloat(self.notesTableViewCellHeightTracker)
        }
        else if indexPath.row == 4 {
            return 124
        }
        return 50
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 5 || indexPath.row == 6 {
            // To remove line separator from tableViewCells
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            cell.directionalLayoutMargins = .zero
        }
    }
    
    // MARK: - Due Date Utilities
    
    private func setDueDatePopupView(viewController: SchedulingTaskMonthlyViewController) {
        if let toDo = toDo {
            viewController.setSelectedDate(dateVal: toDo.getDueDate())
        }
    }
    
    // MARK: - Navigation
    
    // Prepares view controller before it gets presented
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "SegueToEstimatedEfforts" {
            segueToEstimatedEfforts(segue: segue)
        }
        else if segue.identifier == "SegueToToDoTagsTVC" {
            let tagsSegueProcess = TagsSegueProcess(taskItem: self.toDo, tagSelectorAccessed: self.tagSelectorAccessed, currentSelectedTag: self.currentSelectedTag, observerVCs: self.observerVCs)
            tagsSegueProcess?.segueToTagsTVC(segue: segue)
        }
            
        else if segue.identifier == "SegueToSchedulingAssistance" {
            let schedulingAsstSegueProcess = SchedulingAssistanceSegueProcess(taskItem: self.toDo, startTime: self.chosenStartDate, inQueueTask: self.inQueueTask, inQueueTaskContainsNewValue: self.inQueueTaskContainsNewValue, taskItemsForSelectedDay: toDos, observerVCs: self.observerVCs)
            // Sets the task name if taskNameField was already populated before segueing to the SchedulingAssistance
            if !taskNameField.text!.isEmpty {
                schedulingAsstSegueProcess?.setTaskNameToDisplay(taskName: taskNameField.text!)
            }
            print("Details")
            print(startTimeTracker)
            print(endTimeTracker)
            schedulingAsstSegueProcess?.setTaskTimeSpan(timeSpan: TimeSpan(startDate: startTimeTracker, endDate: endTimeTracker))
            schedulingAsstSegueProcess?.segueToSchedulingAssistance(segue: segue)
        }
        else {
            // Only prepare view controller when the save button is pressed
            guard let button = sender as? UIBarButtonItem, button === saveButton else {
                os_log("The save button was not pressed, cancelling new item", log: OSLog.default,
                       type: .debug)
                return
            }
            createOrUpdateTask(sender: button)
        }
    }
    
    // MARK: - Creating / Editing Task
    
    private func createOrUpdateTask(sender: UIBarButtonItem) {
        
        let taskName = taskNameField.text
        let repeating = self.repeatingStatus
        
        updateSaveButtonState()
        navigationItem.title = taskName
        
        if toDo == nil  {
            // Set the Non-Intervalized ToDo to be passed to ToDoListTableViewController after pressing save with unwind segue, IF the ToDo was only being created
            
            toDo = ToDo(taskId: UUID().uuidString, taskName: taskName!, taskNotes: self.notesTextViewValue, taskTag: self.currentSelectedTag, startTime: self.startTimeTracker, endTime: self.endTimeTracker, dueDate: self.dueDateTracker, finished: getIsFinished(), dueDateSet: self.isDueDateSetTracker, repeating: repeating)
            
        } else {
            // Set the Non-Intervalized ToDo to be passed to ToDoListTableViewController after pressing save with unwind segue, IF the ToDo was only being modified and is already  created
            updateTask(taskName: taskName!, repeating: repeating)
        }
    }
    
    private func updateTask(taskName: String, repeating: Bool) {
        // This is to track if anything has changed and the Save button was pressed.
        var dueDate = toDo?.getDueDate()
        var startTime = toDo?.getStartTime()
        var endTime = toDo?.getEndTime()
        var taskTag = toDo?.getTaskTag()
        
        // The trackers gets assigned with something if the Popups were selected
        if self.isDueDatePickerPressedTracker {
            dueDate = self.dueDateTracker
        }
        if self.isSchedulingAssistancePressed {
            startTime = self.startTimeTracker
            endTime = self.endTimeTracker
        }
        if self.tagSelectorAccessed {
            taskTag = self.currentSelectedTag
        }
        
        self.toDo = ToDo(taskId: (self.toDo?.taskId)!, taskName: taskName, taskNotes: self.notesTextViewValue, taskTag: taskTag!, startTime: startTime!, endTime: endTime!, dueDate: dueDate!, finished: getIsFinished(), dueDateSet: self.isDueDateSetTracker, repeating: repeating)
    }
    
    // MARK: - Segue Operations
    
    // NOTE: IS THIS EVEN USED???
    private func segueToEstimatedEfforts(segue: UIStoryboardSegue) {
        guard let simpleItemsTVC = segue.destination as? SimpleItemsTableViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
        
        simpleItemsTVC.setItemTypeToDisplay(itemTypeToDisplay: SimpleStaticTVCReturnType.ESTIMATED_EFFORT)
    }
    
    // MARK: - Actions
    
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
        if !(taskNameField.text?.isEmpty)! && isSchedulingAssistanceUtilized {
            saveButton.isEnabled = true
        }
    }
    
    private func changeTagsLabelColor() {
        self.tagsLabel.textColor = UIColor.white
    }
    
    private func changeDueDateLabelColor(whiteColor: Bool) {
        if whiteColor {
            self.dueDateLabel.textColor = UIColor.white
        } else {
            self.dueDateLabel.textColor = UIColor.lightGray
        }
    }
    
    private func changeTaskNameFieldColor() {
        self.taskNameField.textColor = UIColor.black
    }
    
    // MARK: - Observers
    
    // Only allow saveButton if textFields are not empty
    @objc func textFieldsAreNotEmpty(sender: UITextField) {
        updateSaveButtonState()
    }
    
    // MARK: - Setters
    
    func setToDos(toDos: [String: ToDo]) {
        self.toDos = toDos
    }
    
    func setChosenStartDate(chosenStartDate: Date) {
        self.chosenStartDate = chosenStartDate
    }
    
    func setIsFinished(isFinished: Bool) {
        self.finished = isFinished
    }
    
    func setSelectedTaskType(selectedTaskTypePickerData: String) {
        self.selectedTaskTypePickerData = selectedTaskTypePickerData
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
    
    func getIsFinished() -> Bool {
        return self.finished
    }
}
