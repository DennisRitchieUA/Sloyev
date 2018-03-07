//
//  SloyevLoginCell.swift
//  testProjectForSloyev
//
//  Created by Dennis Ritchie on 3/5/18.
//  Copyright © 2018 Dennis Ritchie. All rights reserved.
//

import UIKit
import DPLocalization

class SloyevLoginCell: UITableViewCell {
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupInterface()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.setupInterface()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    private func setupInterface() {
        loginField.attributedPlaceholder = NSAttributedString(string: DPAutolocalizedString("SloyevLoginTableViewController_login_field", nil), attributes: [NSAttributedStringKey.foregroundColor : UIColor.defaultPing()])
        passwordField.attributedPlaceholder = NSAttributedString(string: DPAutolocalizedString("SloyevLoginTableViewController_password_field", nil), attributes: [NSAttributedStringKey.foregroundColor : UIColor.defaultPing()])
    }
    
}
