//
//  SideMenuVC.m
//  CancerLife
//
//  Created by Constantin Lungu on 9/24/13.
//  Copyright (c) 2013 FusionWorks. All rights reserved.
//

#import "SideMenuVC.h"
#import "Utils.h"
#import <QuartzCore/QuartzCore.h>
#import "HomeVC.h"
#import "AddEntryVC.h"
#import "Defines.h"
#import "SupportersVC.h"
#import "InviteSupporterVC.h"
#import "JournalEntryStepOne.h"
#import "ReportsVC.h"
#import "ChatsListVC.h"

#define JOURNAL_BUTTON_TAG              1020
#define MESSAGES_BUTTON_TAG             1011
#define INVITES_BUTTON_TAG              1000
@interface SideMenuVC (/*Private*/)
{
    NSArray             *_sideMenuElements;
    AppDelegate         *_appDel;
    int                 _selectedRow;
}
- (void) cellButtonPressed:(UIButton*)sender;
- (void) setupView;
- (void) publicImageUpdated:(NSNotification*) notification;
@end

@implementation SideMenuVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    _appDel = (AppDelegate*) [UIApplication sharedApplication].delegate;
    [self setupView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    if (_selectedRow >= 0) {
        [self setSelectionIndex:_selectedRow];
    }
}

#pragma mark -
#pragma mark - Private API

- (void) setupView
{
    _selectedRow = -1;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_profileLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profilePressed)]];
    _profileLabel.userInteractionEnabled = YES;
    if (IS_IOS_7) {
        self.tableView.frame = CGRectMake(0, self.view.frame.origin.y+100, self.view.frame.size.width, self.view.frame.size.height+20);
        self.avatarImageView.frame = CGRectOffset(self.avatarImageView.frame, 0, 20);
        self.profileLabel.frame = CGRectOffset(self.profileLabel.frame, 0, 20);
    }
    NSLog(@"_appDel.role %@",_appDel.role);
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    if ([_appDel.role isEqualToString:@"Doctor"]){
        _sideMenuElements = [NSArray arrayWithObjects:@"Home", @"Patients", @"Messages", nil];
    }else{
        _sideMenuElements = [NSArray arrayWithObjects:@"Home", @"Journal", @"Messages", @"Supporters", @"My reports", nil];
    }
    [_tableView reloadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(publicImageUpdated:) name:PUBLIC_PHOTO_UPDATED_NOTIFICATION object:nil];
}

- (void) cellButtonPressed:(UIButton*)sender
{
    AddEntryVC *addEntry = [[AddEntryVC alloc] init];
    switch (sender.tag) {
        case JOURNAL_BUTTON_TAG:
        {
            // messages
            UINavigationController *contr = (UINavigationController*) _appDel.container.centerViewController;
            JournalEntryStepOne* newEntryVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"JournalEntryStepOne"];
            [contr pushViewController:newEntryVC animated:YES];
            break;
        }
        case MESSAGES_BUTTON_TAG:
        {
            UINavigationController *navigationController = (UINavigationController*) _appDel.container.centerViewController;
            [navigationController pushViewController:_appDel.messagesVC animated:YES];
            break;
        }
        case INVITES_BUTTON_TAG:
        {
            addEntry.title = @"New invite";
            InviteSupporterVC* isvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"InviteSupporterVC"];
            UINavigationController *contr = (UINavigationController*) _appDel.container.centerViewController;
            [contr pushViewController:isvc animated:YES];
            break;
        }
      
        default:
            break;
    }
    [_appDel.container toggleLeftSideMenuCompletion:^{}];
}

- (void) publicImageUpdated:(NSNotification *)notification
{
    _avatarImageView.image = _appDel.publicImage;
}

#pragma mark - Table view data source

- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _sideMenuElements.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SideMenuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSString *cellTitle = [_sideMenuElements objectAtIndex:indexPath.row];
    
    cell.textLabel.font = [UIFont fontWithName:@"Menlo" size:24.0];
    cell.textLabel.text = cellTitle;
    cell.textLabel.shadowOffset = CGSizeMake(1., 1.);
    cell.backgroundColor = [UIColor colorWithRed:165.0/255.0 green:170.0/255.0 blue:172.0/255.0 alpha:1.];
    if (!IS_IOS_7) {
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    if ([cellTitle isEqualToString:@"Journal"] || [cellTitle isEqualToString:@"Messages"] || [cellTitle isEqualToString:@"Invites"]) {
        UIButton *newButton = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *buttonTitle = [cellTitle isEqualToString:@"Invites"] ? @"Add" : @"New";
        [newButton setImage:[UIImage imageNamed:@"sideMenuTableViewButton"] forState:UIControlStateNormal];
        newButton.frame = CGRectMake(0, 0, 60, 30);
        [newButton addTarget:self action:@selector(cellButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = [UIColor blackColor];
        [titleLabel setText:buttonTitle];
        [titleLabel sizeToFit];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        titleLabel.center = newButton.center;
        [newButton addSubview:titleLabel];
        
        
        if ([cellTitle isEqualToString:@"Journal"]) newButton.tag = JOURNAL_BUTTON_TAG;
        else if ([cellTitle isEqualToString:@"Messages"]) newButton.tag = MESSAGES_BUTTON_TAG;
        else if ([cellTitle isEqualToString:@"Invites"]) newButton.tag = INVITES_BUTTON_TAG;
        
        cell.accessoryView = newButton;
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedRow = indexPath.row;
    if ([self.tableView cellForRowAtIndexPath:indexPath].accessoryView) {
        UIButton* cellButton = (UIButton*) [self.tableView cellForRowAtIndexPath:indexPath].accessoryView;
        [cellButton setHighlighted:NO];
    }
    [_appDel.container toggleLeftSideMenuCompletion:^{
    }];
    UINavigationController *navigationController = (UINavigationController*) _appDel.container.centerViewController;
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    switch (indexPath.row) {
        case Home:
        {
            if (_appDel.homeVC.navigationController.viewControllers.count > 1) {
                [_appDel.homeVC.navigationController popViewControllerAnimated:YES];
            }
            if (![[navigationController.viewControllers objectAtIndex:0] isMemberOfClass:[HomeVC class]]) {
                if (_appDel.isLoggedIn) {
                    [controllers addObject:_appDel.homeVC];
                } else {
                    [controllers addObject:_appDel.loginVC];
                }
            }
            break;
        }
        case Journal:
        {
            if (![_appDel.container.centerViewController isMemberOfClass:[JournalVC class]]) {
                if ([_appDel.role isEqualToString:@"Doctor"]){
                    [controllers addObject:_appDel.patientVC];
                }else{
                    [controllers addObject:_appDel.journalVC];
                }
            }

            break;
        }
        case ChatsList:
        {
            if (![_appDel.container.centerViewController isMemberOfClass:[ChatsListVC class]]) {
                [controllers addObject:_appDel.chatsListVC];
            }
            break;
        }
        case Invites:
        {
            if (![_appDel.container.centerViewController isMemberOfClass:[SupportersVC class]]) {
                [controllers addObject:_appDel.supportersVC];
            }
            break;
        }
        case MyReports:
        {
            if (![_appDel.container.centerViewController isMemberOfClass:[ReportsVC class]]) {
                [_appDel.myReportsVC setPatientID:_appDel.userID];
                [controllers addObject:_appDel.myReportsVC];
            }
            break;
        }
        default:
            break;
    }
    if ([controllers count]) {
        navigationController.viewControllers = controllers;
    }
}

- (void) profilePressed
{
    _selectedRow = -1;
    for (int i = 0; i < _sideMenuElements.count; i++)
        [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:YES];
    
    [_appDel.container toggleLeftSideMenuCompletion:^{
    }];
    UINavigationController *navigationController = (UINavigationController*) _appDel.container.centerViewController;
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    if (![_appDel.container.centerViewController isMemberOfClass:[ProfileVC class]]) {
        [controllers addObject:_appDel.profileVC];
    }
    if ([controllers count]) {
        navigationController.viewControllers = controllers;
    }
}

#pragma mark -
#pragma mark - Public API

- (void) setSelectionIndex:(NSUInteger)index
{
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    UIButton* btn = (UIButton*) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]].accessoryView;
    btn.highlighted = NO;
}

@end
