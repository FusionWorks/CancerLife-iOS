//
//  JournalEntryStepOne.h
//  CancerLife
//
//  Created by Constantin Lungu on 11/9/13.
//  Copyright (c) 2013 FusionWorks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JournalEntryStepOne : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *nextStepButton;
@property (strong, nonatomic) IBOutlet UIButton *goodButton;
@property (strong, nonatomic) IBOutlet UIButton *optimisticButton;
@property (strong, nonatomic) IBOutlet UIButton *annoyedButton;
@property (strong, nonatomic) IBOutlet UIButton *downButton;
@property (strong, nonatomic) IBOutlet UIButton *nervousButton;

@property (strong, nonatomic) IBOutlet UIButton *symptomButtonOne;
@property (strong, nonatomic) IBOutlet UIButton *symptomButtonTwo;
@property (strong, nonatomic) IBOutlet UIButton *symptomButtonThree;

- (IBAction)nextStepPressed;
- (IBAction)moodPressed:(id)sender;
- (IBAction)symptomPressed:(id)sender;
@end
