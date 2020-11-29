//
//  BaseViewController.swift
//  Real
//
//  Created by 唐紹桓 on 2020/11/30.
//

import UIKit
import IQKeyboardManager

class BaseViewController: UIViewController {
    
    var segues: [String] {
        
        return []
    }
    
    var isHideTabBar: Bool {
        
        return false
    }
    
    var isHideNavigationBar: Bool {
        
        return false
    }
    
    var isHideBackButton: Bool {
        
        return false
    }
    
    var isHideKeyboardToolbarPlaceholder: Bool {
        
        return true
    }
    
    var isHideKeyboardAutoToolbar: Bool {
        
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.sendAction(
            #selector(UIApplication.resignFirstResponder),
            to: nil, from: nil, for: nil
        )
        
        self.tabBarController?.tabBar.isHidden = isHideTabBar
        
        self.navigationController?.isNavigationBarHidden = isHideNavigationBar
        
        self.navigationItem.hidesBackButton = isHideBackButton
        
        IQKeyboardManager.shared().shouldShowToolbarPlaceholder = !isHideKeyboardToolbarPlaceholder
        
        IQKeyboardManager.shared().isEnableAutoToolbar = !isHideKeyboardAutoToolbar
        
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
    }
}