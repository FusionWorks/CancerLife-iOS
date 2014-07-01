//
//  JournalVC.m
//  CancerLife
//
//  Created by Constantin Lungu on 9/25/13.
//  Copyright (c) 2013 FusionWorks. All rights reserved.
//

#import "JournalVC.h"
#import "AppDelegate.h"
#import "MFSideMenu.h"
#import "Utils.h"
#import "JournalEntryView.h"
#import "JournalCommentView.h"
#import "AFHTTPRequestOperationManager.h"
#import "SORelativeDateTransformer.h"
#import "JournalEntryStepOne.h"
#import "CommentsVC.h"
#import "Defines.h"
#import "UIBorderLabel.h"

@interface JournalVC (/* Private */)
{
    AppDelegate             *_appDel;
    NSArray                 *_posts;
    NSMutableArray          *_scrollViewSubviews;

    NSNumber                *_entryIdToCommentOn;
    NSUInteger               _journalPageToLoad;
    BOOL                     _hasMoreJournalPosts;
    BOOL                     _isLoadingJournalPosts;
    int                     symptomOffset;
}

- (void) setupNavigationButtons;
- (void) setupView;
- (void) loadJournalPosts;
@end

@implementation JournalVC

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
    _scrollViewSubviews = [NSMutableArray array];
    _journalPageToLoad = 2;
    _hasMoreJournalPosts = YES;
    _isLoadingJournalPosts = NO;
    _shouldRefreshJournal = NO;
    [self setupView];
}

- (void) viewDidAppear:(BOOL)animated
{
    _scrollView.userInteractionEnabled = YES;
    _appDel.container.panMode = MFSideMenuPanModeCenterViewController | MFSideMenuPanModeSideMenu;
    if (!_posts || _shouldRefreshJournal) {
        _shouldRefreshJournal = NO;
        [self loadJournalPosts];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) togglePressed
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{}];
}

- (IBAction)postEntryPressed
{
    JournalEntryStepOne* newEntryVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"JournalEntryStepOne"];
    [self.navigationController pushViewController:newEntryVC animated:YES];
    _appDel.container.panMode = MFSideMenuPanModeNone;
}

- (IBAction)refreshPressed:(id)sender
{
    [self loadJournalPosts];
}

#pragma mark -
#pragma mark - Private API

- (void) setupView
{
    int offset = 65;
    [self setupNavigationButtons];
    _scrollView.contentSize = CGSizeMake(320, 0);
    _scrollView.frame = CGRectMake(_scrollView.frame.origin.x, _scrollView.frame.origin.y - offset, _scrollView.frame.size.width, _scrollView.frame.size.height + 65);
    _scrollView.showsVerticalScrollIndicator = YES;
    _scrollView.delegate = self;
    
    if ([_appDel.role isEqualToString:@"Doctor"]){
        self.title = @"Patients";
        [_postEntryButton setHidden:YES];
    }else{
        self.title = @"Journal";
        [_postEntryButton setHidden:NO];
        [_postEntryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_postEntryButton setTitle:@"+ Post an entry" forState:UIControlStateNormal];
        [_postEntryButton.titleLabel setFont:[UIFont systemFontOfSize:18.0]];
        _postEntryButton.titleLabel.shadowOffset = CGSizeMake(0, 0);
        [_postEntryButton setTitleEdgeInsets:UIEdgeInsetsMake(-_postEntryButton.frame.size.height, -_postEntryButton.frame.size.width, -_postEntryButton.frame.size.height, 0.0)];
        if (!IS_IOS_7) {
            _postEntryButton.frame = CGRectOffset(_postEntryButton.frame, 0, 5);
        }
        offset = 130;
    }


}

