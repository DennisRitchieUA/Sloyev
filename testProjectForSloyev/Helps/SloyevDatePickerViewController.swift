//
//  SloyevDatePickerViewController.swift
//  testProjectForSloyev
//
//  Created by Dennis Ritchie on 3/6/18.
//  Copyright © 2018 Dennis Ritchie. All rights reserved.
//

import UIKit
import DPLocalization

@objc protocol SloyevDatePickerViewControllerDelegate: UIPickerViewDelegate {
    @objc optional func pickerViewDidCancel(_ picker: UIDatePicker)
    func pickerViewDidDone(_ picker: UIDatePicker, date: Date)
}

class SloyevDatePickerViewController: UIViewController {
    
    let pickerViewDefaultY:CGFloat = 44.0 //default y position for date picker
    let pickerViewDefaultHeight:CGFloat = 216.0 //default height for picker view
    
    let defaultAnimationDuration:TimeInterval = 0.25 //default duration for animation
    
    let pickerToolBarDefaultHeight:CGFloat = 44.0 //default height for tool bar
    let pickerToolBarDefaultBackgroundColor:UIColor = UIColor(red: 73/255, green: 73/255, blue: 73/255, alpha: 1) //default color for toolbar
    
    let defaultBackgroundColor:UIColor = UIColor.black.withAlphaComponent(0.4) //default color for controller
    var pickerView = UIDatePicker()
    var delegate: SloyevDatePickerViewControllerDelegate?
    var containerView = UIView()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.setupStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupStyle()
    }
    
    func setupStyle() {
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overFullScreen
    }
    
    func topMostController() -> UIViewController {
        var topController = UIApplication.shared.keyWindow?.rootViewController
        
        while ((topController?.presentedViewController) != nil) {
            topController = topController?.presentedViewController
        }
        
        return topController!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = defaultBackgroundColor
        containerView.frame = CGRect(x: 0.0, y: self.view.frame.size.height + pickerViewDefaultHeight + pickerViewDefaultY, width: self.view.frame.size.width, height: pickerViewDefaultHeight + pickerViewDefaultY)
        
        pickerView.frame = CGRect(x: 0.0, y: pickerViewDefaultY, width: self.view.frame.size.width, height: pickerViewDefaultHeight)
        pickerView.backgroundColor = UIColor.lightGray
        pickerView.clipsToBounds = false
        
        let pickerToolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: pickerToolBarDefaultHeight))
        pickerToolBar.barStyle = .default
        pickerToolBar.isTranslucent = true
        pickerToolBar.tintColor = pickerToolBarDefaultBackgroundColor
        pickerToolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: DPAutolocalizedString("SloyevPicker_done", nil), style: .plain, target: self, action: #selector(doneAction))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: DPAutolocalizedString("SloyevPicker_cancel", nil), style: .plain, target: self, action: #selector(cancelAction))
        
        cancelButton.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.registrationPlaceholderColor(),
                                             NSAttributedStringKey.font : UIFont.defaultRegularFont()], for: .normal)
        doneButton.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.black,
                                           NSAttributedStringKey.font : UIFont.defaultBoldFont()], for: .normal)
        
        cancelButton.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.registrationPlaceholderColor(),
                                             NSAttributedStringKey.font : UIFont.defaultRegularFont()], for: .highlighted)
        doneButton.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.black,
                                           NSAttributedStringKey.font : UIFont.defaultBoldFont()], for: .highlighted)
        pickerToolBar.items = [cancelButton, spaceButton, doneButton]
        pickerToolBar.isUserInteractionEnabled = true
        
        let cancelTap = UITapGestureRecognizer(target: self, action: #selector(cancelAction))
        self.view.addGestureRecognizer(cancelTap)
        
        containerView.addSubview(pickerView)
        containerView.addSubview(pickerToolBar)
        self.view.addSubview(containerView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func present(delegate: SloyevDatePickerViewControllerDelegate, mode: UIDatePickerMode) {
        self.delegate = delegate
        pickerView.datePickerMode = mode
        
        let currentDate = Date()
        var dateComponnent = DateComponents()
        var minAge = SloyevGlobalVariables.minimumRegistrationAge
        if (minAge > 0) {
            minAge = minAge * -1
        }
        dateComponnent.setValue(minAge, for: Calendar.Component.year)
        pickerView.maximumDate = Calendar.current.date(byAdding: dateComponnent, to: currentDate)
        
        self.topMostController().present(self, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showPicker(animated: true)
    }
    
    private func showPicker(animated: Bool) {
        if (animated) {
            UIView.animate(withDuration: defaultAnimationDuration) {
                self.containerView.frame = CGRect(x: 0.0, y: self.view.frame.size.height - self.containerView.frame.size.height, width: self.containerView.frame.size.width, height: self.containerView.frame.size.height)
            }
        } else {
            containerView.frame = CGRect(x: 0.0, y: self.view.frame.size.height - containerView.frame.size.height, width: containerView.frame.size.width, height: containerView.frame.size.height)
        }
        
    }
    
    @objc private func doneAction() {
        UIView.animate(withDuration: defaultAnimationDuration, animations: {
            self.containerView.frame = CGRect(x: 0.0, y: self.view.frame.size.height + self.containerView.frame.size.height, width: self.containerView.frame.size.width, height: self.containerView.frame.size.height)
        }) { (finish) in
            if (finish) {
                self.dismiss(animated: true, completion: {
                    guard let delegate = self.delegate else {
                        return
                    }
                    delegate.pickerViewDidDone(self.pickerView, date: self.pickerView.date)
                })
            }
        }
    }
    
    @objc private func cancelAction() {
        UIView.animate(withDuration: defaultAnimationDuration, animations: {
            self.containerView.frame = CGRect(x: 0.0, y: self.view.frame.size.height + self.containerView.frame.size.height, width: self.containerView.frame.size.width, height: self.containerView.frame.size.height)
        }) { (finish) in
            if (finish) {
                self.dismiss(animated: true, completion: {
                    guard let delegate = self.delegate else {
                        return
                    }
                    if delegate.pickerViewDidCancel != nil {
                        delegate.pickerViewDidCancel!(self.pickerView)
                    }
                })
            }
        }
    }
}
