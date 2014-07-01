//
//  InviteSupporterVC.h
//  CancerLife
//
//  Created by Constantin Lungu on 11/7/13.
//  Copyright (c) 2013 FusionWorks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InviteSupporterVC : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *emailFieldView;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;

- (IBAction)cancelInvitePressed:(id)sender;
- (IBAction)sendInvitePressed:(id)sender;

@end
