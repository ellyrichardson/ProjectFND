//
//  SchedulingAssistanceViewController.swift
//  ProjectFND
//
//  Created by Elly Richardson on 6/3/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import SwiftEntryKit
import UIKit

class SchedulingAssistanceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, Observer {
    
    @IBOutlet weak var schedulingAstncTableView: UITableView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    private var taskItems = [String: ToDo]()
    private var scheduleTimeSpan: TimeSpan?
    private var dateFormatter = DateFormatter()
    private var tsveResult = [Oter]()
    //private var currentTaskId = String()
    private var schedlngAsstncHelper = SchedulingAssistanceHelper()
    private var targetTask = ToDo()
    
    // MARK: - Trackers
    
    private var targetTaskJustCreated = false
    
    // MARK: - TimeSpan Observable
    
    private var observableOterController = ObservableOterController()
    
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
    
    func update<T>(with newValue: T, with observableType: ObservableType) {
        // TODO: Need to fix this algorithm
        if observableType == ObservableType.OTER {
            let newValueOter = newValue as! Oter
            for oterItem in tsveResult {
                if oterItem.ownerTaskId == newValueOter.ownerTaskId {
                    //oterItem = newValueOter
                    // NOTE: My thought was to create a new ToDo after the selection of time, add it to the taskItems dictionary, then run the evaluation again
                    //ToDo(taskId: taskToBeCreatedId, taskName: <#T##String#>, taskDescription: <#T##String#>, workDate: <#T##Date#>, estTime: <#T##String#>, dueDate: <#T##Date#>, finished: <#T##Bool#>)
                    self.targetTask.workDate = newValueOter.startDate
                    self.targetTask.dueDate = newValueOter.endDate
                    self.taskItems[self.targetTask.getTaskId()] = self.targetTask
                    evaluateVacantTimes()
                    self.schedulingAstncTableView.reloadData()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.schedulingAstncTableView.delegate = self
        self.schedulingAstncTableView.dataSource = self
        self.schedulingAstncTableView.backgroundColor = UIColor.clear
        
        configureObserversAndObservables()
        configureTaskItemsValues()
        
        evaluateVacantTimes()
    }
    
    private func configureObserversAndObservables() {
        // NOTE: Observable area
        let observerVCs: [Observer] = [self]
        self.observableOterController.setupData()
        self.observableOterController.setObservers(observers: observerVCs)
    }
    
    private func configureTaskItemsValues() {
        // TODO: Refactor the having to worry about TargetTaskJustCreated like this, to just setting it in the ToDo Task itself.
        if !self.targetTaskJustCreated {
            self.taskItems[targetTask.getTaskId()] = self.targetTask
        }
    }
    
    // MARK: - Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tsveResult.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let heightForRow = CGFloat(85 * getLengthOfOterInHours(oter: self.tsveResult[indexPath.row]))
        if heightForRow > 680 {
            return 680
        }
        if heightForRow < 85 {
            return 85
        }
        return heightForRow
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tsveResultRow = tsveResult[indexPath.row]
        if tsveResultRow.occupancyType == TSOType.VACANT {
            showTimeSlotsAssignmentViewWithVacantTSO(tsveResultItem: tsveResultRow)
        }
        if tsveResultRow.ownerTaskId == targetTask.getTaskId() {
            showTimeSlotsAssignmentViewCurrentTask(tsveResultItem: tsveResultRow, indexPathRow: indexPath.row)
        }
    }
    
    private func showTimeSlotsAssignmentView(tsveResultItem: Oter, timeSlotsAssgnmentViewCntrlr: TimeSlotsAssignmentViewController) {
        timeSlotsAssgnmentViewCntrlr.setSelectedOter(selectedOter: tsveResultItem)
        timeSlotsAssgnmentViewCntrlr.setObservableOterController(observableOterController: self.observableOterController)
        
        let timeSlotsAssgnmentNavCntrlr = TimeSlotsAssignmentNavViewController(rootViewController: timeSlotsAssgnmentViewCntrlr)
        
        SwiftEntryKit.display(entry: timeSlotsAssgnmentNavCntrlr, using: PresetsDataSource.getCustomPreset())
    }
    
    private func showTimeSlotsAssignmentViewWithVacantTSO(tsveResultItem: Oter) {
        let timeSlotsAssgnmentViewCntrlr = TimeSlotsAssignmentViewController()
        timeSlotsAssgnmentViewCntrlr.setMinAndMaxTime(minTime: tsveResultItem.startDate, maxTime: tsveResultItem.endDate)
        
        showTimeSlotsAssignmentView(tsveResultItem: tsveResultItem, timeSlotsAssgnmentViewCntrlr: timeSlotsAssgnmentViewCntrlr)
    }
    
    private func showTimeSlotsAssignmentViewCurrentTask(tsveResultItem: Oter, indexPathRow: Int) {
        let timeSlotsAssgnmentViewCntrlr = TimeSlotsAssignmentViewController()
        
        let prevTsveResult = retrieveAppropriatePrevTsveResultItem(currentItemIndex: indexPathRow)
        let nextTsveResult = retrieveAppropriateNextTsveResultItem(currentItemIndex: indexPathRow)
        
        if prevTsveResult.occupancyType == TSOType.VACANT && nextTsveResult.occupancyType == TSOType.VACANT {
            timeSlotsAssgnmentViewCntrlr.setMinAndMaxTime(minTime: prevTsveResult.startDate, maxTime: nextTsveResult.endDate)
        }
        else if prevTsveResult.occupancyType == TSOType.VACANT && nextTsveResult.occupancyType != TSOType.VACANT {
            timeSlotsAssgnmentViewCntrlr.setMinAndMaxTime(minTime: prevTsveResult.startDate, maxTime: tsveResultItem.endDate)
        }
        else if prevTsveResult.occupancyType != TSOType.VACANT && nextTsveResult.occupancyType == TSOType.VACANT {
            timeSlotsAssgnmentViewCntrlr.setMinAndMaxTime(minTime: tsveResultItem.startDate, maxTime: nextTsveResult.endDate)
        }
        else {
            timeSlotsAssgnmentViewCntrlr.setMinAndMaxTime(minTime: tsveResultItem.startDate, maxTime: tsveResultItem.endDate)
        }

        showTimeSlotsAssignmentView(tsveResultItem: tsveResultItem, timeSlotsAssgnmentViewCntrlr: timeSlotsAssgnmentViewCntrlr)
    }
    
    private func retrieveAppropriatePrevTsveResultItem(currentItemIndex: Int) -> Oter {
        if currentItemIndex > 0 {
            return tsveResult[currentItemIndex - 1]
        }
        else {
            // Return current tsveResult as previous tsveResult
            return tsveResult[currentItemIndex]
        }
    }
    
    private func retrieveAppropriateNextTsveResultItem(currentItemIndex: Int) -> Oter {
        if currentItemIndex < (self.tsveResult.count - 1) {
            return tsveResult[currentItemIndex + 1]
        }
        else {
            // Return current tsveResult as next tsveResult
            return tsveResult[currentItemIndex]
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ScheduleAstncTableViewCell"
        
        let startTimeFormatter = DateFormatter()
        let endTimeFormatter = DateFormatter()
        startTimeFormatter.dateFormat = "h:mm a"
        endTimeFormatter.dateFormat = "h:mm a"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SchedulingAssistanceTableViewCell else {
            fatalError("The dequeued cell is not an instance of ScheduleAssistanceTableViewCell.")
        }
        
        let tsverItem = self.tsveResult[indexPath.row]
        let taskFromId = ToDoProcessUtils.retrieveTaskById(taskItems: self.taskItems, taskId: tsverItem.ownerTaskId)
        
        if tsverItem.occupancyType == TSOType.VACANT {
            cell.setBackgroundColor(backgroundClr: ColorUtils.paleGray())
            cell.taskNameLabel.text = "VACANT"
        } else {
            if tsverItem.ownerTaskId == self.targetTask.getTaskId() {
                cell.setBackgroundColor(backgroundClr: ColorUtils.paleGreen())
            }
            else {
                cell.setBackgroundColor(backgroundClr: ColorUtils.paleBlue())
            }
            cell.taskNameLabel.text = taskFromId.getTaskName()
        }
        
        cell.startTimeLabel.text = startTimeFormatter.string(from: tsverItem.startDate)
        let appropriateEndTime = schedlngAsstncHelper.adjustTaskEndTimeIf12AMNextDay(startTime: tsverItem.startDate, endTime: tsverItem.endDate)
        cell.endTimeLabel.text = endTimeFormatter.string(from: appropriateEndTime)
        return cell
    }
    
    // MARK: - Time Slots Vacancy Evaluator
    
    private func evaluateVacantTimes() {
        let tsve = TimeSlotsVacancyEvaluator()
        tsve.setTaskItems(tasks: ToDoProcessUtils.sortToDoItemsByDate(toDoItems: self.taskItems))
        
        if self.scheduleTimeSpan == nil {
            setDayToAssist(dayDate: Date())
        }
        
        tsve.populateOtd(timeSpan: self.scheduleTimeSpan!)
        tsve.evaluateOtd(timeSpan: self.scheduleTimeSpan!)
        
        self.tsveResult = tsve.getOterAvailabilities()
    }
    
    // MARK: - Utilities
    
    private func getLengthOfOterInHours(oter: Oter) -> Int {
        let dateUtil = DateUtils()
        return dateUtil.hoursBetweenTwoDates(earlyDate: oter.startDate, laterDate: oter.endDate)
    }
    
    func setObservableTaskController(observableTaskController: ObservableTaskController) {
        self.observableTaskController = observableTaskController
    }
    
    func setTargetTaskJustCreated(targetTaskJustCreated: Bool) {
        self.targetTaskJustCreated = targetTaskJustCreated
    }
    
    // MARK: - Setter
    
    // Step 1
    func setTaskItems(taskItems: [String: ToDo]) {
        self.taskItems = taskItems
    }
    
    // Step 2
    func setDayToAssist(dayDate: Date) {
        dateFormatter.dateFormat = "yyyy/MM/dd"
        
        let dateUtil = DateUtils()
        let stringForBeginningOfDay = dateFormatter.string(from: dayDate) + " 00:00"
        let beginningOfDay = dateUtil.createDate(dateString: stringForBeginningOfDay)
        let endOfDay = dateUtil.addHoursToDate(date: beginningOfDay, hours: 24.0)
        self.scheduleTimeSpan = TimeSpan(startDate: beginningOfDay, endDate: endOfDay)
    }
    
    func setTargetTask(taskItem: ToDo) {
        self.targetTask = taskItem
    }
    
    // MARK: - Getter
    
    func getTaskItems() ->[String: ToDo] {
        return self.taskItems
    }
    
    // MARK: - IBActions
    
    @IBAction func backButtonAction(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        self.observableTaskController.updateTask(updatedTask: self.targetTask)
        self.targetTaskJustCreated = false
        let isPresentingInAddToDoMode = presentingViewController is UINavigationController
        
        if isPresentingInAddToDoMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The SchedulingAssistanceViewController is not inside a navigation controller.")
        }
        
        dismiss(animated: true, completion: nil)
    }
}
