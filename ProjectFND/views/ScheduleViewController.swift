//
//  ViewController.swift
//  ProjectFND
//
//  Created by Elly Richardson on 9/3/19.
//  Copyright © 2019 EllyRichardson. All rights reserved.
//
//  Parts of the calendar implementation code was taken from CalendarControlUsingJTAppleCalenader
//  project by anoop4real.
//

import UIKit
import CoreData
import os.log
import JTAppleCalendar

class ScheduleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, Observer {
    
    final let REMOVE = "Remove"
    final let DELETE = "Delete"
    final let ADD_TASK_ITEM = "AddToDoItem"
    final let SHOW_TASK_ITEM_DETAILS = "ShowToDoItemDetails"
    final let CALENDAR_HEADER = "CalendarHeader"
    final let SCHEDULE_TABLE_VIEW_CELL = "ScheduleTableViewCell"
    final let EMPTY_STRING = ""
    final let TIME_h_mm_a = "h:mm a"
    final let TIME_dd_MM_yy = "dd MM yy"
    final let DATE_MMMM_YYYY =  "MMMM YYYY"
    final let CALENDAR_CELL = "CalendarCell"
    
    // MARK: Properties
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var toDoListTableView: UITableView!
    @IBOutlet weak var tasksLabelView: UIView!
    
    // Helpers
    
    var toDoProcessHelper: ToDoProcessUtils = ToDoProcessUtils()
    
    // Properties

    private var toDos = [String: ToDo]()
    private var selectedDate: Date = Date()
    private var coreToDoData: [NSManagedObject] = []
    private var checkButtonTapped: Int =  -1
    private var currentSelectedCalendarCell: IndexPath?
    private var shouldReloadTableView: Bool = true
    private var toDosController: ToDosController = ToDosController()

    let formatter = DateFormatter()
    let numberOfRows = 6
    
    private var _observerId: Int = 0
    
    // Id of the ViewController as an Observer
    var observerId: Int {
        get {
            return self._observerId
        }
    }
    
