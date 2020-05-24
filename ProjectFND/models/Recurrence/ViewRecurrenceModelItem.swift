//
//  RecurrenceModelItem.swift
//  ProjectFND
//
//  Created by Elly Richardson on 5/23/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

class ViewRecurrenceDetailModelItem {
    private var item: RecurrenceDetailModel
    private var type: RecurrenceDetailType
    var isSelected = false
    
    var recurrenceDetail: String {
        return item.recurrenceDetail
    }
    
    var recurrenceType: RecurrenceDetailType {
        return item.recurrenceType
    }
    
    init(item: RecurrenceDetailModel) {
        self.item = item
        self.type = item.recurrenceType
    }
}
