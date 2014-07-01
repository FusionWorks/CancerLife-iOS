//
//  MessagesVC.h
//  CancerLife
//
//  Created by Constantin Lungu on 9/25/13.
//  Copyright (c) 2013 FusionWorks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface MessagesVC : UIViewController <UITableViewDataSource, UITableViewDelegate, MBProgressHUDDelegate, UITextFieldDelegate>

@property (strong, nonatomic) NSString* jid;
@property (strong, nonatomic) NSString* myName;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) UIImage* photo;
@property (strong, nonatomic) UIImage* myPhoto;
@property (strong, nonatomic) NSMutableArray* messages;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *messageText;
- (IBAction)sendMessage:(id)sender;

@end
