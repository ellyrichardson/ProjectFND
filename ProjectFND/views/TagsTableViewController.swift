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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tagsList = ["Work", "Personal", "School"]
        
        setSelectedRow()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        // Haha
        self.observableTagsController.updateTag(updatedDate: ToDoTags(tagValue: tagsList[indexPath.row], assigned: true))
    }
    
    
    
    func setObservableTagsController(observableTagsController: ObservableTagsController) {
        self.observableTagsController = observableTagsController
    }
    
    private func setSelectedRow() {
        let selectedTag = self.observableTagsController.getTag().tagValue
        let isTagAssigned = self.observableTagsController.getTag().assigned
        if isTagAssigned {
            let indexPath = IndexPath(row: getCorrectTagRow(tagName: selectedTag!), section: 0)
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
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