    // To Update the ViewController
    func update<T>(with newValue: T, with observableType: ObservableType) {
        setToDoItems(toDoItems: newValue as! [String: ToDo])
        print("ToDo Items for ScheduleViewController has been updated")
    }
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTaskController()
        configureNav()
        configureTableView()
        configureCalendarView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        toDoListTableView.reloadData()
    }
    
    // MARK: - Configurations
    
    private func configureTaskController() {
        self.toDosController.setInitialToDos()
        var observerVCList: [Observer] = [Observer]()
        let barViewController = self.tabBarController
        let nav1 = barViewController!.viewControllers?[1] as! UINavigationController
        let statusViewController = nav1.topViewController as! ParentStatusViewController
        statusViewController.setToDosController(toDosController: toDosController)
        observerVCList.append(statusViewController)
        self.toDosController.setObservers(observers: observerVCList)
    }
    
    private func configureNav() {
        let nav = self.navigationController?.navigationBar
        
        // Sets the navigation bar to color black with tintColor of yellow.
        nav?.barStyle = UIBarStyle.black
        nav?.tintColor = UIColor(red:1.00, green:0.89, blue:0.00, alpha:1.0)
    }
    
    private func configureTableView() {
        toDoListTableView.delegate = self
        toDoListTableView.dataSource = self
        toDoListTableView.backgroundColor = UIColor.clear
        GeneralViewUtils.addTopBorderWithColor(toDoListTableView, color: UIColor.lightGray, width: 1.00)
    }
    
    func configureCalendarView(){
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        calendarView.register(UINib(nibName: CALENDAR_HEADER, bundle: Bundle.main),
                              forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                              withReuseIdentifier: CALENDAR_HEADER)
        calendarView.backgroundColor = UIColor.clear
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
        currentCell.selectedView.clipsToBounds = true
        
        if cellState.isSelected{
            currentCell.selectedView.isHidden = false
            DispatchQueue.main.async {
                self.currentSelectedCalendarCell = self.calendarView.indexPath(for: currentCell)
            }
        } else {
            currentCell.selectedView.isHidden = true
        }
    }
    
    // When a particular day is selected in the calendar
    func configureSelectedDay(cell: JTAppleCell?, cellState: CellState) {
        if cellState.isSelected{
            setSelectedDate(selectedDate: cellState.date)

            // If tableView should be reloaded based on todo update, or simply loading the calendar
            if self.shouldReloadTableView {
                GeneralViewUtils.reloadTableViewData(tableView: self.toDoListTableView)
            }
            // Set shouldReloadTableview by default
            self.shouldReloadTableView = true
        }
    }
    
    // MARK: - Table View Data Source
    // --
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Gets the ToDos that fall under the selected day in calendar
        return toDosController.getToDosByDay(dateChosen: getSelectedDate()).count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    // --
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SCHEDULE_TABLE_VIEW_CELL, for: indexPath) as? ScheduleTableViewCell else {
            fatalError("The dequeued cell is not an instance of ScheduleTableViewCell.")
        }
        
        generalCellPresentationConfig(cell: cell, row: indexPath.row)
        return cell
    }
    
    // =====
    private func generalCellPresentationConfig(cell: ScheduleTableViewCell, row: Int) {
        let dueDateFormatter = DateFormatter()
        let workDateFormatter = DateFormatter()
        dueDateFormatter.dateFormat = TIME_h_mm_a
        workDateFormatter.dateFormat = TIME_h_mm_a
        
        // Retrieves sorted ToDo Items by date that fall under the chosen day in the calendar
        let taskItems = ToDoProcessUtils.retrieveToDoItemsByDay(toDoDate: getSelectedDate(), toDoItems: getToDosController().getToDos())
        let sortedTaskItems =  ToDoProcessUtils.sortToDoItemsByDate(toDoItems: taskItems)
        cell.taskNameLabel.text = sortedTaskItems[row].value.getTaskName()
        cell.startTimeLabel.text = workDateFormatter.string(from: sortedTaskItems[row].value.getStartTime())
        cell.endTimeLabel.text = dueDateFormatter.string(from: sortedTaskItems[row].value.getEndTime())
        cell.taskTypeLabel.text = sortedTaskItems[row].value.getTaskTag()
        cell.checkBoxButton.setToDoRowIndex(toDoRowIndex: row)
        
        cellCheckBoxButtonConfig(cell: cell, row: row, sortedTaskItems: sortedTaskItems)
        cellImportantButtonConfig(cell: cell, row: row, sortedTaskItems: sortedTaskItems)
        cellNotifyButtonConfig(cell: cell, row: row, sortedTaskItems: sortedTaskItems)
        cellFinishedButtonConfig(cell: cell, row: row, sortedTaskItems: sortedTaskItems)
    }
    
    // =====
    // NOTE: Is this actually used?????
    private func cellCheckBoxButtonConfig(cell: ScheduleTableViewCell, row: Int, sortedTaskItems: [(key: String, value: ToDo)]) {
        // Sets the status of the CheckBox being pressed
        cell.checkBoxButton.tag = row
        cell.checkBoxButton.setPressedStatus(isPressed: sortedTaskItems[row].value.isFinished())
        cell.checkBoxButton.addTarget(self, action: #selector(onCheckBoxButtonTap(sender:)), for: .touchUpInside)
    }
    
    // =====
    private func cellImportantButtonConfig(cell: ScheduleTableViewCell, row: Int, sortedTaskItems: [(key: String, value: ToDo)]) {
        // Sets the status of the important button being pressed
        cell.importantButton.tag = row
        cell.importantButton.setPressedStatus(isPressed: sortedTaskItems[row].value.isImportant())
        cell.importantButton.addTarget(self, action: #selector(onImportantButtonTap(sender:)), for: .touchUpInside)
    }
    
    // =====
    private func cellNotifyButtonConfig(cell: ScheduleTableViewCell, row: Int, sortedTaskItems: [(key: String, value: ToDo)]) {
        // Sets the status of the notify button being pressed
        cell.notifyButton.tag = row
        cell.notifyButton.setPressedStatus(isPressed: sortedTaskItems[row].value.isNotifying())
        cell.notifyButton.addTarget(self, action: #selector(onNotificationButtonTap(sender:)), for: .touchUpInside)
    }
    
    // =====
    private func cellFinishedButtonConfig(cell: ScheduleTableViewCell, row: Int, sortedTaskItems: [(key: String, value: ToDo)]) {
        // Sets the status of the finished button being pressed
        cell.finishedButton.tag = row
        cell.finishedButton.isOverdue(overdue: ToDoProcessUtils.isToDoOverdue(toDoRowIndex: row, toDoItems: sortedTaskItems))
        cell.finishedButton.setPressedStatus(isPressed: sortedTaskItems[row].value.isFinished())
        cell.finishedButton.addTarget(self, action: #selector(onFinishedButtonTap(sender:)), for: .touchUpInside)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        animateCellPresentation(cell: cell, indexPath: indexPath)
        let sortedTaskItems =  ToDoProcessUtils.sortToDoItemsByDate(toDoItems: toDosController.getToDosByDay(dateChosen: getSelectedDate()))
        configureCellDesign(cell: cell, row: indexPath.row, sortedTaskItems: sortedTaskItems)
    }
    
    private func animateCellPresentation(cell: UITableViewCell, indexPath: IndexPath) {
        if checkButtonTapped == indexPath.row {
            ToDoTableViewUtils.makeCellMoveUpWithFade(cell: cell, indexPath: indexPath)
            checkButtonTapped = -1
        }
        else {
            ToDoTableViewUtils.makeCellSlide(cell: cell, indexPath: indexPath, tableView: toDoListTableView)
        }
    }
    
    private func configureCellDesign(cell: UITableViewCell, row: Int, sortedTaskItems: [(key: String, value: ToDo)]) {
        cell.contentView.layer.backgroundColor = ToDoTableViewUtils.colorForToDoRow(toDoRowIndex: row, toDoItems: sortedTaskItems).cgColor
        cell.layer.backgroundColor = ToDoTableViewUtils.colorForToDoRow(toDoRowIndex: row, toDoItems: sortedTaskItems).cgColor
        
        // This will turn on `masksToBounds` just before showing the cell
        cell.contentView.layer.masksToBounds = true
        
        /*
         NOTE: If this is not set `shadowPath` you'll notice laggy scrolling. Mysterious code too.  It just make the shadow stuff work
         */
        let radius = cell.contentView.layer.cornerRadius
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: radius).cgPath
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .default, title: DELETE) { (action, indexPath) in
            self.toDoListTableView.dataSource?.tableView!(self.toDoListTableView, commit: .delete, forRowAt: indexPath)
            return
        }
        // Makes the backgroundColor of deleteButton black and its title "Remove".
        deleteButton.backgroundColor = UIColor.black
        deleteButton.title = REMOVE
        return [deleteButton]
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteTaskFromSystem(row: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            reloadOnlyCalendarViewItems()

        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    private func deleteTaskFromSystem(row: Int) {
        let taskToBeDeleted = ToDoProcessUtils.sortToDoItemsByDate(toDoItems: toDosController.getToDosByDay(dateChosen: getSelectedDate()))[row]
        toDosController.updateToDos(modificationType: ListModificationType.REMOVE, toDo: taskToBeDeleted.value)
    }
    
    private func reloadOnlyCalendarViewItems() {
        DispatchQueue.main.async {
            // NOTE: This will make the tableView not reload, only the calendarView item
            self.shouldReloadTableView = false
            self.calendarView.reloadItems(at: [self.currentSelectedCalendarCell!])
        }
    }
    
    // MARK: - Utilities
    
    private func configureCellIndicators(cell: CalendarCell, indexPath: IndexPath, date: Date) -> CalendarCell {
        
        var onProgressToDoExist: Bool = false
        var finishedToDoExist: Bool = false
        var overdueToDoExist: Bool = false
        
        // Hides the indicators initially.
        cell.bottomIndicator.isHidden = true
        cell.topIndicator.isHidden = true
        cell.topLeftIndicator.isHidden = true
        cell.topRightIndicator.isHidden = true
        
        // Gets the ToDos based on the date of the current cell.
        let toDosForTheDay = toDosController.getToDosByDay(dateChosen: date)
        
        // Checks if these kinds of ToDos exist in the date of the current cell.
        /*
         Task will be identified as onProgress if due date is not set
         */
        let onProgressToDo = toDosForTheDay.first(where: {(Date() < $0.value.getDueDate() || !$0.value.isDueDateSet()) && !$0.value.isFinished() })
        let finishedToDo = toDosForTheDay.first(where: {$0.value.isFinished() == true})
        let overdueToDo = toDosForTheDay.first(where: {(Date() > $0.value.getDueDate() && !$0.value.isFinished()) && $0.value.isDueDateSet()})
        
        // Sets boolean variables if types of ToDos exist.
        if onProgressToDo != nil {
            onProgressToDoExist = true
        }
        if finishedToDo != nil {
            finishedToDoExist = true
        }
        if overdueToDo != nil {
            overdueToDoExist = true
        }
        
        // If either one of the types of ToDo exist.
        if onProgressToDoExist == true || finishedToDoExist == true || overdueToDoExist == true {
            // Update the cell to have the indicators it needs.
            return CalendarViewUtils.showCellIndicators(cell: cell, onProgress: onProgressToDoExist, finished: finishedToDoExist, overdue: overdueToDoExist)
        }
        return cell
    }
    
    // MARK: - Actions
    
    @IBAction func unwindToScheduleView(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ItemInfoTableViewController {
            let taskItem = sourceViewController.toDo
            if toDoListTableView.indexPathForSelectedRow != nil {
                toDosController.updateToDos(modificationType: ListModificationType.UPDATE, toDo: taskItem!)
                GeneralViewUtils.reloadTableViewData(tableView: self.toDoListTableView)
            } else {
                toDosController.updateToDos(modificationType: ListModificationType.ADD, toDo: taskItem!)
                GeneralViewUtils.reloadCollectionViewData(collectionView: self.calendarView)
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? EMPTY_STRING) {
        case ADD_TASK_ITEM:
            let itemInfoSegueProcess = ItemInfoSegueProcess(segue: segue)
            itemInfoSegueProcess!.segueToItemInfoVCForAddingTask(tasksController: toDosController, startDate: selectedDate)
        case SHOW_TASK_ITEM_DETAILS:
            let itemInfoSegueProcess = ItemInfoSegueProcess(segue: segue)
            itemInfoSegueProcess!.segueToItemInfoVCForShowingTaskDetails(selectedDate: getSelectedDate(), tasksController: toDosController, sender: sender, taskListTableView: toDoListTableView)
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }

    // TODO: Move utility setters and getters to the controller
    // MARK: - Setters and Getters
    
    func setToDoItems(toDoItems: [String: ToDo]) {
        self.toDos = toDoItems
    }
    
    func setSelectedDate(selectedDate: Date) {
        self.selectedDate = selectedDate
    }
    
    func setToDosController(toDosController: ToDosController) {
        self.toDosController = toDosController
    }
    
    func getToDosController() -> ToDosController {
        return self.toDosController
    }
    
    func getObserverId() -> Int {
        return self.observerId
    }
    
    func getSelectedDate() -> Date {
        return self.selectedDate
    }
    
    func getTasks() -> [String: ToDo] {
        return getToDosController().getToDos()
    }
    
    func getTasksForSelectedDay() -> [String: ToDo] {
        return toDosController.getToDosByDay(dateChosen: getSelectedDate())
    }
    
    func getSortedTasksByDayForSelectedDay() -> [(key: String, value: ToDo)] {
        let taskItems = toDosController.getToDosByDay(dateChosen: getSelectedDate())
        return ToDoProcessUtils.sortToDoItemsByDate(toDoItems: taskItems)
    }
    
    func getTasksByDate(date: Date) -> [String : ToDo] {
        return toDosController.getToDosByDay(dateChosen: date)
    }
    
    // TODO: Refactor code to use proper state tracking, like ENUMS! I'm talking about the shouldReloadTableView
    @objc func onCheckBoxButtonTap(sender: CheckBoxButton) { // =====
        // The toDosByDay variable should be sorted already
        let toDosByDay = ToDoProcessUtils.sortToDoItemsByDate(toDoItems: toDosController.getToDosByDay(dateChosen: getSelectedDate()))
        let tempToDoItem: ToDo = toDosByDay[sender.tag].value
        let newToDoItem = tempToDoItem
        
        toDosController.updateToDos(modificationType: ListModificationType.FINISHNESS, toDo: newToDoItem)
        let indexPath = IndexPath(item: sender.tag, section: 0)
        self.toDoListTableView.reloadRows(at: [indexPath], with: .top)
        self.shouldReloadTableView = false
        self.calendarView.reloadItems(at: [self.currentSelectedCalendarCell!])
    }
    
    @objc func onFinishedButtonTap(sender: FinishedButton) { // ===
        // The toDosByDay variable should be sorted already
        let toDosByDay = ToDoProcessUtils.sortToDoItemsByDate(toDoItems: toDosController.getToDosByDay(dateChosen: getSelectedDate()))
        let tempToDoItem: ToDo = toDosByDay[sender.tag].value
        let newToDoItem = tempToDoItem
        
        toDosController.updateToDos(modificationType: ListModificationType.FINISHNESS, toDo: newToDoItem)
        let indexPath = IndexPath(item: sender.tag, section: 0)
        self.toDoListTableView.reloadRows(at: [indexPath], with: .top)
        self.shouldReloadTableView = false
        self.calendarView.reloadItems(at: [self.currentSelectedCalendarCell!])
    }
    
    func updateFinishStatusOnTask(taskIndex: Int) {
        // The toDosByDay variable should be sorted already
        let tasksByDay = getSortedTasksByDayForSelectedDay()
        let tempToDoItem: ToDo = tasksByDay[taskIndex].value
        let newToDoItem = tempToDoItem
        toDosController.updateToDos(modificationType: ListModificationType.FINISHNESS, toDo: newToDoItem)
    }
    
    
    
    @objc func onImportantButtonTap(sender: ImportantButton) { // ====
        // The toDosByDay variable should be sorted already
        let toDosByDay = ToDoProcessUtils.sortToDoItemsByDate(toDoItems: toDosController.getToDosByDay(dateChosen: getSelectedDate()))
        let tempToDoItem: ToDo = toDosByDay[sender.tag].value
        let newToDoItem = tempToDoItem
        
        toDosController.updateToDos(modificationType: ListModificationType.IMPORTANT, toDo: newToDoItem)
    }
    
    func updateImportanceStatusOnTask(taskIndex: Int) {
        // The toDosByDay variable should be sorted already
        let tasksByDay = getSortedTasksByDayForSelectedDay()
        let tempToDoItem: ToDo = tasksByDay[taskIndex].value
        let newToDoItem = tempToDoItem
        toDosController.updateToDos(modificationType: ListModificationType.IMPORTANT, toDo: newToDoItem)
    }
    
    @objc func onNotificationButtonTap(sender: NotificationButton) { // ====
        // The toDosByDay variable should be sorted already
        let toDosByDay = ToDoProcessUtils.sortToDoItemsByDate(toDoItems: toDosController.getToDosByDay(dateChosen: getSelectedDate()))
        let tempToDoItem: ToDo = toDosByDay[sender.tag].value
        let newToDoItem = tempToDoItem
        
        toDosController.updateToDos(modificationType: ListModificationType.NOTIFICATION, toDo: newToDoItem)
    }
    
    func updateNotificationStatusOnTask(taskIndex: Int) {
        // The toDosByDay variable should be sorted already
        let tasksByDay = getSortedTasksByDayForSelectedDay()
        let tempToDoItem: ToDo = tasksByDay[taskIndex].value
        let newToDoItem = tempToDoItem
        toDosController.updateToDos(modificationType: ListModificationType.NOTIFICATION, toDo: newToDoItem)
    }
}

extension ScheduleViewController: JTAppleCalendarViewDataSource {
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: CALENDAR_CELL, for: indexPath) as! CalendarCell
        configureCell(cell: cell, cellState: cellState)
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = TIME_dd_MM_yy
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

extension ScheduleViewController: JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        
        var cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: CALENDAR_CELL, for: indexPath) as! CalendarCell
        
        cell = configureCellIndicators(cell: cell, indexPath: indexPath, date: date)
        
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
        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: CALENDAR_HEADER, for: indexPath)
        let date = range.start
        let formatter = DateFormatter()
        formatter.dateFormat = DATE_MMMM_YYYY
        (header as! CalendarHeader).title.text = formatter.string(from: date).uppercased()
        return header
    }
    
    func calendarSizeForMonths(_ calendar: JTAppleCalendarView?) -> MonthSize? {
        return MonthSize(defaultSize: 75)
    }
}