- (void) setupNavigationButtons
{
    if (!_journalToLoad) {
        UIButton *toggleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [toggleButton setImage:[UIImage imageNamed:@"sideMenuButton"] forState:UIControlStateNormal];
        [toggleButton setFrame:CGRectMake(0, 0, 32, 22)];
        [toggleButton addTarget:self action:@selector(togglePressed) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *toggle = [[UIBarButtonItem alloc] initWithCustomView:toggleButton];
        self.navigationItem.leftBarButtonItem = toggle;
    }
}

- (void) loadJournalPosts
{
    _posts = nil;
    NSMutableArray* subviews = [[_scrollView subviews] mutableCopy];
    [_scrollView setContentSize:CGSizeMake(320, 0)];
    if ([[_scrollView.subviews objectAtIndex:0] isKindOfClass:[UIButton class]]) {
        [subviews removeObjectAtIndex:0];
    }
    for (UIView* subview in subviews) {
        if (![subview isKindOfClass:[UIImageView class]]) {
            [subview removeFromSuperview];
        }
    }

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer* serializer = [AFHTTPRequestSerializer serializer];
    [serializer setValue:_appDel.authToken forHTTPHeaderField:@"token"];
    [manager setRequestSerializer:serializer];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString* url = _journalToLoad ? _journalToLoad : API_GET_JOURNAL;
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _posts = [responseObject valueForKey:@"Updates"];
        [self loadPostsIntoJournal:_posts];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Sorry, an error occured." delegate:Nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void) loadPostsIntoJournal:(NSArray*) postsToLoad
{
    int offsetY;
    if (_scrollView.contentSize.height == 0) {
        _scrollView.contentSize = CGSizeMake(320, 40);
        offsetY = 70;
        if ([_appDel.role isEqualToString:@"Doctor"]){
            offsetY = 10;
        }
    } else {
        offsetY = _scrollView.contentSize.height;
    }
    for (NSDictionary* post in postsToLoad) {
        // set up the view
        JournalEntryView *entry = [[[NSBundle mainBundle] loadNibNamed:@"JournalEntryView" owner:self options:nil] lastObject];
        NSString* moodImageName = [post valueForKey:@"mood"];
        if (moodImageName.length > 0) {
            entry.moodImageView.image = [UIImage imageNamed:moodImageName];
        }
        entry.entryID = [NSNumber numberWithUnsignedInteger:[[post valueForKey:@"id"] unsignedIntegerValue]];
        entry.frame = CGRectMake(0, offsetY, entry.frame.size.width, entry.frame.size.height);
        if([[post valueForKey:@"message"] length] < 1){
            entry.messageLabel.hidden = YES;
            entry.messageTriangle.hidden = YES;
        }else{
            UILabel *newTextView = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 0, 0)];
            [newTextView setFont:[UIFont systemFontOfSize:14]];
            newTextView.text = [NSString stringWithFormat:@"  %@  ", [post valueForKey:@"message"]];
            newTextView.userInteractionEnabled = NO;
            newTextView.lineBreakMode = NSLineBreakByWordWrapping;
            newTextView.numberOfLines = 0;
            [newTextView.layer setCornerRadius:8.0f];
            [newTextView setBackgroundColor:[UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1.0f]];
            [newTextView sizeToFit];
            CGRect frame = newTextView.frame;
            frame.size.height = frame.size.height + 5;
            int scale = newTextView.text.length / 20;
            if(frame.size.width > 150){
                frame.size.width = 150;
            }
            frame.size.height = 20 * (scale + 1);
            NSLog(@"size W%f size H%f %i", frame.size.width,frame.size.height, scale);
            newTextView.frame = frame;
            [entry.messageHandler addSubview:newTextView];
        }
        
        entry.audienceLabel.text = [post valueForKey:@"user_circle"];
//        NSDate* creationDate = [NSDate dateWithTimeIntervalSince1970:[[post valueForKey:@"created"] unsignedIntegerValue]];
//        entry.timestampLabel.text = [[SORelativeDateTransformer registeredTransformer] transformedValue:creationDate];
        NSTimeInterval _interval=[[post valueForKey:@"created"] unsignedIntegerValue];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
        NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
        [_formatter setDateFormat:@"dd/MM/yy HH:mm a"];
        entry.timestampLabel.text = [_formatter stringFromDate:date];

        // side effects
        symptomOffset = 0;
        NSArray* sideEffects = [post valueForKey:@"sideEffects"];
//        if (sideEffects.count) {
//            entry.scaleHeadLabel.text = [[[sideEffects objectAtIndex:0] valueForKey:@"name"] uppercaseString];
//            [entry setScaleFactor:[[[sideEffects objectAtIndex:0] valueForKey:@"level"] unsignedIntegerValue] animated:NO];
//            [entry setImpactScaleFactor:[[[sideEffects objectAtIndex:0] valueForKey:@"level2"] unsignedIntegerValue] animated:NO];
//            if (sideEffects.count > 1) {
//                entry.scaleHeadLabel2.text = [[[sideEffects objectAtIndex:1] valueForKey:@"name"] uppercaseString];
//                [entry setSecondScaleFactor:[[[sideEffects objectAtIndex:1] valueForKey:@"level"] unsignedIntegerValue] animated:NO];
//                [entry setSecondImpactScaleFactor:[[[sideEffects objectAtIndex:1] valueForKey:@"level2"] unsignedIntegerValue] animated:NO];
//            } else {
//                [entry.scaleHeadLabel2 setText:@""];
//                [entry setSecondScaleFactor:0 animated:NO];
//            }
//#warning needs better implementation!
////            if (sideEffects.count > 2) {
////                [entry addSideEffectWithName:[[[sideEffects objectAtIndex:2] valueForKey:@"name"] uppercaseString]];
////            }
//        } else {
//            [entry removeAnySideEffects];
//        }
        for(NSDictionary *dict in sideEffects){
            NSString *text = [NSString stringWithFormat:@"%@/10 %@ (%@)",[dict valueForKey:@"level"],[dict valueForKey:@"name"],[dict valueForKey:@"level2"]];
            if([[dict valueForKey:@"level"] intValue] == 0){
                 text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"name"]];
            }
            if([[dict valueForKey:@"name"] isEqualToString:@"Fever"]){
                text = [NSString stringWithFormat:@"%@ %@",[dict valueForKey:@"name"], [dict valueForKey:@"fever"]];
            }
            [self createSymptom:text inView:entry.symptomParent];
        }
        CGRect frame = entry.symptomParent.frame;
        frame.size.height = symptomOffset;
        entry.symptomParent.frame = frame;
        
        frame = entry.audienceLabel.frame;
        frame.origin.y =  entry.symptomParent.frame.size.height + entry.symptomParent.frame.origin.y;
        entry.audienceLabel.frame = frame;
        [entry setup];

        self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, self.scrollView.contentSize.height + entry.frame.size.height);
        [self.scrollView addSubview:entry];
        [_scrollViewSubviews addObject:entry];
        offsetY += entry.frame.size.height;

        // comments
        BOOL hasMoreCommentsButton = NO;
        int lastCommentAddedYPosition = entry.frame.origin.y + entry.frame.size.height + 5;
        if ([[post valueForKey:@"comments_total"] unsignedIntegerValue] > 0) {
            NSArray* comments = [post valueForKey:@"comments"];
            for (NSDictionary* comment in comments) {
                entry.totalComments = @([[post valueForKey:@"comments_total"] unsignedIntegerValue]);
                // create it
                JournalCommentView* commentView = [[[NSBundle mainBundle] loadNibNamed:@"JournalCommentView" owner:self options:nil] lastObject];
                commentView.entryID = entry.entryID;
                commentView.commentLabel.text = [comment valueForKey:@"message"];
                NSTimeInterval _interval=[[post valueForKey:@"created"] unsignedIntegerValue];
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
                NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
                [_formatter setDateFormat:@"dd/MM/yy HH:mm a"];
                commentView.timestampLabel.text = [_formatter stringFromDate:date];
//                commentView.timestampLabel.text = [[SORelativeDateTransformer registeredTransformer] transformedValue:[NSDate dateWithTimeIntervalSince1970:[[comment valueForKey:@"created"] unsignedIntegerValue]]];
                commentView.nameLabel.text = [comment valueForKey:@"name"];
                
                commentView.frame = CGRectMake(0, offsetY, commentView.frame.size.width, commentView.frame.size.height);
                if ([[comment valueForKey:@"photo"] length] > 0) {
                    commentView.avatarImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",API_MAIN,[comment valueForKey:@"photo"]]]]];
                } else {
                    commentView.avatarImageView.image = [UIImage imageNamed:@"noPhoto"];
                }
                [commentView setup];
                self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, self.scrollView.contentSize.height + commentView.frame.size.height);
                [self.scrollView addSubview:commentView];
                [_scrollViewSubviews addObject:commentView];
                offsetY += commentView.frame.size.height + 2.5;
                lastCommentAddedYPosition += commentView.frame.size.height + 2.5;
            }
            if ([[post valueForKey:@"comments_total"] unsignedIntegerValue] > 3) {
                UIButton* moreCommentsButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [moreCommentsButton setImage:[UIImage imageNamed:@"moreComments"] forState:UIControlStateNormal];
                moreCommentsButton.tag = [entry.entryID unsignedIntegerValue];
                [moreCommentsButton addTarget:self action:@selector(moreCommentsPressed:) forControlEvents:UIControlEventTouchUpInside];
                moreCommentsButton.frame = CGRectMake(10, lastCommentAddedYPosition, 148, 42);
                [self.scrollView addSubview:moreCommentsButton];
                [_scrollViewSubviews addObject:moreCommentsButton];
                hasMoreCommentsButton = YES;
            }
        }

        UIButton* addCommentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [addCommentButton setImage:[UIImage imageNamed:@"newComment"] forState:UIControlStateNormal];
        addCommentButton.tag = [entry.entryID unsignedIntegerValue];
        [addCommentButton addTarget:self action:@selector(addCommentPressed:) forControlEvents:UIControlEventTouchUpInside];
        addCommentButton.frame = CGRectMake(160, lastCommentAddedYPosition, 148, 42);
        if (!hasMoreCommentsButton) {
            addCommentButton.center = CGPointMake(self.view.center.x, addCommentButton.center.y);
        }
        [self.scrollView addSubview:addCommentButton];
        [_scrollViewSubviews addObject:addCommentButton];
        offsetY += addCommentButton.frame.size.height + 10;
        self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.scrollView.contentSize.height + addCommentButton.frame.size.height + 7.2);
    }
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, (self.scrollView.contentSize.height + (_posts.count * 4)));
}

