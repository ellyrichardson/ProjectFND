//
//  ScheduleView.swift
//  ProjectFND
//
//  Created by Elly Richardson on 8/13/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import UIKit
import JTAppleCalendar

class ScheduleView: UIView, UITableViewDelegate, UITableViewDataSource, ScheduleViewProtocol {
    final let TIME_h_mm_a = "h:mm a"
    final let TIME_dd_MM_yy = "dd MM yy"
    final let REMOVE = "Remove"
    final let DELETE = "Delete"
    final let ADD_TASK_ITEM = "AddToDoItem"
    final let SHOW_TASK_ITEM_DETAILS = "ShowToDoItemDetails"
    final let CALENDAR_HEADER = "CalendarHeader"
    final let SCHEDULE_TABLE_VIEW_CELL = "ScheduleTableViewCell"
    final let EMPTY_STRING = ""
    final let DATE_MMMM_YYYY =  "MMMM YYYY"
    final let CALENDAR_CELL = "CalendarCell"
    final let numberOfRows = 6
    
    @IBOutlet weak var scheduleCalendarView: JTAppleCalendarView!
    @IBOutlet weak var taskScheduleTableView: UITableView!
    @IBOutlet weak var tasksSectionLabel: UILabel!
    
    private var controller: ScheduleViewController?
    private var currentSelectedCalendarCell: IndexPath?
    private var shouldReloadTableView: Bool = true
    
