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
import os.log
import JTAppleCalendar

class ScheduleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Properties
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var toDoListTableView: UITableView!
    
    // Helpers
    
    var toDoProcessHelper: ToDoProcessHelper = ToDoProcessHelper()
    
    // Properties

    private var toDos = [ToDo]()
    private var selectedDate: Date = Date()
    private var selectedToDoIndex: Int = -1
    private var selectedIndexPath: IndexPath?
    private var selectedIndexPaths: [IndexPath] = [IndexPath]()
    
    // Expand row buttons tracker assets
    
    private var calendarDayChanged: Bool = false
    private var remainingExpandButtonsToReset: Int = -1
    
    let formatter = DateFormatter()
    let numberOfRows = 6
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.toDoListTableView.delegate = self
        self.toDoListTableView.dataSource = self
        
        if let savedToDos = loadToDos() {
            setToDoItems(toDoItems: savedToDos)
        }
        
        configureCalendarView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadTableViewData()
    }
    
    func configureCalendarView(){
        
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
        calendarView.register(UINib(nibName: "CalendarHeader", bundle: Bundle.main),
                              forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                              withReuseIdentifier: "CalendarHeader")
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
            currentCell.dateLabel.textColor = UIColor.red
            reloadTableViewData()
        } else {
            if cellState.dateBelongsTo == .thisMonth && cellState.date > Date()  {
                currentCell.dateLabel.textColor = UIColor.black
            } else {
                currentCell.dateLabel.textColor = UIColor.gray
            }
        }
    }
    
    func configureSelectedStateFor(cell: JTAppleCell?, cellState: CellState){
        
        guard let currentCell = cell as? CalendarCell else {
            return
        }
        
        if cellState.isSelected{
            currentCell.selectedView.isHidden = false
            currentCell.bgView.isHidden = true
        } else {
            currentCell.selectedView.isHidden = true
            currentCell.bgView.isHidden = true
        }
    }
    
    // When a particular day is selected in the calendar
    func configureSelectedDay(cell: JTAppleCell?, cellState: CellState) {
        if cellState.isSelected{
            setSelectedDate(selectedDate: cellState.date)
            removeAllSelectedIndexPaths()
            // To track if the selected day in the calendar was changed
            setCalendarDayChanged(didChange: true)
            reloadTableViewData()
            // To track how many expand row buttons will be reset if the selected was changed
            setRemainingExpandButtonsToReset(remainingButtons: getToDoItemsByDay().count)
        }
    }
    
    // MARK: - Table View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Gets the ToDos that fall under the selected day in calendar
        return getToDoItemsByDay().count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedIndexPaths.count > 0 {
            if selectedIndexPaths.contains(indexPath) {
                return 75
            }
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dateCellIdentifier = "ScheduleTableViewCell"
        
        let dueDateFormatter = DateFormatter()
        let workDateFormatter = DateFormatter()
        dueDateFormatter.dateFormat = "M/d/yy, h:mm a"
        workDateFormatter.dateFormat = "h:mm a"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: dateCellIdentifier, for: indexPath) as? ScheduleTableViewCell else {
            fatalError("The dequeued cell is not an instance of ScheduleTableViewCell.")
        }
        // Retrieves sorted ToDo Items by date that fall under the chosen day in the calendar
        var toDoItems = getToDoItemsByDay()
        cell.taskNameLabel.text = toDoItems[indexPath.row].taskName
        cell.startDateLabel.text = workDateFormatter.string(from: toDoItems[indexPath.row].workDate)
        cell.estTimeLabel.text = toDoItems[indexPath.row].estTime
        cell.dueDateLabel.text = dueDateFormatter.string(from: toDoItems[indexPath.row].dueDate)
        // Assigns an index to the CheckBox button of a row
        cell.checkBoxButton.setToDoRowIndex(toDoRowIndex: indexPath.row)
        // Sets the status of the CheckBox being pressed
        print("isfinished")
        print(indexPath.row)
        print(toDoItems[indexPath.row].finished)
        cell.checkBoxButton.setPressedStatus(isPressed: toDoItems[indexPath.row].finished)
        cell.checkBoxButton.addTarget(self, action: #selector(onCheckBoxButtonTap(sender:)), for: .touchUpInside)
        
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
    
    // MARK: - Actions
    
    @IBAction func unwindToScheduleView(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ItemInfoTableViewController, let toDo = sourceViewController.toDo {
            if toDoListTableView.indexPathForSelectedRow != nil {
                // Replaces the ToDo item in the original array of ToDos.
                replaceToDoItemInBaseList(editedToDoItem: toDo, editedToDoItemIndex: getSelectedToDoIndex())
                reloadTableViewData()
            } else {
                addToDoItem(toDoItem: toDo)
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
        case "AddToDoItem":
            os_log("Adding a new ToDo item.", log: OSLog.default, type: .debug)
        case "ShowToDoItemDetails":
            var toDoItemsByDay: [ToDo] = getToDoItemsByDay()
            guard let itemInfoTableViewController = segue.destination as? ItemInfoTableViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedToDoItemCell = sender as? ScheduleTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = toDoListTableView.indexPath(for: selectedToDoItemCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedToDoItem = toDoItemsByDay[indexPath.row]
            itemInfoTableViewController.toDo = selectedToDoItem
            // Sets the chosen work and due date in the itemInfoTableViewController to avoid its reset
            itemInfoTableViewController.setChosenWorkDate(chosenWorkDate: selectedToDoItem.workDate)
            itemInfoTableViewController.setChosenDueDate(chosenDueDate: selectedToDoItem.dueDate)
            // Sets the finish status of the todo in the itemInfoTableViewController to avoid its reset
            itemInfoTableViewController.setIsFinished(isFinished: selectedToDoItem.finished)
            // Retrieves the index of the selected toDo
            setSelectedToDoIndex(toDoItemIndex: retrieveRealIndexOfToDo(toDoItem: selectedToDoItem))
            os_log("Showing details for the selected ToDo item.", log: OSLog.default, type: .debug)
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    // MARK: - Setters
    
    func setToDoItems(toDoItems: [ToDo]) {
        self.toDos = toDoItems
    }
    
    func setSelectedToDoIndex(toDoItemIndex: Int) {
        self.selectedToDoIndex = toDoItemIndex
    }
    
    func setSelectedDate(selectedDate: Date) {
        self.selectedDate = selectedDate
    }
    
    func setCalendarDayChanged(didChange: Bool) {
        self.calendarDayChanged = didChange
    }
    
    func setRemainingExpandButtonsToReset(remainingButtons: Int) {
        self.remainingExpandButtonsToReset = remainingButtons
    }
    
    // MARK: - Getters
    
    private func getToDoItemsByDay() -> [ToDo] {
        return toDoProcessHelper.retrieveToDoItemsByDay(toDoDate: getSelectedDate(), toDoItems: getToDoItems())
    }
    
    func getToDoItems() -> [ToDo] {
        return self.toDos
    }
    
    func getToDoItemByIndex(toDoIndex: Int) -> ToDo {
        return self.toDos[toDoIndex]
    }
    
    func getSelectedToDoIndex() -> Int {
        return self.selectedToDoIndex
    }
    
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
    
    // MARK: - Private Methods
    
    private func loadToDos() -> [ToDo]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: ToDo.ArchiveURL.path) as? [ToDo]
    }
    
    // TODO: Put this function in its own helper
    private func reloadTableViewData() {
        DispatchQueue.main.async {
            self.toDoListTableView.reloadData()
        }
    }
    
    private func addToDoItem(toDoItem: ToDo) {
        self.toDos.append(toDoItem)
    }
    
    private func removeToDoItem(toDoIndex: Int) {
        self.toDos.remove(at: toDoIndex)
    }
    
    private func addSelectedIndexPath(indexPath: IndexPath) {
        selectedIndexPaths.append(indexPath)
    }
    
    private func removeSelectedIndexPath(indexPathInt: Int) {
        selectedIndexPaths.remove(at: indexPathInt)
    }
    
    private func removeAllSelectedIndexPaths() {
        selectedIndexPaths.removeAll()
    }
    
    // Retrieves the index of the ToDo from the base ToDo List instead of by day
    private func retrieveRealIndexOfToDo(toDoItem: ToDo) -> Int {
        let toDoItems: [ToDo] = getToDoItems()
        let retrievedIndex: Int = toDoItems.firstIndex(of: toDoItem)!
        return retrievedIndex
    }
    
    // Replaces a ToDo item based on its index from an array
    private func replaceToDoItemInBaseList(editedToDoItem: ToDo, editedToDoItemIndex: Int) {
        //self.toDos[editedToDoItemIndex] = editedToDoItem
        removeToDoItem(toDoIndex: editedToDoItemIndex)
        addToDoItem(toDoItem: editedToDoItem)
    }
    
    // Function for expanding specific rows
    private func expandRow(rowIndex: Int) {
        reloadTableViewData()
    }
    
    // Function for collapsing specific rows
    private func collapseRow(rowIndex: Int) {
        reloadTableViewData()
    }
    
    // Tracks the expand row buttons that needs to be reset
    private func trackExpandButtonsToBeReset() {
        setRemainingExpandButtonsToReset(remainingButtons: getRemainingButtonsToReset() - 1)
        // If all to-be loaded expand buttons state are now false
        if getRemainingButtonsToReset() <= 0 {
            setCalendarDayChanged(didChange: false)
            setRemainingExpandButtonsToReset(remainingButtons: -1)
        }
    }
    
    @objc func onCheckBoxButtonTap(sender: CheckBoxButton) {
        var toDoItemsByDay: [ToDo] = getToDoItemsByDay()
        let toDoItemToUpdate: ToDo = toDoItemsByDay[sender.getToDoRowIndex()]
        let toDoItemRealIndex: Int = retrieveRealIndexOfToDo(toDoItem: toDoItemToUpdate)
        toDoItemToUpdate.finished = !toDoItemToUpdate.finished
        replaceToDoItemInBaseList(editedToDoItem: toDoItemToUpdate, editedToDoItemIndex: toDoItemRealIndex)
    }
    
    @objc func onExpandRowButtonTap(sender: ExpandButton) {
        let buttonIndexPath = IndexPath(row: sender.getExpandedRowIndex(), section: 0)
        
        // If there is no expanded row yet
        if !getSelectedIndexPaths().contains(buttonIndexPath) {
            addSelectedIndexPath(indexPath: buttonIndexPath)
            reloadTableViewData()
        } else {
            let indPath: Int = selectedIndexPaths.firstIndex(of: buttonIndexPath)!
            removeSelectedIndexPath(indexPathInt: indPath)
            reloadTableViewData()
        }
    }
}

extension ScheduleViewController: JTAppleCalendarViewDataSource {
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
        configureCell(cell: cell, cellState: cellState)
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "dd MM yy"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        calendar.scrollingMode = .stopAtEachSection
        
        let startDate = formatter.date(from: "01 01 18")!
        let endDate = formatter.date(from: "31 12 20")!
        
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
        
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
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
        return MonthSize(defaultSize: 40)
    }
}

// To keep track of expandable rows
struct ExpandedRows {
    var expandedRowIndex: Int = Int()
    var isExpandedRowSelected: Bool = Bool()
    
    init(expandedRowIndex: Int, isExpandedRowSelected: Bool) {
        self.expandedRowIndex = expandedRowIndex
        self.isExpandedRowSelected = isExpandedRowSelected
    }
}


