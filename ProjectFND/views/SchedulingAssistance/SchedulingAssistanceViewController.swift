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
    private var taskItems = [String: ToDo]()
    private var scheduleTimeSpan: TimeSpan?
    private var dateFormatter = DateFormatter()
    private var tsveResult = [Oter]()
    private var currentTaskId = String()
    private var schedlngAsstncHelper = SchedulingAssistanceHelper()
    
    // MARK: - TimeSpan Observable
    
    private var observableOterController = ObservableOterController()
    
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
                    //ToDo(taskId: <#T##String#>, taskName: <#T##String#>, taskDescription: <#T##String#>, workDate: <#T##Date#>, estTime: <#T##String#>, dueDate: <#T##Date#>, finished: <#T##Bool#>)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.schedulingAstncTableView.delegate = self
        self.schedulingAstncTableView.dataSource = self
        self.schedulingAstncTableView.backgroundColor = UIColor.clear
        
        evaluateVacantTimes()
    }
    
    private func configureObserversAndObservables() {
        // NOTE: Observable area
        let observerVCs: [Observer] = [self]
        self.observableOterController.setupData()
        self.observableOterController.setObservers(observers: observerVCs)
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
        return heightForRow
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tsveResultRow = tsveResult[indexPath.row]
        if tsveResultRow.occupancyType == TSOType.VACANT {
            let timeSlotsAssgnmentViewCntrlr = TimeSlotsAssignmentViewController()
            timeSlotsAssgnmentViewCntrlr.setMinAndMaxTime(minTime: tsveResultRow.startDate, maxTime: tsveResultRow.endDate)
            timeSlotsAssgnmentViewCntrlr.setSelectedOter(selectedOter: tsveResultRow)
            
            let timeSlotsAssgnmentNavCntrlr = TimeSlotsAssignmentNavViewController(rootViewController: timeSlotsAssgnmentViewCntrlr)
            
            SwiftEntryKit.display(entry: timeSlotsAssgnmentNavCntrlr, using: PresetsDataSource.getCustomPreset())
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
            if tsverItem.ownerTaskId == self.currentTaskId {
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
    
    func setCurrentTaskId(taskId: String) {
        self.currentTaskId = taskId
    }
    
    // MARK: - Getter
    
    func getTaskItems() ->[String: ToDo] {
        return self.taskItems
    }
}
