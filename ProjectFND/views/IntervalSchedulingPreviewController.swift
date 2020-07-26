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
    private var dateUtils = DateUtils()
    
    // Properties
    
    private var toDos = [String: ToDo]()
    private var tasksToBeAdded = [String: ToDo]()
    //private var toDosToBeAdded = [String: ToDo]()
    private var selectedDate: Date = Date()
    //private var selectedToDoIndex: Int = -1
    private var selectedIndexPath: IndexPath?
    private var selectedIndexPaths: [IndexPath] = [IndexPath]()
    //private var coreToDoData: [NSManagedObject] = []
    private var intervalHours: Double = 0.0
    private var intervalDays: Double = 0.0
    private var dateOfTheDay: String = ""
    //private var toDoToBeIntervalized = ToDo()
    private var toDoStartDate: Date = Date()
    private var toDoEndDate: Date = Date()
    private var toDoDueDate = Date()
    //private var toDoIntervalsToAssign = [String: ToDo]()
    private var toDosController: ToDosController!
    //private var toDosWithToDosToBeAdded = [String: ToDo]()
    
    // Trackers
    
    var datesWithAnIntervalTracker: Set = Set<String>()
    //var intervalsToPreview = [String: Bool]()
    
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
        
        loadingScreen.showSpinner(onView: self.view)
        
        configureCalendarView()
        
        // 07/09/2020 UPDATE >>>>>>>>>>>>>>>>>>>>>>>>
        
        self.tasksToBeAdded = determineSlottedTasks()
        ToDoProcessUtils.addToDoDictionaryToAToDoDictionary(toDoDictionary: &self.toDos, toDosToBeAdded: self.tasksToBeAdded)
        
        // <<<<<<<<<<<<<<<<<<<<<<< <07/09/2020 UPDATE
        
        // Determines the interval starting from the start date of ToDo
        //loadingScreen.showSpinner(onView: self.view)
        loadingScreen.removeSpinner()
        /*
        DispatchQueue.global(qos: .background).async {
            print("This is run on the background queue")
            
            // Uncomment this to make the old way of determining intervals work
            /*
            self.determineInterval(savedToDos: self.getToDos(), dateOfTheDay: self.getToDoStartDate())
             */
            
            DispatchQueue.main.async {
                self.loadingScreen.removeSpinner()
                GeneralViewUtils.reloadCollectionViewData(collectionView: self.calendarView)
                GeneralViewUtils.reloadTableViewData(tableView: self.toDoListTableView)
            }
        }*/
        /*
        DispatchQueue.main.async {
            self.loadingScreen.removeSpinner()
            GeneralViewUtils.reloadCollectionViewData(collectionView: self.calendarView)
            GeneralViewUtils.reloadTableViewData(tableView: self.toDoListTableView)
        }*/
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
    func configureCell(cell: JTAppleCell?, cellState: CellState, date: Date) {
        guard let currentCell = cell as? CalendarCell else {
            return
        }
        
        currentCell.dateLabel.text = cellState.text
        currentCell.setCellDayId(cellDayId: dateUtils.getDayAsString(date: date))
        
        configureSelectedStateFor(cell: currentCell, cellState: cellState)
        configureTextColorFor(cell: currentCell, cellState: cellState)
        configureSelectedDay(cell: currentCell, cellState: cellState)
        previewToDoIntervals(cell: currentCell, dateChosen: date)
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
            
            ToDoProcessUtils.removeAllSelectedIndexPaths(selectedIndexPaths: &self.selectedIndexPaths)
            // To track if the selected day in the calendar was changed
            setCalendarDayChanged(didChange: true)
            GeneralViewUtils.reloadTableViewData(tableView: self.toDoListTableView)
            // To track how many expand row buttons will be reset if the selected was changed
            
            //setRemainingExpandButtonsToReset(remainingButtons:  getToDoItemsByDay(dateChosen: self.selectedDate)).count)
            setRemainingExpandButtonsToReset(remainingButtons:  ToDoProcessUtils.retrieveToDoItemsByDay(toDoDate: self.selectedDate, toDoItems: self.toDos).count)
        }
    }
    
    // MARK: - Table View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Gets the ToDos that fall under the selected day in calendar
        /*let toDoIntervalsToAssignOnCurrentDay = ToDoProcessUtils.retrieveToDoItemsByDay(toDoDate: getSelectedDate(), toDoItems: getToDosWithToDosToBeAdded())*/
        /*let sortedToDoItemsOnCurrentDay = ToDoProcessUtils.sortToDoItemsByDate(toDoItems: toDoIntervalsToAssignOnCurrentDay)*/
        //return sortedToDoItemsOnCurrentDay.count
        //return getToDoItemsByDay(dateChosen: getSelectedDate()).count
        
        let tasksForSelectedDay = ToDoProcessUtils.retrieveToDoItemsByDay(toDoDate: self.selectedDate, toDoItems: self.toDos)
        return tasksForSelectedDay.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.selectedIndexPaths.count > 0 {
            if self.selectedIndexPaths.contains(indexPath) {
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
        let tasksForSelectedDay = ToDoProcessUtils.retrieveToDoItemsByDay(toDoDate: self.selectedDate, toDoItems: self.toDos)
        
        /*let toDosWithToDosToBeAddedOnCurrentDay = ToDoProcessUtils.retrieveToDoItemsByDay(toDoDate: getSelectedDate(), toDoItems: getToDosWithToDosToBeAdded())*/
        
        let sortedTasks = ToDoProcessUtils.sortToDoItemsByDate(toDoItems: tasksForSelectedDay)
        /*
        let sortedtoDosWithToDosToBeAddedOnCurrentDay = ToDoProcessUtils.sortToDoItemsByDate(toDoItems: toDosWithToDosToBeAddedOnCurrentDay)
        //let sortedToDoItems = ToDoProcessUtils.sortToDoItemsByDate(toDoItems: toDoItems)
        cell.taskNameLabel.text = sortedtoDosWithToDosToBeAddedOnCurrentDay[indexPath.row].value.getTaskName()
        cell.startDateLabel.text = workDateFormatter.string(from: sortedtoDosWithToDosToBeAddedOnCurrentDay[indexPath.row].value.getStartDate())
        cell.estTimeLabel.text = sortedtoDosWithToDosToBeAddedOnCurrentDay[indexPath.row].value.getEstTime()
        cell.dueDateLabel.text = dueDateFormatter.string(from: sortedtoDosWithToDosToBeAddedOnCurrentDay[indexPath.row].value.getEndDate())
        */
        cell.taskNameLabel.text = sortedTasks[indexPath.row].value.getTaskName()
        cell.startDateLabel.text = workDateFormatter.string(from: sortedTasks[indexPath.row].value.getStartTime())
        cell.estTimeLabel.text = "DELETE EST TIME PLEASE"
        cell.dueDateLabel.text = dueDateFormatter.string(from: sortedTasks[indexPath.row].value.getEndTime())
        // If calendar day was changed, then make the state of to-be loaded expand row buttons false
        
        if getCalendarDayChanged() == true {
            cell.expandButton.setPressedStatus(isPressed: false)
            // Determines if more buttons need to be reset
            trackExpandButtonsToBeReset()
        }
        
        cell.expandButton.setExpandedRowIndex(toDoRowIndex: indexPath.row)
        cell.expandButton.addTarget(self, action: #selector(onExpandRowButtonTap(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        ToDoTableViewUtils.makeCellMoveUpWithFade(cell: cell, indexPath: indexPath)
        //let toDoItemsOnCurrentDay = getToDoItemsByDay(dateChosen: getSelectedDate())
        /*
        let toDoIntervalsToAssignOnCurrentDay = ToDoProcessUtils.retrieveToDoItemsByDay(toDoDate: getSelectedDate(), toDoItems: getToDosWithToDosToBeAdded())
        let sortedToDoItemsOnCurrentDay = ToDoProcessUtils.sortToDoItemsByDate(toDoItems: toDoIntervalsToAssignOnCurrentDay)
        cell.backgroundColor = ToDoTableViewUtils.intervalsColorForToDoRow(toDoTaskId: sortedToDoItemsOnCurrentDay[indexPath.row].value.getTaskId(), toDoItems: getToDoIntervalsToAssign())
        //cell.backgroundColor = ToDoTableViewUtils.intervalsColorForToDoRow(toDoRowIndex: indexPath.row, toDoItems: getToDoItemsByDay(dateChosen: getSelectedDate()), toDoIntervalsToAssign: self.toDoIntervalsToAssign)
        cell.layer.backgroundColor = ToDoTableViewUtils.intervalsColorForToDoRow(toDoTaskId: sortedToDoItemsOnCurrentDay[indexPath.row].value.getTaskId(), toDoItems: getToDoIntervalsToAssign() ).cgColor*/
        
        let tasksForSelectedDay = ToDoProcessUtils.retrieveToDoItemsByDay(toDoDate: self.selectedDate, toDoItems: self.toDos)
        
        let sortedTasks = ToDoProcessUtils.sortToDoItemsByDate(toDoItems: tasksForSelectedDay)
        
        cell.backgroundColor = ToDoTableViewUtils.intervalsColorForToDoRowIfInTaskItems(toDoTaskId: sortedTasks[indexPath.row].value.getTaskId(), toDoItems: self.tasksToBeAdded)
        
        cell.layer.backgroundColor = ToDoTableViewUtils.intervalsColorForToDoRowIfInTaskItems(toDoTaskId: sortedTasks[indexPath.row].value.getTaskId(), toDoItems: self.tasksToBeAdded).cgColor
        
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
    func setIntervalHours(intervalHours: Int) {
        self.intervalHours = Double(intervalHours)
    }
    
    // USED HERE IN THIS CONTEXT
    func setIntervalDays(intervalDays: Int) {
        self.intervalDays = Double(intervalDays)
    }
    
    // USED HERE IN THIS CONTEXT
    func setToDoStartDate(toDoStartDate: Date) {
        self.toDoStartDate = toDoStartDate
    }
    
    // USED HERE IN THIS CONTEXT
    func setToDoEndDate(toDoEndDate: Date) {
        /*
        self.toDoEndDate = toDoEndDate
        print("DIDATE")
        print(self.toDoEndDate)*/
    }
    
    func setTaskDueDate(taskDueDate: Date) {
        self.toDoDueDate = taskDueDate
    }
    
    // USED HERE IN THIS CONTEXT
    /*
    func setToDoToBeIntervalized(toDo: ToDo) {
        self.toDoToBeIntervalized = toDo
    }*/
    
    func setDateOfTheDay(dayOfTheDay: Date) {
        
    }
    
    func setToDos(toDos: [String: ToDo]) {
        self.toDos = toDos
    }
    
    /*
    func setToDosToBeAdded(toDoItems: [String: ToDo]) {
        self.toDosToBeAdded = toDoItems
    }*/
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
    
    /*
    func setTodosWithToDosToBeAdded(originalToDos: [String: ToDo], newToDos: [String : ToDo]) {
        self.toDosWithToDosToBeAdded = originalToDos
        for singleToDo in newToDos {
            self.toDosWithToDosToBeAdded[singleToDo.value.taskId] = singleToDo.value
        }
    }*/
    
    
    func setRemainingExpandButtonsToReset(remainingButtons: Int) {
        self.remainingExpandButtonsToReset = remainingButtons
    }
    
    // MARK: - Getters
    
    // USED HERE IN THIS CONTEXT
    func getIntervalAmount() -> Int {
        return Int(self.intervalHours)
    }
    
    // USED HERE IN THIS CONTEXT
    func getIntervalLength() -> Double {
        return self.intervalDays
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
    /*
    func getToDoToBeIntervalized() -> ToDo {
        return self.toDoToBeIntervalized
    }*/
    
    /*
    // USED HERE IN THIS CONTEXT
    func getToDoIntervalsToAssign() -> [String: ToDo] {
        return self.toDoIntervalsToAssign
    }*/
    
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
    /*
    func getSelectedDate() -> Date {
        return self.selectedDate
    }*/
    
    /*
    func getSelectedIndexPaths() -> [IndexPath] {
        return self.selectedIndexPaths
    }*/
    
    func getCalendarDayChanged() -> Bool {
        return self.calendarDayChanged
    }
    
    func getRemainingButtonsToReset() -> Int {
        return self.remainingExpandButtonsToReset
    }
    
    /*
    func getToDosWithToDosToBeAdded() -> [String: ToDo] {
        return self.toDosWithToDosToBeAdded
    }*/
    
    
    // Tracks the expand row buttons that needs to be reset
    private func trackExpandButtonsToBeReset() {
        setRemainingExpandButtonsToReset(remainingButtons: getRemainingButtonsToReset() - 1)
        // If all to-be loaded expand buttons state are now false
        if getRemainingButtonsToReset() <= 0 {
            setCalendarDayChanged(didChange: false)
            setRemainingExpandButtonsToReset(remainingButtons: -1)
        }
    }
    
    // NOTE: Refactor this function
    
    /*
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
            // NOTE: This is the actual end time of the task, including its intervals
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
            //let intervalDueDate = longestTimeIntervalEndTime.getStartTime()
            let intervalDueDate =  dateArithmeticOps.addHoursToDate(date: intervalStartDate, hours: getIntervalLength())
            let intervalStatus = getToDoToBeIntervalized().isFinished()
            
            //let testVar = dateArithmeticOps.addHoursToDate(date: intervalStartDate, hours: Double(getToDoToBeIntervalized().estTime)!)
            let intervalTaskType = getToDoToBeIntervalized().getTaskType()
            
            //let intervalEstTime = getToDoToBeIntervalized().getEstTime()
            // NOTE: Don't know the return of the timeIntervalSince if it is in hours or seconds
            print("Interval Length")
            print(getIntervalLength())
            // NOTE: The interval length is the length of a single interval in the whole task
            if determinedInterval >= getIntervalLength() {
                // TODO: Action here
                self.toDoIntervalsToAssign[intervalTaskId] = ToDo(taskId: intervalTaskId, taskName: intervalName, taskType: intervalTaskType,taskDescription: intervalDescription, workDate: intervalStartDate, estTime: String(getIntervalLength()), dueDate: intervalDueDate, finished: intervalStatus, intervalized: true, intervalId: intervalId, intervalLength: Int(getIntervalAmount()), intervalIndex: assignedIntervals, intervalDueDate: getToDoToBeIntervalized().getEndDate())!
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
    }*/
    
    private func isToDoIntervalOnDay(toDoInterval: ToDo, dateOfDay: Date) -> Bool {
        formatter.dateFormat = "yyyy/MM/dd"
        let stringDateOfDay: String = formatter.string(from: dateOfDay)
        //let actualDateOfDay: Date = formatter.date(from: stringDateOfDay)!
        let strToDoIntervalStartDate: String = formatter.string(from: toDoInterval.getStartTime())
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
        if ToDoProcessUtils.retrieveToDoItemsByDay(toDoDate: date, toDoItems: self.toDos)[toDoToCheck.taskId] != nil  {
            return true
        }
        return false
    }
    
    
    func previewToDoIntervals(cell: CalendarCell, dateChosen: Date) {
        // NOTE: REFACTOR, like use a dictionary instead
        print("yhecount of getToDoIntervalsToAssign")
        //print(getToDoIntervalsToAssign())
        /*
        for toDoInterval in self.tasksToBeAdded {
            if isToDoIntervalOnDay(toDoInterval: toDoInterval.value, dateOfDay: dateChosen) && isToDoOnDay(toDoToCheck: toDoInterval.value, date: dateChosen) {
                cell.setShouldDrawStripes(shouldDraw: true)
            }
        }*/
        /*
        for toDoInterval in self.tasksToBeAdded {
            let toDoIntervalStartTimeString = dateUtils.getDayAsString(date: toDoInterval.value.getStartTime())
            let dateChosenString = dateUtils.getDayAsString(date: dateChosen)
            if toDoIntervalStartTimeString == dateChosenString && isToDoOnDay(toDoToCheck: toDoInterval.value, date: dateChosen) {
                print("toDoIntervalStartTimeString")
                print(toDoIntervalStartTimeString)
                print("dateChosenString")
                print(dateChosenString)
                cell.setShouldDrawStripes(shouldDraw: true)
            }
        }*/
        
        let dateChosenString = dateUtils.getDayAsString(date: dateChosen)
        if self.datesWithAnIntervalTracker.contains(dateChosenString) {
            cell.setShouldDrawStripes(shouldDraw: true, dayString: dateChosenString)
            //cell.setShouldDrawStripes(shouldDraw: false, dayString: dateChosenString)
        }
        /*
        let dateChosenString = dateUtils.getDayAsString(date: dateChosen)
        if let previewing = self.intervalsToPreview[dateChosenString] {
            if self.intervalsToPreview[dateChosenString] == true {
                cell.setShouldDrawStripes(shouldDraw: true)
                self.intervalsToPreview[dateChosenString] = false
            }
        }*/
    }
    
    @objc func onCheckBoxButtonTap(sender: CheckBoxButton) {
        /*
        var toDoItemsByDay = ToDoProcessUtils.sortToDoItemsByDate(toDoItems: toDosController.getToDosByDay(dateChosen: getSelectedDate()))*/
        //let toDoItemToUpdate: ToDo = toDoItemsByDay[sender.tag].value
        //let newToDoItem: ToDo = toDoItemsByDay[sender.tag].value
        
        //newToDoItem.finished = !newToDoItem.finished
        /*
        toDosController.updateToDos(modificationType: ListModificationType.UPDATE, toDo: newToDoItem)*/
        //reloadTableViewData()
        //reloadCalendarViewData()
    }
    
    @objc func onExpandRowButtonTap(sender: ExpandButton) {
        let buttonIndexPath = IndexPath(row: sender.getExpandedRowIndex(), section: 0)
        
        // If there is no expanded row yet
        if !self.selectedIndexPaths.contains(buttonIndexPath) {
            ToDoProcessUtils.addSelectedIndexPath(indexPath: buttonIndexPath, selectedIndexPaths: &self.selectedIndexPaths)
            self.toDoListTableView.beginUpdates()
            self.toDoListTableView.endUpdates()
            //reloadTableViewData()
        } else {
            let indPath: Int = self.selectedIndexPaths.firstIndex(of: buttonIndexPath)!
            ToDoProcessUtils.removeSelectedIndexPath(indexPathAsInt: indPath, selectedIndexPaths: &self.selectedIndexPaths)
            self.toDoListTableView.beginUpdates()
            self.toDoListTableView.endUpdates()
            //reloadTableViewData()
        }
    }
    
    
    // ----- NEW STUFF HERE
    
    
    private func retrieveTasksForDate(date: Date) -> [(key: String, value: ToDo)] {
        let taskItemTuple = ToDoProcessUtils.retrieveToDoItemsByDay(toDoDate: date, toDoItems: self.toDos)
        return ToDoProcessUtils.sortToDoItemsByDate(toDoItems: taskItemTuple)
    }
    
    private func evaluateVacantTimesByDate(date: Date, scheduleTimeSpan: TimeSpan) -> [Oter] {
        let tsve = TimeSlotsVacancyEvaluator()
        tsve.setTaskItems(tasks: retrieveTasksForDate(date: date))
        
        tsve.populateOtd(timeSpan: scheduleTimeSpan)
        tsve.evaluateOtd(timeSpan: scheduleTimeSpan)
        
        return tsve.getOterAvailabilities()
    }
    
    // NOTE: This function just makes a list of [Oter]
    private func processOterList() -> [String: [Oter]] {
        var oterCollectionDict = [String: [Oter]]()
        var currentDate = self.toDoStartDate
        
        while currentDate < self.toDoDueDate {
            let formattedStartDate = dateUtils.revertDateToZeroHours(date: currentDate)
            let formattedEndDate = dateUtils.revertDateToZeroHours(date: dateUtils.addDayToDate(date: currentDate, days: 1.0))

            let dayTimeSpan = TimeSpan(startDate: formattedStartDate, endDate: formattedEndDate)
            
            oterCollectionDict[dateUtils.getDayAsString(date: currentDate)] = evaluateVacantTimesByDate(date: currentDate, scheduleTimeSpan: dayTimeSpan)
            currentDate = dateUtils.addDayToDate(date: currentDate, days: 1.0)
        }
        
        return oterCollectionDict
    }

    private func processAvailableSlot(oterList: [Oter]) -> ToDo {
        var slottedTask = ToDo()
        for oter in oterList {
            if Double(dateUtils.hoursBetweenTwoDates(earlyDate: oter.startDate, laterDate: oter.endDate)) >= self.intervalHours {
                
                slottedTask = ToDo(taskId: UUID().uuidString, taskName: "Task" + String(self.intervalHours), startTime: oter.startDate, endTime: dateUtils.addHoursToDate(date: oter.startDate, hours: self.intervalHours), dueDate: dateUtils.addHoursToDate(date: oter.startDate, hours: self.intervalHours), finished: false)!
                
                return slottedTask
            }
        }
        return slottedTask
    }
    
    private func determineSlottedTasks() -> [String: ToDo] {
        let oterCollectionDict: [String: [Oter]] = processOterList()
        var currentDate = self.toDoStartDate
        var slottedTasks: [String: ToDo] = [String: ToDo]()
        var daysAssignedCounter = 0
        
        while currentDate < self.toDoDueDate && Double(daysAssignedCounter) < self.intervalDays {
            if let oterList = oterCollectionDict[dateUtils.getDayAsString(date: currentDate)] {
                let potentialSlottedTask = processAvailableSlot(oterList: oterList)
                
                if potentialSlottedTask.getTaskId() != "" {
                    print("Determiner day")
                    print(potentialSlottedTask.getStartTime())
                    potentialSlottedTask.intervalized = true
                    slottedTasks[potentialSlottedTask.getTaskId()] = potentialSlottedTask
                    self.datesWithAnIntervalTracker.insert(dateUtils.getDayAsString(date: potentialSlottedTask.getStartTime()))
                    
                    // This is to keep track of calendarCells that will have green stripe
                    //self.intervalsToPreview[dateUtils.getDayAsString(date: potentialSlottedTask.getStartTime())] = true
                }
            }
        
            currentDate = dateUtils.addDayToDate(date: currentDate, days: 1.0)
            daysAssignedCounter += 1
        }
        
        return slottedTasks
    }
}

extension IntervalSchedulingPreviewController: JTAppleCalendarViewDataSource {
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
        
        //cell.setCellDayId(cellDayId: dateUtils.getDayAsString(date: date))
        configureCell(cell: cell, cellState: cellState, date: date)
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
 
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
        
        //cell.setCellDayId(cellDayId: dateUtils.getDayAsString(date: date))
        
        configureCell(cell: cell, cellState: cellState, date: date)
        //previewToDoIntervals(cell: cell, dateChosen: date)
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(cell: cell, cellState: cellState, date: date)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(cell: cell, cellState: cellState, date: date)
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
