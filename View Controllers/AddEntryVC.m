//
//  AddEntryVC.m
//  CancerLife
//
//  Created by Constantin Lungu on 9/26/13.
//  Copyright (c) 2013 FusionWorks. All rights reserved.
//

#import "AddEntryVC.h"
#import "Utils.h"

@interface AddEntryVC (/* Private */)

@end

@implementation AddEntryVC

#pragma mark -
#pragma mark - View Controller's lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *entryTypeLabel = [[UILabel alloc] init];
    
    switch (_entry) {
        case EntryJournal:
        {
            entryTypeLabel.text = @"Journal";
            break;
        }
        case EntryMessage:
        {
            entryTypeLabel.text = @"Message";
            break;
        }
        case EntryInvite:
        {
            entryTypeLabel.text = @"Invite";
            break;
        }
        default:
            break;
    }
    
    [entryTypeLabel sizeToFit];
    entryTypeLabel.backgroundColor = [UIColor clearColor];
    entryTypeLabel.center = self.view.center;
    [self.view addSubview:entryTypeLabel];

    if (!IS_IOS_7) {
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark - Private API

// ...

#pragma mark -
#pragma mark - Text Field Delegate

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    
}
@end
