//
//  CalendarCell.swift
//  ProjectFND
//
//  Created by Elly Richardson on 9/4/19.
//  Copyright © 2019 EllyRichardson. All rights reserved.
//
//  Parts of this code was taken from CalendarControlUsingJTAppleCalenader
//  project by anoop4real.
//

import JTAppleCalendar

class CalendarCell: JTAppleCell {
    
    // THIS is still not in the repo
    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var topIndicator: UIStackView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var topRightIndicator: UIStackView!
    @IBOutlet weak var topLeftIndicator: UIStackView!
    @IBOutlet weak var bottomIndicator: UIStackView!
    
    private  var shouldDrawStripes: Bool = false
    
    /*
     USAGE:
     Indicator Types:
     0 - All indicators, which are Yellow, Green, and Red
     1 - Yellow indicator only
     2 - Green indicator only
     3 - Red indicator only
     4 - Yellow and Green indicators
     5 - Yellow and Red indicators
     6 - Red and Green indicators
     */
    func createIndicators(createIndicator: Bool, indicatorType: Int) {
        if createIndicator == true {
            switch indicatorType {
            // Yellow only
            case 1:
                print("Yellow ONLY")
                removeIndicatorSubviews()
                topIndicator.addArrangedSubview(generateIndicators(indicatorColor: 1))
                //topLeftIndicator.addArrangedSubview(generateIndicators(indicatorColor: 3))
                //topRightIndicator.addArrangedSubview(generateIndicators(indicatorColor: 3))
            // Green only
            case 2:
                print("Green ONLY")
                removeIndicatorSubviews()
                topIndicator.addArrangedSubview(generateIndicators(indicatorColor: 2))
                //topLeftIndicator.addArrangedSubview(generateIndicators(indicatorColor: 3))
                //topRightIndicator.addArrangedSubview(generateIndicators(indicatorColor: 3))
            // Red only
            case 3:
                print("red ONLY")
                removeIndicatorSubviews()
                topIndicator.addArrangedSubview(generateIndicators(indicatorColor: 0))
                //topLeftIndicator.addArrangedSubview(generateIndicators(indicatorColor: 3))
                //topRightIndicator.addArrangedSubview(generateIndicators(indicatorColor: 3))
            // Yellow and Green
            case 4:
                print("Yellow  and Green ONLY")
                removeIndicatorSubviews()
                topLeftIndicator.addArrangedSubview(generateIndicators(indicatorColor: 2))
                topRightIndicator.addArrangedSubview(generateIndicators(indicatorColor: 1))
                //topIndicator.addArrangedSubview(generateIndicators(indicatorColor: 3))
            // Yellow and Red
            case 5:
                print("green and red ONLY")
                removeIndicatorSubviews()
                topLeftIndicator.addArrangedSubview(generateIndicators(indicatorColor: 0))
                topRightIndicator.addArrangedSubview(generateIndicators(indicatorColor: 1))
                //topIndicator.addArrangedSubview(generateIndicators(indicatorColor: 3))
            // Green and Red
            case 6:
                print("green and red ONLY")
                removeIndicatorSubviews()
                topLeftIndicator.addArrangedSubview(generateIndicators(indicatorColor: 0))
                topRightIndicator.addArrangedSubview(generateIndicators(indicatorColor: 2))
                //topIndicator.addArrangedSubview(generateIndicators(indicatorColor: 3))
            // Yellow, Green, and Red
            default:
                print("Yellow, green and red ONLY")
                removeIndicatorSubviews()
                topRightIndicator.addArrangedSubview(generateIndicators(indicatorColor: 0))
                topLeftIndicator.addArrangedSubview(generateIndicators(indicatorColor: 2))
                topIndicator.addArrangedSubview(generateIndicators(indicatorColor: 1))
            }
        }
    }
    
    func generateIndicators(indicatorColor: Int) -> UIView {
        switch indicatorColor {
        // Creates Yellow indicator
        case 1:
            let yellowIndicator = UIView()
            yellowIndicator.layer.masksToBounds = false
            yellowIndicator.layer.borderColor = UIColor(red:1.00, green:0.89, blue:0.00, alpha:1.0).cgColor
            yellowIndicator.layer.backgroundColor = UIColor(red:1.00, green:0.89, blue:0.00, alpha:1.0).cgColor
            yellowIndicator.layer.cornerRadius = 15
            yellowIndicator.clipsToBounds = false
            return yellowIndicator
        // Creates Green indicator
        case 2:
            let greenIndicator = UIView()
            greenIndicator.layer.masksToBounds = false
            greenIndicator.layer.borderColor = UIColor(red:0.08, green:0.85, blue:0.42, alpha:1.0).cgColor
            greenIndicator.layer.backgroundColor = UIColor(red:0.08, green:0.85, blue:0.42, alpha:1.0).cgColor
            greenIndicator.layer.cornerRadius = 15
            greenIndicator.clipsToBounds = false
            return greenIndicator
            
        // Creates Blank/Clear indicator
        case 3:
            let clearIndicator = UIView()
            clearIndicator.layer.masksToBounds = false
            clearIndicator.layer.borderColor = UIColor.clear.cgColor
            clearIndicator.layer.backgroundColor = UIColor.clear.cgColor
            clearIndicator.layer.cornerRadius = 15
            clearIndicator.clipsToBounds = false
            return clearIndicator
 
        // Creates Red indicator
        default:
            let redIndicator = UIView()
            redIndicator.layer.masksToBounds = false
            redIndicator.layer.borderColor = UIColor(red:1.00, green:0.5, blue:0.0, alpha:1.0).cgColor
            redIndicator.layer.backgroundColor = UIColor(red:1.00, green:0.5, blue:0.0, alpha:1.0).cgColor
            redIndicator.layer.cornerRadius = 15
            redIndicator.clipsToBounds = false
            return redIndicator
        }
    }
    
    func removeIndicatorSubviews() {
        if topIndicator.arrangedSubviews.count > 0 {
            topIndicator.arrangedSubviews[0].removeFromSuperview()
        }
        if topLeftIndicator.arrangedSubviews.count > 0 {
            topLeftIndicator.arrangedSubviews[0].removeFromSuperview()
        }
        if topRightIndicator.arrangedSubviews.count > 0 {
            topRightIndicator.arrangedSubviews[0].removeFromSuperview()
        }
        /*
        topIndicator.arrangedSubviews[0].removeFromSuperview()
        topLeftIndicator.arrangedSubviews[0].removeFromSuperview()
        topRightIndicator.arrangedSubviews[0].removeFromSuperview()
 */
    }
    
    override func draw(_ rect: CGRect) {
        if shouldDrawStripes {
            let T: CGFloat = 5     // desired thickness of lines
            let G: CGFloat = 4.76   // desired gap between lines
            let W = rect.size.width
            let H = rect.size.height
            
            guard let c = UIGraphicsGetCurrentContext() else { return }
            c.setStrokeColor(UIColor(red:0.729, green:0.860, blue:0.354, alpha:0.5).cgColor)
            //c.setStrokeColor(UIColor.orange.cgColor)
            c.setLineWidth(T)
            
            var p = -(W > H ? W : H) - T
            while p <= W {
                
                c.move( to: CGPoint(x: p-T, y: -T) )
                c.addLine( to: CGPoint(x: p+T+H, y: T+H) )
                c.strokePath()
                p += G + T + T
            }
        }
    }
    
    func setShouldDrawStripes(shouldDraw: Bool) {
        self.shouldDrawStripes = shouldDraw
    }
    
    func getShouldDrawStripes() -> Bool {
        return self.shouldDrawStripes
    }
}
