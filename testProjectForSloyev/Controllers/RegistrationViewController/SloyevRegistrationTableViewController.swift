//
//  SloyevRegistrationTableViewController.swift
//  testProjectForSloyev
//
//  Created by Dennis Ritchie on 3/5/18.
//  Copyright © 2018 Dennis Ritchie. All rights reserved.
//

import UIKit
import DPLocalization
import SVProgressHUD

public enum GenderType: String {
    case male = "male"
    case female = "female"
    
    func getLocalizateName() -> String {
        switch self {
        case .male:
            return DPAutolocalizedString("SloyevRegistrationTableViewController_select_gender_male", nil)
        case .female:
            return DPAutolocalizedString("SloyevRegistrationTableViewController_select_gender_female", nil)
        }
    }
}
public enum RegistrationCellType: Int {
    case defaultCell = 0 //Cell with one editable field
    case lettersFieldsCell = 1 //Cell with two editable letters field
    case genderSelectionCell = 2 //Cell with gender selection
    case birthSelecteCell = 3 //Cell with birth date select
    case twoNumberPickerCell = 4 //Cell with two numbers pickers
}

class FieldModel: NSObject {
    var icon:UIImage
    var placeholder: String
    var secondPlaceholder: String
    var isSecurityField: Bool = false
    var firstData: String
    var secondData: String
    var cellType: RegistrationCellType
    var keyboardType: UIKeyboardType = .default
    var returnBtn: UIReturnKeyType = .next
    var editable: Bool = true
    var firstPickerModel: PickerModel?
    var secondPickerModel: PickerModel?
    
    init(icon: UIImage, placeholder: String, secondPlaceholder: String? = "", isSecurityField: Bool? = false, firstData: String? = "", secondData: String? = "", cellType: RegistrationCellType, keyboardType: UIKeyboardType? = .default, editable: Bool? = true) {
        self.icon = icon
        self.placeholder = placeholder
        self.secondPlaceholder = secondPlaceholder!
        self.isSecurityField = isSecurityField!
        self.firstData = firstData!
        self.secondData = secondData!
        self.cellType = cellType
        self.keyboardType = keyboardType!
        self.editable = editable!
    }
    
    
}

class SloyevRegistrationTableViewController: UITableViewController {
    let tableHeaderViewHeight:CGFloat = 185 //Height for table view header
    let cellHeight:CGFloat = 47.0 //Height for cell
    let minTableFooterViewHeight:CGFloat = 57.0 //Height for table footer view

    let oneFieldCellIdentifier:String = "SloyevRegistrationOneFieldCell" //Reuse identifier for cell with one field
    let twoFieldCellIdentifier:String = "SloyevRegistrationTwoFieldCell" //Reuse identifier for cell with two field
    
    var dataSource: [FieldModel] = [FieldModel]()
    var genderDataSource: [PickerModel] = [PickerModel]()
    var weightDataSource: [PickerModel] = [PickerModel]()
    var growthDataSource: [PickerModel] = [PickerModel]()
    var pickerDataSource: [PickerModel] = [PickerModel]()

