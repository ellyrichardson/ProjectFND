//
//  ViewEstimatedEffortModelItem.swift
//  ProjectFND
//
//  Created by Elly Richardson on 5/26/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

class ViewEstimatedEffortModelItem {
    private var item: EstimatedEffortModel
    var isSelected = false
    
    var estimatedEffortAmount: String {
        return item.estimatedEffortAmount
    }
    
    init(item: EstimatedEffortModel) {
        self.item = item
    }
}
