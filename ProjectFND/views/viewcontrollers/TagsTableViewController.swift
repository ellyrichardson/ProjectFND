//
//  TagsTableViewController.swift
//  ProjectFND
//
//  Created by Elly Richardson on 5/30/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import UIKit

class TagsTableViewController: UITableViewController {
    
    private let EMPTY_TAG = ""
    
    private let OUT_OF_BOUNDS = 4
    
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
        if self.observableTagsController.getTag().tagValue == tagsList[indexPath.row] {
            shouldDeselectRows()
        }
        /*
        if self.observableTagsController.getTag().assigned || isTagPreAssignedTracker {
            deselectRow()
            if isTagPreAssignedTracker {
                self.isTagPreAssignedTracker = false
            }
        }*/
        else {
            self.observableTagsController.updateTag(updatedDate: ToDoTags(tagValue: tagsList[indexPath.row], assigned: true))
        }
    }
    
    private func shouldDeselectRows() {
        if self.observableTagsController.getTag().assigned || isTagPreAssignedTracker {
            deselectRow()
            if isTagPreAssignedTracker {
                self.isTagPreAssignedTracker = false
            }
        }
    }
    
    func setObservableTagsController(observableTagsController: ObservableTagsController) {
        self.observableTagsController = observableTagsController
    }
    
    private func setSelectedRow() {
        let selectedTag = self.observableTagsController.getTag().tagValue
        var indexPath = IndexPath()
        var correctTagRow = 0
        if self.observableTagsController.getTag().assigned {
            correctTagRow = getCorrectTagRow(tagName: selectedTag!)
            if correctTagRow != OUT_OF_BOUNDS {
                indexPath = IndexPath(row: correctTagRow, section: 0)
                DispatchQueue.main.async {
                    self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                }
            }
        }
        else if isTagPreAssignedTracker {
            correctTagRow = getCorrectTagRow(tagName: self.preAssignedTagTracker)
            if correctTagRow != OUT_OF_BOUNDS {
                indexPath = IndexPath(row: correctTagRow, section: 0)
                DispatchQueue.main.async {
                    self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                }
            }
        }
    }
    
    private func deselectRow() {
        let selectedTag = self.observableTagsController.getTag().tagValue
        var indexPath = IndexPath()
        let correctTagRow = getCorrectTagRow(tagName: selectedTag!)
        
        if correctTagRow != OUT_OF_BOUNDS {
            indexPath = IndexPath(row: correctTagRow, section: 0)
            self.observableTagsController.updateTag(updatedDate: ToDoTags(tagValue: EMPTY_TAG, assigned: false))
            DispatchQueue.main.async {
                self.tableView.deselectRow(at: indexPath, animated: false)
            }
        }
    }

    private func getCorrectTagRow(tagName: String) -> Int {
        switch tagName {
        case "Work":
            return 0
        case "Personal":
            return 1
        case "School":
            return 2
        default:
            return OUT_OF_BOUNDS
        }
    }
    
    /*
    private func configureRows() {
        deselectAllRows()
        setSelectedRow()
    }
    
    private func deselectAllRows() {
        var counter = 0
        while counter < tagsList.count {
            self.tableView.deselectRow(at: IndexPath(row: counter, section: 0), animated: false)
            counter += 1
        }
    }*/
    
    func setAssignedTag(tagName: String) {
        self.preAssignedTagTracker = tagName
        self.observableTagsController.updateTag(updatedDate: ToDoTags(tagValue: tagName, assigned: true))
        self.isTagPreAssignedTracker = true
    }

}
