//
//  ProfileViewController.h
//  LineSDKStarterObjC
//
//  Created by Serrano Mark on 2016/12/12.
//  Copyright © 2016 LINE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DisplayInfoType.h"


@class LineSDKProfile;


@interface ProfileViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *viewTitle;
@property (weak, nonatomic) IBOutlet UIStackView *infoView;
@property (strong, nonatomic) NSDictionary * displayInfo;
@property (strong, nonatomic) LineSDKProfile * userProfile;

typedef enum InfoLabelStyles
{
    InfoLabelStyleText,
    InfoLabelStyleTitle,
} InfoLabelStyle;


- (void)setupLabelsForType: (DisplayInfoType)type;
- (void)createLabelWithText:(NSString *)text andStyle:(InfoLabelStyle)style;

@end