- (void) createSymptom:(NSString *)text inView:(UIView *)parentView{
    UITextView *newTextView = [[UITextView alloc] initWithFrame:CGRectMake(5, symptomOffset, 300, 0)];
    [newTextView setFont:[UIFont systemFontOfSize:14]];
    newTextView.text = text;
    newTextView.userInteractionEnabled = NO;
    [newTextView sizeToFit];
    [newTextView.layer setCornerRadius:8.0f];
    [newTextView setBackgroundColor:[UIColor lightGrayColor]];
    CGRect frame = newTextView.frame;
    symptomOffset += frame.size.height + 5;
    [parentView addSubview:newTextView];
}


- (void) moreCommentsPressed:(id)sender
{
    CommentsVC* comments = [self.storyboard instantiateViewControllerWithIdentifier:@"CommentsVC"];
    [comments setSelectedPostID:[NSNumber numberWithInteger:[(UIButton *)sender tag]]];
    [self.navigationController pushViewController:comments animated:YES];
}

- (void) addCommentPressed:(id)sender
{
    _entryIdToCommentOn = [NSNumber numberWithInt:[(UIButton *)sender tag]];
    NSLog(@"Entry id to comment on = %@",_entryIdToCommentOn);
    UIAlertView *addComment = [[UIAlertView alloc]initWithTitle:@"Add comment" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    addComment.alertViewStyle = UIAlertViewStylePlainTextInput;
    [addComment show];
}

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ([[[alertView textFieldAtIndex:0] text] length] > 0) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPRequestSerializer* serializer = [AFHTTPRequestSerializer serializer];
        [serializer setValue:_appDel.authToken forHTTPHeaderField:@"token"];
        [manager setRequestSerializer:serializer];
        NSDictionary *parameters = @{@"post_id": _entryIdToCommentOn, @"message": [[alertView textFieldAtIndex:0] text] };
        [manager POST:API_POST_JOURNAL_COMMENT parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([[responseObject valueForKey:@"result"] integerValue] == 1) {
                MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                [self.navigationController.view addSubview:HUD];
                HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
                HUD.mode = MBProgressHUDModeCustomView;
                HUD.delegate = self;
                HUD.labelText = @"Commented!";
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [HUD show:YES];
                for (int i = 0; i < _scrollViewSubviews.count; i++) {
                    id entry = [_scrollViewSubviews objectAtIndex:i];
                    NSLog(@"Entry %@",entry);
                    if ([entry isMemberOfClass:[JournalEntryView class]]) {
                        NSLog(@"Journal entry %@",entry);
                        NSLog(@"Entry ID to comment on %d", [_entryIdToCommentOn integerValue]);
                        NSLog(@"Entry ID %d", [[entry entryID] unsignedIntegerValue]);
                        if ([[entry entryID] unsignedIntegerValue] == [_entryIdToCommentOn integerValue]) {
                            NSLog(@"Should add comment below entry with message %@",[[entry messageLabel] text]);
                            NSUInteger idx = [_scrollViewSubviews indexOfObject:entry];
                            JournalCommentView* commentView = [[[NSBundle mainBundle] loadNibNamed:@"JournalCommentView" owner:self options:nil] lastObject];
                            commentView.entryID = [entry entryID];
                            commentView.commentLabel.text = [[alertView textFieldAtIndex:0] text];
                            commentView.timestampLabel.text = [[SORelativeDateTransformer registeredTransformer] transformedValue:[NSDate date]];
                            commentView.nameLabel.text = _appDel.firstName;
                            [commentView setup];
                            NSLog(@"Entry frame: %@",NSStringFromCGRect([entry frame]));
                            NSLog(@"Entry Y Pos: %f",[entry frame].origin.x + [entry frame].size.height + 3);
                            commentView.frame = CGRectMake(0, [entry frame].origin.y + [entry frame].size.height + 3, commentView.frame.size.width, commentView.frame.size.height);
                            NSLog(@"Comment view frame: %@",NSStringFromCGRect(commentView.frame));
                            if (_appDel.publicImage) {
                                commentView.avatarImageView.image = _appDel.publicImage;
                            } else {
                                commentView.avatarImageView.image = [UIImage imageNamed:@"noPhoto"];
                            }

                            if ([[entry totalComments] unsignedIntegerValue] >= 2) {
                                JournalCommentView* firstComment = [_scrollViewSubviews objectAtIndex:idx+1];
                                firstComment.frame = CGRectOffset(firstComment.frame, 0, commentView.frame.size.height+3);

                                JournalCommentView* secondComment = [_scrollViewSubviews objectAtIndex:idx+2];
                                [secondComment removeFromSuperview];
                                [_scrollViewSubviews removeObject:secondComment];
                            } else {
                                for (int i = idx+1; i < _scrollViewSubviews.count; i++) {
                                    UIView* view = (UIView*)[_scrollViewSubviews objectAtIndex:i];
                                    view.frame = CGRectOffset(view.frame, 0, commentView.frame.size.height+3);
                                }
                            }

                            self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, self.scrollView.contentSize.height + commentView.frame.size.height);
                            [self.scrollView addSubview:commentView];
                            [_scrollViewSubviews insertObject:commentView atIndex:idx+1];
                            break;
                        }
                    }
                }
                _entryIdToCommentOn = @0;
                [HUD hide:YES afterDelay:1.25];
            } else {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Sorry, couldn't post comment. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Sorry, couldn't post comment. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }];
    }else{
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Add at least 1 char" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

#pragma mark -
#pragma mark - UIScrollView delegate

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    float offsetY = scrollView.contentOffset.y;
    float scrollViewHeightThreshold = scrollView.contentSize.height - (scrollView.contentSize.height/6);
    if (offsetY > scrollViewHeightThreshold) {
    if (_hasMoreJournalPosts && !_isLoadingJournalPosts) {
            _isLoadingJournalPosts = YES;
            [self loadMorePosts];
        }
    }
}

- (void) loadMorePosts
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer* serializer = [AFHTTPRequestSerializer serializer];
    [serializer setValue:_appDel.authToken forHTTPHeaderField:@"token"];
    [manager setRequestSerializer:serializer];
    NSString* url = _journalToLoad ? _journalToLoad : [NSString stringWithFormat:@"%@%@",API_GET_JOURNAL,_appDel.userID];
    url = [url stringByAppendingFormat:@"/%u",_journalPageToLoad];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Journal page = %u",_journalPageToLoad);
        NSArray* morePosts = [responseObject valueForKey:@"Updates"];
        if (morePosts.count) {
            _journalPageToLoad++;
            [self loadPostsIntoJournal:morePosts];
            _isLoadingJournalPosts = NO;
            _hasMoreJournalPosts = YES;
        } else {
            _isLoadingJournalPosts = NO;
            _hasMoreJournalPosts = NO;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _isLoadingJournalPosts = NO;
        _hasMoreJournalPosts = NO;
    }];
}

@end