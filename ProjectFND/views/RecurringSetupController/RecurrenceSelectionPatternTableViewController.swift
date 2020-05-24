//
//  RecurrenceSelectionPatternTableViewController.swift
//  ProjectFND
//
//  Created by Elly Richardson on 5/21/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import UIKit

class RecurrenceSelectionPatternTableViewController: UITableViewController {
    @IBOutlet weak var dailyLabel: UILabel!
    @IBOutlet weak var weeklyLabel: UILabel!
    @IBOutlet weak var monthlyLabel: UILabel!
    @IBOutlet weak var yearlyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let recurrencePatternDetailsTVC = segue.destination as? RecurrencePatternDetailsTableViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
        switch segue.identifier {
        case "SegueToRecurrenceDailyDetails":
        recurrencePatternDetailsTVC.setDetailsToReturn(detailsToReturn: RecurrenceDetailType.DAILY)
        case "SegueToRecurrenceWeeklyDetails":
        recurrencePatternDetailsTVC.setDetailsToReturn(detailsToReturn: RecurrenceDetailType.WEEKLY)
        case "SegueToRecurrenceMonthlyDetails":
        recurrencePatternDetailsTVC.setDetailsToReturn(detailsToReturn: RecurrenceDetailType.MONTHLY)
        default:
        recurrencePatternDetailsTVC.setDetailsToReturn(detailsToReturn: RecurrenceDetailType.YEARLY)
            
        }
    }
    /*
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.recurrenceDetailsToShow = RecurrenceDetailType.DAILY
        case 1:
            self.recurrenceDetailsToShow = RecurrenceDetailType.WEEKLY
        case 2:
            self.recurrenceDetailsToShow = RecurrenceDetailType.MONTHLY
        default:
            self.recurrenceDetailsToShow = RecurrenceDetailType.YEARLY
        }
    }*/
    /*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }*/

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
