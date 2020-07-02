//
//  ScheduleIntervalizerNavVC.swift
//  ProjectFND
//
//  Created by Elly Richardson on 7/1/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import UIKit
import SwiftEntryKit

class ScheduleIntervalizerNavVC: UINavigationController {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        navigationBar.tintColor = EKColor.navigationItemColor.color(for: traitCollection, mode: .inferred)
    }
}
