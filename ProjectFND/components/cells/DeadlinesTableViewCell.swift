//
//  DeadlinesTableViewCell.swift
//  ProjectFND
//
//  Created by Elly Richardson on 3/17/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import UIKit

class DeadlinesTableViewCell: UITableViewCell {

    /*
    @IBOutlet weak var deadlineDateLabel: UILabel!
    @IBOutlet weak var roundIndicator: UIView!
    @IBOutlet weak var deadlineDateBorder: UIView!
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var deadlineTimeLabel: UILabel!
    @IBOutlet weak var taskTypeLabel: UILabel!
    @IBOutlet weak var intervalAmountBorder: UIView!
    @IBOutlet weak var intervalAmountLabel: UILabel!
 */
    
    @IBOutlet weak var intervalizedToDoLabel: UILabel!
    @IBOutlet weak var intervalizedToDoTypeLabel: UILabel!
    @IBOutlet weak var intervalizedToDoEstTimeLabel: UILabel!
    @IBOutlet weak var intervalizedToDoEndingTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //deadlineDateBorder.layer.cornerRadius = 5
        //intervalAmountBorder.layer.cornerRadius = 20
        //roundIndicator.layer.cornerRadius = 18.5
        
        /*
        self.contentView.layer.masksToBounds = true
        self.contentView.layer.cornerRadius = 8
        
        self.layer.backgroundColor = UIColor.clear.cgColor
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.3
        self.layer.cornerRadius = 58
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
        */
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    /*
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
    }*/
}
