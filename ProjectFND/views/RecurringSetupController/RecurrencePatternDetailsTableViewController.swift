//
//  RecurrencePatternDetailsTableViewController.swift
//  ProjectFND
//
//  Created by Elly Richardson on 5/22/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import UIKit

class RecurrencePatternDetailsTableViewController: UITableViewController {
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    var viewRecurrenceDetailModel = ViewRecurrenceDetailModel()
    private var detailsToReturn = RecurrenceDetailType.DAILY
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsMultipleSelection = true
        tableView.dataSource = viewRecurrenceDetailModel
        
        viewRecurrenceDetailModel.setDetailTypeToReturn(detailTypeToReturn: self.detailsToReturn)
        viewRecurrenceDetailModel.setProperDetailItems()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewRecurrenceDetailModel.items[indexPath.row].isSelected = true
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        viewRecurrenceDetailModel.items[indexPath.row].isSelected = false
    }
    
    // MARK: - Utilities
    
    @IBAction func saveSelections(_ sender: Any) {
    }
    
    func setDetailsToReturn(detailsToReturn: RecurrenceDetailType) {
        self.detailsToReturn = detailsToReturn
    }
}

extension ViewRecurrenceDetailModel: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        items[indexPath.row].isSelected = true
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        items[indexPath.row].isSelected = false
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "RecurrenceDetailCell", for: indexPath) as? RecurrenceDetailsTableViewCell {
            cell.item = items[indexPath.row]
            
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
