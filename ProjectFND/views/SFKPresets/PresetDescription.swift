//
//  PresetDescription.swift
//  ProjectFND
//
//  Created by Elly Richardson on 5/16/20.
//  Copyright © 2020 EllyRichardson. All rights reserved.
//

import SwiftEntryKit

// Description of a single preset to be presented
struct PresetDescription {
    let title: String
    let description: String
    let thumb: String
    let attributes: EKAttributes
    
    init(with attributes: EKAttributes, title: String, description: String = "", thumb: String) {
        self.attributes = attributes
        self.title = title
        self.description = description
        self.thumb = thumb
    }
}
