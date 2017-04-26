//
//  UserInfoViewController.swift
//  LineSDKStarterSwift
//
//  Created by Serrano Mark on 2017/03/01.
//  Copyright © 2017 LINE. All rights reserved.
//

import UIKit
import LineSDK


class UserInfoViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    var userData: Dictionary<String, String> = [:]
    var apiClient: LineSDKAPI?
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var statusMessageLabel: UILabel!
    @IBOutlet weak var accessTokenLabel: UILabel!
    @IBOutlet weak var displayNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.apiClient = LineSDKAPI(configuration: LineSDKConfiguration.defaultConfig())
        
        self.userIdLabel.text = self.userData["userid"]
        self.statusMessageLabel.text = self.userData["statusmessage"]
        self.accessTokenLabel.text = self.userData["accesstoken"]
        self.displayNameLabel.text = self.userData["displayname"]
        
        guard let pictureURLString = self.userData["pictureurl"] else {
            print("picture URL is blank")
            return
        }
        
        guard let pictureURL = URL(string: pictureURLString) else {
            print("String to URL conversion failed")
            return
        }
        
        let task = URLSession.shared.dataTask(with: pictureURL) {
            (data, response, error) in
            
            if let data = data {
                DispatchQueue.main.async {
                    self.profileImageView.image = UIImage(data: data)
                }
            }
        }
        task.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pressGetProfile (with sender: UIButton) {
        
        self.apiClient?.getProfile(queue: .main) {
            (profile, error) in
            
            if let error = error {
                print("Error getting profile \(error.localizedDescription)")
            }
            
            let profileVC = self.storyboard?.instantiateViewController(withIdentifier: "profileViewController") as! ProfileViewController
            
            // Pass the profile information to the next view controller
            profileVC.userProfile = profile;
            self.present(profileVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func pressVerifyToken (with sender: UIButton) {
        
        self.apiClient?.verifyToken(queue: .main) {
            (result, error) in
            
            if let error = error {
                print("Token is Invalid: \(error.localizedDescription)")
                self.displayAlertDialog(with: "Access Token is Invalid", and: "Your access token is invalid.", dismiss: false)
                return
            }
            
            guard let result = result, let permissions = result.permissions else {
                print("Response result is null")
                return
            }
            
            print("Token is Valid")
            var dialogMessage = "Access Token is Valid and contains the following permissions: "
            
            for permission in permissions {
                dialogMessage += "\(permission), "
            }
            self.displayAlertDialog(with: "Access Token is Valid", and: dialogMessage, dismiss: false)
        }
    }
    
    @IBAction func pressRefreshToken (with sender: UIButton) {
        
        self.apiClient?.refreshToken(queue: .main) {
            (accessToken, error) in
            
            if let error = error {
                print("Error occurred when refreshing the access token: \(error.localizedDescription)")
                self.displayAlertDialog(with: "Error refreshing access token", and: "Error freshing access token", dismiss: false)
                return
            }
            
            guard let accessToken = accessToken else {
                print ("Access token is null")
                return
            }
            
            let newAccessToken = (accessToken.accessToken)
            print("Access token was refreshed: \(newAccessToken)")
            self.accessTokenLabel.text = newAccessToken
            self.displayAlertDialog(with: "Access Token Was Refreshed", and: "Access Token Was Refreshed", dismiss: false)
        }
    }
    
    @IBAction func pressLogout (with sender: UIButton) {
        
        self.apiClient?.logout(queue: .main) {
            (success, error) in
            
            if success {
                print("Logout Succeeded")
                self.displayAlertDialog(with: "Login Successful", and: "You have successfully logged out.", dismiss: true)
            }
            else {
                print("Logout Failed \(error?.localizedDescription as String?)")
                self.displayAlertDialog(with: "Logout Failed", and: "The LINE Logout Failed", dismiss: false)
            }
        }
    }
    
    func displayAlertDialog(with title: String, and message: String, dismiss: Bool){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        var okHandler = { (action: UIAlertAction) -> Void in}
        
        if dismiss {
            okHandler = { (action: UIAlertAction) -> Void in
                self.presentingViewController?.dismiss(animated: true, completion: nil)
            }
        }
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: okHandler)
        alertController.addAction(ok)
        self.present(alertController, animated: true, completion: nil)
    }
}
