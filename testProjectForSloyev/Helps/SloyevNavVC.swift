//
//  SloyevNavVC.swift
//  testProjectForSloyev
//
//  Created by Dennis Ritchie on 3/5/18.
//  Copyright © 2018 Dennis Ritchie. All rights reserved.
//

import UIKit

class SloyevNavVC: UINavigationController {
    static let navVCFont: UIFont = UIFont.defaultRegularFont()
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        self.setupStyle()
    }
    
    override init(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
        super.init(navigationBarClass: navigationBarClass, toolbarClass: toolbarClass)
        self.setupStyle()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.setupStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupStyle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func setupStyle() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: .plain, target: nil, action: nil)
        self.navigationBar.isTranslucent = false
        self.navigationBar.barTintColor = UIColor.white
        self.navigationBar.tintColor = UIColor.black
//        self.navigationBar.shadowImage = UIImage()
//        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: SloyevNavVC.navVCFont]
    }
    
    override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        super.setViewControllers(viewControllers, animated: animated)
        
        for vc in viewControllers {
            vc.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        viewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
