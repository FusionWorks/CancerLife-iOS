//
//  SupportersVC.h
//  CancerLife
//
//  Created by Constantin Lungu on 11/7/13.
//  Copyright (c) 2013 FusionWorks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SupporterCell.h"

@interface SupportersVC : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *supportersTableView;
- (IBAction)newInviteButtonPressed:(id)sender;

@end
