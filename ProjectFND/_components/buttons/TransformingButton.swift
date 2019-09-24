//
//  TransformingButton.swift
//  ProjectFND
//
//  Created by Elly Richardson on 9/20/19.
//  Copyright © 2019 EllyRichardson. All rights reserved.
//

import UIKit

class TransformingButton: UIButton {
    //private var toDoRowIndex: Int = Int()
    private var isPressed: Bool = false
    
    override func awakeFromNib() {
        //self.addTarget(self, action: #selector(buttonPressed(sender:)), for: UIControl.Event.touchUpInside)
        //self.toDoRowIndex = Int()
        self.isPressed = false
    }
    
    func setPressedStatus(isPressed: Bool) {
        self.isPressed = isPressed
    }
    
    func getPressedStatus() -> Bool {
        return self.isPressed
    }
    
    @objc func buttonPressed(sender: UIButton) {
        if sender == self {
            isPressed = !isPressed
        }
    }
}
