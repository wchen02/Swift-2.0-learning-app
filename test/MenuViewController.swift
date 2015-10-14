//
//  MenuViewController.swift
//  test
//
//  Created by nluo on 6/3/15.
//  Copyright (c) 2015 nluo. All rights reserved.
//

import UIKit

class MenuViewController: UITableViewController {
    
    @IBOutlet weak var menuTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "goto_login") {
            let prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
            prefs.setBool(false, forKey: "IS_LOGGED_IN")
            prefs.synchronize()
            
            //let appDomain = NSBundle.mainBundle().bundleIdentifier
            //NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain!)
        }
    }
}