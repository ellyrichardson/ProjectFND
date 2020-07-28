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
    
    // MARK: Properties
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var toDoListTableView: UITableView!
    @IBOutlet weak var tasksLabelView: UIView!
    
    // Helpers
    
    var toDoProcessHelper: ToDoProcessUtils = ToDoProcessUtils()
    
    // Properties

    private var toDos = [String: ToDo]()
    private var selectedDate: Date = Date()
    private var selectedToDoIndex: Int = -1
    private var selectedIndexPath: IndexPath?
    private var selectedIndexPaths: [IndexPath] = [IndexPath]()
    private var coreToDoData: [NSManagedObject] = []
    private var checkButtonTapped: Int =  -1
    private var currentCellIndexPath: IndexPath?
    private var shouldReloadTableView: Bool = true
    private var toDosController: ToDosController = ToDosController()
    
    // Expand row buttons tracker assets
    
    private var calendarDayChanged: Bool = false
    private var remainingExpandButtonsToReset: Int = -1
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.toDosController.setInitialToDos()
        //self.toDosController.setInitialDummyToDos()
        var observerVCList: [Observer] = [Observer]()
        let barViewController = self.tabBarController
        let nav1 = barViewController!.viewControllers?[1] as! UINavigationController
        let statusViewController = nav1.topViewController as! ParentStatusViewController
        statusViewController.setToDosController(toDosController: toDosController)
        observerVCList.append(statusViewController)
        self.toDosController.setObservers(observers: observerVCList)
        
        // TODO: REFACTOR MESS!
        
        
        let nav = self.navigationController?.navigationBar
        
        // Sets the navigation bar to color black with tintColor of yellow.
        nav?.barStyle = UIBarStyle.black
        nav?.tintColor = UIColor(red:1.00, green:0.89, blue:0.00, alpha:1.0)
        
        // Do any additional setup after loading the view, typically from a nib.
        self.toDoListTableView.delegate = self
        self.toDoListTableView.dataSource = self
        self.toDoListTableView.backgroundColor = UIColor.clear
        
        configureCalendarView()
        GeneralViewUtils.addTopBorderWithColor(self.toDoListTableView, color: UIColor.lightGray, width: 1.00)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.toDoListTableView.reloadData()
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
        }
    }
    
    // MARK: - Table View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Gets the ToDos that fall under the selected day in calendar
        return toDosController.getToDosByDay(dateChosen: getSelectedDate()).count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedIndexPaths.count > 0 {
            if selectedIndexPaths.contains(indexPath) {
                return 120
                
            }
        }
        return 150
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
        let toDoItems = ToDoProcessUtils.retrieveToDoItemsByDay(toDoDate: getSelectedDate(), toDoItems: getToDosController().getToDos())
        let sortedToDoItems =  ToDoProcessUtils.sortToDoItemsByDate(toDoItems: toDoItems)
        cell.taskNameLabel.text = sortedToDoItems[indexPath.row].value.getTaskName()
        cell.startDateLabel.text = workDateFormatter.string(from: sortedToDoItems[indexPath.row].value.getStartTime())
        cell.estTimeLabel.text = "Irrelevant"
        cell.dueDateLabel.text = dueDateFormatter.string(from: sortedToDoItems[indexPath.row].value.getEndTime())
        cell.taskTypeLabel.text = sortedToDoItems[indexPath.row].value.getTaskTag()
        // Assigns an index to the CheckBox button of a row
        cell.checkBoxButton.setToDoRowIndex(toDoRowIndex: indexPath.row)
        // Sets the status of the CheckBox being pressed
        cell.checkBoxButton.tag = indexPath.row
        cell.checkBoxButton.setPressedStatus(isPressed: sortedToDoItems[indexPath.row].value.isFinished())
        cell.checkBoxButton.addTarget(self, action: #selector(onCheckBoxButtonTap(sender:)), for: .touchUpInside)
        
        // Assigns an index to the CheckBox button of a row
        //cell.importantButton.setImportantRowIndex(toDoRowIndex: indexPath.row)
        // Sets the status of the CheckBox being pressed
        cell.importantButton.tag = indexPath.row
        cell.importantButton.setPressedStatus(isPressed: sortedToDoItems[indexPath.row].value.isImportant())
        cell.importantButton.addTarget(self, action: #selector(onImportantButtonTap(sender:)), for: .touchUpInside)
        
        cell.notifyButton.tag = indexPath.row
        cell.notifyButton.setPressedStatus(isPressed: sortedToDoItems[indexPath.row].value.isNotifying())
        cell.notifyButton.addTarget(self, action: #selector(onNotificationButtonTap(sender:)), for: .touchUpInside)
        
        cell.finishedButton.tag = indexPath.row
        cell.finishedButton.isOverdue(overdue: ToDoProcessUtils.isToDoOverdue(toDoRowIndex: indexPath.row, toDoItems: sortedToDoItems))
        cell.finishedButton.setPressedStatus(isPressed: sortedToDoItems[indexPath.row].value.isFinished())
        cell.finishedButton.addTarget(self, action: #selector(onFinishedButtonTap(sender:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //print("Value of index "  +  String(checkButtonTapped))
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
        var sortedToDoItems =  ToDoProcessUtils.sortToDoItemsByDate(toDoItems: toDosController.getToDosByDay(dateChosen: getSelectedDate()))
        cell.contentView.layer.backgroundColor = ToDoTableViewUtils.colorForToDoRow(toDoRowIndex: indexPath.row, toDoItems: sortedToDoItems).cgColor
        cell.layer.backgroundColor = ToDoTableViewUtils.colorForToDoRow(toDoRowIndex: indexPath.row, toDoItems: sortedToDoItems).cgColor
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
            let toDoToBeDeleted = ToDoProcessUtils.sortToDoItemsByDate(toDoItems: toDosController.getToDosByDay(dateChosen: getSelectedDate()))[indexPath.row]
            print("tofo to be deleted")
            print(toDoToBeDeleted.value.getStartTime())
            //let toDoRealIndex = ToDoProcessUtils.retrieveRealIndexOfToDo(toDoItem: toDoToBeDeleted[indexPath.row], toDoItemCollection: self.toDos)
            toDosController.updateToDos(modificationType: ListModificationType.REMOVE, toDo: toDoToBeDeleted.value)
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
            // If ToDo is intervalized
            if sourceViewController.isToDoIntervalsExist() {
                let toDoIntervals = sourceViewController.getToDoIntervals()
                for toDo in toDoIntervals {
                    toDosController.updateToDos(modificationType: ListModificationType.ADD, toDo: toDo.value)
                }
            }
            // If toDo is a single ToDo
            else {
                let toDo = sourceViewController.toDo
                if toDoListTableView.indexPathForSelectedRow != nil {
                    toDosController.updateToDos(modificationType: ListModificationType.UPDATE, toDo: toDo!)
                    GeneralViewUtils.reloadTableViewData(tableView: self.toDoListTableView)
                } else {
                    toDosController.updateToDos(modificationType: ListModificationType.ADD, toDo: toDo!)
                    print("ToDo Finished?")
                    print(toDo!.finished)
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
            guard let navigationController = segue.destination as? UINavigationController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            let itemInfoTableViewController = navigationController.viewControllers.first as! ItemInfoTableViewController
            print(toDosController.getToDos())
            itemInfoTableViewController.setToDos(toDos: toDosController.getToDos())
            os_log("Adding a new ToDo item.", log: OSLog.default, type: .debug)
        case "ShowToDoItemDetails":
            var toDosByDay = ToDoProcessUtils.sortToDoItemsByDate(toDoItems: toDosController.getToDosByDay(dateChosen: getSelectedDate()))
            guard let navigationController = segue.destination as? UINavigationController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            let itemInfoTableViewController = navigationController.viewControllers.first as! ItemInfoTableViewController
            
            guard let selectedToDoItemCell = sender as? ScheduleTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = toDoListTableView.indexPath(for: selectedToDoItemCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            let selectedToDoItem = toDosByDay[indexPath.row].value
            //print(toDosController.getToDos())
            //itemInfoTableViewController.setToDos(toDos: toDosController.getToDos())
            itemInfoTableViewController.toDo = selectedToDoItem
            // Sets the chosen work and due date in the itemInfoTableViewController to avoid its reset
            itemInfoTableViewController.setChosenWorkDate(chosenWorkDate: selectedToDoItem.getStartTime())
            itemInfoTableViewController.setChosenDueDate(chosenDueDate: selectedToDoItem.getEndTime())
            // Sets the finish status of the todo in the itemInfoTableViewController to avoid its reset
            itemInfoTableViewController.setIsFinished(isFinished: selectedToDoItem.isFinished())
            itemInfoTableViewController.setSelectedTaskType(selectedTaskTypePickerData: selectedToDoItem.getTaskTag())
            itemInfoTableViewController.setToDos(toDos: ToDoProcessUtils.retrieveToDoItemsByDay(toDoDate: getSelectedDate(), toDoItems: toDosController.getToDos()))
            // Retrieves the index of the selected toDo
            /*
            setSelectedToDoIndex(toDoItemIndex: retrieveRealIndexOfToDo(toDoItem: selectedToDoItem))
             */
            os_log("Showing details for the selected ToDo item.", log: OSLog.default, type: .debug)
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }

    // TODO: Move utility setters and getters to the controller
    // MARK: - Setters
    
    func setToDoItems(toDoItems: [String: ToDo]) {
        self.toDos = toDoItems
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
    
    func setToDosController(toDosController: ToDosController) {
        self.toDosController = toDosController
    }
    
    func getToDosController() -> ToDosController {
        return self.toDosController
    }
    
    func getObserverId() -> Int {
        return self.observerId
    }
    
    // MARK: - Getters
    
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
    
    /*
    // Retrieves the index of the ToDo from the base ToDo List instead of by day
    private func retrieveRealIndexOfToDo(toDoItem: ToDo) -> Int {
        let toDoItems: [ToDo] = getToDoItems()
        let retrievedIndex: Int = toDoItems.firstIndex(of: toDoItem)!
        return retrievedIndex
    }
 */
    
    // TODO: Refactor code to use proper state tracking, like ENUMS!
    @objc func onCheckBoxButtonTap(sender: CheckBoxButton) {
        // The toDosByDay variable should be sorted already
        var toDosByDay = ToDoProcessUtils.sortToDoItemsByDate(toDoItems: toDosController.getToDosByDay(dateChosen: getSelectedDate()))
        //let toDoItemToUpdate: (key: String, value: ToDo) = toDosByDay[sender.getToDoRowIndex()]
        let tempToDoItem: ToDo = toDosByDay[sender.tag].value
        let newToDoItem = tempToDoItem
        
        toDosController.updateToDos(modificationType: ListModificationType.FINISHNESS, toDo: newToDoItem)
        //ToDoProcessUtils.updateToDo(toDoToUpdate: toDoItemToUpdate, newToDo: newToDoItem, updateType: 1)
        //self.checkButtonTapped = sender.tag
        let indexPath = IndexPath(item: sender.tag, section: 0)
        self.toDoListTableView.reloadRows(at: [indexPath], with: .top)
        //self.calendarView.cell
        print("value of currentCellIndexPath")
        print(self.currentCellIndexPath)
        self.shouldReloadTableView = false
        self.calendarView.reloadItems(at: [self.currentCellIndexPath!])
        //self.calendarView.reloadData()
        //self.calendarView.reloadDates([actDate!])
        //GeneralViewUtils.reloadCollectionViewData(collectionView: self.calendarView)
    }
    
    @objc func onFinishedButtonTap(sender: FinishedButton) {
        // The toDosByDay variable should be sorted already
        var toDosByDay = ToDoProcessUtils.sortToDoItemsByDate(toDoItems: toDosController.getToDosByDay(dateChosen: getSelectedDate()))
        let tempToDoItem: ToDo = toDosByDay[sender.tag].value
        let newToDoItem = tempToDoItem
        
        toDosController.updateToDos(modificationType: ListModificationType.FINISHNESS, toDo: newToDoItem)
        let indexPath = IndexPath(item: sender.tag, section: 0)
        self.toDoListTableView.reloadRows(at: [indexPath], with: .top)
        print("value of currentCellIndexPath")
        print(self.currentCellIndexPath)
        self.shouldReloadTableView = false
        self.calendarView.reloadItems(at: [self.currentCellIndexPath!])
    }
    
    @objc func onImportantButtonTap(sender: ImportantButton) {
        // The toDosByDay variable should be sorted already
        var toDosByDay = ToDoProcessUtils.sortToDoItemsByDate(toDoItems: toDosController.getToDosByDay(dateChosen: getSelectedDate()))
        let tempToDoItem: ToDo = toDosByDay[sender.tag].value
        let newToDoItem = tempToDoItem
        
        toDosController.updateToDos(modificationType: ListModificationType.IMPORTANT, toDo: newToDoItem)
    }
    
    @objc func onNotificationButtonTap(sender: NotificationButton) {
        // The toDosByDay variable should be sorted already
        var toDosByDay = ToDoProcessUtils.sortToDoItemsByDate(toDoItems: toDosController.getToDosByDay(dateChosen: getSelectedDate()))
        let tempToDoItem: ToDo = toDosByDay[sender.tag].value
        let newToDoItem = tempToDoItem
        
        toDosController.updateToDos(modificationType: ListModificationType.NOTIFICATION, toDo: newToDoItem)
    }
    
    @objc func onExpandRowButtonTap(sender: ExpandButton) {
        let buttonIndexPath = IndexPath(row: sender.tag, section: 0)
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
        let toDosForTheDay = toDosController.getToDosByDay(dateChosen: date)
        
        // Checks if these kinds of ToDos exist in the date of the current cell.
        let onProgressToDo = toDosForTheDay.first(where: {Date() < $0.value.getEndTime() && !$0.value.isFinished()})
        let finishedToDo = toDosForTheDay.first(where: {$0.value.isFinished() == true})
        let overdueToDo = toDosForTheDay.first(where: {Date() > $0.value.getEndTime() && !$0.value.isFinished()})
        
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


