//
//  ViewController.swift
//  LineSDKStarterSwift
//
//  Created by Serrano Mark on 2017/02/27.
//  Copyright © 2017 LINE. All rights reserved.
//

import UIKit
import LineSDK

class ViewController: UIViewController, LineSDKLoginDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        LineSDKLogin.sharedInstance().delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func A2ALogin (with sender: UIButton) {
        
        LineSDKLogin.sharedInstance().start()
    }
    
    @IBAction func WebLogin (with sender: UIButton) {
        
        LineSDKLogin.sharedInstance().startWebLogin()
    }
    
    // MARK: LineSDKLoginDelegate
    
    func didLogin(_ login: LineSDKLogin, credential: LineSDKCredential?, profile: LineSDKProfile?, error: Error?) {
        
        if let error = error {
            print("LINE Login Failed with Error: \(error.localizedDescription) ")
            return
        }
        
        guard let profile = profile, let credential = credential, let accessToken = credential.accessToken else {
            print("Invalid Repsonse")
            return
        }
        
        print("LINE Login Succeeded")
        print("Access Token: \(accessToken.accessToken)")
        print("User ID: \(profile.userID)")
        print("Display Name: \(profile.displayName)")
        print("Picture URL: \(profile.pictureURL as URL?)")
        print("Status Message: \(profile.statusMessage as String?)")
        
        if let userInfoVC = self.storyboard?.instantiateViewController(withIdentifier: "userInfoViewController") as? UserInfoViewController {
            var data = ["userid" : profile.userID,
                        "displayname" : profile.displayName,
                        "accesstoken" : accessToken.accessToken]
            
            if let pictureURL = profile.pictureURL {
                data["pictureurl"] = pictureURL.absoluteString
            }
            
            if let statusMessage = profile.statusMessage {
                data["statusmessage"] = statusMessage
            }
            
            userInfoVC.userData = data
            self.present(userInfoVC, animated: true, completion: nil)
        }
    }
}
