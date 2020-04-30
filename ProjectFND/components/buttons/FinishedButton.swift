//
//  FinishedButton.swift
//  ProjectFND
//
//  Created by Elly Richardson on 4/29/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import UIKit

class FinishedButton: TransformingButton {
    let finishedImage = UIImage(named: "TaskFinishedImage")! as UIImage
    let inProgressImage = UIImage(named: "TaskInProgressImage")! as UIImage
    let overdueImage = UIImage(named: "TaskOverdueImage")! as UIImage
    private let imageSize:CGSize = CGSize(width: 50, height: 50)

    private var overdue: Bool = Bool()
    private var isPressed: Bool = false {
        didSet{
            if getPressedStatus() == true {
                print("pressed status")
                print(getPressedStatus())
                self.setImage(finishedImage, for: UIControl.State.normal)
            } else {
                if self.overdue {
                    self.setImage(overdueImage, for: UIControl.State.normal)
                }
                else {
                    self.setImage(inProgressImage, for: UIControl.State.normal)
                }
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
        //self.frame = CGRect(0, 0, self.frame.width, self.frame.height)
        //self.imageEdgeInsets = UIEdgeInsets(
            //top: (self.frame.size.height - imageSize.height) / 2,
            //left: (self.frame.size.width - imageSize.width) / 2,
            //bottom: (self.frame.size.height - imageSize.height) / 2,
            //right: (self.frame.size.width - imageSize.width) / 2)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func isOverdue(overdue: Bool) {
        self.overdue = overdue
    }
    
    override func buttonPressed(sender: UIButton) {
        if sender == self {
            self.setPressedStatus(isPressed: !self.getPressedStatus())
        }
    }
    
    // To remove tint color
    override func setImage(_ image: UIImage?, for state: UIControl.State) {
        let newImage = image?.withRenderingMode(.alwaysOriginal)
        super.setImage(newImage, for: state)
    }
}
