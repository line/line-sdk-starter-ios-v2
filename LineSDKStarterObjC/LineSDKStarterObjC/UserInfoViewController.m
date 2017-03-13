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
    
    
    self.userIdLabel.text = self.userData[@"userid"];
    self.statusMessageLabel.text = self.userData[@"statusmessage"];
    self.accessTokenLabel.text = self.userData[@"accesstoken"];
    self.displayNameLabel.text = self.userData[@"displayname"];
    
    if (self.userData[@"pictureurl"] != nil ){
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        [[session dataTaskWithURL:self.userData[@"pictureurl"] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
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
        
        // Pass the profile information to the next view controller
        profileVC.userProfile = profile;
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

@end