    @IBOutlet weak var tableViewHeaderView: UIView!
    @IBOutlet weak var tableFooterView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupDataSource()
        self.setupInterface()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupDataSource() {
        let loginFieldModel = FieldModel(icon: UIImage(named: "eyeImage")!, placeholder: DPAutolocalizedString("SloyevRegistrationTableViewController_login_field", nil), cellType: .defaultCell, keyboardType: .emailAddress)
        let passwordFieldModel = FieldModel(icon: UIImage(named: "lockImage")!, placeholder: DPAutolocalizedString("SloyevRegistrationTableViewController_password_field", nil), isSecurityField: true, cellType: .defaultCell)
        let approvePasswordFieldModel = FieldModel(icon: UIImage(named: "doubleLockImage")!, placeholder: DPAutolocalizedString("SloyevRegistrationTableViewController_approve_password_field", nil), isSecurityField: true, cellType: .defaultCell)
        let firstAndSecondNamesFieldModel = FieldModel(icon: UIImage(named: "profileImage")!, placeholder: DPAutolocalizedString("SloyevRegistrationTableViewController_first_name_field", nil), secondPlaceholder: DPAutolocalizedString("SloyevRegistrationTableViewController_second_name_field", nil), cellType: .lettersFieldsCell)
        let genderSelectFieldModel = FieldModel(icon: UIImage(named: "genderImage")!, placeholder: DPAutolocalizedString("SloyevRegistrationTableViewController_gender_field", nil), cellType: .genderSelectionCell)
        let birthDaySelectFieldModel = FieldModel(icon: UIImage(named: "calendarImage")!, placeholder: DPAutolocalizedString("SloyevRegistrationTableViewController_birth_day_field", nil), cellType: .birthSelecteCell)
        let bodyParametrsFieldModel = FieldModel(icon: UIImage(named: "heightManImage")!, placeholder: DPAutolocalizedString("SloyevRegistrationTableViewController_growth_field", nil), secondPlaceholder: DPAutolocalizedString("SloyevRegistrationTableViewController_weight_field", nil), cellType: .twoNumberPickerCell)
        dataSource = [loginFieldModel, passwordFieldModel, approvePasswordFieldModel, firstAndSecondNamesFieldModel, genderSelectFieldModel, birthDaySelectFieldModel, bodyParametrsFieldModel]
        self.tableView.reloadData()
        
        let maleGender = PickerModel(aditionalInfo: GenderType.male, name: DPAutolocalizedString("SloyevRegistrationTableViewController_select_gender_male", nil))
        let femaleGender = PickerModel(aditionalInfo: GenderType.female, name: DPAutolocalizedString("SloyevRegistrationTableViewController_select_gender_female", nil))
        genderDataSource = [maleGender, femaleGender]
        
        for i in SloyevGlobalVariables.minimumWeight ... SloyevGlobalVariables.maximumWeight {
            let weightModel = PickerModel(aditionalInfo: i, name: "\(i) \(DPAutolocalizedString("SloyevRegistrationTableViewController_select_weight_units", nil))")
            weightDataSource.append(weightModel)
        }
        
        for i in SloyevGlobalVariables.minimumGrowth ... SloyevGlobalVariables.maximumGrowth {
            let growthModel = PickerModel(aditionalInfo: i, name: "\(i) \(DPAutolocalizedString("SloyevRegistrationTableViewController_select_growth_units", nil))")
            growthDataSource.append(growthModel)
        }

    }
    
    private func setupInterface() {
        self.tableView.register(UINib(nibName: "SloyevRegistrationOneFieldCell", bundle: nil), forCellReuseIdentifier: oneFieldCellIdentifier)
        self.tableView.register(UINib(nibName: "SloyevRegistrationTwoFieldCell", bundle: nil), forCellReuseIdentifier: twoFieldCellIdentifier)
        
        tableViewHeaderView.frame.size.height = tableHeaderViewHeight
        self.tableView.tableHeaderView = tableViewHeaderView
        
        if let heightAndPositionNavigationBar = self.navigationController?.navigationBar.frame {
           let heightForFooterView = max((self.tableView.frame.size.height - (heightAndPositionNavigationBar.origin.y + heightAndPositionNavigationBar.size.height + tableHeaderViewHeight + CGFloat(dataSource.count) * cellHeight)), minTableFooterViewHeight)
             tableFooterView.frame.size.height = heightForFooterView
        }
        self.tableView.tableFooterView = tableFooterView
        
        self.tableView.keyboardDismissMode = .interactive
    }
    
    @IBAction func registrationAction(_ sender: Any) {
        self.view.endEditing(true)
        
        var params = [String: Any]()
        let modelLogin = dataSource[0]
        
        if (avatarImageView.image == nil) {
            self.presentMessage(message: DPAutolocalizedString("error_avatar_is_empty", nil))
            return
        }
        
        if (!self.validEmail(enteredEmail: modelLogin.firstData)) {
             self.presentMessage(message: DPAutolocalizedString("error_not_valid_email", nil))
            return
        }
        params["email"] = modelLogin.firstData
        
        let modelPassword = dataSource[1]
        if (!self.validatePassword(enteredPassword: modelPassword.firstData)) {
            self.presentMessage(message: DPAutolocalizedString("error_not_valid_password", nil))
            return
        }
        
        let approvePasswordModel = dataSource[2]
        if (modelPassword.firstData != approvePasswordModel.firstData) {
            self.presentMessage(message: DPAutolocalizedString("error_password_does_not_match", nil))
            return
        }
        params["password"] = modelPassword.firstData
        params["password2"] = approvePasswordModel.firstData
        
        let nameModel = dataSource[3]
        if (nameModel.firstData.count == 0) {
            self.presentMessage(message: DPAutolocalizedString("error_first_name_is_empty", nil))
            return
        }
        
        if (nameModel.secondData.count == 0) {
            self.presentMessage(message: DPAutolocalizedString("error_second_name_is_empty", nil))
            return
        }
        params["firstname"] = nameModel.firstData
        params["lastname"] = nameModel.secondData
        
        let genderModel = dataSource[4]
        if let modelPicker = genderModel.firstPickerModel {
            if let genderType = modelPicker.aditionalInfo as? GenderType {
                params["gender"] = genderType.rawValue
            }
        }else {
            self.presentMessage(message: DPAutolocalizedString("error_gender_is_empty", nil))
            return
        }
        
        let birthDayModel = dataSource[5]
        if (birthDayModel.firstData.count == 0) {
            self.presentMessage(message: DPAutolocalizedString("error_select_birth_date", nil))
            return
        }
        params["birthday"] = birthDayModel.firstData

        let growthAndWeightModel = dataSource[6]
        if let modelPicker = growthAndWeightModel.firstPickerModel {
                params["growth"] = modelPicker.aditionalInfo
        }else {
            self.presentMessage(message: DPAutolocalizedString("error_growth_is_empty", nil))
            return
        }
        
        if let modelPicker = growthAndWeightModel.secondPickerModel {
            params["weight"] = modelPicker.aditionalInfo
        }else {
            self.presentMessage(message: DPAutolocalizedString("error_weight_is_empty", nil))
            return
        }
        
        SVProgressHUD.show()
        SloyevAPIManager.registrationAction(params, avatar: avatarImageView.image!) { [weak self] (responseObject) in
            SVProgressHUD.dismiss()
            guard let strongSelf = self else { return }

            if (responseObject.error != nil) {
                strongSelf.presentMessage(message: responseObject.error?.localizedDescription ?? DPAutolocalizedString("error_unknowed_server_error", nil))
            } else {
                if let message = responseObject.message {
                    strongSelf.presentMessage(message: message, completionBlock: { (finished) in
                        strongSelf.navigationController?.popViewController(animated: true)
                    })
                } else {
                    strongSelf.navigationController?.popViewController(animated: true)
                }
            }
        }
        
        
    }
    
