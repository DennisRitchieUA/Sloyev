//
//  SloyevViewControllerExtension.swift
//  testProjectForSloyev
//
//  Created by Dennis Ritchie on 3/5/18.
//  Copyright © 2018 Dennis Ritchie. All rights reserved.
//

import UIKit
import DPLocalization
extension UIViewController {
    
    class var storyboardIdentifier: String {
        return String(describing: self)
    }
    
    
    func presentMessage(message: String, completionBlock: ((Bool) -> ())? = nil) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: DPAutolocalizedString("alert_done_bnt", nil), style: .cancel, handler: { (action) in
            if let complete = completionBlock {
                complete(true)
            }
        }))
        self.present(alert, animated: true)
    }
    
    
    func validEmail(enteredEmail:String) -> Bool {
        if (enteredEmail.count == 0) {
            self.presentMessage(message: DPAutolocalizedString("error_empty_email", nil))
            return false
        }
        
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", SloyevGlobalVariables.emailRegExp)
        return emailPredicate.evaluate(with: enteredEmail)
    }
    
    func validateEmailWithComplete(enteredEmail:String, completionBlock: @escaping ((Bool) -> ())) {
        if (enteredEmail.count == 0) {
            self.presentMessage(message: DPAutolocalizedString("error_empty_email", nil), completionBlock: { (finished) in
                if (finished) {
                    completionBlock(false)
                }
            })
        }
        
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", SloyevGlobalVariables.emailRegExp)
        if (!emailPredicate.evaluate(with: enteredEmail)) {
            self.presentMessage(message: DPAutolocalizedString("error_not_valid_email", nil), completionBlock: { (finished) in
                if (finished) {
                    completionBlock(false)
                }
            })
        } else {
            completionBlock(true)
        }
    }
    
    func validatePassword(enteredPassword: String) -> Bool {
        if (enteredPassword.count == 0) {
            self.presentMessage(message: DPAutolocalizedString("error_empty_password", nil))
            return false
        }
        
        let passwordPredicate = NSPredicate(format:"SELF MATCHES %@", SloyevGlobalVariables.passwordRegExp)
        return passwordPredicate.evaluate(with: enteredPassword)
    }
}
