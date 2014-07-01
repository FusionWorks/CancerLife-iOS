//
//  ChatsListVC.h
//  CancerLife
//
//  Created by AGalkin on 1/6/14.
//  Copyright (c) 2014 FusionWorks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface ChatsListVC : UIViewController <MBProgressHUDDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *chats;
@property (strong, nonatomic) NSArray *messages;
@property (strong, nonatomic) NSMutableArray *photos;

@end