    private let formatter = DateFormatter()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        //UIStoryboard(name: "Main", bundle: nil).load
        //addSubview(controller?.scheduleView as! UIView)
        configureTableView()
        configureCalendarView()
    }
    
    private func configureTableView() {
        taskScheduleTableView.delegate = self
        taskScheduleTableView.dataSource = self
        taskScheduleTableView.backgroundColor = UIColor.clear
        GeneralViewUtils.addTopBorderWithColor(taskScheduleTableView, color: UIColor.lightGray, width: 1.00)
    }
    
    func configureCalendarView(){
        //let scheduleViewCalendar = scheduleView?.getScheduleCalendarView()
        scheduleCalendarView.calendarDelegate = self
        scheduleCalendarView.calendarDataSource = self
        scheduleCalendarView.minimumLineSpacing = 0
        scheduleCalendarView.minimumInteritemSpacing = 0
        scheduleCalendarView.register(UINib(nibName: CALENDAR_HEADER, bundle: Bundle.main),
                              forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                              withReuseIdentifier: CALENDAR_HEADER)
        scheduleCalendarView.backgroundColor = UIColor.clear
        scheduleCalendarView.cellSize = scheduleCalendarView.contentSize.width
        scheduleCalendarView.scrollToDate(Date(),animateScroll: false)
        scheduleCalendarView.selectDates([ Date() ])
    }
    
    func getTaskScheduleTableView() -> UITableView {
        return taskScheduleTableView
    }
    
    func getScheduleCalendarView() -> JTAppleCalendarView {
        return scheduleCalendarView
    }
    
    func setController(controller: UIViewController) {
        self.controller = (controller as! ScheduleViewController)
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
                self.currentSelectedCalendarCell = self.scheduleCalendarView.indexPath(for: currentCell)
            }
        } else {
            currentCell.selectedView.isHidden = true
        }
    }
    
    // When a particular day is selected in the calendar
    func configureSelectedDay(cell: JTAppleCell?, cellState: CellState) {
        if cellState.isSelected{
            controller?.setSelectedDate(selectedDate: cellState.date)

            // If tableView should be reloaded based on todo update, or simply loading the calendar
            if self.shouldReloadTableView {
                GeneralViewUtils.reloadTableViewData(tableView: taskScheduleTableView)
            }
            // Set shouldReloadTableview by default
            self.shouldReloadTableView = true
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (controller?.getTasksForSelectedDay().count)!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SCHEDULE_TABLE_VIEW_CELL, for: indexPath) as? ScheduleTableViewCell else {
            fatalError("The dequeued cell is not an instance of ScheduleTableViewCell.")
        }
        
        generalCellPresentationConfig(cell: cell, row: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .default, title: DELETE) { (action, indexPath) in
            self.taskScheduleTableView.dataSource?.tableView!(self.taskScheduleTableView, commit: .delete, forRowAt: indexPath)
            return
        }
        // Makes the backgroundColor of deleteButton black and its title "Remove".
        deleteButton.backgroundColor = UIColor.black
        deleteButton.title = REMOVE
        return [deleteButton]
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            controller?.deleteTaskFromSystem(row: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            reloadOnlyCalendarViewItems()

        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        animateCellPresentation(cell: cell, indexPath: indexPath)
        let sortedTaskItems = controller?.getSortedTasksByDayForSelectedDay()
        configureCellDesign(cell: cell, row: indexPath.row, sortedTaskItems: sortedTaskItems!)
    }
    
    
    private func animateCellPresentation(cell: UITableViewCell, indexPath: IndexPath) {
        ToDoTableViewUtils.makeCellSlide(cell: cell, indexPath: indexPath, tableView: taskScheduleTableView)
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
    
    func generalCellPresentationConfig(cell: ScheduleTableViewCell, row: Int) {
        let dueDateFormatter = DateFormatter()
        let workDateFormatter = DateFormatter()
        dueDateFormatter.dateFormat = TIME_h_mm_a
        workDateFormatter.dateFormat = TIME_h_mm_a
        
        // Retrieves sorted ToDo Items by date that fall under the chosen day in the calendar
        // NOTE: Put this logic in the controller
        let sortedTaskItems =  controller?.getSortedTasksByDayForSelectedDay()
        cell.taskNameLabel.text = sortedTaskItems![row].value.getTaskName()
        cell.startTimeLabel.text = workDateFormatter.string(from: sortedTaskItems![row].value.getStartTime())
        cell.endTimeLabel.text = dueDateFormatter.string(from: sortedTaskItems![row].value.getEndTime())
        cell.taskTypeLabel.text = sortedTaskItems![row].value.getTaskTag()
        cell.checkBoxButton.setToDoRowIndex(toDoRowIndex: row)
        
        //cellCheckBoxButtonConfig(cell: cell, row: row, sortedTaskItems: sortedTaskItems)
        cellImportantButtonConfig(cell: cell, row: row, sortedTaskItems: sortedTaskItems!)
        cellNotifyButtonConfig(cell: cell, row: row, sortedTaskItems: sortedTaskItems!)
        cellFinishedButtonConfig(cell: cell, row: row, sortedTaskItems: sortedTaskItems!)
    }
    
    private func reloadOnlyCalendarViewItems() {
        DispatchQueue.main.async {
            // NOTE: This will make the tableView not reload, only the calendarView item
            self.shouldReloadTableView = false
            self.scheduleCalendarView.reloadItems(at: [self.currentSelectedCalendarCell!])
        }
    }
    
    /*
    // NOTE: Is this actually used?????
    private func cellCheckBoxButtonConfig(cell: ScheduleTableViewCell, row: Int, sortedTaskItems: [(key: String, value: ToDo)]) {
        // Sets the status of the CheckBox being pressed
        cell.checkBoxButton.tag = row
        cell.checkBoxButton.setPressedStatus(isPressed: sortedTaskItems[row].value.isFinished())
        cell.checkBoxButton.addTarget(self, action: #selector(onCheckBoxButtonTap(sender:)), for: .touchUpInside)
    }*/
    
    private func cellImportantButtonConfig(cell: ScheduleTableViewCell, row: Int, sortedTaskItems: [(key: String, value: ToDo)]) {
        // Sets the status of the important button being pressed
        cell.importantButton.tag = row
        cell.importantButton.setPressedStatus(isPressed: sortedTaskItems[row].value.isImportant())
        cell.importantButton.addTarget(self, action: #selector(onImportantButtonTap(sender:)), for: .touchUpInside)
    }
    
    private func cellNotifyButtonConfig(cell: ScheduleTableViewCell, row: Int, sortedTaskItems: [(key: String, value: ToDo)]) {
        // Sets the status of the notify button being pressed
        cell.notifyButton.tag = row
        cell.notifyButton.setPressedStatus(isPressed: sortedTaskItems[row].value.isNotifying())
        cell.notifyButton.addTarget(self, action: #selector(onNotificationButtonTap(sender:)), for: .touchUpInside)
    }
    
    private func cellFinishedButtonConfig(cell: ScheduleTableViewCell, row: Int, sortedTaskItems: [(key: String, value: ToDo)]) {
        // Sets the status of the finished button being pressed
        cell.finishedButton.tag = row
        cell.finishedButton.isOverdue(overdue: ToDoProcessUtils.isToDoOverdue(toDoRowIndex: row, toDoItems: sortedTaskItems))
        cell.finishedButton.setPressedStatus(isPressed: sortedTaskItems[row].value.isFinished())
        cell.finishedButton.addTarget(self, action: #selector(onFinishedButtonTap(sender:)), for: .touchUpInside)
    }
    
    @objc func onImportantButtonTap(sender: ImportantButton) {
        controller?.updateImportanceStatusOnTask(taskIndex: sender.tag)
    }
    
    @objc func onNotificationButtonTap(sender: NotificationButton) {
        controller?.updateNotificationStatusOnTask(taskIndex: sender.tag)
    }
    
    @objc func onFinishedButtonTap(sender: FinishedButton) {
        controller?.updateFinishStatusOnTask(taskIndex: sender.tag)
        let indexPath = IndexPath(item: sender.tag, section: 0)
        taskScheduleTableView.reloadRows(at: [indexPath], with: .top)
        shouldReloadTableView = false
        scheduleCalendarView.reloadItems(at: [self.currentSelectedCalendarCell!])
    }
    
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
        let toDosForTheDay = controller?.getTasksByDate(date: date)
        
        // Checks if these kinds of ToDos exist in the date of the current cell.
        /*
         Task will be identified as onProgress if due date is not set
         */
        // NOTE: Move this logic to the controller
        let onProgressToDo = toDosForTheDay!.first(where: {(Date() < $0.value.getDueDate() || !$0.value.isDueDateSet()) && !$0.value.isFinished() })
        let finishedToDo = toDosForTheDay!.first(where: {$0.value.isFinished() == true})
        let overdueToDo = toDosForTheDay!.first(where: {(Date() > $0.value.getDueDate() && !$0.value.isFinished()) && $0.value.isDueDateSet()})
        
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
}

extension ScheduleView: JTAppleCalendarViewDataSource {
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

extension ScheduleView: JTAppleCalendarViewDelegate {
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
