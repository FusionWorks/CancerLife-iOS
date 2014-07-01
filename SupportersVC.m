//
//  SupportersVC.m
//  CancerLife
//
//  Created by Constantin Lungu on 11/7/13.
//  Copyright (c) 2013 FusionWorks. All rights reserved.
//

#import "SupportersVC.h"
#import "AFHTTPRequestOperationManager.h"
#import "SupporterCell.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "InviteSupporterVC.h"
#import "Defines.h"

@interface SupportersVC ()
{
    AppDelegate*                _appDel;
    NSArray*                    _supporters;
}

- (void) setupView;
- (void) setupNavigationButtons;
@end

@implementation SupportersVC

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
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - Private API

- (void) setupView
{
    [self setupNavigationButtons];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer* serializer = [AFHTTPRequestSerializer serializer];
    [serializer setValue:_appDel.authToken forHTTPHeaderField:@"token"];
    [manager setRequestSerializer:serializer];
    [manager GET:API_GET_SUPPORTERS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _supporters = [responseObject valueForKey:@"supporters"];
        self.supportersTableView.delegate   = self;
        self.supportersTableView.dataSource = self;
        NSLog(@"sup %@", _supporters);
        [self.supportersTableView reloadData];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
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

#pragma mark -
#pragma mark - Table View Delegate / Data Source

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _supportersTableView) {
        return 1;
    }
    return 0;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _supportersTableView) {
        return _supporters.count;
    }
    return 0;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _supportersTableView) {
        NSString* CellIdentifier = @"SupporterCell";
        SupporterCell *cell = (SupporterCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SupporterCell" owner:nil options:nil];
            cell = (SupporterCell*)[nib objectAtIndex:0];
        }
        NSDictionary* supporter = [_supporters objectAtIndex:indexPath.row];
        if ([[supporter valueForKey:@"public_image"] length] > 0) {
            cell.avatarImageView.image = [UIImage imageWithData:[[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",API_MAIN,[supporter valueForKey:@"public_image"]]]]];
        } else {
            cell.avatarImageView.image = [UIImage imageNamed:@"noPhoto.png"];
        }
#warning add last cell to be the refresh button!
        cell.nameLabel.text = [supporter valueForKey:@"name"];
        NSLog(@"Should return cell with namelabel = %@",[supporter valueForKey:@"name"]);
        cell.emailLabel.text = [supporter valueForKey:@"email"];
        return cell;
    }
    return nil;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _supportersTableView) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _supportersTableView) {
        return 60.0;
    }
    return 0.0;
}

- (IBAction)newInviteButtonPressed:(id)sender
{
    InviteSupporterVC* isvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"InviteSupporterVC"];
    UINavigationController* contr = [[UINavigationController alloc] initWithRootViewController:isvc];
    [self presentViewController:contr animated:YES completion:nil];
}

@end
