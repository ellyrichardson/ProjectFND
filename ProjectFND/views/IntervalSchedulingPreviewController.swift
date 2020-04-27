//
//  IntervalSchedulingPreviewController.swift
//  ProjectFND
//
//  Created by Elly Richardson on 2/10/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import UIKit
import CoreData
import os.log
import JTAppleCalendar

class IntervalSchedulingPreviewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: Properties
    
    
    
    //@IBOutlet weak var calendarView: JTAppleCalendarView!
    //@IBOutlet weak var toDoListTableView: UITableView!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var toDoListTableView: UITableView!
    @IBOutlet weak var acceptButton: UIBarButtonItem!
    
    // Helpers
    
    var toDoProcessHelper: ToDoProcessUtils = ToDoProcessUtils()
    var loadingScreen: LoadingScreen = LoadingScreen()
    
    // Properties
    
    private var toDos = [String: ToDo]()
    private var toDosToBeAdded = [String: ToDo]()
    private var selectedDate: Date = Date()
    private var selectedToDoIndex: Int = -1
    private var selectedIndexPath: IndexPath?
    private var selectedIndexPaths: [IndexPath] = [IndexPath]()
    private var coreToDoData: [NSManagedObject] = []
    private var intervalAmount: Int = 0
    private var intervalLength: Double = 0.0
    private var dateOfTheDay: String = ""
    private var toDoToBeIntervalized = ToDo()
    private var toDoStartDate: Date = Date()
    private var toDoEndDate: Date = Date()
    private var toDoIntervalsToAssign = [String: ToDo]()
    private var toDosController: ToDosController!
    private var toDosWithToDosToBeAdded = [String: ToDo]()
    
    // Expand row buttons tracker assets
    
    private var calendarDayChanged: Bool = false
    private var remainingExpandButtonsToReset: Int = -1
    
    let formatter = DateFormatter()
    let numberOfRows = 6
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nav = self.navigationController?.navigationBar
        
        // Sets the navigation bar to color black with tintColor of yellow.
        nav?.barStyle = UIBarStyle.blackOpaque
        nav?.tintColor = UIColor(red:1.00, green:0.89, blue:0.00, alpha:1.0)
        
        // Do any additional setup after loading the view, typically from a nib.
        self.toDoListTableView.delegate = self
        self.toDoListTableView.dataSource = self
        self.toDoListTableView.backgroundColor = UIColor.clear
        /*
        if let savedToDos = ToDoProcessUtils.loadToDos() {
            setToDoItems(toDoItems: savedToDos)
        }*/
        
        configureCalendarView()
        // Determines the interval starting from the start date of ToDo
        loadingScreen.showSpinner(onView: self.view)
        DispatchQueue.global(qos: .background).async {
            print("This is run on the background queue")
            
            self.determineInterval(savedToDos: self.getToDos(), dateOfTheDay: self.getToDoStartDate())
            
            DispatchQueue.main.async {
                self.loadingScreen.removeSpinner()
                GeneralViewUtils.reloadCollectionViewData(collectionView: self.calendarView)
                GeneralViewUtils.reloadTableViewData(tableView: self.toDoListTableView)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /*
        GeneralViewUtils.reloadCollectionViewData(collectionView: self.calendarView)
        GeneralViewUtils.reloadTableViewData(tableView: self.toDoListTableView)
 */
    }
    
    func configureCalendarView(){
        
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
        calendarView.register(UINib(nibName: "CalendarHeader", bundle: Bundle.main),
                              forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                              withReuseIdentifier: "CalendarHeader")
        calendarView.cellSize = calendarView.contentSize.width
        self.calendarView.scrollToDate(Date(),animateScroll: false)
        self.calendarView.selectDates([ Date() ])
        
    }
    
    // Configure the calendar cell
    func configureCell(cell: JTAppleCell?, cellState: CellState) {
        guard let currentCell = cell as? CalendarCell else {
            return
        }
        
        currentCell.dateLabel.text = cellState.text
        configureSelectedStateFor(cell: currentCell, cellState: cellState)
        configureTextColorFor(cell: currentCell, cellState: cellState)
        configureSelectedDay(cell: currentCell, cellState: cellState)
        //previewToDoIntervals(cell: currentCell, dateChosen: getSelectedDate())
        let cellHidden = cellState.dateBelongsTo != .thisMonth
        currentCell.isHidden = cellHidden
    }
    
    // Configure text calendar colors
    func configureTextColorFor(cell: JTAppleCell?, cellState: CellState){
        
        guard let currentCell = cell as? CalendarCell else {
            return
        }
        
        if cellState.isSelected {
            currentCell.dateLabel.textColor = UIColor.black
            //GeneralViewUtils.reloadTableViewData(tableView: self.toDoListTableView)
        } else {
            if cellState.dateBelongsTo == .thisMonth && cellState.date > Date()  {
                currentCell.dateLabel.textColor = UIColor.white
            } else {
                currentCell.dateLabel.textColor = UIColor.lightGray
            }
        }
    }
    
    func configureSelectedStateFor(cell: JTAppleCell?, cellState: CellState){
        
        guard let currentCell = cell as? CalendarCell else {
            return
        }
        
        currentCell.selectedView.layer.masksToBounds = false
        currentCell.selectedView.layer.borderColor = UIColor.gray.cgColor
        currentCell.selectedView.layer.backgroundColor = UIColor.gray.cgColor
        //currentCell.selectedView.layer.cornerRadius = 18.5
        currentCell.selectedView.clipsToBounds = true
        
        if cellState.isSelected{
            currentCell.selectedView.isHidden = false
        } else {
            currentCell.selectedView.isHidden = true
        }
    }
    
    // When a particular day is selected in the calendar
    func configureSelectedDay(cell: JTAppleCell?, cellState: CellState) {
        if cellState.isSelected{
            setSelectedDate(selectedDate: cellState.date)
            ToDoProcessUtils.removeAllSelectedIndexPaths(selectedIndexPaths: &selectedIndexPaths)
            // To track if the selected day in the calendar was changed
            setCalendarDayChanged(didChange: true)
            GeneralViewUtils.reloadTableViewData(tableView: self.toDoListTableView)
            // To track how many expand row buttons will be reset if the selected was changed
            /*
            setRemainingExpandButtonsToReset(remainingButtons: getToDoItemsByDay(dateChosen: getSelectedDate()).count)
 */
        }
    }
    
    // MARK: - Table View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Gets the ToDos that fall under the selected day in calendar
        let toDoIntervalsToAssignOnCurrentDay = ToDoProcessUtils.retrieveToDoItemsByDay(toDoDate: getSelectedDate(), toDoItems: getToDosWithToDosToBeAdded())
        let sortedToDoItemsOnCurrentDay = ToDoProcessUtils.sortToDoItemsByDate(toDoItems: toDoIntervalsToAssignOnCurrentDay)
        return sortedToDoItemsOnCurrentDay.count
        //return getToDoItemsByDay(dateChosen: getSelectedDate()).count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedIndexPaths.count > 0 {
            if selectedIndexPaths.contains(indexPath) {
                return 120
            }
        }
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dateCellIdentifier = "ScheduleTableViewCell"
        
        let dueDateFormatter = DateFormatter()
        let workDateFormatter = DateFormatter()
        dueDateFormatter.dateFormat = "h:mm a"
        workDateFormatter.dateFormat = "h:mm a"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: dateCellIdentifier, for: indexPath) as? ScheduleTableViewCell else {
            fatalError("The dequeued cell is not an instance of ScheduleTableViewCell.")
        }
        
        
        
        //var toDoItems = getToDoItemsByDay(dateChosen: getSelectedDate())
        let toDosWithToDosToBeAddedOnCurrentDay = ToDoProcessUtils.retrieveToDoItemsByDay(toDoDate: getSelectedDate(), toDoItems: getToDosWithToDosToBeAdded())
        let sortedtoDosWithToDosToBeAddedOnCurrentDay = ToDoProcessUtils.sortToDoItemsByDate(toDoItems: toDosWithToDosToBeAddedOnCurrentDay)
        //let sortedToDoItems = ToDoProcessUtils.sortToDoItemsByDate(toDoItems: toDoItems)
        cell.taskNameLabel.text = sortedtoDosWithToDosToBeAddedOnCurrentDay[indexPath.row].value.getTaskName()
        cell.startDateLabel.text = workDateFormatter.string(from: sortedtoDosWithToDosToBeAddedOnCurrentDay[indexPath.row].value.getStartDate())
        cell.estTimeLabel.text = sortedtoDosWithToDosToBeAddedOnCurrentDay[indexPath.row].value.getEstTime()
        cell.dueDateLabel.text = dueDateFormatter.string(from: sortedtoDosWithToDosToBeAddedOnCurrentDay[indexPath.row].value.getEndDate())
        
        // If calendar day was changed, then make the state of to-be loaded expand row buttons false
        /*
        if getCalendarDayChanged() == true {
            cell.expandButton.setPressedStatus(isPressed: false)
            // Determines if more buttons need to be reset
            trackExpandButtonsToBeReset()
        }*/
        
        cell.expandButton.setExpandedRowIndex(toDoRowIndex: indexPath.row)
        cell.expandButton.addTarget(self, action: #selector(onExpandRowButtonTap(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        ToDoTableViewUtils.makeCellMoveUpWithFade(cell: cell, indexPath: indexPath)
        //let toDoItemsOnCurrentDay = getToDoItemsByDay(dateChosen: getSelectedDate())
        let toDoIntervalsToAssignOnCurrentDay = ToDoProcessUtils.retrieveToDoItemsByDay(toDoDate: getSelectedDate(), toDoItems: getToDosWithToDosToBeAdded())
        let sortedToDoItemsOnCurrentDay = ToDoProcessUtils.sortToDoItemsByDate(toDoItems: toDoIntervalsToAssignOnCurrentDay)
        cell.backgroundColor = ToDoTableViewUtils.intervalsColorForToDoRow(toDoTaskId: sortedToDoItemsOnCurrentDay[indexPath.row].value.getTaskId(), toDoItems: getToDoIntervalsToAssign())
        //cell.backgroundColor = ToDoTableViewUtils.intervalsColorForToDoRow(toDoRowIndex: indexPath.row, toDoItems: getToDoItemsByDay(dateChosen: getSelectedDate()), toDoIntervalsToAssign: self.toDoIntervalsToAssign)
        cell.layer.backgroundColor = ToDoTableViewUtils.intervalsColorForToDoRow(toDoTaskId: sortedToDoItemsOnCurrentDay[indexPath.row].value.getTaskId(), toDoItems: getToDoIntervalsToAssign() ).cgColor
        //cell.layer.backgroundColor = ToDoTableViewUtils.intervalsColorForToDoRow(toDoRowIndex: indexPath.row, toDoItems: getToDoItemsByDay(dateChosen: getSelectedDate()), toDoIntervalsToAssign: self.toDoIntervalsToAssign).cgColor
        
        // This will turn on `masksToBounds` just before showing the cell
        cell.contentView.layer.masksToBounds = true
        
        /*
         NOTE: If this is not set `shadowPath` you'll notice laggy scrolling. Mysterious code too.  It just make the shadow stuff work
         */
        let radius = cell.contentView.layer.cornerRadius
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: radius).cgPath
    }
    
    /*
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let toDoToBeDeleted: [String: ToDo] = getToDoItemsByDay(dateChosen: getSelectedDate())
            let toDoRealIndex = ToDoProcessUtils.retrieveRealIndexOfToDo(toDoItem: toDoToBeDeleted[indexPath.row], toDoItemCollection: self.toDos)
            ToDoProcessUtils.deleteToDo(toDoToDelete: getToDoItems()[toDoRealIndex])
            ToDoProcessUtils.removeToDoItem(toDoItemIndexToRemove: toDoRealIndex, toDoItemCollection: &self.toDos)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */
    
    // MARK: - Actions
    
    @IBAction func unwindToScheduleView(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ItemInfoTableViewController, let toDo = sourceViewController.toDo {
            if toDoListTableView.indexPathForSelectedRow != nil {
                // Replaces the ToDo item in the original array of ToDos.
                toDosController.updateToDos(modificationType: ListModificationType.UPDATE, toDo: toDo)
                //ToDoProcessUtils.updateToDo(toDoToUpdate: getToDoItemByIndex(toDoIndex: getSelectedToDoIndex()), newToDo: toDo, updateType: 0)
                /*
                ToDoProcessUtils.replaceToDoItemInBaseList(editedToDoItem: toDo, editedToDoItemIndex: getSelectedToDoIndex(), toDoItemCollection: &self.toDos)*/
                GeneralViewUtils.reloadTableViewData(tableView: self.toDoListTableView)
            } else {
                ToDoProcessUtils.addToDoItem(toDoItemToAdd: toDo, toDoItemCollection: &self.toDos)
                print("ToDo Finished?")
                print(toDo.finished)
                ToDoProcessUtils.saveToDos(toDoItem: toDo)
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // Only prepare view controller when the save button is pressed
        guard let button = sender as? UIBarButtonItem, button === acceptButton else {
            os_log("The accept button was not pressed, ignoring intervals generated", log: OSLog.default,
                   type: .debug)
            return
        }
        
        // Uses the toDoIntervalsToAssign for the unwindSegue
    }
    
    // MARK: - Setters
    
    // USED HERE IN THIS CONTEXT
    func setIntervalAmount(intervalAmount: String) {
        if intervalAmount != "" {
            self.intervalAmount = Int(intervalAmount)!
        }
    }
    
    // USED HERE IN THIS CONTEXT
    func setIntervalLength(intervalLength: String) {
        if intervalLength != "" {
            self.intervalLength = Double(intervalLength)!
        }
    }
    
    // USED HERE IN THIS CONTEXT
    func setToDoStartDate(toDoStartDate: Date) {
        self.toDoStartDate = toDoStartDate
    }
    
    // USED HERE IN THIS CONTEXT
    func setToDoEndDate(toDoEndDate: Date) {
        self.toDoEndDate = toDoEndDate
    }
    
    // USED HERE IN THIS CONTEXT
    func setToDoToBeIntervalized(toDo: ToDo) {
        self.toDoToBeIntervalized = toDo
    }
    
    func setDateOfTheDay(dayOfTheDay: Date) {
        
    }
    
    func setToDos(toDos: [String: ToDo]) {
        self.toDos = toDos
    }
    
    func setToDosToBeAdded(toDoItems: [String: ToDo]) {
        self.toDosToBeAdded = toDoItems
    }
    /*
    func setSelectedToDoIndex(toDoItemIndex: Int) {
        self.selectedToDoIndex = toDoItemIndex
    }
 */
    
    func setSelectedDate(selectedDate: Date) {
        self.selectedDate = selectedDate
    }
    
    func setCalendarDayChanged(didChange: Bool) {
        self.calendarDayChanged = didChange
    }
    
    func setTodosWithToDosToBeAdded(originalToDos: [String: ToDo], newToDos: [String : ToDo]) {
        self.toDosWithToDosToBeAdded = originalToDos
        for singleToDo in newToDos {
            self.toDosWithToDosToBeAdded[singleToDo.value.taskId] = singleToDo.value
        }
    }
    
    /*
    func setRemainingExpandButtonsToReset(remainingButtons: Int) {
        self.remainingExpandButtonsToReset = remainingButtons
    }
 */
    
    // MARK: - Getters
    
    // USED HERE IN THIS CONTEXT
    func getIntervalAmount() -> Int {
        return self.intervalAmount
    }
    
    // USED HERE IN THIS CONTEXT
    func getIntervalLength() -> Double {
        return self.intervalLength
    }
    
    // USED HERE IN THIS CONTEXT
    func getToDoStartDate() -> Date {
        return self.toDoStartDate
    }
    
    // USED HERE IN THIS CONTEXT
    func getToDoEndDate() -> Date {
        return self.toDoEndDate
    }
    
    // USED HERE IN THIS CONTEXT
    func getToDoToBeIntervalized() -> ToDo {
        return self.toDoToBeIntervalized
    }
    
    // USED HERE IN THIS CONTEXT
    func getToDoIntervalsToAssign() -> [String: ToDo] {
        return self.toDoIntervalsToAssign
    }
    
    private func getToDoItemsByDay(dateChosen: Date) -> [String: ToDo] {
        return ToDoProcessUtils.retrieveToDoItemsByDay(toDoDate: dateChosen, toDoItems: getToDos())
    }
    
    //private func getToDo
    
    func getToDos() -> [String: ToDo] {
        return self.toDos
    }
    
    /*
    // Gets ToDo item by its index in the base list.
    func getToDoItemByIndex(toDoIndex: Int) -> ToDo {
        return self.toDos[toDoIndex]
    }
    
    // Gets the index of the selected ToDo
    func getSelectedToDoIndex() -> Int {
        return self.selectedToDoIndex
    }
    */
    func getSelectedDate() -> Date {
        return self.selectedDate
    }
    
    func getSelectedIndexPaths() -> [IndexPath] {
        return self.selectedIndexPaths
    }
    
    func getCalendarDayChanged() -> Bool {
        return self.calendarDayChanged
    }
    
    func getRemainingButtonsToReset() -> Int {
        return self.remainingExpandButtonsToReset
    }
    
    func getToDosWithToDosToBeAdded() -> [String: ToDo] {
        return self.toDosWithToDosToBeAdded
    }
    
    /*
    // Tracks the expand row buttons that needs to be reset
    private func trackExpandButtonsToBeReset() {
        setRemainingExpandButtonsToReset(remainingButtons: getRemainingButtonsToReset() - 1)
        // If all to-be loaded expand buttons state are now false
        if getRemainingButtonsToReset() <= 0 {
            setCalendarDayChanged(didChange: false)
            setRemainingExpandButtonsToReset(remainingButtons: -1)
        }
    }
 
 */
    
    // NOTE: Refactor this function
    private func determineInterval(savedToDos: [String: ToDo], dateOfTheDay: Date) {
        formatter.dateFormat = "yyyy/MM/dd"
        let stringDateOfTheDay: String = formatter.string(from: dateOfTheDay)
        var actualDateOfTheDay: Date = formatter.date(from: stringDateOfTheDay)!
        let intervalSchedCheckHelper = IntervalAvailabilitiesCheckingOperations()
        let intervalSchedRetrivHelper = IntervalAvailabilitiesRetrievalOperations()
        var assignedIntervals: Int = 0
        let intervalId = UUID().uuidString
        var dateArithmeticOps = DateUtils()
        print("intervalAmounts")
        print(getIntervalAmount())
        while assignedIntervals < getIntervalAmount() {
            let toDoItemsForDay: [String: ToDo] = ToDoProcessUtils.retrieveToDoItemsByDay(toDoDate: actualDateOfTheDay, toDoItems: savedToDos)
            let timeSlotsOfAllToDoInDate = intervalSchedCheckHelper.getOccupiedTimeSlots(collectionOfToDosForTheDay: toDoItemsForDay, dayDateOfTheCollection: actualDateOfTheDay)
            let availableTimeSlots = intervalSchedCheckHelper.getLongestAvailableConsecutiveTimeSlot(timeSlotDictionary: timeSlotsOfAllToDoInDate, dayToCheck: actualDateOfTheDay)
            if availableTimeSlots.count == 0 {
                print("AvailableTimeSlots Less than 0")
            }
            let longestTimeIntervalStartTime = intervalSchedRetrivHelper.getStartTimeOfConsecutiveTimeSlots(consecutiveTimeSlot: availableTimeSlots, dayOfConcern: actualDateOfTheDay)
            let longestTimeIntervalEndTime = intervalSchedRetrivHelper.getEndTimeOfConsecutiveTimeSlots(consecutiveTimeSlot: availableTimeSlots, dayOfConcern: actualDateOfTheDay)
            
            //let cal = Calendar.current
            //let diffDate = Calendar.current.dateComponents(<#T##components: Set<Calendar.Component>##Set<Calendar.Component>#>, from: longestTimeIntervalStartTime.getStartTime(), to: longestTimeIntervalEnd)
            
            let determinedInterval = (longestTimeIntervalEndTime.getEndTime().timeIntervalSince(longestTimeIntervalStartTime.getStartTime())/3600)
            
            //DateUtils.addHoursToDate(<#T##DateUtils#>)
            
            print("YOOOOOOO")
            print(determinedInterval)
            
            // The logic of separating tasks breaks when intervalTaskId is moved out of this loop
            let intervalTaskId = UUID().uuidString
            let intervalName = getToDoToBeIntervalized().getTaskName()
            let intervalDescription = getToDoToBeIntervalized().getTaskDescription()
            let intervalStartDate = longestTimeIntervalStartTime.getStartTime()
            let intervalDueDate = longestTimeIntervalEndTime.getStartTime()
            let intervalStatus = getToDoToBeIntervalized().isFinished()
            let testVar = dateArithmeticOps.addHoursToDate(date: intervalStartDate, hours: Double(getToDoToBeIntervalized().estTime)!)
            let intervalTaskType = getToDoToBeIntervalized().getTaskType()
            
            //let intervalEstTime = getToDoToBeIntervalized().getEstTime()
            // NOTE: Don't know the return of the timeIntervalSince if it is in hours or seconds
            print("Interval Length")
            print(getIntervalLength())
            if determinedInterval >= getIntervalLength() {
                // TODO: Action here
                self.toDoIntervalsToAssign[intervalTaskId] = ToDo(taskId: intervalTaskId, taskName: intervalName, taskType: intervalTaskType,taskDescription: intervalDescription, workDate: intervalStartDate, estTime: String(getIntervalLength()), dueDate: intervalDueDate, finished: intervalStatus, intervalized: true, intervalId: intervalId, intervalLength: Int(getIntervalAmount()), intervalIndex: assignedIntervals)!
                assignedIntervals += 1
            }
            print("Assigned Intervals")
            print(assignedIntervals)
            if actualDateOfTheDay < getToDoToBeIntervalized().getEndDate() {
                actualDateOfTheDay = Calendar.current.date(byAdding: .day, value: 1, to: actualDateOfTheDay)!
            }
        }
        
        setTodosWithToDosToBeAdded(originalToDos: getToDos(), newToDos: getToDoIntervalsToAssign())
        loadingScreen.removeSpinner()
        print("Count of getToDos")
        print(getToDos().count)
        print("Count of getToDosWithToDosToBeAdded")
        print(getToDosWithToDosToBeAdded().count)
        //ToDoProcessUtils.addToDoArrayToAToDoArray(toDoArray: &self.toDos, toDosToBeAdded: self.getToDoIntervalsToAssign())
        //loadingScreen.removeSpinner()
    }
    
    private func isToDoIntervalOnDay(toDoInterval: ToDo, dateOfDay: Date) -> Bool {
        formatter.dateFormat = "yyyy/MM/dd"
        let stringDateOfDay: String = formatter.string(from: dateOfDay)
        //let actualDateOfDay: Date = formatter.date(from: stringDateOfDay)!
        let strToDoIntervalStartDate: String = formatter.string(from: toDoInterval.getStartDate())
        //let actToDoIntervalStartDate: Date = formatter.date(from: strToDoIntervalStartDate)!
        if strToDoIntervalStartDate == stringDateOfDay {
        //if actToDoIntervalStartDate == actualDateOfDay {
            print("actual date of Day")
            print(stringDateOfDay)
            print("toDo Interval Day")
            print(strToDoIntervalStartDate)
            return true
        }
        return false
    }
    
    private func isToDoOnDay(toDoToCheck: ToDo, date: Date) -> Bool {
        if ToDoProcessUtils.retrieveToDoItemsByDay(toDoDate: date, toDoItems: getToDosWithToDosToBeAdded())[toDoToCheck.taskId] != nil  {
            return true
        }
        return false
    }
    
    func previewToDoIntervals(cell: CalendarCell, dateChosen: Date) {
        // NOTE: REFACTOR, like use a dictionary instead
        print("yhecount of getToDoIntervalsToAssign")
        print(getToDoIntervalsToAssign())
        for toDoInterval in getToDoIntervalsToAssign() {
            if isToDoIntervalOnDay(toDoInterval: toDoInterval.value, dateOfDay: dateChosen) && isToDoOnDay(toDoToCheck: toDoInterval.value, date: dateChosen) {
                cell.setShouldDrawStripes(shouldDraw: true)
            }
        }
    }
    
    @objc func onCheckBoxButtonTap(sender: CheckBoxButton) {
        var toDoItemsByDay = ToDoProcessUtils.sortToDoItemsByDate(toDoItems: toDosController.getToDosByDay(dateChosen: getSelectedDate()))
        //let toDoItemToUpdate: ToDo = toDoItemsByDay[sender.tag].value
        let newToDoItem: ToDo = toDoItemsByDay[sender.tag].value
        
        newToDoItem.finished = !newToDoItem.finished
        toDosController.updateToDos(modificationType: ListModificationType.UPDATE, toDo: newToDoItem)
        //reloadTableViewData()
        //reloadCalendarViewData()
    }
    
    @objc func onExpandRowButtonTap(sender: ExpandButton) {
        let buttonIndexPath = IndexPath(row: sender.getExpandedRowIndex(), section: 0)
        
        // If there is no expanded row yet
        if !getSelectedIndexPaths().contains(buttonIndexPath) {
            ToDoProcessUtils.addSelectedIndexPath(indexPath: buttonIndexPath, selectedIndexPaths: &selectedIndexPaths)
            self.toDoListTableView.beginUpdates()
            self.toDoListTableView.endUpdates()
            //reloadTableViewData()
        } else {
            let indPath: Int = selectedIndexPaths.firstIndex(of: buttonIndexPath)!
            ToDoProcessUtils.removeSelectedIndexPath(indexPathAsInt: indPath, selectedIndexPaths: &selectedIndexPaths)
            self.toDoListTableView.beginUpdates()
            self.toDoListTableView.endUpdates()
            //reloadTableViewData()
        }
    }
}

extension IntervalSchedulingPreviewController: JTAppleCalendarViewDataSource {
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
        configureCell(cell: cell, cellState: cellState)
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "dd MM yy"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        calendar.scrollingMode = .stopAtEachSection
        
        let startDate = formatter.date(from: "01 01 19")!
        let endDate = formatter.date(from: "31 12 22")!
        
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
                                                 numberOfRows: numberOfRows,
                                                 calendar: Calendar.current,
                                                 generateInDates: .forAllMonths,
                                                 generateOutDates: .tillEndOfRow,
                                                 firstDayOfWeek: .sunday,
                                                 hasStrictBoundaries: true)
        return parameters
    }
}

extension IntervalSchedulingPreviewController: JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
 
        var cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
        
        previewToDoIntervals(cell: cell, dateChosen: date)
        
        configureCell(cell: cell, cellState: cellState)
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTAppleCollectionReusableView {
        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "CalendarHeader", for: indexPath)
        let date = range.start
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM YYYY"
        (header as! CalendarHeader).title.text = formatter.string(from: date)
        return header
    }
    
    func calendarSizeForMonths(_ calendar: JTAppleCalendarView?) -> MonthSize? {
        return MonthSize(defaultSize: 75)
    }
}
