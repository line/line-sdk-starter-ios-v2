//
//  ProfileViewController.m
//  LineSDKStarterObjC
//
//  Created by Serrano Mark on 2016/12/12.
//  Copyright © 2016 LINE. All rights reserved.
//

#import "ProfileViewController.h"
#import <LineSDK/LineSDK.h>

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.profilePicture.text = self.userProfile.pictureURL.absoluteString;
    self.profileUserID.text = self.userProfile.userID;
    self.profileDisplayName.text = self.userProfile.displayName;
    self.profileStatusMessage.text = self.userProfile.statusMessage;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)pressOK:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
