//
//  Structs.swift
//  ProjectFND
//
//  Created by Elly Richardson on 5/23/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import UIKit

struct RecurrenceDetailModel {
    var recurrenceDetail: String
    var recurrenceType: RecurrenceDetailType
}

struct EstimatedEffortModel {
    var estimatedEffortAmount: String
}

struct ToDoDate {
    var dateValue: Date?
    var assigned: Bool
    //var observableType: ObservableType
}

struct ToDoTags {
    var tagValue: String?
    var assigned: Bool
    //var observableType: ObservableType
}

// MARK: - Time Scheduling

struct Oter {
    var startDate: Date
    var endDate: Date
    var ownerTaskId: String
    var occupancyType: TSOType
}
