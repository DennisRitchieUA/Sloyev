//
//  SloyevDateFormatterExtension.swift
//  testProjectForSloyev
//
//  Created by Dennis Ritchie on 3/6/18.
//  Copyright © 2018 Dennis Ritchie. All rights reserved.
//

import UIKit

extension DateFormatter {
    
    static func dateOfBirth(date: Date) -> String {
        let df = DateFormatter()
        df.dateFormat = SloyevGlobalVariables.dayOfBirthDateFormat
        return df.string(from: date)
    }
    
    static func dateOfBirth(date: String) -> Date {
        let df = DateFormatter()
        df.dateFormat = SloyevGlobalVariables.dayOfBirthDateFormat
        return df.date(from: date)!
    }
    
}

