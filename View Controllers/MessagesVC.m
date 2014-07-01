//
//  MessagesVC.m
//  CancerLife
//
//  Created by Constantin Lungu on 9/25/13.
//  Copyright (c) 2013 FusionWorks. All rights reserved.
//

#import "MessagesVC.h"
#import "AppDelegate.h"
#import "MFSideMenu.h"
#import "Utils.h"
#import "MessageCell.h"
#import "AFNetworking.h"
#import "JournalCommentView.h"
#import "SORelativeDateTransformer.h"
#import "Defines.h"
@interface MessagesVC (/* Private */)
{
    AppDelegate             *_appDel;
}
@end

@implementation MessagesVC

#pragma mark -
#pragma mark - View Controller's Lifecycle

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    _appDel = (AppDelegate*) [UIApplication sharedApplication].delegate;
    _messages = [[NSMutableArray alloc] init];
    [self setupView];
    [self loadMessages:_jid];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageReceived:) name:kNotificationXMPPMessageReceived object:nil];
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) screenTapped
{
    if (self.view.frame.origin.y != 0) {
        [UIView animateWithDuration:0.29f animations:^(void) {
            self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        }completion:nil];
    }
    [self.view endEditing:YES];
}

#pragma mark -
#pragma mark - Private API

- (void) setupView
{
    if (!IS_IOS_7) {
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    }
    self.navigationItem.title = _name;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _messageText.delegate = self;
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTapped)]];
}



- (void)loadMessages:(NSString *)jid
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer* serializer = [AFHTTPRequestSerializer serializer];
    [serializer setValue:_appDel.authToken forHTTPHeaderField:@"token"];
    [manager setRequestSerializer:serializer];
    [manager GET:[NSString stringWithFormat:@"%@%@",API_GET_MESSAGES,jid] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        if ([[responseObject objectForKey:@"result"] integerValue] == 1){
            
            _messages = [[responseObject objectForKey:@"messages"] mutableCopy];
            
        }
        
        [_tableView reloadData];
        if([_messages count]>0){
            NSIndexPath* ip = [NSIndexPath indexPathForRow:[_messages count]-1 inSection:0];
            [_tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        NSLog(@"arr %@",_messages);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
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
        return [_messages count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView) {

        NSString* CellIdentifier = @"MessageCell";
        MessageCell* cell = (MessageCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MessageCell" owner:nil options:nil];
            cell = (MessageCell *)[nib objectAtIndex:0];
        }
        
        NSString* text = [[_messages objectAtIndex:indexPath.row] objectForKey:@"text"];
        NSString* time = [[SORelativeDateTransformer registeredTransformer] transformedValue:[NSDate dateWithTimeIntervalSince1970:[[[_messages objectAtIndex:indexPath.row] objectForKey:@"created"]unsignedIntegerValue]]];
        
        if([[[_messages objectAtIndex:indexPath.row] objectForKey:@"self"] boolValue]){
            [cell setLeftHidden];
            
            cell.commentLabelRight.text = text;
            [cell.commentLabelRight sizeToFit];
            
            CGRect frame = cell.commentCloudImageViewRight.frame;
            frame.size.height = cell.commentLabelRight.frame.size.height+40;
            cell.commentCloudImageViewRight.frame = frame;
            
            frame = cell.timestampLabelRight.frame;
            frame.origin.y = cell.commentLabelRight.frame.origin.y + cell.commentLabelRight.frame.size.height - 5;
            cell.timestampLabelRight.frame = frame;
            
            cell.timestampLabelRight.text = time;
            cell.avatarImageViewRight.image = _myPhoto;
            cell.nameLabelRight.text = _myName;
        }else{
            [cell setRightHidden];
            
            cell.commentLabel.text = text;
            [cell.commentLabel sizeToFit];
            
            CGRect frame = cell.commentCloudImageView.frame;
            frame.size.height = cell.commentLabel.frame.size.height+40;
            cell.commentCloudImageView.frame = frame;
            
            frame = cell.timestampLabel.frame;
            frame.origin.y = cell.commentLabel.frame.origin.y + cell.commentLabel.frame.size.height;
            cell.timestampLabel.frame = frame;
            
            cell.timestampLabel.text = time;
            cell.avatarImageView.image = _photo;
            cell.nameLabel.text = _name;
        
        }

        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView) {
        
        NSString* CellIdentifier = @"MessageCell";
        MessageCell* cell = (MessageCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MessageCell" owner:nil options:nil];
            cell = (MessageCell *)[nib objectAtIndex:0];
        }
        NSString* text = [[_messages objectAtIndex:indexPath.row] objectForKey:@"text"];

        if([[[_messages objectAtIndex:indexPath.row] objectForKey:@"self"] boolValue]){
            cell.commentLabelRight.text = text;
            [cell.commentLabelRight sizeToFit];
            return cell.commentLabelRight.frame.size.height + cell.nameLabelRight.frame.size.height + cell.timestampLabelRight.frame.size.height + 20;
        
        }else{
            cell.commentLabel.text = text;
            [cell.commentLabel sizeToFit];
            return cell.commentLabel.frame.size.height + cell.nameLabel.frame.size.height + cell.timestampLabel.frame.size.height + 20;
        }
    }
    return 0.0;
}

#pragma mark -
#pragma mark - Text Field Delegate

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.view.frame.origin.y == 0) {
        int offset = -220;
        [UIView animateWithDuration:0.29f animations:^(void) {
            self.view.frame = CGRectMake(0, offset, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        }completion:nil];
    }
}

- (IBAction)sendMessage:(id)sender {
    NSNumber * timeStampValue = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                          _messageText.text,@"text",
                          timeStampValue,@"created",
                          [NSNumber numberWithBool:true],@"self", nil];
    
    [_messages addObject:dict];
    NSLog(@"mes %@", _messages);
    [_tableView reloadData];
    NSIndexPath* ip = [NSIndexPath indexPathForRow:[_messages count]-1 inSection:0];
    [_tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:YES];
    [self screenTapped];
    
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:[NSString stringWithFormat:@"%@:%@",_jid,[_messageText text]]];
    NSXMLElement *myMessage = [NSXMLElement elementWithName:@"message"];
    [myMessage addAttributeWithName:@"type" stringValue:@"chat"];
    [myMessage addAttributeWithName:@"to" stringValue:@"listen@beta.cancerlife.net"];
    [myMessage addChild:body];
    [_appDel.stream sendElement:myMessage];
    
    body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:[NSString stringWithFormat:@"%@",[_messageText text]]];
    myMessage = [NSXMLElement elementWithName:@"message"];
    [myMessage addAttributeWithName:@"type" stringValue:@"chat"];
    [myMessage addAttributeWithName:@"to" stringValue:_jid];
    [myMessage addChild:body];
    [_appDel.stream sendElement:myMessage];
    
    [_messageText setText:@""];
}

#pragma mark - XMPP
- (void) messageReceived:(NSNotification*)notification
{
    NSLog(@" MESSAGE RECEIVED - %@",[notification object]);
    XMPPMessage *message = [notification object];
    if([_jid isEqualToString:[[message from] user]]){
        NSNumber * timeStampValue = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     [[message elementForName:@"body"] stringValue],@"text",
                                     timeStampValue,@"created",
                                     [NSNumber numberWithBool:false],@"self", nil];
        
        [_messages addObject:dict];
        NSLog(@"mes %@", _messages);
        [_tableView reloadData];
        NSIndexPath* ip = [NSIndexPath indexPathForRow:[_messages count]-1 inSection:0];
        [_tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

@end
