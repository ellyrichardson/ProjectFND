//
//  RecurrencePatternDetailsTableViewController.swift
//  ProjectFND
//
//  Created by Elly Richardson on 5/22/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import UIKit

class SimpleItemsTableViewController: UITableViewController {
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    var viewRecurrenceDetailModel = ViewRecurrenceDetailModel()
    var viewEstimatedEffortModel = ViewEstimatedEffortModel()
    
    // MARK: - Tracking Attributes
    
    private var recurrenceDetailsToReturn = RecurrenceDetailType.DAILY
    private var itemTypeToDisplay = SimpleStaticTVCReturnType.RECURRENCE
    
    // MARK: - View 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareViewDidLoad()
    }
    
    private func prepareViewDidLoad() {
        switch itemTypeToDisplay {
        case .RECURRENCE:
            tableView.allowsMultipleSelection = true
            tableView.dataSource = viewRecurrenceDetailModel
            viewRecurrenceDetailModel.setDetailTypeToReturn(detailTypeToReturn: self.recurrenceDetailsToReturn)
            viewRecurrenceDetailModel.setProperDetailItems()
        default:
            tableView.allowsMultipleSelection = false
            tableView.dataSource = viewEstimatedEffortModel
        }
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        prepareDidSelectRowAt(indexPath: indexPath)
    }
    
    private func prepareDidSelectRowAt(indexPath: IndexPath) {
        switch itemTypeToDisplay {
        case .RECURRENCE:
            viewRecurrenceDetailModel.items[indexPath.row].isSelected = true
        default:
            viewEstimatedEffortModel.items[indexPath.row].isSelected = true
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        prepareDidDeselectRowAt(indexPath: indexPath)
    }
    
    private func prepareDidDeselectRowAt(indexPath: IndexPath) {
        switch itemTypeToDisplay {
        case .RECURRENCE:
            viewRecurrenceDetailModel.items[indexPath.row].isSelected = false
        default:
            viewEstimatedEffortModel.items[indexPath.row].isSelected = false
        }
    }
    
    // MARK: - Utilities
    
    @IBAction func saveSelections(_ sender: Any) {
    }
    
    // MARK: - Setters For Connecting VCs
    
    func setItemTypeToDisplay (itemTypeToDisplay: SimpleStaticTVCReturnType) {
        self.itemTypeToDisplay = itemTypeToDisplay
    }
    
    func setRecurrenceDetailsToReturn(recurrenceDetailsToReturn: RecurrenceDetailType) {
        self.recurrenceDetailsToReturn = recurrenceDetailsToReturn
    }
}

extension ViewRecurrenceDetailModel: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        items[indexPath.row].isSelected = true
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        items[indexPath.row].isSelected = false
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleItemsTVCTableViewCell", for: indexPath) as? SimpleItemsTVCTableViewCell {
            cell.recurrenceItem = items[indexPath.row]
            
            // Select/Deselect the cell
            if items[indexPath.row].isSelected {
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            } else {
                tableView.deselectRow(at: indexPath, animated: false)
            }
            return cell
        }
        return UITableViewCell()
    }
}

extension ViewEstimatedEffortModel: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        items[indexPath.row].isSelected = true
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        items[indexPath.row].isSelected = false
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleItemsTVCTableViewCell", for: indexPath) as? SimpleItemsTVCTableViewCell {
            cell.estimatedEffortItem = items[indexPath.row]
            
            // Select/Deselect the cell
            if items[indexPath.row].isSelected {
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            } else {
                tableView.deselectRow(at: indexPath, animated: false)
            }
            return cell
        }
        return UITableViewCell()
    }
}
