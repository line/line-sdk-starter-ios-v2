//
//  UserInfoViewController.h
//  LineSDKStarterObjC
//
//  Created by Serrano Mark on 12/8/16.
//  Copyright © 2016 LINE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DisplayInfoType.h"

@interface UserInfoViewController : UIViewController

@property (copy, nonatomic) NSDictionary * profileData;
@property (copy, nonatomic) NSDictionary * openIDData;

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

@property (weak, nonatomic) IBOutlet UILabel *userIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *accessTokenLabel;
@property (weak, nonatomic) IBOutlet UILabel *displayNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *profileButton;
@property (weak, nonatomic) IBOutlet UIButton *openIDButton;
@property (weak, nonatomic) IBOutlet UIButton *checkFriendshipButton;

- (void) displayAlertDialogWithTitle:(NSString *)title AndMessage:(NSString *)message Dismiss:(BOOL)dismiss;

@end
