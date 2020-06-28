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
    }
    
    // MARK: - Utilities
    
    @IBAction func chooseBarButton(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func closeBarButton(_ sender: UIBarButtonItem) {
        let isPresentingInAddToDoMode = presentingViewController is UINavigationController
        
        if isPresentingInAddToDoMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The ItemInfoTableViewController is not inside a navigation controller.")
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let simpleItemsTVC = segue.destination as? SimpleItemsTableViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
        
        simpleItemsTVC.setItemTypeToDisplay(itemTypeToDisplay: SimpleStaticTVCReturnType.RECURRENCE)
        
        prepareRecurrenceDetailsSegue(segue: segue, simpleItemsTVC: simpleItemsTVC)
    }
    
    private func prepareRecurrenceDetailsSegue(segue: UIStoryboardSegue, simpleItemsTVC: SimpleItemsTableViewController) {
        switch segue.identifier {
        case "SegueToRecurrenceDailyDetails":
            simpleItemsTVC.setRecurrenceDetailsToReturn(recurrenceDetailsToReturn: RecurrenceDetailType.DAILY)
        case "SegueToRecurrenceWeeklyDetails":
            simpleItemsTVC.setRecurrenceDetailsToReturn(recurrenceDetailsToReturn: RecurrenceDetailType.WEEKLY)
        case "SegueToRecurrenceMonthlyDetails":
            simpleItemsTVC.setRecurrenceDetailsToReturn(recurrenceDetailsToReturn: RecurrenceDetailType.MONTHLY)
        default:
            simpleItemsTVC.setRecurrenceDetailsToReturn(recurrenceDetailsToReturn: RecurrenceDetailType.YEARLY)
        }
    }
}
