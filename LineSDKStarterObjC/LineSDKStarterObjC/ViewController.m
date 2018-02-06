//
//  ViewController.m
//  LineSDKStarterObjC
//
//  Created by Serrano Mark on 12/8/16.
//  Copyright © 2016 LINE. All rights reserved.
//

#import "ViewController.h"
#import "UserInfoViewController.h"
#import <LineSDK/LineSDK.h>

@interface ViewController () <LineSDKLoginDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Set the LINE Login Delegate
    [LineSDKLogin sharedInstance].delegate = self;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)A2ALogin
{
    [[LineSDKLogin sharedInstance] startLogin];
}

- (IBAction)WebLogin
{
    [[LineSDKLogin sharedInstance] startWebLogin];
}


#pragma mark LineSDKLoginDelegate

- (void)didLogin:(LineSDKLogin *)login
      credential:(LineSDKCredential *)credential
         profile:(LineSDKProfile *)profile
           error:(NSError *)error
{
    if (error) {
        NSLog(@"LINE Login Failed with Error: %@", error.description);
        return;
    }
    
    NSLog(@"LINE Login Succeeded");
    NSLog(@"Access Token: %@", credential.accessToken.accessToken);
    NSLog(@"User ID: %@", profile.userID);
    NSLog(@"Display Name: %@", profile.displayName);
    NSLog(@"Picture URL: %@", profile.pictureURL);
    NSLog(@"Status Message: %@", profile.statusMessage);
    
    UserInfoViewController *userInfoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"userInfoViewController"];
    
    NSMutableDictionary *data = [@{
                                   @"userid" : profile.userID,
                                   @"displayname" : profile.displayName,
                                   @"accesstoken" : credential.accessToken.accessToken
                                   } mutableCopy];
    
    if(profile.pictureURL != nil) {
        data[@"pictureurl"] = profile.pictureURL;
    }
    
    if(profile.statusMessage != nil) {
        data[@"statusmessage"] = profile.statusMessage;
    }
    
    // Pass the user information into the next view controller so that we can display it.
    userInfoVC.userData = data;
    
    [self presentViewController:userInfoVC animated:YES completion:nil];
}

@end
