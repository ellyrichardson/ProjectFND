//
//  TagsTableViewController.swift
//  ProjectFND
//
//  Created by Elly Richardson on 5/30/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import UIKit

class TagsTableViewController: UITableViewController {
    
    private var tagsList = [String]()
    
    private var observableTagsController = ObservableTagsController()
    
    // Trackers
    private var isTagPreAssignedTracker = false
    private var preAssignedTagTracker = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tagsList = ["Work", "Personal", "School"]
        
        setSelectedRow()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tagsList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TagsTableViewCell", for: indexPath) as! TagsTableViewCell
        
        cell.tagLabel.text = tagsList[indexPath.row]

        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.observableTagsController.updateTag(updatedDate: ToDoTags(tagValue: tagsList[indexPath.row], assigned: true))
    }
    
    // This is not working right now
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        /*self.observableTagsController.updateTag(updatedDate: ToDoTags(tagValue: tagsList[indexPath.row], assigned: false))*/
    }
    
    func setObservableTagsController(observableTagsController: ObservableTagsController) {
        self.observableTagsController = observableTagsController
    }
    
    private func setSelectedRow() {
        let selectedTag = self.observableTagsController.getTag().tagValue
        let isTagAssigned = self.observableTagsController.getTag().assigned
        var indexPath = IndexPath()
        if isTagAssigned {
            indexPath = IndexPath(row: getCorrectTagRow(tagName: selectedTag!), section: 0)
            DispatchQueue.main.async {
                self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            }
        }
        else if isTagPreAssignedTracker {
            indexPath = IndexPath(row: getCorrectTagRow(tagName: self.preAssignedTagTracker), section: 0)
            DispatchQueue.main.async {
                self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            }
        }
    }

    private func getCorrectTagRow(tagName: String) -> Int {
        if tagName == "Work" {
            return 0
        }
        else if tagName == "Personal" {
            return 1
        }
        else {
            return 2
        }
    }
    
    func setAssignedTag(tagName: String) {
        self.preAssignedTagTracker = tagName
        self.isTagPreAssignedTracker = true
    }

}
