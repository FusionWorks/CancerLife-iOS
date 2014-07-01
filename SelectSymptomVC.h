//
//  SelectSymptomVC.h
//  CancerLife
//
//  Created by Constantin Lungu on 11/23/13.
//  Copyright (c) 2013 FusionWorks. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectSymptomDelegate <NSObject>

- (void)selectedSymptom:(NSString*)symptom;

@end

@interface SelectSymptomVC : UITableViewController

@property (nonatomic, strong) id <SelectSymptomDelegate> delegate;
@property (nonatomic, strong) NSArray* symptoms;
- (IBAction)cancelPressed:(id)sender;

@end
