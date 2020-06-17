//
//  SchedulingAssistanceTableViewCell.swift
//  ProjectFND
//
//  Created by Elly Richardson on 6/16/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import UIKit

class SchedulingAssistanceTableViewCell: UITableViewCell {
    
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var taskNameLabel: UILabel!
    
    //private var backgroundClr: UIColor?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setOvalShape()
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
    
    private func setOvalShape() {
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
    
    func setBackgroundColor(backgroundClr: UIColor) {
        self.layer.backgroundColor = backgroundClr.cgColor
    }
}
