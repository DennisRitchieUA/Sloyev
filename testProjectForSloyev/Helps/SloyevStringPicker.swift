//
//  SloyevStringPickerView.swift
//  testProjectForSloyev
//
//  Created by Dennis Ritchie on 3/6/18.
//  Copyright © 2018 Dennis Ritchie. All rights reserved.
//

import UIKit
import DPLocalization

class PickerModel: NSObject {
    let aditionalInfo: Any
    let name: String
    
    init(aditionalInfo: Any, name: String) {
        self.aditionalInfo = aditionalInfo
        self.name = name
        super.init()
    }
}

// MARK: - Protocol
@objc protocol SloyevStringPickerrDelegate {
    func stringPickerView(_ pickerView: SloyevStringPickerView, didSelectRow row: Int, inComponent component: Int, sender: Any)
    @objc optional func stringPickerViewDidCancel(_ pickerView: SloyevStringPickerView, sender: Any)
}

// MARK: - Protocol
@objc protocol SloyevStringPickerDataSource {
    @objc optional func numberOfComponents(in pickerView: SloyevStringPickerView) -> Int
    func stringPickerView(_ pickerView: SloyevStringPickerView, numberOfRowsInComponent component: Int) -> Int
    func stringPickerView(_ pickerView: SloyevStringPickerView, titleForRow row: Int, forComponent component: Int) -> String?
}

class SloyevStringPickerView: UIViewController {
    let pickerViewDefaultY:CGFloat = 44.0 //default y position for date picker
    let pickerViewDefaultHeight:CGFloat = 216.0 //default height for picker view
    
    let defaultAnimationDuration:TimeInterval = 0.25 //default duration for animation
    
    let pickerToolBarDefaultHeight:CGFloat = 44.0 //default height for tool bar
    let pickerToolBarDefaultBackgroundColor:UIColor = UIColor(red: 73/255, green: 73/255, blue: 73/255, alpha: 1) //default color for toolbar
    
    let defaultBackgroundColor:UIColor = UIColor.black.withAlphaComponent(0.4) //default color for controller

    weak var delegate: SloyevStringPickerrDelegate? = nil
    weak var dataSources: SloyevStringPickerDataSource? = nil
    
    private var containerView = UIView()
    var pickerView = UIPickerView()
    private var component: Int = 0
    private var row: Int = 0
    private var sender: Any!
    
    func topMostController() -> UIViewController {
        var topController = UIApplication.shared.keyWindow?.rootViewController
        
        while ((topController?.presentedViewController) != nil) {
            topController = topController?.presentedViewController
        }
        
        return topController!
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.setupStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupStyle()
    }
    
    convenience init (sender: Any) {
        self.init()
        self.sender = sender
        self.setupStyle()
    }
    
    func setupStyle() {
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overFullScreen
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
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
        
        UIView.animate(withDuration: 0.25, animations: {
            self.containerView.frame = CGRect(x: 0.0, y: self.view.frame.size.height + self.containerView.frame.size.height, width: self.containerView.frame.size.width, height: self.containerView.frame.size.height)
        }) { (finish) in
            if (finish) {
                
                self.dismiss(animated: true, completion: {
                    if let method = self.delegate?.stringPickerView {
                        return method(self, self.row, self.component, self.sender)
                    }
                })
            }
        }
    }
    
    @objc private func cancelAction() {
        UIView.animate(withDuration: 0.25, animations: {
            self.containerView.frame = CGRect(x: 0.0, y: self.view.frame.size.height + self.containerView.frame.size.height, width: self.containerView.frame.size.width, height: self.containerView.frame.size.height)
        }) { (finish) in
            if (finish) {
                self.dismiss(animated: true, completion: {
                    if let method = self.delegate?.stringPickerViewDidCancel?(self, sender: self.sender) {
                        return method
                    }
                })
            }
        }
    }
    
    func present(delegate: SloyevStringPickerrDelegate, dataSource: SloyevStringPickerDataSource) {
        self.delegate = delegate
        self.dataSources = dataSource
        self.topMostController().present(self, animated: true, completion: nil)
    }
}

extension SloyevStringPickerView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if let method = self.dataSources?.numberOfComponents?(in: self) {
            return method
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let method = self.dataSources?.stringPickerView(self, numberOfRowsInComponent: component) {
            return method
        }
        return 0
    }
}

extension SloyevStringPickerView: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.component = component
        self.row = row
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if let method = self.dataSources?.stringPickerView(self, titleForRow: row, forComponent: component) {
            return method
        }
        return ""
    }
}
