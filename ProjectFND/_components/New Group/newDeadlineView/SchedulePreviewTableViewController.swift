//
//  SchedulePreviewTableViewController.swift
//  ProjectFND
//
//  Created by Elly Richardson on 11/24/19.
//  Copyright © 2019 EllyRichardson. All rights reserved.
//

import UIKit

class SchedulePreviewTableViewController: UITableViewController {
    
    private var toDo: ToDo?
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    func setBaseToDo(baseToDo: ToDo) {
        self.toDo = baseToDo
    }
    
}
