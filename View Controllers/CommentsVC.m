//
//  CommentsVC.m
//  CancerLife
//
//  Created by Constantin Lungu on 11/13/13.
//  Copyright (c) 2013 FusionWorks. All rights reserved.
//

#import "CommentsVC.h"
#import "AFHTTPRequestOperationManager.h"
#import "JournalCommentView.h"
#import "SORelativeDateTransformer.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "Defines.h"

@interface CommentsVC ()
{
    NSArray*            _comments;
    AppDelegate*        _appDel;
}

- (void) loadCommentsIntoScrollView;
- (void) setupView;
@end

@implementation CommentsVC

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
    _scrollView.contentSize = CGSizeMake(320, 0);
    _scrollView.frame = CGRectMake(_scrollView.frame.origin.x, _scrollView.frame.origin.y - 65, _scrollView.frame.size.width, _scrollView.frame.size.height+65);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer* serializer = [AFHTTPRequestSerializer serializer];
    [serializer setValue:_appDel.authToken forHTTPHeaderField:@"token"];
    [manager setRequestSerializer:serializer];
    [manager GET:[NSString stringWithFormat:@"%@%d",API_GET_COMMENTS, [_selectedPostID integerValue]] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        _comments = [responseObject valueForKey:@"comments"];
        [self loadCommentsIntoScrollView];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Sorry, couldn't load messages. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        [self.navigationController popViewControllerAnimated:YES];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

- (void) loadCommentsIntoScrollView
{
    int offsetY = 0;
    for (NSDictionary* comment in _comments) {
        // create it
        JournalCommentView* commentView = [[[NSBundle mainBundle] loadNibNamed:@"JournalCommentView" owner:self options:nil] lastObject];
        commentView.entryID = _selectedPostID;
        commentView.commentLabel.text = [comment valueForKey:@"message"];
        commentView.timestampLabel.text = [[SORelativeDateTransformer registeredTransformer] transformedValue:[NSDate dateWithTimeIntervalSince1970:[[comment valueForKey:@"created"] unsignedIntegerValue]]];
        commentView.nameLabel.text = [comment valueForKey:@"name"];
        [commentView setup];
        if ([[comment valueForKey:@"photo"] length] > 0) {
            commentView.avatarImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",API_MAIN,[comment valueForKey:@"photo"]]]]];
        } else {
            commentView.avatarImageView.image = [UIImage imageNamed:@"noPhoto.png"];
        }
        commentView.frame = CGRectMake(0, offsetY, commentView.frame.size.width, commentView.frame.size.height);
        [_scrollView addSubview:commentView];
        _scrollView.contentSize = CGSizeMake(_scrollView.contentSize.width, _scrollView.contentSize.height + commentView.frame.size.height);
        offsetY += commentView.frame.size.height + 5;
    }
    _scrollView.contentSize = CGSizeMake(_scrollView.contentSize.width, _scrollView.contentSize.height + 20);
}

@end
