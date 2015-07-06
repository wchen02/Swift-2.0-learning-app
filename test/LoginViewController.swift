//
//  LoginViewController.swift
//  test
//
//  Created by nluo on 6/12/15.
//  Copyright (c) 2015 nluo. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate, APIControllerProtocol {
    
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
            let data: [String: String] = ["username": username, "password": password]
            //bypass the sign in page
            self.performSegueWithIdentifier("goto_home", sender: self)
            //api.post(data, url: "http://uikk854d01aa.icydragoon.koding.io/login.php") { (succeeded: Bool, msg: String) -> () in
            /*api.post(data, url: "http://localhost.test.com/login.php") { (succeeded: Bool, msg: String) -> () in
                // Move to the UI thread
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if(succeeded) {
                        self.prefs.setObject(username, forKey: "USERNAME")
                        self.prefs.setBool(true, forKey: "IS_LOGGED_IN")
                        self.prefs.synchronize()
                        
                        self.performSegueWithIdentifier("goto_home", sender: self)
                    } else {
                        self.showAlert("Sign in Failed!", message: msg)
                    }
                })
            }*/
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.signInButtonPressed(self)
        return true
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