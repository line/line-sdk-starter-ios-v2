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

    [self setupLabelsForType:[self.displayInfo[@"type"] intValue]];
    
}

- (void)setupLabelsForType:(DisplayInfoType)type{
    
    switch(type){
        case DisplayInfoTypeProfile:
            self.viewTitle.text = @"Profile Information";
            [self createLabelWithText:@"User ID:" andStyle:InfoLabelStyleTitle];
            [self createLabelWithText:self.displayInfo[@"userId"] andStyle:InfoLabelStyleText];
            [self createLabelWithText:@"Status Message:" andStyle:InfoLabelStyleTitle];
            [self createLabelWithText:self.displayInfo[@"statusMessage"] andStyle:InfoLabelStyleText];
            [self createLabelWithText:@"Display Name:" andStyle:InfoLabelStyleTitle];
            [self createLabelWithText:self.displayInfo[@"displayName"] andStyle:InfoLabelStyleText];
            [self createLabelWithText:@"Picture URL:" andStyle:InfoLabelStyleTitle];
            [self createLabelWithText:self.displayInfo[@"pictureUrl"] andStyle:InfoLabelStyleText];
            break;
            
        case DisplayInfoTypeOpenID:
            self.viewTitle.text = @"OpenID Information";
            [self createLabelWithText:@"Issuer:" andStyle:InfoLabelStyleTitle];
            [self createLabelWithText:self.displayInfo[@"issuer"] andStyle:InfoLabelStyleText];
            [self createLabelWithText:@"Subject:" andStyle:InfoLabelStyleTitle];
            [self createLabelWithText:self.displayInfo[@"subject"] andStyle:InfoLabelStyleText];
            [self createLabelWithText:@"Audience:" andStyle:InfoLabelStyleTitle];
            [self createLabelWithText:self.displayInfo[@"audience"] andStyle:InfoLabelStyleText];
            [self createLabelWithText:@"Expiration:" andStyle:InfoLabelStyleTitle];
            [self createLabelWithText:self.displayInfo[@"expiration"] andStyle:InfoLabelStyleText];
            [self createLabelWithText:@"Issue At:" andStyle:InfoLabelStyleTitle];
            [self createLabelWithText:self.displayInfo[@"issueAt"] andStyle:InfoLabelStyleText];
            [self createLabelWithText:@"Name:" andStyle:InfoLabelStyleTitle];
            [self createLabelWithText:self.displayInfo[@"name"] andStyle:InfoLabelStyleText];
            [self createLabelWithText:@"Picture URL:" andStyle:InfoLabelStyleTitle];
            [self createLabelWithText:self.displayInfo[@"pictureUrl"] andStyle:InfoLabelStyleText];
            break;
        default:
            [self createLabelWithText:@"No Data Available" andStyle:InfoLabelStyleText];
            break;

    }
    
}

- (void)createLabelWithText:(NSString *)text andStyle:(InfoLabelStyle)style{
    

    UILabel * newLabel = [[UILabel alloc] init];
    newLabel.preferredMaxLayoutWidth = CGRectGetWidth(newLabel.frame);
    newLabel.lineBreakMode = NSLineBreakByWordWrapping;
    newLabel.numberOfLines = 0;
    newLabel.text = text;
    [newLabel sizeToFit];
    
    switch (style){
        case InfoLabelStyleTitle:
            newLabel.font = [UIFont boldSystemFontOfSize:20];
            break;
        default:
            newLabel.font = [newLabel.font fontWithSize:12];
            break;
    }
    [self.infoView addArrangedSubview:newLabel];
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
