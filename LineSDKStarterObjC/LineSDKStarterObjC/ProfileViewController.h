//
//  ProfileViewController.h
//  LineSDKStarterObjC
//
//  Created by Serrano Mark on 2016/12/12.
//  Copyright © 2016 LINE. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LineSDKProfile;


@interface ProfileViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *profileDisplayName;
@property (weak, nonatomic) IBOutlet UILabel *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *profileStatusMessage;
@property (weak, nonatomic) IBOutlet UILabel *profileUserID;
@property (strong, nonatomic) LineSDKProfile * userProfile;

@end
