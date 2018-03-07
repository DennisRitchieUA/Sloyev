//
//  SloyevLoginTableViewController.swift
//  testProjectForSloyev
//
//  Created by Dennis Ritchie on 3/5/18.
//  Copyright © 2018 Dennis Ritchie. All rights reserved.
//

import UIKit
import DPLocalization
import SVProgressHUD

class LoginModel: NSObject {
    var login: String = ""
    var password: String = ""
    
    override init() {
        super.init()
    }
}
class SloyevLoginTableViewController: UITableViewController {
    
    let dataForEnterViewHeight:CGFloat = 34.0 //Height view with label "Данные для входа"
    let loginCellReuseIdentifier:String = "SloyevLoginCell" //Reuse identifier login cell
    let estimateHeightLoginCells:CGFloat = 93.0 //Estimate height cell with login fields
    let deltaForHeaderView:CGFloat = 3.3 //Delta for calculate height for heder view
    
    @IBOutlet weak var tableViewHeaderView: UIView!
    @IBOutlet weak var tableViewFooterView: UIView!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var forgetPasswordBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    var loginModel = LoginModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInterface()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupInterface() {
        self.tableView.keyboardDismissMode = .interactive
        tableViewHeaderView.frame.size.height = CGFloat(ceil(Float(UIScreen.main.bounds.size.height / deltaForHeaderView))) + dataForEnterViewHeight
        self.tableView.tableHeaderView = tableViewHeaderView
        
        if let heightAndPositionNavigationBar = self.navigationController?.navigationBar.frame {
            tableViewFooterView.frame.size.height = self.tableView.frame.size.height - (tableViewHeaderView.frame.size.height + estimateHeightLoginCells + heightAndPositionNavigationBar.origin.y + heightAndPositionNavigationBar.size.height)
        }
        self.tableView.tableFooterView = tableViewFooterView
        
        let str = "\(DPAutolocalizedString("SloyevLoginTableViewController_dont_have_acc", nil)) \(DPAutolocalizedString("SloyevLoginTableViewController_register", nil))"
        let attributeString = NSMutableAttributedString.init(string: str)
        var range = (str as NSString).range(of: DPAutolocalizedString("SloyevLoginTableViewController_dont_have_acc", nil))
        attributeString.addAttribute(NSAttributedStringKey.font, value:  UIFont.defaultRegularFont(), range: range)
        range = (str as NSString).range(of: DPAutolocalizedString("SloyevLoginTableViewController_register", nil))
        attributeString.addAttribute(NSAttributedStringKey.font, value:  UIFont.defaultBoldFont(), range: range)
        registerBtn.setAttributedTitle(attributeString, for: .normal)
    }
    
    @IBAction func loginAction(_ sender: Any) {
        self.view.endEditing(true)
        
        var params = [String: Any]()
        
        if (!self.validEmail(enteredEmail: loginModel.login)) {
            self.presentMessage(message: DPAutolocalizedString("error_not_valid_email", nil))
            return
        }
        params["email"] = loginModel.login
        
        
        if (!self.validatePassword(enteredPassword: loginModel.password)) {
            self.presentMessage(message: DPAutolocalizedString("error_not_valid_password", nil))
            return
        }
        params["password"] = loginModel.password
        
        SVProgressHUD.show()
        SloyevAPIManager.loginAction(params) { [weak self] (responseObject) in
            SVProgressHUD.dismiss()
            guard let strongSelf = self else { return }
            if (responseObject.error != nil) {
                strongSelf.presentMessage(message: responseObject.error?.localizedDescription ?? DPAutolocalizedString("error_unknowed_server_error", nil))
            } else {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = SloyevNavVC(rootViewController: (strongSelf.storyboard?.instantiateViewController(withIdentifier: SloyevProfileTableViewController.storyboardIdentifier))!)
            }
        }
    }
    
    @IBAction func forgetPasswordAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let alert = UIAlertController(title: nil, message: DPAutolocalizedString("SloyevLoginTableViewController_forget_password_alert_message", nil), preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: { (textField) in
            textField.attributedPlaceholder = NSAttributedString(string: DPAutolocalizedString("SloyevLoginTableViewController_login_field", nil), attributes: [NSAttributedStringKey.foregroundColor : UIColor.defaultPing()])
            textField.keyboardType = .emailAddress
            textField.returnKeyType = .done
        })
        
        alert.addAction(UIAlertAction(title: DPAutolocalizedString("SloyevLoginTableViewController_forget_password_alert_cancel_done", nil), style: .default, handler: { (action) in
            guard let field = alert.textFields?.first else {return}
            self.validateEmailWithComplete(enteredEmail: field.text ?? "", completionBlock: { (isValidEmail) in
                if (isValidEmail) {
                    self.presentMessage(message: DPAutolocalizedString("SloyevLoginTableViewController_forget_password_success", nil))
                } else {
                    self.forgetPasswordAction(self.forgetPasswordBtn)
                }
            })
        }))
        
        alert.addAction(UIAlertAction(title: DPAutolocalizedString("SloyevLoginTableViewController_forget_password_alert_cancel_btn", nil), style: .cancel))
        self.present(alert, animated: true)
    }
    
    @IBAction func registerAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: SloyevRegistrationTableViewController.storyboardIdentifier)
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: loginCellReuseIdentifier, for: indexPath) as! SloyevLoginCell
        cell.loginField.delegate = self
        cell.passwordField.delegate = self
        
        if (!loginModel.login.isEmpty) {
            cell.loginField.text = loginModel.login
        }
        
        if (!loginModel.password.isEmpty) {
            cell.passwordField.text = loginModel.password
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return estimateHeightLoginCells
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

extension SloyevLoginTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! SloyevLoginCell

        if (textField == cell.loginField) {
            cell.passwordField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! SloyevLoginCell
        
        if (textField == cell.loginField) {
            loginModel.login = textField.text!
        } else {
            loginModel.password = textField.text!
        }
    }
}
