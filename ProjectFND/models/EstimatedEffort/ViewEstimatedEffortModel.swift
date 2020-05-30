//
//  ViewEstimatedEffortModel.swift
//  ProjectFND
//
//  Created by Elly Richardson on 5/26/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import UIKit

class ViewEstimatedEffortModel: NSObject {
    var items = [ViewEstimatedEffortModelItem]()
    
    override init() {
        super.init()
        items = getEstimatedEffortList().map { ViewEstimatedEffortModelItem(item: $0) }
    }
    
    func getEstimatedEffortList() -> [EstimatedEffortModel] {
        return [EstimatedEffortModel(estimatedEffortAmount: "0.5"),
        EstimatedEffortModel(estimatedEffortAmount: "1.0"),
        EstimatedEffortModel(estimatedEffortAmount: "1.5"),
        EstimatedEffortModel(estimatedEffortAmount: "2.0"),
        EstimatedEffortModel(estimatedEffortAmount: "2.5"),
        EstimatedEffortModel(estimatedEffortAmount: "3.0"),
        EstimatedEffortModel(estimatedEffortAmount: "3.5"),
        EstimatedEffortModel(estimatedEffortAmount: "4.0"),
        EstimatedEffortModel(estimatedEffortAmount: "4.5"),
        EstimatedEffortModel(estimatedEffortAmount: "5.0"),
        EstimatedEffortModel(estimatedEffortAmount: "5.5"),
        EstimatedEffortModel(estimatedEffortAmount: "6.0"),
        EstimatedEffortModel(estimatedEffortAmount: "6.5"),
        EstimatedEffortModel(estimatedEffortAmount: "7.0"),
        EstimatedEffortModel(estimatedEffortAmount: "7.5"),
        EstimatedEffortModel(estimatedEffortAmount: "8.0")]
    }
}
