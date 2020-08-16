//
//  CalendarViewUtils.swift
//  ProjectFND
//
//  Created by Elly Richardson on 3/2/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import UIKit
import CoreData
import os.log
import JTAppleCalendar

class CalendarViewUtils {
    static func showCellIndicators(cell: CalendarCell, onProgress: Bool, finished: Bool, overdue: Bool){
        // Yellow indicator only
        if onProgress == true && finished == false && overdue == false {
            cell.topIndicator.isHidden = false
            cell.createIndicators(createIndicator: true, indicatorType: 1)
        }
            // Green indicator only
        else if onProgress == false && finished == true && overdue == false {
            cell.topIndicator.isHidden = false
            cell.createIndicators(createIndicator: true, indicatorType: 2)
        }
            // Orange indicator only
        else if onProgress == false && finished == false && overdue == true {
            cell.topIndicator.isHidden = false
            cell.createIndicators(createIndicator: true, indicatorType: 3)
        }
            // Yellow and Green indicator
        else if onProgress == true && finished == true && overdue == false {
            cell.topLeftIndicator.isHidden = false
            cell.topRightIndicator.isHidden = false
            cell.createIndicators(createIndicator: true, indicatorType: 4)
        }
            // Yellow and Orange indicator
        else if onProgress == true && finished == false && overdue == true {
            cell.topRightIndicator.isHidden = false
            cell.topLeftIndicator.isHidden = false
            cell.createIndicators(createIndicator: true, indicatorType: 5)
        }
            // Green and Orange indicator
        else if onProgress == false && finished == true && overdue == true {
            cell.topLeftIndicator.isHidden = false
            cell.topRightIndicator.isHidden = false
            cell.createIndicators(createIndicator: true, indicatorType: 6)
        }
            // Yellow, Green, and Orange indicator
        else if onProgress == true && finished == true && overdue == true {
            cell.topIndicator.isHidden = false
            cell.topRightIndicator.isHidden = false
            cell.topLeftIndicator.isHidden = false
            cell.createIndicators(createIndicator: true, indicatorType: 0)
        }
        //return cell
    }
}
