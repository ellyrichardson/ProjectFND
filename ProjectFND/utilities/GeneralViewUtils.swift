//
//  ViewUtils.swift
//  ProjectFND
//
//  Created by Elly Richardson on 3/2/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import UIKit
import CoreData
import os.log

class GeneralViewUtils {
    
    func reloadTableViewData(tableView: UITableView) {
        DispatchQueue.main.async {
            tableView.reloadData()
        }
    }
    
    func reloadCollectionViewData(collectionView: UICollectionView) {
        DispatchQueue.main.async {
            collectionView.reloadData()
        }
    }
    
    // MARK: - View Border
    func addTopBorderWithColor(_ objView : UIView, color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: objView.frame.size.width, height: width)
        objView.layer.addSublayer(border)
    }
    
    func addRightBorderWithColor(_ objView : UIView, color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: objView.frame.size.width - width, y: 0, width: width, height: objView.frame.size.height)
        objView.layer.addSublayer(border)
    }
    
    func addBottomBorderWithColor(_ objView : UIView, color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: objView.frame.size.height - width, width: objView.frame.size.width, height: width)
        objView.layer.addSublayer(border)
    }
    
    func addLeftBorderWithColor(_ objView : UIView, color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: width, height: objView.frame.size.height)
        objView.layer.addSublayer(border)
    }
    
    // MARL: - Background
    func addGradientBackground(cell: UITableViewCell, firstColor: UIColor, secondColor: UIColor){
        cell.contentView.clipsToBounds = true
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor]
        gradientLayer.frame = cell.bounds
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        print(gradientLayer.frame)
        cell.contentView.layer.insertSublayer(gradientLayer, at: 0)
    }
}
