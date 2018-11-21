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
    [[LineSDKLogin sharedInstance] startLoginWithPermissions:@[@"profile", @"openid"]];
}

- (IBAction)WebLogin
{
    [[LineSDKLogin sharedInstance] startWebLoginWithPermissions:@[@"profile", @"openid"]];
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
    
    UserInfoViewController *userInfoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"userInfoViewController"];
    
    NSMutableDictionary *profileData = [@{
                                   @"userid" : profile.userID,
                                   @"displayname" : profile.displayName,
                                   @"accesstoken" : credential.accessToken.accessToken
                                   } mutableCopy];
    
    if(profile.pictureURL != nil) {
        profileData[@"pictureurl"] = profile.pictureURL;
    }
    
    if(profile.statusMessage != nil) {
        profileData[@"statusmessage"] = profile.statusMessage;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy HH:mm"];

    NSMutableDictionary *openIDData = [@{
                                         @"issuer" : credential.IDToken.issuer,
                                         @"subject" : credential.IDToken.subject,
                                         @"audience" : credential.IDToken.audience,
                                         @"expiration" : [formatter stringFromDate:credential.IDToken.expiration],
                                         @"issueAt" : [formatter stringFromDate:credential.IDToken.issueAt],
                                         @"name" : credential.IDToken.name,
                                         @"pictureUrl" : credential.IDToken.pictureURL.absoluteString
                                         }mutableCopy];
    
    
    // Pass the user information into the next view controller so that we can display it.
    userInfoVC.profileData = profileData;
    userInfoVC.openIDData = openIDData;
    
    [self presentViewController:userInfoVC animated:YES completion:nil];
}

@end