    @IBAction func selectAvatar(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        let alertController = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction.init(title: DPAutolocalizedString("SloyevRegistrationTableViewController_select_photo_cancel", nil), style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction.init(title: DPAutolocalizedString("SloyevRegistrationTableViewController_select_photo_from_camera", nil), style: .default, handler: { (action) in
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        }))
        alertController.addAction(UIAlertAction.init(title: DPAutolocalizedString("SloyevRegistrationTableViewController_select_photo_from_galerry", nil), style: .default, handler: { (action) in
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataSource[indexPath.row]
        switch model.cellType {
        case .defaultCell, .birthSelecteCell, .genderSelectionCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: oneFieldCellIdentifier, for: indexPath) as! SloyevRegistrationOneFieldCell
            cell.imageForIcon.image = model.icon
            cell.textField.attributedPlaceholder = NSAttributedString(string: model.placeholder, attributes: [NSAttributedStringKey.foregroundColor : UIColor.registrationPlaceholderColor()])
            cell.textField.isSecureTextEntry = model.isSecurityField
            cell.textField.keyboardType = model.keyboardType
            cell.textField.returnKeyType = model.returnBtn
            cell.textField.delegate = self
            if (model.firstData.count > 0) {
                cell.textField.text = model.firstData
            }
            return cell
        case .lettersFieldsCell, .twoNumberPickerCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: twoFieldCellIdentifier, for: indexPath) as! SloyevRegistrationTwoFieldCell
            cell.firstImageForIcon.image = model.icon
            cell.firstTextField.keyboardType = model.keyboardType
            cell.firstTextField.returnKeyType = model.returnBtn
            cell.secondTextField.keyboardType = model.keyboardType
            cell.secondTextField.returnKeyType = model.returnBtn
            
            cell.firstTextField.attributedPlaceholder = NSAttributedString(string: model.placeholder, attributes: [NSAttributedStringKey.foregroundColor : UIColor.registrationPlaceholderColor()])
            cell.secondTextField.attributedPlaceholder = NSAttributedString(string: model.secondPlaceholder, attributes: [NSAttributedStringKey.foregroundColor : UIColor.registrationPlaceholderColor()])
            
            if (model.cellType == .twoNumberPickerCell) {
                cell.separatorView.isHidden = true
            } else {
                cell.separatorView.isHidden = false
            }
            
            if (model.firstData.count > 0) {
                cell.firstTextField.text = model.firstData
            }
            
            if (model.secondData.count > 0) {
                cell.secondTextField.text = model.secondData
            }
            cell.firstTextField.delegate = self
            cell.secondTextField.delegate = self
            return cell
            
        }
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
}

extension SloyevRegistrationTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        avatarImageView.image = info[UIImagePickerControllerEditedImage] as? UIImage
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension SloyevRegistrationTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let textFieldPosition = textField.convert(CGPoint.zero, to: self.tableView)
        guard let indexPath = self.tableView.indexPathForRow(at: textFieldPosition) else {return false}
        let curentModel = dataSource[indexPath.row]
        if (curentModel.cellType == .lettersFieldsCell) {
            let cell = self.tableView.cellForRow(at: indexPath) as! SloyevRegistrationTwoFieldCell
            if (textField == cell.firstTextField) {
                cell.secondTextField.becomeFirstResponder()
                return true
            }
        }
        
        let indexPathNextRow = IndexPath(row: indexPath.row+1, section: indexPath.section)
        let model = dataSource[indexPathNextRow.row]
        if (model.cellType == .defaultCell || model.cellType == .birthSelecteCell || model.cellType == .genderSelectionCell) {
            let cell = self.tableView.cellForRow(at: indexPathNextRow) as! SloyevRegistrationOneFieldCell
            cell.textField.becomeFirstResponder()
        } else {
            let cell = self.tableView.cellForRow(at: indexPathNextRow) as! SloyevRegistrationTwoFieldCell
            cell.firstTextField.becomeFirstResponder()
        }
        
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let textFieldPosition = textField.convert(CGPoint.zero, to: self.tableView)
        guard let indexPath = self.tableView.indexPathForRow(at: textFieldPosition) else {return false}
        let model = dataSource[indexPath.row]
        switch model.cellType {
        case .defaultCell, .lettersFieldsCell:
            return true
        case .genderSelectionCell:
            self.view.endEditing(true)
            pickerDataSource = genderDataSource
            let stringPicker = SloyevStringPickerView(sender: textField)
            stringPicker.delegate = self
            stringPicker.dataSources = self
            self.present(stringPicker, animated: true)
            return false
        case .twoNumberPickerCell:
            let cell = self.tableView.cellForRow(at: indexPath) as! SloyevRegistrationTwoFieldCell
            self.view.endEditing(true)
            if (textField == cell.firstTextField) {
                pickerDataSource = growthDataSource
            } else {
                pickerDataSource = weightDataSource
            }
            
            let stringPicker = SloyevStringPickerView(sender: textField)
            stringPicker.delegate = self
            stringPicker.dataSources = self
            self.present(stringPicker, animated: true)
            
            return false
        case .birthSelecteCell:
            self.view.endEditing(true)
            let datePicker = SloyevDatePickerViewController()
            datePicker.present(delegate: self, mode: .date)
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
        let textFieldPosition = textField.convert(CGPoint.zero, to: self.tableView)
        guard let indexPath = self.tableView.indexPathForRow(at: textFieldPosition) else {return}
        let model = dataSource[indexPath.row]
            if (model.cellType == .defaultCell) {
                model.firstData = text
            } else if (model.cellType == .lettersFieldsCell) {
                let cell = self.tableView.cellForRow(at: indexPath) as! SloyevRegistrationTwoFieldCell
                if (textField == cell.firstTextField) {
                    model.firstData = text
                } else if (textField == cell.secondTextField) {
                    model.secondData = text
                }
            }
        }
        
    }
}

