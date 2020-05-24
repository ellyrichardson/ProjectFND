//
//  RepeatingSetupTableViewController.swift
//  ProjectFND
//
//  Created by Elly Richardson on 5/15/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import UIKit
import SwiftEntryKit

class RepeatingSetupTableViewController: UITableViewController {
    
    @IBOutlet weak var dailyLabel: UILabel!
    @IBOutlet weak var weeklyLabel: UIView!
    @IBOutlet weak var monthlyLabel: UILabel!
    @IBOutlet weak var yearlyLabel: UILabel!
    
    private var selectionCells = [StaticTableCell]()
    
    private func setupSelectionCells() {

        selectionCells = [
            StaticTableCell(name: "Daily"),
            StaticTableCell(name: "Weekly"),
            StaticTableCell(name: "Monthly"),
            StaticTableCell(name: "Yearly"),
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //dailyLabel.text = "TEST"

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            setupSEK()
        }
    }
    
    // MARK: - SwiftEntryKit
    
    private func setupSEK() {
        // Create a basic toast that appears at the top
        var attributes = EKAttributes.topToast

        // Set its background to white
        attributes.entryBackground = .color(color: .white)

        // Animate in and out using default translation
        attributes.entranceAnimation = .translation
        attributes.exitAnimation = .translation

        let title = EKProperty.LabelContent(text: "titleText", style: .init(font: UIFont.init(), color: EKColor.init(light: UIColor.white, dark: UIColor.black)))
        let description = EKProperty.LabelContent(text: "descText", style: .init(font: UIFont.init(), color: EKColor.init(light: UIColor.white, dark: UIColor.black)))
        let image = EKProperty.ImageContent(image: UIImage(named: "EmptyFriends")!, size: CGSize(width: 35, height: 35))
        let simpleMessage = EKSimpleMessage(image: image, title: title, description: description)
        let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)

        let contentView = RepeatingSetupTableViewController()
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }

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
