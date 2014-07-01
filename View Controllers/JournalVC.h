//
//  JournalVC.h
//  CancerLife
//
//  Created by Constantin Lungu on 9/25/13.
//  Copyright (c) 2013 FusionWorks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface JournalVC : UIViewController <UIAlertViewDelegate, MBProgressHUDDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIButton *postEntryButton;
@property (strong, nonatomic) NSString* journalToLoad;
@property (assign, nonatomic) BOOL shouldRefreshJournal;

- (IBAction)postEntryPressed;
- (IBAction)refreshPressed:(id)sender;
@end
