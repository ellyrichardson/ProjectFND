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
                bottomIndicator.addArrangedSubview(generateIndicators(indicatorColor: 1))
            // Green only
            case 2:
                topIndicator.isHidden = true
                topRightIndicator.isHidden = true
                topLeftIndicator.isHidden = true
                bottomIndicator.addArrangedSubview(generateIndicators(indicatorColor: 2))
            // Red only
            case 3:
                topIndicator.isHidden = true
                topRightIndicator.isHidden = true
                topLeftIndicator.isHidden = true
                bottomIndicator.addArrangedSubview(generateIndicators(indicatorColor: 0))
            // Yellow and Green
            case 4:
                topIndicator.addArrangedSubview(generateIndicators(indicatorColor: 2))
                topRightIndicator.isHidden = true
                topLeftIndicator.isHidden = true
                bottomIndicator.addArrangedSubview(generateIndicators(indicatorColor: 1))
            // Yellow and Red
            case 5:
                topIndicator.addArrangedSubview(generateIndicators(indicatorColor: 0))
                topRightIndicator.isHidden = true
                topLeftIndicator.isHidden = true
                bottomIndicator.addArrangedSubview(generateIndicators(indicatorColor: 1))
            // Green and Red
            case 6:
                topIndicator.addArrangedSubview(generateIndicators(indicatorColor: 0))
                topRightIndicator.isHidden = true
                topLeftIndicator.isHidden = true
                bottomIndicator.addArrangedSubview(generateIndicators(indicatorColor: 2))
            // Yellow, Green, and Red
            default:
                topIndicator.isHidden = true
                topRightIndicator.addArrangedSubview(generateIndicators(indicatorColor: 0))
                topLeftIndicator.addArrangedSubview(generateIndicators(indicatorColor: 2))
                bottomIndicator.addArrangedSubview(generateIndicators(indicatorColor: 1))
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
            greenIndicator.layer.borderColor = UIColor(red:0.08, green:0.65, blue:0.42, alpha:1.0).cgColor
            greenIndicator.layer.backgroundColor = UIColor(red:0.08, green:0.65, blue:0.42, alpha:1.0).cgColor
            greenIndicator.layer.cornerRadius = 15
            greenIndicator.clipsToBounds = false
            return greenIndicator
        // Creates Red indicator
        default:
            let redIndicator = UIView()
            redIndicator.layer.masksToBounds = false
            redIndicator.layer.borderColor = UIColor(red:1.00, green:0.40, blue:0.18, alpha:1.0).cgColor
            redIndicator.layer.backgroundColor = UIColor(red:1.00, green:0.40, blue:0.18, alpha:1.0).cgColor
            redIndicator.layer.cornerRadius = 15
            redIndicator.clipsToBounds = false
            return redIndicator
        }
    }
}