extension SloyevRegistrationTableViewController: SloyevDatePickerViewControllerDelegate {
    func pickerViewDidDone(_ picker: UIDatePicker, date: Date) {
        let sortedModels = dataSource.flatMap { (model) -> FieldModel? in
            if (model.cellType == .birthSelecteCell) {
                return model
            }
            return nil
        }
        if let model = sortedModels.first {
            model.firstData = DateFormatter.dateOfBirth(date: date)
            self.tableView.reloadData()
        }
    }
}

extension SloyevRegistrationTableViewController: SloyevStringPickerDataSource {
    func stringPickerView(_ pickerView: SloyevStringPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count

    }
    
    func stringPickerView(_ pickerView: SloyevStringPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let model = pickerDataSource[row]
        return model.name
    }
}

// MARK: - UISortTypePickerViewrDelegate
extension SloyevRegistrationTableViewController: SloyevStringPickerrDelegate {
    func stringPickerView(_ pickerView: SloyevStringPickerView, didSelectRow row: Int, inComponent component: Int, sender: Any) {
        guard let field = sender as? UITextField else { return }
        let textFieldPosition = field.convert(CGPoint.zero, to: self.tableView)
        guard let indexPath = self.tableView.indexPathForRow(at: textFieldPosition) else {return}
        
        let pickerModel = pickerDataSource[row]
        let model = dataSource[indexPath.row]
        
        if (model.cellType == .twoNumberPickerCell) {
            let cell = self.tableView.cellForRow(at: indexPath) as! SloyevRegistrationTwoFieldCell
            if (field == cell.firstTextField) {
                model.firstPickerModel = pickerModel
                model.firstData = pickerModel.name
            } else {
                model.secondPickerModel = pickerModel
                model.secondData = pickerModel.name
            }
        } else {
            model.firstData = pickerModel.name
            model.firstPickerModel = pickerModel
        }
        self.tableView.reloadData()
    }
}
