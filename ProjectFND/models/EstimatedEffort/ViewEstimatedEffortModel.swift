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
        EstimatedEffortModel(estimatedEffortAmount: "8.0"),
        EstimatedEffortModel(estimatedEffortAmount: "8.5"),
        EstimatedEffortModel(estimatedEffortAmount: "9.0"),
        EstimatedEffortModel(estimatedEffortAmount: "9.5"),
        EstimatedEffortModel(estimatedEffortAmount: "10.0"),
        EstimatedEffortModel(estimatedEffortAmount: "10.5"),
        EstimatedEffortModel(estimatedEffortAmount: "11.0"),
        EstimatedEffortModel(estimatedEffortAmount: "11.5"),
        EstimatedEffortModel(estimatedEffortAmount: "12.0"),
        EstimatedEffortModel(estimatedEffortAmount: "12.5"),
        EstimatedEffortModel(estimatedEffortAmount: "13.0"),
        EstimatedEffortModel(estimatedEffortAmount: "13.5"),
        EstimatedEffortModel(estimatedEffortAmount: "14.0"),
        EstimatedEffortModel(estimatedEffortAmount: "14.5"),
        EstimatedEffortModel(estimatedEffortAmount: "15.0"),
        EstimatedEffortModel(estimatedEffortAmount: "15.5"),
        EstimatedEffortModel(estimatedEffortAmount: "16.0")]
    }
}
