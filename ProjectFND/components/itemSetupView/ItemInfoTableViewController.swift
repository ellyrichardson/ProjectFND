//
//  ItemInfoTableViewController.swift
//  ProjectFND
//
//  Created by Elly Richardson on 9/4/19.
//  Copyright © 2019 EllyRichardson. All rights reserved.
//

import UIKit

class ItemInfoTableViewController: UITableViewController, UITextViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var taskNameDescriptionLabel: UILabel!
    @IBOutlet weak var taskNameField: UITextField!
    @IBOutlet weak var taskDescriptionView: UITextView!
    @IBOutlet weak var estTimeLabel: UILabel!
    @IBOutlet weak var estTimeField: UITextField!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    
    private var taskItemCells = [StaticTableCell]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Auto resizing the height of the cell
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableView.automaticDimension
        
        taskItemCells = [
            StaticTableCell(name: "Task Details"),
            StaticTableCell(name: "Work Date"),
            StaticTableCell(name: "Estimated Time"),
            StaticTableCell(name: "Due Date"),
        ]

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if taskItemCells[0].collapsed {
                taskItemCells[0].collapsed = false
            } else {
                taskItemCells[0].collapsed = true
            }
            tableView.beginUpdates()
            tableView.endUpdates()
        }
        if indexPath.row == 1 {
            if taskItemCells[1].collapsed {
                taskItemCells[1].collapsed = false
            } else {
                taskItemCells[1].collapsed = true
            }
            tableView.beginUpdates()
            tableView.endUpdates()
        }
        if indexPath.row == 2 {
            if taskItemCells[2].collapsed {
                taskItemCells[2].collapsed = false
            } else {
                taskItemCells[2].collapsed = true
            }
            tableView.beginUpdates()
            tableView.endUpdates()
        }
        if indexPath.row == 3 {
            if taskItemCells[3].collapsed {
                taskItemCells[3].collapsed = false
            } else {
                taskItemCells[3].collapsed = true
            }
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            if taskItemCells[0].collapsed {
                return 210
            }
        }
        if indexPath.row == 1 {
            if taskItemCells[1].collapsed {
                return 100
            }
        }
        if indexPath.row == 2 {
            if taskItemCells[2].collapsed {
                return 170
            }
        }
        if indexPath.row == 3 {
            if taskItemCells[3].collapsed {
                return 170
            }
        }
        return 50
    }

}
