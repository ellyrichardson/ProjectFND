//
//  Observer.swift
//  ProjectFND
//
//  Created by Elly Richardson on 3/20/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

protocol Observer {
    var id : Int { get } // property to get an id
    func update<T>(with newValue: T)
}

protocol Observable {
    associatedtype T
    
    var value : T { get set }
    var observers : [Observer] { get set }
    /*
    func setValue(value: T)
    func getValue()
    func setObservers(observers: [Observer])
    func getObservers()
 */
    
    func addObserver(observer: Observer)
    func removeObserver(observer: Observer)
    func notifyAllObservers<T>(with newValue: T)
}
