//
//  JournalEntryStepThree.h
//  CancerLife
//
//  Created by Constantin Lungu on 11/23/13.
//  Copyright (c) 2013 FusionWorks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSKeyboardControls.h"
#import "MBProgressHUD.h"

@interface JournalEntryStepThree : UIViewController <BSKeyboardControlsDelegate, MBProgressHUDDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIButton *trackButton;
@property (strong, nonatomic) IBOutlet UIButton *broadcastButton;
@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic) NSString* selectedMoodImageName;
@property (strong, nonatomic) BSKeyboardControls *keyboardControls;
@property (strong, nonatomic) NSArray *selectedSideEffects;
@property (strong, nonatomic) NSArray *pickerArray;

- (IBAction)trackPressed;
- (IBAction)broadcastPressed;
@end
