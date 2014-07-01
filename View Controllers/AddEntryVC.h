//
//  AddEntryVC.h
//  CancerLife
//
//  Created by Constantin Lungu on 9/26/13.
//  Copyright (c) 2013 FusionWorks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SideMenuVC.h"

@interface AddEntryVC : UIViewController <UITextFieldDelegate>

@property (nonatomic) enum EntryType entry;

@end
