//
//  ToDoTableUtils.swift
//  ProjectFND
//
//  Created by Elly Richardson on 3/2/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import UIKit
import CoreData
import os.log

class ToDoTableViewUtils {
    
    // Sets the appropriate row color if the ToDo is finished, late, or neutral status
    static func colorForToDoRow(toDoRowIndex: Int, toDoItems: [ToDo]) -> UIColor {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "M/d/yy, h:mm a"
        
        let toDoItem = toDoItems[toDoRowIndex]
        
        // Neutral status - if ToDo hasn't met due date yet
        if toDoItem.finished == false && currentDate < toDoItem.dueDate {
            // Yellowish color
            return UIColor(red:1.00, green:0.89, blue:0.00, alpha:1.0)
        }
            // Finished - if ToDo is finished
        else if toDoItem.finished == true {
            // Greenish color
            return UIColor(red:0.08, green:0.65, blue:0.42, alpha:1.0)
        }
            // Late - if ToDo hasn't finished yet and is past due date
        else {
            // Reddish orange color
            return UIColor(red:1.00, green:0.40, blue:0.18, alpha:1.0)
        }
    }
    
    // MARK: - Animations
    static func makeCellFade(cell: UITableViewCell, indexPath: IndexPath) {
        cell.alpha = 0
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0.05 * Double(indexPath.row),
            animations: {
                cell.alpha = 1
        })
    }
    
    static func makeCellSlide(cell: UITableViewCell, indexPath: IndexPath, tableView: UITableView) {
        cell.transform = CGAffineTransform(translationX: tableView.bounds.width, y: 0)
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0.05 * Double(indexPath.row),
            options: [.curveEaseInOut],
            animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
        })
    }
    
    static func makeCellMoveUpWithFade(cell: UITableViewCell, indexPath: IndexPath) {
        cell.transform = CGAffineTransform(translationX: 0, y: cell.frame.height / 2)
        cell.alpha = 0
        UIView.animate(
            withDuration: 0.5,
            delay: 0.05 * Double(indexPath.row),
            options: [.curveEaseInOut],
            animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
                cell.alpha = 1
        })
    }
    
    static func makeCellMoveUpWithFade(cell: UITableViewCell, rowHeight: CGFloat, duration: TimeInterval, delayFactor: Double, indexPath: IndexPath) {
        cell.transform = CGAffineTransform(translationX: 0, y: rowHeight / 2)
        cell.alpha = 0
        UIView.animate(
            withDuration: duration,
            delay: delayFactor * Double(indexPath.row),
            options: [.curveEaseInOut],
            animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
                cell.alpha = 1
        })
    }
}
