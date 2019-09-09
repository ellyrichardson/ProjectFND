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
    @IBOutlet weak var workDateLabel: UILabel!
    @IBOutlet weak var estTimeLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    
    //@IBOutlet weak var doneCheckBox: CheckBox!
    
    /*@IBOutlet weak var taskNameLabel: UILabel!
     @IBOutlet weak var workDateLabel: UILabel!
     @IBOutlet weak var estTimeLabel: UILabel!
     @IBOutlet weak var dueDateLabel: UILabel!*/
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //setupSubTable()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

