//
//  TableViewCell.swift
//  ProjectFND
//
//  Created by Elly Richardson on 9/9/19.
//  Copyright © 2019 EllyRichardson. All rights reserved.
//

import UIKit

class ScheduleTableViewCell: UITableViewCell, UITableViewDelegate {
    /*var toDos = [ToDo]()
     var toDoSubMenuTable: UITableView?*/
    
    // MARK: - Properties
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var estTimeLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    
    @IBOutlet weak var checkBoxButton: CheckBoxButton!
    @IBOutlet weak var expandButton: ExpandButton!
    
    // Unused - I think
    private var checkButtonPressed = Bool()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // ATTEMPT ON SHADOW
        // add shadow on cell
        /*
        backgroundColor = .clear // very important
        layer.masksToBounds = false
        layer.shadowOpacity = 0.23
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowColor = UIColor.black.cgColor
 */
        
        // add corner radius on `contentView`
        //contentView.backgroundColor = .white
        //contentView.layer.cornerRadius = 8
        //self.layer.cornerRadius = 8
        self.contentView.layer.masksToBounds = true
        self.contentView.layer.cornerRadius = 8
        /*
        let heightRatio = UIScreen.main.bounds.height / 580
        self.taskNameLabel.font = self.taskNameLabel.font.withSize(heightRatio)
 */
        
        /*
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowOpacity = 5
 */
        self.layer.backgroundColor = UIColor.clear.cgColor
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.3
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // For spacing
    override var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            var frame =  newFrame
            frame.origin.y += 4
            frame.size.height -= 2 * 5
            super.frame = frame
        }
    }
    
    func setCheckButtonStatus(isPressed: Bool) {
        self.checkButtonPressed = isPressed
    }
    
    func getCheckButtonStatus() -> Bool {
        return self.checkButtonPressed
    }
}

