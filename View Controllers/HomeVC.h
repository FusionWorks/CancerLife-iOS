//
//  HomeVC.h
//  CancerLife
//
//  Created by Constantin Lungu on 9/25/13.
//  Copyright (c) 2013 FusionWorks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeVC : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *journalButton;
@property (strong, nonatomic) IBOutlet UIButton *messagesButton;
@property (strong, nonatomic) IBOutlet UIButton *invitesButton;

- (IBAction)journalPressed;
- (IBAction)messagesPressed;
- (IBAction)invitesPressed;
@end
