//
//  PatientManagementVC.h
//  CancerLife
//
//  Created by Constantin Lungu on 11/29/13.
//  Copyright (c) 2013 FusionWorks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JournalEntryView.h"
#import "MBProgressHUD.h"

@interface PatientManagementVC : UIViewController <UIScrollViewDelegate, JournalEntryDelegate,UIAlertViewDelegate, MBProgressHUDDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

- (IBAction)segmentedControlValueChanged;
- (void)journalPressedOnEntry:(JournalEntryView *)entry;
- (void)reportsPressedOnEntry:(JournalEntryView *)entry;
@end
