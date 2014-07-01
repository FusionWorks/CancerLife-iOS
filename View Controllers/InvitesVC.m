//
//  InvitesVC.m
//  CancerLife
//
//  Created by Constantin Lungu on 9/25/13.
//  Copyright (c) 2013 FusionWorks. All rights reserved.
//

#import "InvitesVC.h"
#import "AppDelegate.h"
#import "MFSideMenu.h"
#import "Utils.h"

@interface InvitesVC (/* Private */)
{
    AppDelegate             *_appDel;
}

- (void) setupView;
- (void) setupNavigationButtons;
- (void) togglePressed;
@end

@implementation InvitesVC

#pragma mark -
#pragma mark - View Controller's Lifecycle

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
    [self setupView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark - Private API

- (void) setupView
{
    [self setupNavigationButtons];
    _scrollView.contentSize = CGSizeMake(320, 1000);
    _scrollView.frame = CGRectMake(_scrollView.frame.origin.x, _scrollView.frame.origin.y - 65, _scrollView.frame.size.width, _scrollView.frame.size.height+65);

    if (!IS_IOS_7) {
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
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
