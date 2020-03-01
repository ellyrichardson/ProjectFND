//
//  AnimationFactory.swift
//  ProjectFND
//
//  Created by Elly Richardson on 2/29/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import UIKit
import CoreData
import os.log


class TableViewAnimations {
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

