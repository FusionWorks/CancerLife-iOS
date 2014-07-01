//
//  InviteSupporterVC.m
//  CancerLife
//
//  Created by Constantin Lungu on 11/7/13.
//  Copyright (c) 2013 FusionWorks. All rights reserved.
//

#import "InviteSupporterVC.h"
#import "AFHTTPRequestOperationManager.h"
#import "AppDelegate.h"
#import "Defines.h"
#import "Utils.h"

@interface InviteSupporterVC ()
{
    AppDelegate*            _appDel;
}

@end

@implementation InviteSupporterVC

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
    if (!IS_IOS_7) {
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        [[UINavigationBar appearance] setTitleTextAttributes:
         [NSDictionary dictionaryWithObjectsAndKeys:
          [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1],
          UITextAttributeTextColor,
          nil]];
        _emailFieldView.frame = CGRectOffset(_emailFieldView.frame, 0, -60);
        _emailTextField.frame = CGRectOffset(_emailTextField.frame, 0, -60);
    }
    _appDel = (AppDelegate*) [UIApplication sharedApplication].delegate;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelInvitePressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)sendInvitePressed:(id)sender
{
    if (_emailTextField.text.length > 0) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPRequestSerializer* serializer = [AFHTTPRequestSerializer serializer];
        [serializer setValue:_appDel.authToken forHTTPHeaderField:@"token"];
        [manager setRequestSerializer:serializer];
        NSDictionary *parameters = @{ @"Invites": [NSArray arrayWithObject: @{ @"email": _emailTextField.text } ] };
        NSLog(@"Parameters = %@",parameters);
        [manager POST:API_POST_SUPPORTERS parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([[responseObject valueForKey:@"result"] unsignedIntegerValue] == 0) {
                [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Couldn't send invite. Please try again later." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil] show];
            } else {
                [[[UIAlertView alloc] initWithTitle:@"Success" message:@"Invite sent!" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil] show];
            }
            NSLog(@"Result = %@",responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Couldn't send invite. Please try again later." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil] show];
        }];
    }

}
@end
