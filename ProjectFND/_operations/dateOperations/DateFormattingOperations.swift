//
//  DateOperationsHelper.swift
//  ProjectFND
//
//  Created by Elly Richardson on 1/18/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import CoreData
import UIKit
import os.log

class DateFormattingOperations{
    func changeDateFormatToMDYY(dateToChange: Date) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d/yy"
        let dateString = dateFormatter.string(from: dateToChange)
        return dateFormatter.date(from: dateString)!
    }
}
