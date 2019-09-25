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
    
    private var isPressed: Bool = false {
        didSet{
            if getPressedStatus() == true {
                print("pressed status")
                print(getPressedStatus())
                self.setImage(collapsedImage, for: UIControl.State.normal)
            } else {
                self.setImage(expandedImage, for: UIControl.State.normal)
            }
        }
    }
    
    //private var isChecked: Bool = Bool()
    
    override func getPressedStatus() -> Bool {
        return self.isPressed
    }
    
    
    override func setPressedStatus(isPressed: Bool) {
        self.isPressed = isPressed
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action: #selector(buttonPressed(sender:)), for: UIControl.Event.touchUpInside)
        self.setPressedStatus(isPressed: false)
        self.toDoRowIndex = Int()
        /*if getPressedStatus() == true {
         print("pressed status")
         print(getPressedStatus())
         self.setImage(checkedImage, for: UIControl.State.normal)
         } else {
         self.setImage(uncheckedImage, for: UIControl.State.normal)
         }*/
    }
    
    func setToDoRowIndex(toDoRowIndex: Int) {
        self.toDoRowIndex = toDoRowIndex
    }
    
    func getToDoRowIndex() -> Int {
        return self.toDoRowIndex
    }
    
    override func buttonPressed(sender: UIButton) {
        if sender == self {
            self.setPressedStatus(isPressed: !self.getPressedStatus())
        }
    }
}
