//
//  SloyevProfileTableViewController.swift
//  testProjectForSloyev
//
//  Created by Dennis Ritchie on 3/7/18.
//  Copyright © 2018 Dennis Ritchie. All rights reserved.
//

import UIKit
import  DPLocalization
import Kingfisher
import MagicalRecord

class SloyevProfileTableViewController: UITableViewController {
    let tableHeaderViewHeight:CGFloat = 185 //Height for table view header
    let cellHeight:CGFloat = 47.0 //Height for cell
    
    let oneFieldCellIdentifier:String = "SloyevRegistrationOneFieldCell" //Reuse identifier for cell with one field
    let twoFieldCellIdentifier:String = "SloyevRegistrationTwoFieldCell" //Reuse identifier for cell with two field
    
    var dataSource: [FieldModel] = [FieldModel]()
    var genderDataSource: [PickerModel] = [PickerModel]()
    var weightDataSource: [PickerModel] = [PickerModel]()
    var growthDataSource: [PickerModel] = [PickerModel]()
    var pickerDataSource: [PickerModel] = [PickerModel]()
    
    @IBOutlet weak var tableViewHeaderView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupInterface()
        self.prepareInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func prepareInfo() {
        let user = UserProfile.mr_findFirst()?.mr_inThreadContext()
        avatarImageView.kf.setImage(with: user?.avatar)
        
        let loginFieldModel = FieldModel(icon: UIImage(named: "eyeImage")!, placeholder: DPAutolocalizedString("SloyevRegistrationTableViewController_login_field", nil), firstData: user?.login, cellType: .defaultCell, editable: false)
        let passwordFieldModel = FieldModel(icon: UIImage(named: "lockImage")!, placeholder: DPAutolocalizedString("SloyevRegistrationTableViewController_password_field", nil), isSecurityField: true, firstData: user?.password, cellType: .defaultCell)
        let approvePasswordFieldModel = FieldModel(icon: UIImage(named: "doubleLockImage")!, placeholder: DPAutolocalizedString("SloyevRegistrationTableViewController_approve_password_field", nil), isSecurityField: true, firstData: user?.password, cellType: .defaultCell)
        let firstAndSecondNamesFieldModel = FieldModel(icon: UIImage(named: "profileImage")!, placeholder: DPAutolocalizedString("SloyevRegistrationTableViewController_first_name_field", nil), secondPlaceholder: DPAutolocalizedString("SloyevRegistrationTableViewController_second_name_field", nil), firstData: user?.firstName, secondData: user?.lastName, cellType: .lettersFieldsCell)
        let gender = GenderType(rawValue: (user?.gender)!)
        let genderSelectFieldModel = FieldModel(icon: UIImage(named: "genderImage")!, placeholder: DPAutolocalizedString("SloyevRegistrationTableViewController_gender_field", nil), firstData: gender?.getLocalizateName(), cellType: .genderSelectionCell)
        let birthDaySelectFieldModel = FieldModel(icon: UIImage(named: "calendarImage")!, placeholder: DPAutolocalizedString("SloyevRegistrationTableViewController_birth_day_field", nil), firstData: DateFormatter.dateOfBirth(date: user?.birthDate as Date? ?? Date()), cellType: .birthSelecteCell)
        let bodyParametrsFieldModel = FieldModel(icon: UIImage(named: "heightManImage")!, placeholder: DPAutolocalizedString("SloyevRegistrationTableViewController_growth_field", nil), secondPlaceholder: DPAutolocalizedString("SloyevRegistrationTableViewController_weight_field", nil), firstData: "\(user?.weight ?? 0) \(DPAutolocalizedString("SloyevRegistrationTableViewController_select_growth_units", nil))", secondData: "\(user?.growth ?? 0) \(DPAutolocalizedString("SloyevRegistrationTableViewController_select_weight_units", nil))", cellType: .twoNumberPickerCell)
        
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
        
        self.tableView.keyboardDismissMode = .interactive
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
    
    @IBAction func logoutAction(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: DPAutolocalizedString("SloyevProfileTableViewController_question", nil), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: DPAutolocalizedString("SloyevProfileTableViewController_logout_cancel", nil), style: .cancel))
        alert.addAction(UIAlertAction(title: DPAutolocalizedString("SloyevProfileTableViewController_logout_yes", nil), style: .default, handler: { (action) in
            let context = NSManagedObjectContext.mr_default()
            UserProfile.mr_truncateAll(in: context)
            context.mr_saveToPersistentStore(completion: { (finished, error) in
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = self.storyboard?.instantiateInitialViewController()
            })
        }))
        self.present(alert, animated: true)
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
            cell.textField.isEnabled = model.editable
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

extension SloyevProfileTableViewController: UITextFieldDelegate {
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

extension SloyevProfileTableViewController: SloyevDatePickerViewControllerDelegate {
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

extension SloyevProfileTableViewController: SloyevStringPickerDataSource {
    func stringPickerView(_ pickerView: SloyevStringPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count
        
    }
    
    func stringPickerView(_ pickerView: SloyevStringPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let model = pickerDataSource[row]
        return model.name
    }
}

// MARK: - UISortTypePickerViewrDelegate
extension SloyevProfileTableViewController: SloyevStringPickerrDelegate {
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

extension SloyevProfileTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        avatarImageView.image = info[UIImagePickerControllerEditedImage] as? UIImage
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
