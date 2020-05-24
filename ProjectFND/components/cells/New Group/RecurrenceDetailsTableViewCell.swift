//
//  RecurrenceDetailsTableViewCell.swift
//  ProjectFND
//
//  Created by Elly Richardson on 5/23/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import UIKit

class RecurrenceDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var detailLabel: UILabel!
    
    var item: ViewRecurrenceDetailModelItem? {
        didSet {
            detailLabel?.text = item?.recurrenceDetail
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // update UI
        accessoryType = selected ? .checkmark : .none
    }

}
