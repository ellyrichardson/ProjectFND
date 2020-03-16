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

class ScheduleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Properties
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var toDoListTableView: UITableView!
    @IBOutlet weak var tasksLabelView: UIView!
    
    // Helpers
    
    var toDoProcessHelper: ToDoProcessUtils = ToDoProcessUtils()
    
    // Properties

    private var toDos = [ToDo]()
    private var selectedDate: Date = Date()
    private var selectedToDoIndex: Int = -1
    private var selectedIndexPath: IndexPath?
    private var selectedIndexPaths: [IndexPath] = [IndexPath]()
    private var coreToDoData: [NSManagedObject] = []
    private var checkButtonTapped: Int =  -1
    private var currentCellIndexPath: IndexPath?
    private var shouldReloadTableView: Bool = true
    
    // Expand row buttons tracker assets
    
    private var calendarDayChanged: Bool = false
    private var remainingExpandButtonsToReset: Int = -1
    
    let formatter = DateFormatter()
    let numberOfRows = 6
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nav = self.navigationController?.navigationBar
        
        // Sets the navigation bar to color black with tintColor of yellow.
        nav?.barStyle = UIBarStyle.black
        nav?.tintColor = UIColor(red:1.00, green:0.89, blue:0.00, alpha:1.0)
        
        // Do any additional setup after loading the view, typically from a nib.
        self.toDoListTableView.delegate = self
        self.toDoListTableView.dataSource = self
        self.toDoListTableView.backgroundColor = UIColor.clear
        
        if let savedToDos = ToDoProcessUtils.loadToDos() {
            setToDoItems(toDoItems: savedToDos)
        }
        
        configureCalendarView()
        GeneralViewUtils.addTopBorderWithColor(self.toDoListTableView, color: UIColor.lightGray, width: 1.00)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //GeneralViewUtils.reloadCollectionViewData(collectionView: self.calendarView)
        //GeneralViewUtils.reloadTableViewData(tableView: self.toDoListTableView)
    }
    
    func configureCalendarView(){
        
        //calendarView.collectionView(calendarView, numberOfItemsInSection: 31)
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        calendarView.register(UINib(nibName: "CalendarHeader", bundle: Bundle.main),
                              forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                              withReuseIdentifier: "CalendarHeader")
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
        //self.currentCellIndexPath = self.calendarView.indexPath(for: currentCell)
        currentCell.dateLabel.text = cellState.text
        //self.currentCellIndexPath = self.calendarView.indexPath(for: currentCell)
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
            DispatchQueue.main.async {
                self.currentCellIndexPath = self.calendarView.indexPath(for: currentCell)
            }
        } else {
            currentCell.selectedView.isHidden = true
        }
    }
    
    // When a particular day is selected in the calendar
    func configureSelectedDay(cell: JTAppleCell?, cellState: CellState) {
        if cellState.isSelected{
            //self.currentCellIndexPath = self.calendarView.indexPath(for: cell!)
            setSelectedDate(selectedDate: cellState.date)
            ToDoProcessUtils.removeAllSelectedIndexPaths(selectedIndexPaths: &selectedIndexPaths)
            // To track if the selected day in the calendar was changed
            setCalendarDayChanged(didChange: true)
            // If tableView should be reloaded based on todo update, or simply loading the calendar
            if self.shouldReloadTableView {
                GeneralViewUtils.reloadTableViewData(tableView: self.toDoListTableView)
            }
            // Set shouldReloadTableview by default
            self.shouldReloadTableView = true
            // To track how many expand row buttons will be reset if the selected day was changed
            setRemainingExpandButtonsToReset(remainingButtons: getToDoItemsByDay(dateChosen: getSelectedDate()).count)
        }
    }
    
    // MARK: - Table View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Gets the ToDos that fall under the selected day in calendar
        return getToDoItemsByDay(dateChosen: getSelectedDate()).count
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
        
        // Retrieves sorted ToDo Items by date that fall under the chosen day in the calendar
        var toDoItems = getToDoItemsByDay(dateChosen: getSelectedDate())
        cell.taskNameLabel.text = toDoItems[indexPath.row].taskName
        cell.startDateLabel.text = workDateFormatter.string(from: toDoItems[indexPath.row].workDate)
        cell.estTimeLabel.text = toDoItems[indexPath.row].estTime
        cell.dueDateLabel.text = dueDateFormatter.string(from: toDoItems[indexPath.row].dueDate)
        // Assigns an index to the CheckBox button of a row
        cell.checkBoxButton.setToDoRowIndex(toDoRowIndex: indexPath.row)
        // Sets the status of the CheckBox being pressed
        cell.checkBoxButton.tag = indexPath.row
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("Value of checkButtonTapped "  +  String(checkButtonTapped))
        print("Value of indexPath.row "  +  String(indexPath.row))
        print("Value of indexPath.section "  +  String(indexPath.section))

        if checkButtonTapped == indexPath.row {
            ToDoTableViewUtils.makeCellMoveUpWithFade(cell: cell, indexPath: indexPath)
            checkButtonTapped = -1
        }
        else {
            ToDoTableViewUtils.makeCellSlide(cell: cell, indexPath: indexPath, tableView: toDoListTableView)
        }
        //ToDoTableViewUtils.makeCellMoveUpWithFade(cell: cell, indexPath: indexPath)
        
        cell.contentView.layer.backgroundColor = ToDoTableViewUtils.colorForToDoRow(toDoRowIndex: indexPath.row, toDoItems: getToDoItemsByDay(dateChosen: getSelectedDate())).cgColor
        cell.layer.backgroundColor = ToDoTableViewUtils.colorForToDoRow(toDoRowIndex: indexPath.row, toDoItems: getToDoItemsByDay(dateChosen: getSelectedDate())).cgColor
        // This will turn on `masksToBounds` just before showing the cell
        cell.contentView.layer.masksToBounds = true
        
        /*
         NOTE: If this is not set `shadowPath` you'll notice laggy scrolling. Mysterious code too.  It just make the shadow stuff work
         */
        let radius = cell.contentView.layer.cornerRadius
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: radius).cgPath
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            self.toDoListTableView.dataSource?.tableView!(self.toDoListTableView, commit: .delete, forRowAt: indexPath)
            return
        }
        // Makes the backgroundColor of deleteButton black and its title "Remove".
        deleteButton.backgroundColor = UIColor.black
        deleteButton.title = "Remove"
        return [deleteButton]
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let toDoToBeDeleted: [ToDo] = getToDoItemsByDay(dateChosen: getSelectedDate())
            let toDoRealIndex = ToDoProcessUtils.retrieveRealIndexOfToDo(toDoItem: toDoToBeDeleted[indexPath.row], toDoItemCollection: self.toDos)
            ToDoProcessUtils.deleteToDo(toDoToDelete: getToDoItems()[toDoRealIndex])
            ToDoProcessUtils.removeToDoItem(toDoItemIndexToRemove: toDoRealIndex, toDoItemCollection: &self.toDos)
            tableView.deleteRows(at: [indexPath], with: .fade)
            DispatchQueue.main.async {
                // NOTE: This will make the tableView not reload, only the the calendarView item
                self.shouldReloadTableView = false
                self.calendarView.reloadItems(at: [self.currentCellIndexPath!])
            }

            //GeneralViewUtils.reloadCollectionViewData(collectionView: self.calendarView)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    // MARK: - Actions
    
    @IBAction func unwindToScheduleView(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ItemInfoTableViewController {
            if sourceViewController.isToDoIntervalsExist() {
                let toDoIntervals = sourceViewController.getToDoIntervals()
                for toDo in toDoIntervals {
                    ToDoProcessUtils.addToDoItem(toDoItemToAdd: toDo, toDoItemCollection: &self.toDos)
                    print("ToDo Finished?")
                    print(toDo.finished)
                    ToDoProcessUtils.saveToDos(toDoItem: toDo)
                }
            }
            else {
                let toDo = sourceViewController.toDo
                if toDoListTableView.indexPathForSelectedRow != nil {
                    // Replaces the ToDo item in the original array of ToDos.
                    ToDoProcessUtils.updateToDo(toDoToUpdate: getToDoItemByIndex(toDoIndex: getSelectedToDoIndex()), newToDo: toDo!, updateType: 0)
                    replaceToDoItemInBaseList(editedToDoItem: toDo!, editedToDoItemIndex: getSelectedToDoIndex())
                    /*
                    ToDoProcessUtils.updateToDo(toDoToUpdate: getToDoItemByIndex(toDoIndex: getSelectedToDoIndex()), newToDo: toDo!, updateType: 0)
                    ToDoProcessUtils.replaceToDoItemInBaseList(editedToDoItem: toDo!, editedToDoItemIndex: getSelectedToDoIndex(), toDoItemCollection: &self.toDos)
 */
                    GeneralViewUtils.reloadTableViewData(tableView: self.toDoListTableView)
                } else {
                    ToDoProcessUtils.addToDoItem(toDoItemToAdd: toDo!, toDoItemCollection: &self.toDos)
                    print("ToDo Finished?")
                    print(toDo!.finished)
                    ToDoProcessUtils.saveToDos(toDoItem: toDo!)
                    GeneralViewUtils.reloadCollectionViewData(collectionView: self.calendarView)
                }
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
            var toDoItemsByDay: [ToDo] = getToDoItemsByDay(dateChosen: getSelectedDate())
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
    
    private func getToDoItemsByDay(dateChosen: Date) -> [ToDo] {
        return ToDoProcessUtils.retrieveToDoItemsByDay(toDoDate: dateChosen, toDoItems: getToDoItems())
    }
    
    func getToDoItems() -> [ToDo] {
        return self.toDos
    }
    
    // Gets ToDo item by its index in the base list.
    func getToDoItemByIndex(toDoIndex: Int) -> ToDo {
        return self.toDos[toDoIndex]
    }
    
    // Gets the index of the selected ToDo
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
    
    //  NOTE:  KEEP  THIS FUNCTION HERE
    // Tracks the expand row buttons that needs to be reset
    private func trackExpandButtonsToBeReset() {
        setRemainingExpandButtonsToReset(remainingButtons: getRemainingButtonsToReset() - 1)
        // If all to-be loaded expand buttons state are now false
        if getRemainingButtonsToReset() <= 0 {
            setCalendarDayChanged(didChange: false)
            setRemainingExpandButtonsToReset(remainingButtons: -1)
        }
    }
    
    /*
     NOTE: Refactor this in the future if it can be better
     */
    // Replaces a ToDo item based on its index from an array
    private func replaceToDoItemInBaseList(editedToDoItem: ToDo, editedToDoItemIndex: Int) {
        //self.toDos[editedToDoItemIndex] = editedToDoItem
        removeToDoItem(toDoItemIndexToRemove: editedToDoItemIndex)
        addToDoItem(toDoItemToAdd: editedToDoItem)
    }
    
    private func addToDoItem(toDoItemToAdd: ToDo) {
        self.toDos.append(toDoItemToAdd)
    }
    
    /*
     NOTE: Refactor this in the future if it can be better
     */
    private func removeToDoItem(toDoItemIndexToRemove: Int) {
        self.toDos.remove(at: toDoItemIndexToRemove)
    }
    
    // Retrieves the index of the ToDo from the base ToDo List instead of by day
    private func retrieveRealIndexOfToDo(toDoItem: ToDo) -> Int {
        let toDoItems: [ToDo] = getToDoItems()
        let retrievedIndex: Int = toDoItems.firstIndex(of: toDoItem)!
        return retrievedIndex
    }
    
    @objc func onCheckBoxButtonTap(sender: CheckBoxButton) {
        var toDoItemsByDay: [ToDo] = getToDoItemsByDay(dateChosen: getSelectedDate())
        let toDoItemToUpdate: ToDo = toDoItemsByDay[sender.getToDoRowIndex()]
        let newToDoItem: ToDo = toDoItemsByDay[sender.getToDoRowIndex()]
        //var dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "mm/dd/yyyy"
        //var currDate = dateFormatter.string(from: newToDoItem.workDate)
        //var actDate = dateFormatter.date(from: currDate)
        newToDoItem.finished = !newToDoItem.finished
        ToDoProcessUtils.updateToDo(toDoToUpdate: toDoItemToUpdate, newToDo: newToDoItem, updateType: 1)
        self.checkButtonTapped = sender.tag
        let indexPath = IndexPath(item: self.checkButtonTapped, section: 0)
        self.toDoListTableView.reloadRows(at: [indexPath], with: .top)
        //self.calendarView.cell
        print("value of currentCellIndexPath")
        print(self.currentCellIndexPath)
        //self.currentCellIndexPath![0] = self.currentCellIndexPath![1]
        //if self.currentCellIndexPath
        self.shouldReloadTableView = false
        self.calendarView.reloadItems(at: [self.currentCellIndexPath!])
        //self.calendarView.reloadData()
        //self.calendarView.reloadDates([actDate!])
        //GeneralViewUtils.reloadCollectionViewData(collectionView: self.calendarView)
    }
    
    @objc func onExpandRowButtonTap(sender: ExpandButton) {
        let buttonIndexPath = IndexPath(row: sender.getExpandedRowIndex(), section: 0)
        // If there is no expanded row yet
        if !getSelectedIndexPaths().contains(buttonIndexPath) {
            ToDoProcessUtils.addSelectedIndexPath(indexPath: buttonIndexPath, selectedIndexPaths: &selectedIndexPaths)
            self.toDoListTableView.beginUpdates()
            self.toDoListTableView.endUpdates()
        } else {
            let indPath: Int = selectedIndexPaths.firstIndex(of: buttonIndexPath)!
            ToDoProcessUtils.removeSelectedIndexPath(indexPathAsInt: indPath, selectedIndexPaths: &selectedIndexPaths)
            self.toDoListTableView.beginUpdates()
            self.toDoListTableView.endUpdates()
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
        
        print("Being CALLED")
        print(date)
        var onProgressToDoExist: Bool = false
        var finishedToDoExist: Bool = false
        var overdueToDoExist: Bool = false
        
        var cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
        
        
        // Hides the indicators initially.
        cell.bottomIndicator.isHidden = true
        cell.topIndicator.isHidden = true
        cell.topLeftIndicator.isHidden = true
        cell.topRightIndicator.isHidden = true
        
        // Gets the ToDos based on the date of the current cell.
        let toDosForTheDay = getToDoItemsByDay(dateChosen: date)
        
        // Checks if these kinds of ToDos exist in the date of the current cell.
        let onProgressToDo = toDosForTheDay.first(where: {Date() < $0.dueDate && !$0.finished})
        let finishedToDo = toDosForTheDay.first(where: {$0.finished == true})
        let overdueToDo = toDosForTheDay.first(where: {Date() > $0.dueDate && !$0.finished})
        
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
            cell = CalendarViewUtils.showCellIndicators(cell: cell, onProgress: onProgressToDoExist, finished: finishedToDoExist, overdue: overdueToDoExist)
        }
        
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
        (header as! CalendarHeader).title.text = formatter.string(from: date).uppercased()
        return header
    }
    
    func calendarSizeForMonths(_ calendar: JTAppleCalendarView?) -> MonthSize? {
        return MonthSize(defaultSize: 75)
    }
}

