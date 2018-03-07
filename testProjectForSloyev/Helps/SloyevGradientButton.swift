//
//  SloyevGradientButton.swift
//  testProjectForSloyev
//
//  Created by Dennis Ritchie on 3/6/18.
//  Copyright © 2018 Dennis Ritchie. All rights reserved.
//

import UIKit

class SloyevGradientButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        setupStyle()
    }
    
    private func setupStyle() {
        let gradient:CAGradientLayer = CAGradientLayer()
        let color1 = UIColor.colorFromHex(hex: "#49defe").cgColor as CGColor
        let color2 = UIColor.colorFromHex(hex: "#5179f7").cgColor as CGColor
        
        gradient.colors = [color1, color2]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.frame = self.bounds
        
        self.layer.insertSublayer(gradient, at: 0)
    }
}
