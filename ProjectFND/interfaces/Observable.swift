//
//  Observable.swift
//  ProjectFND
//
//  Created by Elly Richardson on 3/22/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

protocol Observable {
    associatedtype T
    
    var value : T { get set }
    var observers : [Observer] { get set }
    
    func addObserver(observer: Observer)
    func removeObserver(observer: Observer)
    func notifyAllObservers<T>(with newValue: T)
}
