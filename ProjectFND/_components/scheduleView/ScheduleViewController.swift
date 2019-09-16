//
//  ViewController.swift
//  ProjectFND
//
//  Created by Elly Richardson on 9/3/19.
//  Copyright © 2019 EllyRichardson. All rights reserved.
//
//  Parts of this code was taken from CalendarControlUsingJTAppleCalenader
//  project by anoop4real.
//

import UIKit
import JTAppleCalendar

class ScheduleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var toDoListTableView: UITableView!
    
    // Helpers
    var toDoProcessHelper: ToDoProcessHelper = ToDoProcessHelper()
    
    // Properties
    var toDos = [ToDo]()
    var toDoItemsForDay = [ToDo]()
    var selectedDate: Date = Date()
    
    let formatter = DateFormatter()
    let numberOfRows = 6
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.toDoListTableView.delegate = self
        self.toDoListTableView.dataSource = self
        
        //toDoListTableView.delegate = self
        
        if let savedToDos = loadToDos() {
            setToDoItems(toDoItems: savedToDos)
        }
        
        configureCalendarView()
        //toDoListTableView.dataSource = self as! UITableViewDataSource
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
        print("Cell State")
        print(cellState.text)
        print(cellState.date)
        print(cellState.dateBelongsTo.rawValue)
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
            //setSelectedDate(selectedDate: cellState.date)
            // USELESS reloadTableViewData()?
            //reloadTableViewData()
        } else {
            currentCell.selectedView.isHidden = true
            currentCell.bgView.isHidden = true
        }
    }
    
    func configureSelectedDay(cell: JTAppleCell?, cellState: CellState) {
        if cellState.isSelected{
            setSelectedDate(selectedDate: cellState.date)
            // USELESS reloadTableViewData()?
            reloadTableViewData()
        }
    }
    
    // MARK: - Table View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let toDoItems = getToDoItemsByDay()
        return toDoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dateCellIdentifier = "ScheduleTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: dateCellIdentifier, for: indexPath) as? ScheduleTableViewCell else {
            fatalError("The dequeued cell is not an instance of ScheduleTableViewCell.")
        }
        // Retrieves sorted ToDo Items by date that fall under the chosen day in the calendar
        var toDoItems = getToDoItemsByDay()
        cell.taskNameLabel.text = toDoItems[indexPath.row].taskName
        //cell.startDateLabel.text = toDos[indexPath.row].workDate
        //cell.estTimeLabel.text = toDos[indexPath.row].estTime
        //cell.dueDateLabel.text = toDos[indexPath.row].dueDate
        
        return cell
    }
    
    // MARK: - Actions
    
    @IBAction func unwindToScheduleView(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ItemInfoTableViewController, let toDo = sourceViewController.toDo {
            
            addToDoItem(toDoItem: toDo)
        }
    }
    
    // MARK: - Setters
    
    func setToDoItems(toDoItems: [ToDo]) {
        self.toDos = toDoItems
    }
    
    func setSelectedDate(selectedDate: Date) {
        self.selectedDate = selectedDate
    }
    
    private func getToDoItemsByDay() -> [ToDo] {
        return toDoProcessHelper.retrieveToDoItemsByDay(toDoDate: getSelectedDate(), toDoItems: getToDoItems())
    }
    
    // MARK: - Getters
    
    func getToDoItems() -> [ToDo] {
        return self.toDos
    }
    
    func getSelectedDate() -> Date {
        return self.selectedDate
    }
    
    // MARK: - Private Methods
    
    private func loadToDos() -> [ToDo]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: ToDo.ArchiveURL.path) as? [ToDo]
    }
    
    private func reloadTableViewData() {
        DispatchQueue.main.async {
            self.toDoListTableView.reloadData()
        }
    }
    
    private func addToDoItem(toDoItem: ToDo) {
        self.toDos.append(toDoItem )
    }
    
    // MARK: - Utility Methods
    
    func configureTableView(cell: JTAppleCell?, cellState: CellState) {
        
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
        // Reloads table view data when a date is selected (USELESS reloadTableViewData()?)
        reloadTableViewData()
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


