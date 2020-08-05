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
    static func colorForToDoRow(toDoRowIndex: Int, toDoItems: [(key: String, value: ToDo)]) -> UIColor {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "M/d/yy, h:mm a"
        
        let toDoItem = toDoItems[toDoRowIndex]
        /*
        // Neutral status - if ToDo hasn't met due date yet
        if (toDoItem.value.finished == false && currentDate < toDoItem.value.dueDate) || !toDoItem.value.isDueDateSet() {
            // Yellowish color
            
            return UIColor(red:1.00, green:0.89, blue:0.00, alpha:1.0)
        }
            // Finished - if ToDo is finished
        else if toDoItem.value.finished == true {
            // Greenish color
            print("GREENN")
            return UIColor(red:0.08, green:0.85, blue:0.42, alpha:1.0)
        }
            // Late - if ToDo hasn't finished yet and is past due date
        else {
            // Reddish orange color
            return UIColor(red:1.00, green:0.5, blue:0.0, alpha:1.0)
        }*/
        
        // Late - if ToDo hasn't finished yet and is past due date
        if (toDoItem.value.finished == false && currentDate > toDoItem.value.dueDate) && toDoItem.value.isDueDateSet() {
            // Reddish orange color
            return UIColor(red:1.00, green:0.5, blue:0.0, alpha:1.0)
        }
        // Finished - if ToDo is finished
        if toDoItem.value.finished == true {
            // Greenish color
            print("GREENN")
            return UIColor(red:0.08, green:0.85, blue:0.42, alpha:1.0)
        }
        
        // Neutral status - if ToDo hasn't met due date yet
        // Yellowish color
        return UIColor(red:1.00, green:0.89, blue:0.00, alpha:1.0)
    }
    
    
    // Sets the appropriate row color if the ToDo is finished, late, or neutral status that involves intervals
    // NOTE: Was originally static func intervalsColorForToDoRow(toDoTaskId: String, toDoItems: [ToDo], toDoIntervalsToAssign: [ToDo])
    static func intervalsColorForToDoRowIfInTaskItems(toDoTaskId: String, toDoItems: [String: ToDo]) -> UIColor {
        //let currentDate = Date()
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "M/d/yy, h:mm a"

        if toDoItems[toDoTaskId] != nil {
            return UIColor(red:0.729, green:0.860, blue:0.354, alpha:1.0)
        }
        else {
            //return UIColor(red:0.200, green:0.860, blue:0.354, alpha:1.0)
            return UIColor(red:0.928, green:0.928, blue:0.934, alpha:1.0)
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
