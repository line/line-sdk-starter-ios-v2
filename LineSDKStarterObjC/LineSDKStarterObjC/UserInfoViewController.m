//
//  UserInfoViewController.m
//  LineSDKStarterObjC
//
//  Created by Serrano Mark on 12/8/16.
//  Copyright © 2016 LINE. All rights reserved.
//

#import "UserInfoViewController.h"
#import "ProfileViewController.h"
#import <LineSDK/LineSDK.h>

@interface UserInfoViewController () <UIPopoverPresentationControllerDelegate>

// LINE SDK API Client
@property (strong, nonatomic) LineSDKAPI *apiClient;

@end

@implementation UserInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialize the API Client so that we can use the LINE SDK's API
    self.apiClient = [[LineSDKAPI alloc] initWithConfiguration:[LineSDKConfiguration defaultConfig]];
    
    self.userIdLabel.text = self.profileData[@"userid"];
    self.statusMessageLabel.text = self.profileData[@"statusmessage"];
    self.accessTokenLabel.text = self.profileData[@"accesstoken"];
    self.displayNameLabel.text = self.profileData[@"displayname"];
    
    if (self.profileData[@"pictureurl"] != nil ){
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        [[session dataTaskWithURL:self.profileData[@"pictureurl"] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.profileImageView.image = [UIImage imageWithData:data];
            });
        }]resume];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pressGetProfile:(id)sender
{
    [self.apiClient getProfileWithCompletion:^(LineSDKProfile * _Nullable profile, NSError * _Nullable error) {
        
        if(error){
            NSLog(@"Error getting profile: %@", error.description);
            [self displayAlertDialogWithTitle:@"Could not get Profile" AndMessage:@"The call to the getProfile API failed." Dismiss:NO];
            return;
        }
        
        ProfileViewController * profileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"profileViewController"];
        
        profileVC.displayInfo =  @{
                                   @"type": [NSNumber numberWithInt:DisplayInfoTypeProfile],
                                   @"userId": profile.userID ? profile.userID : @"",
                                   @"statusMessage": profile.statusMessage ? profile.statusMessage : @"",
                                   @"displayName": profile.displayName ? profile.displayName : @"",
                                   @"pictureUrl": profile.pictureURL.absoluteString ? profile.pictureURL.absoluteString : @""
                                   };
        
        [self presentViewController:profileVC animated:YES completion:nil];
    }];
}


- (IBAction)pressVerifyToken:(id)sender
{
    [self.apiClient verifyTokenWithCompletion:^(LineSDKVerifyResult * _Nullable result, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Token is Invalid: %@", error.description);
            [self displayAlertDialogWithTitle:@"Access Token is Invalid"  AndMessage:@"Your access token is invalid." Dismiss:NO];
            return;
        }
        
        NSLog(@"Token is Valid");
        NSMutableString * dialogMessage = [[NSMutableString alloc]initWithString:@"Access Token is Valid and contains the following permissions: "];
        
        for (NSString* permission in result.permissions){
            [dialogMessage appendFormat:@"%@, ", permission];
        }
        
        [self displayAlertDialogWithTitle:@"Access Token is Valid"  AndMessage:dialogMessage Dismiss:NO];
    }];
}

- (IBAction)pressRefreshToken:(id)sender
{
    [self.apiClient refreshTokenWithCompletion:^(LineSDKAccessToken * _Nullable accessToken, NSError * _Nullable error) {
        if (error){
            NSLog(@"Error occurred when refreshing the access token: %@", error.description);
            [self displayAlertDialogWithTitle:@"Error refreshing access token"  AndMessage:@"Error refreshing access token" Dismiss:NO];
            return;
        }
        
        NSLog(@"Access token was refreshed: %@", accessToken.accessToken);
        NSString * newAccessToken = accessToken.accessToken;
        
        self.accessTokenLabel.text = newAccessToken;
        [self displayAlertDialogWithTitle:@"Access Token Was Refreshed"  AndMessage:@"Access Token Was Refreshed" Dismiss:NO];
    }];
}

- (IBAction)pressLogout:(id)sender
{
    [self.apiClient logoutWithCompletion:^(BOOL success, NSError * _Nullable error){
        if (success){
            NSLog(@"Logout Succeeded");
            [self displayAlertDialogWithTitle:@"Logout Successful" AndMessage:@"You have successfully logged out." Dismiss:YES];
        }
        else {
            NSLog(@"Logout Failed: %@", error.description);
            [self displayAlertDialogWithTitle:@"Logout Failed" AndMessage:@"The LINE Logout Failed" Dismiss:NO];
        }
    }];
}

- (void) displayAlertDialogWithTitle:(NSString *)title AndMessage:(NSString *)message Dismiss:(BOOL)dismiss
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    void (^okHandler)(UIAlertAction * action) = nil;
    
    if (dismiss){
        okHandler = ^void(UIAlertAction * action) {
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        };
    }
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:okHandler];
    
    [alertController addAction:ok];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (IBAction)pressCheckFriendship:(id)sender {

    [self.apiClient getBotFriendshipStatusWithCompletion:^(LineSDKBotFriendshipStatusResult * _Nullable result, NSError * _Nullable error) {
        
        NSString * message;
        NSString * title;
        
        if (error){
            
            if ([error.domain isEqualToString:LineSDKServerErrorDomain] && error.code == 400) {
                title = @"Friendship API Error";
                message = @"Error calling the Friendship API. Perhaps you don't have a bot linked to your channel?";
            } else {
                title = @"Friendship API Error";
                message = @"Error calling the Friendship API.";
            }
            NSLog(@"Error calling friendship API: %@", error.description);
        } else {
            title = @"Friendship API";
            if (result.friendFlag){
                message = @"Friendship status has changed.";
            } else {
                message = @"Friendship status has not changed.";
            }
        }
        
        [self displayAlertDialogWithTitle:title AndMessage:message Dismiss:NO];
        
    }];
}

- (IBAction)pressOpenID:(id)sender {
    

    ProfileViewController * openIDVC = [self.storyboard instantiateViewControllerWithIdentifier:@"profileViewController"];
    
    
    openIDVC.displayInfo =  @{
                               @"type": [NSNumber numberWithInt:DisplayInfoTypeOpenID],
                               @"issuer": self.openIDData[@"issuer"] ? self.openIDData[@"issuer"] : @"",
                               @"subject": self.openIDData[@"subject"] ? self.openIDData[@"subject"] : @"",
                               @"audience": self.openIDData[@"audience"] ? self.openIDData[@"audience"] : @"",
                               @"expiration": self.openIDData[@"expiration"] ? self.openIDData[@"expiration"] : @"",
                               @"issueAt": self.openIDData[@"issueAt"] ? self.openIDData[@"issueAt"] : @"",
                               @"name": self.openIDData[@"name"] ? self.openIDData[@"name"] : @"",
                               @"pictureUrl": self.openIDData[@"pictureUrl"] ? self.openIDData[@"pictureUrl"] : @"",
                               };
    
    [self presentViewController:openIDVC animated:YES completion:nil];
    
}

@end
