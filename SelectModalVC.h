//
//  SelectModalVC.h
//  CancerLife
//
//  Created by Constantin Lungu on 11/28/13.
//  Copyright (c) 2013 FusionWorks. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectModalDelegate <NSObject>

- (void)modalSelectedItems:(NSArray*)items;
- (void) doctorSelectedItems:(NSArray *)items organizationId:(NSString *)orgId doctorId:(NSString *)docId;
@end

@interface SelectModalVC : UITableViewController

@property (nonatomic, strong) NSDictionary* items;
@property (nonatomic, strong) NSArray* doctorItems;
@property (nonatomic, strong) id <SelectModalDelegate> delegate;

- (IBAction)cancelPressed:(id)sender;
- (IBAction)donePressed:(id)sender;

@end
