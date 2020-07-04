//
//  DetachedVCDelegate.swift
//  ProjectFND
//
//  Created by Elly Richardson on 7/4/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import UIKit

/*
 NOTE: Make this protocol be generic, and have other detachedVCDelegates inherit from this
 */
protocol DetachedVCDelegate: class {
    func transitionToNextVC()
    func setIntervalHours(intervalHours: Int)
    func setIntervalDays(intervalDays: Int)
}
