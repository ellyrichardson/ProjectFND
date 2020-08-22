//
//  ItemInfoViewPresenter.swift
//  ProjectFND
//
//  Created by Elly Richardson on 8/22/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import Foundation

class ItemInfoViewPresenter {
    weak private var itemInfoViewDelegate: ItemInfoViewDelegate?
    
    func setViewDelegate(itemInfoViewDelegate: ItemInfoViewDelegate) {
        self.itemInfoViewDelegate = itemInfoViewDelegate
        //configureViewDelegate()
    }
}
