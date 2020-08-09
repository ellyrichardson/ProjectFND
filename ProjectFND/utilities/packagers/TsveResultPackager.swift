//
//  TsveResultPackager.swift
//  ProjectFND
//
//  Created by Elly Richardson on 8/8/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import UIKit

class TsveResultPackager {
    private var dateUtils = DateUtils()
    func packageTsveResultsWithOneOccupied() -> [Oter] {
        let oter1 = Oter(startDate: dateUtils.createDate(dateString: "2020/01/15 00:00"), endDate: dateUtils.createDate(dateString: "2020/01/15 09:30"), ownerTaskId: "DUMMY-ID1", occupancyType: TSOType.VACANT)
        let oter2 = Oter(startDate: dateUtils.createDate(dateString: "2020/01/15 09:30"), endDate: dateUtils.createDate(dateString: "2020/01/15 10:30"), ownerTaskId: "DUMMY-ID1", occupancyType: TSOType.OCCUPIED)
        let oter3 = Oter(startDate: dateUtils.createDate(dateString: "2020/01/15 10:30"), endDate: dateUtils.createDate(dateString: "2020/01/16 00:00"), ownerTaskId: "DUMMY-ID1", occupancyType: TSOType.VACANT)
        
        return [oter1, oter2, oter3]
    }
    
    func packageTsveResultsWithThreeHoursOccupied() -> [Oter] {
        let oter1 = Oter(startDate: dateUtils.createDate(dateString: "2020/01/15 00:00"), endDate: dateUtils.createDate(dateString: "2020/01/15 09:30"), ownerTaskId: "DUMMY-ID1", occupancyType: TSOType.VACANT)
        let oter2 = Oter(startDate: dateUtils.createDate(dateString: "2020/01/15 09:30"), endDate: dateUtils.createDate(dateString: "2020/01/15 12:30"), ownerTaskId: "DUMMY-ID1", occupancyType: TSOType.OCCUPIED)
        let oter3 = Oter(startDate: dateUtils.createDate(dateString: "2020/01/15 12:30"), endDate: dateUtils.createDate(dateString: "2020/01/16 00:00"), ownerTaskId: "DUMMY-ID1", occupancyType: TSOType.VACANT)
        
        return [oter1, oter2, oter3]
    }
}
