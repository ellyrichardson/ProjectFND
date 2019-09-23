//
//  ExpandButton.swift
//  ProjectFND
//
//  Created by Elly Richardson on 9/20/19.
//  Copyright © 2019 EllyRichardson. All rights reserved.
//

import UIKit

class ExpandButton: TransformingButton {
    let expandedImage = UIImage(named: "ExpandToDo")! as UIImage
    let collapsedImage = UIImage(named: "CollapseToDo")! as UIImage
    
    private var toDoRowIndex: Int = Int()
    
    override func awakeFromNib() {
        self.toDoRowIndex = Int()
    }
}
