//
//  BaseButton.swift
//  ProjectFND
//
//  Created by Elly Richardson on 9/9/19.
//  Copyright © 2019 EllyRichardson. All rights reserved.
//

import UIKit

class CheckBoxButton: TransformingButton {
    let checkedImage = UIImage(named: "CheckBox")! as UIImage
    let uncheckedImage = UIImage(named: "UncheckBox")! as UIImage
    
    private var toDoRowIndex: Int = Int()
    
    //private var isChecked: Bool = Bool()
    
    override func awakeFromNib() {
        if getPressedStatus() == true {
            self.setImage(checkedImage, for: UIControl.State.normal)
        } else {
            self.setImage(uncheckedImage, for: UIControl.State.normal)
        }
    }
    
    func setToDoRowIndex(toDoRowIndex: Int) {
        self.toDoRowIndex = toDoRowIndex
    }
    
    func getToDoRowIndex() -> Int {
        return self.toDoRowIndex
    }
}
