//
//  TestWebviewViewController.swift
//  test
//
//  Created by nluo on 6/29/15.
//  Copyright (c) 2015 nluo. All rights reserved.
//

import UIKit

class TestWebviewViewController: UIViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var webview: UIWebView!
    //var URLPath = "http://yahoo.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        loadAddressURL()
    }
    
    func loadAddressURL() {
        //let requestURL = NSURL(string: URLPath)
        //let request = NSURLRequest(URL: requestURL!)
        //webview.loadRequest(request)
        
        let myHTMLString:String =
            "<head>" +
            "<link rel='stylesheet' href='main.css' type='text/css'>" +
            "<script src='main.js'></script>" +
            "</head>" +
            "<body>" +
            "<h1 style=\"font-family: Helvetica\">Hello Pizza</h1><p>Tap the buttons above to see <strong>some cool stuff</strong> with <code>UIWebView</code><p><img src=\"https://apppie.files.wordpress.com/2014/09/photo-sep-14-7-40-59-pm_small1.jpg\">" +
            "<p>Hello world GPT Ad!</p>mpu<br/><div id='mpu'><script type='text/javascript'>googletag.cmd.push(function() {googletag.display('mpu');});</script></div><hr>" +
            "</body>"

        
        webview.loadHTMLString(myHTMLString, baseURL: NSBundle.mainBundle().URLForResource("main", withExtension: "css"))
    }
}
