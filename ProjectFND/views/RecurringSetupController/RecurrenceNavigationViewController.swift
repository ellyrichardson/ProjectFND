//
//  RecurrenceNavigationViewController.swift
//  ProjectFND
//
//  Created by Elly Richardson on 5/16/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import UIKit
import SwiftEntryKit

class RecurrenceNavigationViewController: UINavigationController {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        navigationBar.tintColor = EKColor.navigationItemColor.color(for: traitCollection, mode: .inferred)
    }
    
    
}
