//
//  SchedulingAssistanceLabel.swift
//  ProjectFND
//
//  Created by Elly Richardson on 6/6/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import UIKit

class SchedulingAssistanceLabel: UIView {

    let label = UILabel()
    var lineInsideOffset: CGFloat = 10
    var lineOutsideOffset: CGFloat = 4
    var lineHeight: CGFloat = 1
    var lineColor = UIColor.gray

    //MARK: - init
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        initLabel()
    }
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        initLabel()
    }
    convenience init() {self.init(frame: CGRect.zero)}
    func initLabel()
    {
        label.textAlignment = .left

        label.translatesAutoresizingMaskIntoConstraints = false
        let top = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: label, attribute: .top, multiplier: 1, constant: 0)
        let bot = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: label, attribute: .bottom, multiplier: 1, constant: 0)
        let lead = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .lessThanOrEqual, toItem: label, attribute: .leading, multiplier: 1, constant: 0)
        let trail = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .greaterThanOrEqual, toItem: label, attribute: .trailing, multiplier: 1, constant: 0)
        let centerX = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: label, attribute: .centerX, multiplier: 1, constant: 0)

        addSubview(label)
        addConstraints([top, bot, lead, trail, centerX])

        //... if the opaque property of your view is set to YES, your drawRect: method must totally fill the specified rectangle with opaque content.
        //http://stackoverflow.com/questions/11318987/black-background-when-overriding-drawrect-in-uiscrollview
        isOpaque = false
    }

    //MARK: - drawing
    override func draw(_ rect: CGRect)  {
        let lineWidth = label.frame.minX - rect.minX - lineInsideOffset - lineOutsideOffset
        if lineWidth <= 0 {return}

        // let lineLeft = UIBezierPath(rect: CGRect(x: rect.minX + lineOutsideOffset, y: rect.midY, width: lineWidth, height: 1))
        let lineRight = UIBezierPath(rect: CGRect(x: label.frame.maxX + lineInsideOffset, y: rect.midY, width: lineWidth, height: 1))

        /*
        lineLeft.lineWidth = lineHeight
        lineColor.set()
        lineLeft.stroke()*/

        lineRight.lineWidth = lineHeight
        lineColor.set()
        lineRight.stroke()
    }

}
