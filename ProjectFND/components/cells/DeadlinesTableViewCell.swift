//
//  DeadlinesTableViewCell.swift
//  ProjectFND
//
//  Created by Elly Richardson on 3/17/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import UIKit

class DeadlinesTableViewCell: UITableViewCell {

    @IBOutlet weak var deadlineDateLabel: UILabel!
    @IBOutlet weak var roundIndicator: UIView!
    @IBOutlet weak var deadlineDateBorder: UIView!
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var deadlineTimeLabel: UILabel!
    @IBOutlet weak var taskTypeLabel: UILabel!
    @IBOutlet weak var intervalAmountBorder: UIView!
    @IBOutlet weak var intervalAmountLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        deadlineDateBorder.layer.cornerRadius = 5
        intervalAmountBorder.layer.cornerRadius = 20
        //roundIndicator.layer.cornerRadius = 18.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
