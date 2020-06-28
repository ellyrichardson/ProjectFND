//
//  Observer.swift
//  ProjectFND
//
//  Created by Elly Richardson on 3/20/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

protocol Observer {
    var observerId : Int { get } // property to get an id
    func update<T>(with newValue: T, with observableType: ObservableType)
}
