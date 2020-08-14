//
//  TableViewCell.swift
//  ProjectFND
//
//  Created by Elly Richardson on 9/9/19.
//  Copyright © 2019 EllyRichardson. All rights reserved.
//

import UIKit

class ScheduleTableViewCell: UITableViewCell, UITableViewDelegate, ScheduleTableViewCellProtocol {
    
    // MARK: - Properties
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    //@IBOutlet weak var estTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    
    @IBOutlet weak var taskTypeLabel: UILabel!
    @IBOutlet weak var checkBoxButton: CheckBoxButton!
    @IBOutlet weak var expandButton: ExpandButton!
    @IBOutlet weak var importantButton: ImportantButton!
    @IBOutlet weak var notifyButton: NotificationButton!
    @IBOutlet weak var finishedButton: FinishedButton!
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
    
    func setTaskName(taskName: String) {
        self.taskNameLabel.text = taskName
    }
    
    func setStartTime(startTime: String) {
        self.startTimeLabel.text = startTime
    }
    
    func setEndTime(endTime: String) {
        self.endTimeLabel.text = endTime
    }
    
    func setTaskTag(taskTag: String) {
        self.taskTypeLabel.text = taskTag
    }
    
    func getTaskName() -> String {
        return taskNameLabel.text!
    }
    
    func getStartTime() -> String {
        return startTimeLabel.text!
    }
    
    func getEndTime() -> String {
        return endTimeLabel.text!
    }
    
    func getTaskTag() -> String {
        return taskTypeLabel.text!
    }
    
    func getCheckBoxButton() -> CheckBoxButton {
        return checkBoxButton
    }
    
    func getExpandButton() -> ExpandButton {
        return expandButton
    }
    
    func getImportantButton() -> ImportantButton {
        return importantButton
    }
    
    func getNotifyButton() -> NotificationButton {
        return notifyButton
    }
}

