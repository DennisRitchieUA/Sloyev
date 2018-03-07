//
//  SloyevGlobalVariables.swift
//  testProjectForSloyev
//
//  Created by Dennis Ritchie on 3/6/18.
//  Copyright © 2018 Dennis Ritchie. All rights reserved.
//

import UIKit

class SloyevGlobalVariables: NSObject {
    static let minimumRegistrationAge: Int = 18 // minimum approved age for registration
    static let minimumWeight: Int = 25 // minimum approved weight for registration in kilograms
    static let maximumWeight: Int = 150 // maximum approved weight for registration in kilograms
    static let minimumGrowth: Int = 60 // minimum approved growth for registration in centimeters
    static let maximumGrowth: Int = 250 // maximum approved growth for registration in centimeters
    static let emailRegExp: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}" //RegExp for email address
    static let passwordRegExp: String = "(?=.*[A-Z])(?=.*[0-9])[A-Z0-9a-z]{8,20}$" //RegExpp for password//
    static let dayOfBirthDateFormat: String = "yyyy-MM-dd" // date format for birth day

}
