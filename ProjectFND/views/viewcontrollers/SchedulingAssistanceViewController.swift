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
    
    final let PLACE_HOLDER_DATE = "2020/01/15 00:00"
    
    @IBOutlet weak var schedulingAstncTableView: UITableView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    private var taskItems = [String: ToDo]()
    private var scheduleTimeSpan: TimeSpan?
    private var dateFormatter = DateFormatter()
    private var tsveResult = [Oter]()
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
                    // NOTE: My thought was to create a new ToDo after the selection of time, add it to the taskItems dictionary, then run the evaluation again
                    self.targetTask.startTime = newValueOter.startDate
                    self.targetTask.endTime = shouldAdd24HoursToDateTime(dateTime: newValueOter.endDate)
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
        configureNavBar()
        
        evaluateVacantTimes()
    }
    
    func configureObserversAndObservables() {
        // NOTE: Observable area
        let observerVCs: [Observer] = [self]
        self.observableOterController.setupData()
        self.observableOterController.setObservers(observers: observerVCs)
    }
    
    func configureTaskItemsValues() {
        // TODO: Refactor the having to worry about TargetTaskJustCreated like this, to just setting it in the ToDo Task itself.
        if !self.targetTaskJustCreated {
            self.taskItems[targetTask.getTaskId()] = self.targetTask
        }
    }
    
    func configureNavBar() {
        let nav = self.navigationController?.navigationBar
        
        let yellowColor = UIColor(red:1.00, green:0.89, blue:0.00, alpha:1.0)
        
        // Sets the navigation bar to color black with tintColor of yellow.
        nav?.barStyle = UIBarStyle.black
        nav?.tintColor = yellowColor
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
    
    // TODO: Please find a way to unit test this
    private func showTimeSlotsAssignmentView(tsveResultItem: Oter, timeSlotsAssgnmentViewCntrlr: TimeSlotsAssignmentViewController) {
        timeSlotsAssgnmentViewCntrlr.setSelectedOter(selectedOter: tsveResultItem)
        timeSlotsAssgnmentViewCntrlr.setObservableOterController(observableOterController: self.observableOterController)
        
        let timeSlotsAssgnmentNavCntrlr = TimeSlotsAssignmentNavViewController(rootViewController: timeSlotsAssgnmentViewCntrlr)
        
        SwiftEntryKit.display(entry: timeSlotsAssgnmentNavCntrlr, using: PresetsDataSource.getCustomPreset())
    }
    
    func showTimeSlotsAssignmentViewWithVacantTSO(tsveResultItem: Oter) {
        let timeSlotsAssgnmentViewCntrlr = TimeSlotsAssignmentViewController()
        timeSlotsAssgnmentViewCntrlr.setMinAndMaxTime(minTime: tsveResultItem.startDate, maxTime: tsveResultItem.endDate)
        
        showTimeSlotsAssignmentView(tsveResultItem: tsveResultItem, timeSlotsAssgnmentViewCntrlr: timeSlotsAssgnmentViewCntrlr)
    }
    
    func showTimeSlotsAssignmentViewCurrentTask(tsveResultItem: Oter, indexPathRow: Int) {
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
        cell.endTimeLabel.text = endTimeFormatter.string(from: tsverItem.endDate)
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
    
    func getObservableTaskController() -> ObservableTaskController {
        return self.observableTaskController
    }
    
    func setTargetTaskJustCreated(targetTaskJustCreated: Bool) {
        self.targetTaskJustCreated = targetTaskJustCreated
    }
    
    func isTargetTaskJustCreated() -> Bool {
        return self.targetTaskJustCreated
    }
    
    private func shouldAdd24HoursToDateTime(dateTime: Date) -> Date {
        let dateUtil = DateUtils()
        let occupiedOters = tsveResult.filter{ $0.occupancyType != TSOType.VACANT }
        if dateUtil.isDate12AM(dateTime: dateTime) {
            if occupiedOters.count < 1 {
                return dateUtil.addHoursToDate(date: dateTime, hours: 24.0)
            }
        }
        return dateTime
    }
    
    // MARK: - Setter
    
    // Step 1
    func setTaskItems(taskItems: [String: ToDo]) {
        self.taskItems = taskItems
    }
    
    func getTaskItems() ->[String: ToDo] {
        return self.taskItems
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
    
    func getTargetTask() -> ToDo {
        return self.targetTask
    }
    
    func setScheduleTimeSpan(timeSpan: TimeSpan) {
        self.scheduleTimeSpan = timeSpan
    }
    
    func getScheduleTimeSpan() -> TimeSpan {
        return self.scheduleTimeSpan!
    }
    
    func setTsveResult(tsveResult: [Oter]) {
        self.tsveResult = tsveResult
    }
    
    func getTsveResult() -> [Oter] {
        return self.tsveResult
    }
    
    func setObservableOterController(observableOterController: ObservableOterController) {
        self.observableOterController = observableOterController
    }
    
    func getObservableOterController() -> ObservableOterController {
        return self.observableOterController
    }
    
    func getObserverId() -> Int {
        return self.observerId
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
