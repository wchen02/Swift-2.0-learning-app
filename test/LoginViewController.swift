//
//  LoginViewController.swift
//  test
//
//  Created by nluo on 6/12/15.
//  Copyright (c) 2015 nluo. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, APIControllerProtocol {
    
    var api : APIController!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var prefs: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        api = APIController(delegate: self)
        if let username = prefs.objectForKey("USERNAME") as? String {
            usernameTextField.text = username
        }
    }
    
    @IBAction func signInButtonPressed(sender: AnyObject) {
        var username: String = usernameTextField.text
        var password: String = passwordTextField.text
        
        if username == "" || password == "" {
            self.showAlert("Sign in Failed!", message: "Please enter Username and Password")
        } else {
            if username == "Nan" && password == "Luo" {
                prefs.setObject(username, forKey: "USERNAME")
                prefs.setBool(true, forKey: "IS_LOGGED_IN")
                prefs.synchronize()
                
                self.performSegueWithIdentifier("goto_home", sender: self)
            } else {
                self.showAlert("Sign in Failed!", message: "Username and password combination does not exist.")
            }
            //let data: [String: String] = ["username": username, "password": password]
            //api.post(data, url: "http://localhost.test.com/login.php")
        }
    }
    
    func didReceiveAPIResults(results: AnyObject) {
        let resultsDict = results as! Dictionary<String, AnyObject>
        var username: String = usernameTextField.text
        print(resultsDict["message"])
        if let success = resultsDict["success"] as? Bool {
            prefs.setObject(username, forKey: "USERNAME")
            prefs.setBool(true, forKey: "IS_LOGGED_IN")
            prefs.synchronize()
            
            self.performSegueWithIdentifier("goto_home", sender: self)
        } else {
            if let message = resultsDict["message"] as? String {
                self.showAlert("Sign in Failed!", message: message)
            }
        }
    }
    
    func showAlert(title: String, message: String) {
        var titlePrompt = UIAlertController(title: title,
            message: message,
            preferredStyle: .Alert)
        titlePrompt.addAction(UIAlertAction(title: "Ok",
            style: .Default,
            handler: nil))
        self.presentViewController(titlePrompt,
            animated: true,
            completion: nil)
    }
}