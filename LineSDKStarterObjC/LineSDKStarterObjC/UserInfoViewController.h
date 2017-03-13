//
//  UserInfoViewController.h
//  LineSDKStarterObjC
//
//  Created by Serrano Mark on 12/8/16.
//  Copyright © 2016 LINE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoViewController : UIViewController

@property (copy, nonatomic) NSDictionary * userData;

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

@property (weak, nonatomic) IBOutlet UILabel *userIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *accessTokenLabel;
@property (weak, nonatomic) IBOutlet UILabel *displayNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *profileButton;

- (void) displayAlertDialogWithTitle:(NSString *)title AndMessage:(NSString *)message Dismiss:(BOOL)dismiss;

@end
