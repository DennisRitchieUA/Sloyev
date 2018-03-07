//
//  SloyevRealPixelLayoutConstraint.swift
//  testProjectForSloyev
//
//  Created by Dennis Ritchie on 3/5/18.
//  Copyright © 2018 Dennis Ritchie. All rights reserved.
//

import UIKit

class SloyevRealPixelLayoutConstraint: NSLayoutConstraint {
    
    override init() {
        super.init()
    }
    
    override var constant: CGFloat {
        set {
            super.constant = constant / UIScreen.main.scale
        }
        get {
            return super.constant
        }
    }
}
