//
//  SloyevFonts.swift
//  testProjectForSloyev
//
//  Created by Dennis Ritchie on 3/5/18.
//  Copyright © 2018 Dennis Ritchie. All rights reserved.
//

import UIKit

extension UIFont {
    
    class func defaultRegularFont() -> UIFont {
        return  UIFont.systemFont(ofSize: 13.0, weight: UIFont.Weight.regular)
    }
    
    class func defaultBoldFont() -> UIFont {
        return  UIFont.systemFont(ofSize: 13.0, weight: UIFont.Weight.bold)
    }
}
