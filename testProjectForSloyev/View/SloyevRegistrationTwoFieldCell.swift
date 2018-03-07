//
//  SloyevRegistrationTwoFieldCell.swift
//  testProjectForSloyev
//
//  Created by Dennis Ritchie on 3/6/18.
//  Copyright © 2018 Dennis Ritchie. All rights reserved.
//

import UIKit

class SloyevRegistrationTwoFieldCell: UITableViewCell {
    @IBOutlet weak var firstImageForIcon: UIImageView!
    @IBOutlet weak var firstTextField: UITextField!
    
    @IBOutlet weak var secondTextField: UITextField!
    @IBOutlet weak var separatorView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
