//
//  HomeVC.m
//  CancerLife
//
//  Created by Constantin Lungu on 9/25/13.
//  Copyright (c) 2013 FusionWorks. All rights reserved.
//

#import "HomeVC.h"
#import "AppDelegate.h"
#import "SideMenuVC.h"
#import "Utils.h"

@interface HomeVC (/* Private */)
{
    AppDelegate             *_appDel;
}

- (void) setupView;
- (void) setupNavigationButtons;
- (void) togglePressed;
@end

@implementation HomeVC

- (MFSideMenuContainerViewController*) menuContainerViewController
{
    return (MFSideMenuContainerViewController*)_appDel.window.rootViewController;
}

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
    _appDel = (AppDelegate*) [UIApplication sharedApplication].delegate;
    _appDel.container.panMode = MFSideMenuPanModeCenterViewController | MFSideMenuPanModeSideMenu;
    [self setupView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)journalPressed
{
    if ([_appDel.role isEqualToString:@"Doctor"])
        [self.navigationController pushViewController:_appDel.patientVC animated:YES];
    else
        [self.navigationController pushViewController:_appDel.journalVC animated:YES];
    
    
    SideMenuVC *side = (SideMenuVC*)[_appDel.container leftMenuViewController];
    [side setSelectionIndex:Journal];
}

- (IBAction)messagesPressed
{
    [self.navigationController pushViewController:_appDel.chatsListVC animated:YES];
    SideMenuVC *side = (SideMenuVC*)[_appDel.container leftMenuViewController];
    [side setSelectionIndex:ChatsList];
}

- (IBAction)invitesPressed
{
    [self.navigationController pushViewController:_appDel.supportersVC animated:YES];
    SideMenuVC *side = (SideMenuVC*)[_appDel.container leftMenuViewController];
    [side setSelectionIndex:Invites];
}

#pragma mark -
#pragma mark - Private API

- (void) setupView
{
    
    [_journalButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    if ([_appDel.role isEqualToString:@"Doctor"])
        [_journalButton setTitle:@"Patients" forState:UIControlStateNormal];
    else
        [_journalButton setTitle:@"Journal" forState:UIControlStateNormal];
    [_journalButton.titleLabel setFont:[UIFont systemFontOfSize:24.0]];
    _journalButton.titleLabel.shadowOffset = CGSizeMake(0, 0);
    [_journalButton setTitleEdgeInsets:UIEdgeInsetsMake(-_journalButton.frame.size.height, -_journalButton.frame.size.width, -_journalButton.frame.size.height-65, 0.0)];
    
    [_messagesButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_messagesButton setTitle:@"Messages" forState:UIControlStateNormal];
    [_messagesButton.titleLabel setFont:[UIFont systemFontOfSize:24.0]];
    _messagesButton.titleLabel.shadowOffset = CGSizeMake(0, 0);
    [_messagesButton setTitleEdgeInsets:UIEdgeInsetsMake(-_messagesButton.frame.size.height, -_messagesButton.frame.size.width, -_messagesButton.frame.size.height-65, 0.0)];
    
    [_invitesButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_invitesButton setTitle:@"Invites" forState:UIControlStateNormal];
    [_invitesButton.titleLabel setFont:[UIFont systemFontOfSize:24.0]];
    _invitesButton.titleLabel.shadowOffset = CGSizeMake(0, 0);
    [_invitesButton setTitleEdgeInsets:UIEdgeInsetsMake(-_invitesButton.frame.size.height, -_invitesButton.frame.size.width, -_invitesButton.frame.size.height-65, 0.0)];
    
    self.navigationItem.hidesBackButton = YES;
    [self setupNavigationButtons];
    
    if (!IS_IOS_7) {
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        _journalButton.frame = CGRectOffset(_journalButton.frame, 0, -60);
        _messagesButton.frame = CGRectOffset(_messagesButton.frame, 0, -60);
        _invitesButton.frame = CGRectOffset(_invitesButton.frame, 0, -60);
    }
    
    if ([_appDel.role isEqualToString:@"Doctor"]){
        [_invitesButton setHidden:YES];
    }
    
}

- (void) setupNavigationButtons
{
    UIButton *toggleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [toggleButton setImage:[UIImage imageNamed:@"sideMenuButton"] forState:UIControlStateNormal];
    [toggleButton setFrame:CGRectMake(0, 0, 32, 22)];
    [toggleButton addTarget:self action:@selector(togglePressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *toggle = [[UIBarButtonItem alloc] initWithCustomView:toggleButton];
    self.navigationItem.leftBarButtonItem = toggle;
}

- (void) togglePressed
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{}];
}

@end
