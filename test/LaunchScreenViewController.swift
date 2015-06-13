//
//  LaunchScreenViewController.swift
//  test
//
//  Created by nluo on 6/12/15.
//  Copyright (c) 2015 nluo. All rights reserved.
//

import UIKit

class LaunchScreenViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        let prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let isLoggedIn: Bool = prefs.boolForKey("IS_LOGGED_IN")
        if (isLoggedIn) {
            self.performSegueWithIdentifier("goto_home", sender: self)
        } else {
            self.performSegueWithIdentifier("goto_login", sender: self)
        }
    }
}