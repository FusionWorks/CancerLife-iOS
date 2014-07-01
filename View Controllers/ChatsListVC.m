//
//  ChatsListVC.m
//  CancerLife
//
//  Created by AGalkin on 1/6/14.
//  Copyright (c) 2014 FusionWorks. All rights reserved.
//

#import "ChatsListVC.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "Defines.h"

@interface ChatsListVC ()
{
    AppDelegate* _appDel;
}

- (void) setupNavigationButtons;
- (void) togglePressed;
@end

@implementation ChatsListVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (MFSideMenuContainerViewController*) menuContainerViewController
{
    return (MFSideMenuContainerViewController*)_appDel.window.rootViewController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _appDel = (AppDelegate*)[UIApplication sharedApplication].delegate;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _photos = [[NSMutableArray alloc] init];
    [self setupNavigationButtons];
    [self loadChats];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _tableView) {
        return 1;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tableView) {
        return [_chats count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView) {
        NSString* CellIdentifier = @"ReportsCell";
        NSLog(@"indexpath %i", indexPath.row);
        SupporterCell *cell = (SupporterCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SupporterCell" owner:nil options:nil];
            cell = (SupporterCell*)[nib objectAtIndex:0];
        }
        cell.avatarImageView.image = [_photos objectAtIndex:indexPath.row];
        
        
        cell.nameLabel.text = [[_chats objectAtIndex:indexPath.row] objectForKey:@"name"];
        cell.emailLabel.text = [[_chats objectAtIndex:indexPath.row] objectForKey:@"text"];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessagesVC* messages = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MessagesVC"];
    [messages setJid:[[_chats objectAtIndex:indexPath.row] objectForKey:@"jid"]];
    [messages setName:[[_chats objectAtIndex:indexPath.row] objectForKey:@"name"]];
    [messages setPhoto:[_photos objectAtIndex:indexPath.row]];
    [messages setMyName:_appDel.firstName];
    [messages setMyPhoto:_appDel.publicImage];
    [self.navigationController pushViewController:messages animated:YES];
    
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark - Private API

- (void)loadChats
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer* serializer = [AFHTTPRequestSerializer serializer];
    [serializer setValue:_appDel.authToken forHTTPHeaderField:@"token"];
    NSLog(@"token %@", _appDel.authToken);
    [manager setRequestSerializer:serializer];
    [manager GET:API_GET_CHATS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        if ([[responseObject objectForKey:@"result"] integerValue] == 1){
            
            _chats = [responseObject objectForKey:@"chats"];
            for (int i=0; [_chats count]>i; i++){
                if([[[_chats objectAtIndex:i] objectForKey:@"picture"] length] > 0){
                    [_photos addObject:[UIImage imageWithData:[[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",API_MAIN,[[_chats objectAtIndex:i] objectForKey:@"picture"]]]]]];
                } else {
                    [_photos addObject:[UIImage imageNamed:@"noPhoto.png"]];
                }
            }
        }
        
        [_tableView reloadData];
        NSLog(@"arr %@",_chats);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

@end
