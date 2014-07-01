//
//  JournalEntryStepTwo.h
//  CancerLife
//
//  Created by Constantin Lungu on 11/9/13.
//  Copyright (c) 2013 FusionWorks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SymptomView.h"
#import "SelectSymptomVC.h"
#import "SelectModalVC.h"

@interface JournalEntryStepTwo : UIViewController <SymptomViewDelegate, SelectSymptomDelegate, UITextViewDelegate, SelectModalDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIButton *nextStepButton;
@property (strong, nonatomic) IBOutlet UIButton *addSymptomButton;
@property (strong, nonatomic) NSArray* sideEffects;
@property (strong, nonatomic) NSArray* allSideEffects;
@property (strong, nonatomic) NSString* selectedMoodImageName;
@property (strong, nonatomic) NSArray* userCircles;
@property (strong, nonatomic) IBOutlet UIView *datePickerView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;


- (IBAction)nextStepPressed;
- (IBAction)addSymptomPressed;
- (IBAction)datePickerDonePressed:(id)sender;

// SymptomViewDelegate
- (void) deleteSymptomPressed:(id)sender;
- (void) sliderValueChanged:(id)sender;
@end
