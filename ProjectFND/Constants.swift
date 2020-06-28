//
//  Constants.swift
//  ProjectFND
//
//  Created by Elly Richardson on 3/21/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

enum ListModificationType {
    case ADD
    case UPDATE
    case REMOVE
    case FINISHNESS
    case IMPORTANT
    case NOTIFICATION
}

enum TaskTypes: String {
    case PERSONAL = "Personal"
    case SCHOOL = "School"
    case WORK = "Work"
}

enum TaskStatuses {
    case FINISHED
    case INPROGRESS
    case OVERDUE
}

enum RecurrenceDetailType {
    case DAILY
    case WEEKLY
    case MONTHLY
    case YEARLY
}

enum SimpleStaticTVCReturnType {
    case RECURRENCE
    case ESTIMATED_EFFORT
}

enum ObservableType {
    case TODO_DUE_DATE
    case TODO_TAG
    case TODO_LIST
    case OTER
    case TASK
    case BASE
}

// TimeSlotOccupanyType
enum TSOType {
    case OCCUPIED
    case VACANT
    case FILLER
}
