//
//  SideMenuVC.h
//  CancerLife
//
//  Created by Constantin Lungu on 9/24/13.
//  Copyright (c) 2013 FusionWorks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFSideMenu.h"


NS_ENUM(NSUInteger, TableViewButtonsIndexes)
{
    Home = 0,
    Journal = 1,
    ChatsList = 2,
    Invites = 3,
    MyReports = 4
};

NS_ENUM(NSUInteger, EntryType)
{
    EntryJournal = 1,
    EntryMessage = 2,
    EntryInvite =3
};

@interface SideMenuVC : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (strong, nonatomic) IBOutlet UILabel *profileLabel;

- (void) setSelectionIndex:(NSUInteger) index;
- (void) setupView;
@end
