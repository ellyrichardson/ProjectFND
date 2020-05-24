//
//  RecurrenceDetailModel.swift
//  ProjectFND
//
//  Created by Elly Richardson on 5/23/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import UIKit

class ViewRecurrenceDetailModel: NSObject {
    var items = [ViewRecurrenceDetailModelItem]()
    let dailyType = RecurrenceDetailType.DAILY
    let weeklyType = RecurrenceDetailType.WEEKLY
    let monthlyType = RecurrenceDetailType.MONTHLY
    let yearlyType = RecurrenceDetailType.YEARLY
    private var detailTypeToReturn = RecurrenceDetailType.DAILY
    
    
    override init() {
        super.init()
        items = getProperDetailsToReturn().map { ViewRecurrenceDetailModelItem(item: $0) }
    }
    
    func getDailyDetailsArray() -> [RecurrenceDetailModel] {
        return [RecurrenceDetailModel(recurrenceDetail: "Sunday", recurrenceType: dailyType),
        RecurrenceDetailModel(recurrenceDetail: "Monday", recurrenceType: dailyType),
        RecurrenceDetailModel(recurrenceDetail: "Tuesday", recurrenceType: dailyType),
        RecurrenceDetailModel(recurrenceDetail: "Wednesday", recurrenceType: dailyType),
        RecurrenceDetailModel(recurrenceDetail: "Thursday", recurrenceType: dailyType),
        RecurrenceDetailModel(recurrenceDetail: "Friday", recurrenceType: dailyType),
        RecurrenceDetailModel(recurrenceDetail: "Saturday", recurrenceType: dailyType)]
    }
    
    func getWeeklyDetailsArray() -> [RecurrenceDetailModel] {
        return [RecurrenceDetailModel(recurrenceDetail: "Week 1", recurrenceType: weeklyType),
        RecurrenceDetailModel(recurrenceDetail: "Week 2", recurrenceType: weeklyType),
        RecurrenceDetailModel(recurrenceDetail: "Week 3", recurrenceType: weeklyType),
        RecurrenceDetailModel(recurrenceDetail: "Week 4", recurrenceType: weeklyType)]
    }
    
    func getMonthlyDetailsArray() -> [RecurrenceDetailModel] {
        return  [RecurrenceDetailModel(recurrenceDetail: "January", recurrenceType: monthlyType),
        RecurrenceDetailModel(recurrenceDetail: "February", recurrenceType: monthlyType),
        RecurrenceDetailModel(recurrenceDetail: "March", recurrenceType: monthlyType),
        RecurrenceDetailModel(recurrenceDetail: "April", recurrenceType: monthlyType),
        RecurrenceDetailModel(recurrenceDetail: "May", recurrenceType: monthlyType),
        RecurrenceDetailModel(recurrenceDetail: "June", recurrenceType: monthlyType),
        RecurrenceDetailModel(recurrenceDetail: "July", recurrenceType: monthlyType),
        RecurrenceDetailModel(recurrenceDetail: "August", recurrenceType: monthlyType),
        RecurrenceDetailModel(recurrenceDetail: "September", recurrenceType: monthlyType),
        RecurrenceDetailModel(recurrenceDetail: "October", recurrenceType: monthlyType),
        RecurrenceDetailModel(recurrenceDetail: "November", recurrenceType: monthlyType), RecurrenceDetailModel(recurrenceDetail: "December", recurrenceType: monthlyType)]
    }
    
    func getProperDetailsToReturn() -> [RecurrenceDetailModel] {
        switch detailTypeToReturn {
        case .DAILY:
            return getDailyDetailsArray()
        case .WEEKLY:
            return getWeeklyDetailsArray()
        default:
            return getMonthlyDetailsArray()
        }
    }
    
    func setDetailTypeToReturn(detailTypeToReturn: RecurrenceDetailType) {
        self.detailTypeToReturn = detailTypeToReturn
    }
    
    func setProperDetailItems() {
        items = getProperDetailsToReturn().map { ViewRecurrenceDetailModelItem(item: $0) }
    }
}
