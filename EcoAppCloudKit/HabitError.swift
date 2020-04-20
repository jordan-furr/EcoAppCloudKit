//
//  HabitError.swift
//  EcoAppCloudKit
//
//  Created by Jordan Furr on 4/19/20.
//  Copyright © 2020 Jordan Furr. All rights reserved.
//

import Foundation

enum HabitError: LocalizedError {
    case ckError(Error)
    case couldNotUnwrap
    case unexpectedRecords
}
