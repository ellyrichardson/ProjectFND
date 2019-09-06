//
//  StaticTableViewCell.swift
//  ProjectFND
//
//  Created by Elly Richardson on 9/4/19.
//  Copyright © 2019 EllyRichardson. All rights reserved.
//

// For the individual tableView Cells in the view
struct StaticTableCell {
    var name = String()
    var collapsed = Bool()
    
    init(collapsed: Bool = false, name: String?) {
        self.name = name ?? "default"
        self.collapsed = collapsed
    }
}
