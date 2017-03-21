//
//  ProfileViewController.swift
//  LineSDKStarterSwift
//
//  Created by Serrano Mark on 2017/03/01.
//  Copyright © 2017 LINE. All rights reserved.
//

import UIKit
import LineSDK

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileDisplayName: UILabel!
    @IBOutlet weak var profilePicture: UILabel!
    @IBOutlet weak var profileStatusMessage: UILabel!
    @IBOutlet weak var profileUserID: UILabel!
    var userProfile: LineSDKProfile?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.profilePicture.text = self.userProfile?.pictureURL?.absoluteString
        self.profileUserID.text = self.userProfile?.userID
        self.profileDisplayName.text = self.userProfile?.displayName
        self.profileStatusMessage.text = self.userProfile?.statusMessage
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pressOK(with sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
