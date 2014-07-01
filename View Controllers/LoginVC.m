//
//  LoginVC.m
//  CancerLife
//
//  Created by Constantin Lungu on 9/24/13.
//  Copyright (c) 2013 FusionWorks. All rights reserved.
//

#import "LoginVC.h"
#import "Utils.h"
#import "MFSideMenu.h"
#import <QuartzCore/QuartzCore.h>
#import "Defines.h"
#import "AFHTTPRequestOperationManager.h"
#import "MBProgressHUD.h"
#import "Defines.h"

@interface LoginVC (/* Private */)
{
    AppDelegate *               _appDel;
}


- (void) setupView;
- (void) screenTapped;
- (void) setupNavigationButtons;
@end

@implementation LoginVC

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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _appDel = (AppDelegate*) [UIApplication sharedApplication].delegate;
    [self setupView];
    [self setupNavigationButtons];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTapped)]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(XMPPStreamDidAuthenticate:) name:kNotificationXMPPStreamDidAuthenticate object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(XMPPStreamDidFailToAuthenticate:) name:kNotificationXMPPStreamDidFailToAuthenticate object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(XMPPStreamConnectionDidTimeout:) name:kNotificationConnectionDidTimeout object:nil];

//    _emailField.text = @"mike.theoncdoctor@yahoo.com";
//    _passwordField.text = @"5551212";

    _emailField.text = @"mr.charlietest@gmail.com";
    _passwordField.text = @"5551212";

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark - Text Field Delegate

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.view.frame.origin.y == 0) {
        int offset = -100;
        [UIView animateWithDuration:0.29f animations:^(void) {
            self.view.frame = CGRectMake(0, offset, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        }completion:nil];
    }
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _emailField) {
        [_emailField resignFirstResponder];
        [_passwordField becomeFirstResponder];
    } else if (textField == _passwordField) {
        [_passwordField resignFirstResponder];
        [self loginPressed];
    }
    return YES;
}

#pragma mark -
#pragma mark - Private API

- (void) screenTapped
{
    if (self.view.frame.origin.y != 0) {
        [UIView animateWithDuration:0.29f animations:^(void) {
            self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        }completion:nil];
    }
    [self.view endEditing:YES];
}

- (void) setupView
{
    [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginButton setTitle:@"Sign in" forState:UIControlStateNormal];
    [_loginButton.titleLabel setFont:[UIFont systemFontOfSize:18.0]];
    _loginButton.titleLabel.shadowOffset = CGSizeMake(0, 0);
    [_loginButton setTitleEdgeInsets:UIEdgeInsetsMake(-_loginButton.frame.size.height, -_loginButton.frame.size.width, -_loginButton.frame.size.height, 0.0)];
    
    [_registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_registerButton setTitle:@"Create account" forState:UIControlStateNormal];
    [_registerButton.titleLabel setFont:[UIFont systemFontOfSize:18.0]];
    _registerButton.titleLabel.shadowOffset = CGSizeMake(0, 0);
    [_registerButton setTitleEdgeInsets:UIEdgeInsetsMake(-_registerButton.frame.size.height, -_registerButton.frame.size.width, -_registerButton.frame.size.height, 0.0)];
    
    [_forgotButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_forgotButton setTitle:@"Forgot your password?" forState:UIControlStateNormal];
    [_forgotButton.titleLabel setFont:[UIFont systemFontOfSize:18.0]];
    _forgotButton.titleLabel.shadowOffset = CGSizeMake(0, 0);
    [_forgotButton setTitleEdgeInsets:UIEdgeInsetsMake(-_forgotButton.frame.size.height, -_forgotButton.frame.size.width, -_forgotButton.frame.size.height, 0.0)];
    
    if (!IS_IOS_7) {
        _emailView.frame = CGRectOffset(_emailView.frame, 0, -80);
        _passwordView.frame = CGRectOffset(_passwordView.frame, 0, -80);
        _logo.frame = CGRectOffset(_logo.frame, 0, -60);
        _loginButton.frame = CGRectOffset(_loginButton.frame, 0, -60);
        _registerButton.frame = CGRectOffset(_registerButton.frame, 0, -60);
        _forgotButton.frame = CGRectOffset(_forgotButton.frame, 0, -60);
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    }
    
    _emailField.delegate = self;
    _passwordField.delegate = self;
}

- (void) setupNavigationButtons
{
    _sideMenuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sideMenuButton setImage:[UIImage imageNamed:@"sideMenuButton"] forState:UIControlStateNormal];
    [_sideMenuButton setFrame:CGRectMake(0, 0, 32, 22)];
    [_sideMenuButton addTarget:self action:@selector(togglePressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *toggle = [[UIBarButtonItem alloc] initWithCustomView:_sideMenuButton];
    self.navigationItem.leftBarButtonItem = toggle;
}

#pragma mark -
#pragma mark - Login Action

- (IBAction)loginPressed
{
    [self screenTapped];
    if (_emailField.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter your username" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    } else if (_passwordField.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter your password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    } else {
        _loginButton.userInteractionEnabled = NO;
        _registerButton.userInteractionEnabled = NO;
        _forgotButton.userInteractionEnabled = NO;
        _emailField.userInteractionEnabled = NO;
        _passwordField.userInteractionEnabled = NO;
        // Login...
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *token = (NSString *)[defaults objectForKey:@"push_token"];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:_emailField.text, @"email", _passwordField.text, @"password", token, @"ios_id", nil];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [manager POST:API_LOGIN_ENDPOINT parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"avaa %@", responseObject);
            if ([[responseObject valueForKey:@"result"] integerValue] == 1) {
                // Success!
                
                _appDel.userName = [_emailField text];
                _appDel.password = [_passwordField text];
                _appDel.authToken = [responseObject valueForKey:@"auth_token"];
                _appDel.firstName = [responseObject valueForKey:@"first_name"];
                _appDel.lastName = [responseObject valueForKey:@"last_name"];
                _appDel.userID = [NSNumber numberWithInt:[[responseObject valueForKey:@"id"] integerValue]];
                _appDel.gender = [NSNumber numberWithInt:[[responseObject valueForKey:@"gender"] integerValue]];
                _appDel.organizationID = [NSNumber numberWithInt:[[responseObject valueForKey:@"organization_id"] integerValue]];
                _appDel.myJid = [responseObject valueForKey:@"jid"];
                int tmp = [[[responseObject valueForKey:@"roles"] objectAtIndex:0] intValue];
                
                if (tmp == 8){
                    _appDel.role = @"Doctor";
                }else{
                    _appDel.role = @"Patient";
                }
                _appDel.isLoggedIn = YES;
                _appDel.sideMenuVC.profileLabel.text = [NSString stringWithFormat:@"%@ %@",_appDel.firstName, _appDel.lastName];
                [_appDel.sideMenuVC setupView];
                _appDel.publicImage = nil;
                _appDel.privateImage = nil;
                if ([[responseObject valueForKey:@"public_image"] length] > 0) {
                    _appDel.publicImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",API_MAIN, [responseObject valueForKey:@"public_image"]]]]];
                } else {
                    _appDel.publicImage = [UIImage imageNamed:@"noPhoto"];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:PUBLIC_PHOTO_UPDATED_NOTIFICATION object:nil];
                [self getProfileInfo];
                dispatch_queue_t asyncQueue = dispatch_queue_create("some asynchronous queue name", NULL);
                dispatch_async(asyncQueue, ^{
                    
                    [_appDel connect];
                });
            } else if ([[responseObject valueForKey:@"result"] integerValue] == 0) {
                [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Email or password incorrect, please try again." delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                _loginButton.userInteractionEnabled = YES;
                _registerButton.userInteractionEnabled = YES;
                _forgotButton.userInteractionEnabled = YES;
                _emailField.userInteractionEnabled = YES;
                _passwordField.userInteractionEnabled = YES;
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Sorry, there was an error while trying to login. Please try again." delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            _loginButton.userInteractionEnabled = YES;
            _registerButton.userInteractionEnabled = YES;
            _forgotButton.userInteractionEnabled = YES;
            _emailField.userInteractionEnabled = YES;
            _passwordField.userInteractionEnabled = YES;
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
}

- (void) getProfileInfo
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer* serializer = [AFHTTPRequestSerializer serializer];
    [serializer setValue:_appDel.authToken forHTTPHeaderField:@"token"];
    [manager setRequestSerializer:serializer];
    [manager GET:API_GET_PROFILE parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _appDel.country = [responseObject valueForKey:@"country"];
        _appDel.dateOfBirth = [NSDate dateWithTimeIntervalSince1970:[[responseObject valueForKey:@"date_of_birth"] integerValue]];
        _appDel.gender = [NSNumber numberWithInt:[[responseObject valueForKey:@"gender"] integerValue]];
        _appDel.state = [responseObject valueForKey:@"state"];
        _appDel.street = [responseObject valueForKey:@"street"];
        _appDel.language = [responseObject valueForKey:@"language"];
        _appDel.city = [responseObject valueForKey:@"city"];
        _appDel.timezone = [responseObject valueForKey:@"timezone"];
        _appDel.cellPhone = [NSString stringWithFormat:@"%@",[responseObject valueForKey:@"cell_phone"]];
        _appDel.homePhone = [NSString stringWithFormat:@"%@",[responseObject valueForKey:@"home_phone"]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (IBAction)registerPressed
{
    [self performSegueWithIdentifier:@"goToChoice" sender:self];
}

- (IBAction)forgotButtonPressed
{
    
}

- (void) togglePressed
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{}];
}

#pragma mark -
#pragma mark - Notification Center Methods

- (void) XMPPStreamDidAuthenticate:(NSNotification*)notification
{
    NSLog(@"Authentication succeeded");
    if([[NSUserDefaults standardUserDefaults] objectForKey:DEFAULTS_USERS_EMAIL] == nil){
        dispatch_queue_t asyncQueue = dispatch_queue_create("some asynchronous queue name", NULL);
        dispatch_async(asyncQueue, ^{
            
            NSUserDefaults *defts = [NSUserDefaults standardUserDefaults];
            [defts setBool:YES forKey:DEFAULTS_IS_LOGGED_IN];
            [defts setValue:_emailField.text forKey:DEFAULTS_USERS_EMAIL];
            [defts setValue:_passwordField.text forKey:DEFAULTS_USERS_PASSWORD];
            [defts synchronize];
            dispatch_async(dispatch_get_main_queue(), ^{
                _loginButton.userInteractionEnabled = YES;
                _registerButton.userInteractionEnabled = YES;
                _forgotButton.userInteractionEnabled = YES;
                _emailField.userInteractionEnabled = YES;
                _passwordField.userInteractionEnabled = YES;
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self performSegueWithIdentifier:@"goToHome" sender:self];
            });
        });
    } else {
        _loginButton.userInteractionEnabled = YES;
        _registerButton.userInteractionEnabled = YES;
        _forgotButton.userInteractionEnabled = YES;
        _emailField.userInteractionEnabled = YES;
        _passwordField.userInteractionEnabled = YES;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self performSegueWithIdentifier:@"goToHome" sender:self];
    }
}

- (void) XMPPStreamConnectionDidTimeout:(NSNotification*)notification
{
    _loginButton.userInteractionEnabled = YES;
    _registerButton.userInteractionEnabled = YES;
    _forgotButton.userInteractionEnabled = YES;
    _emailField.userInteractionEnabled = YES;
    _passwordField.userInteractionEnabled = YES;
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [[[UIAlertView alloc] initWithTitle:@"Sorry" message:@"There was a connection timeout. Please try again." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
}

- (void) XMPPStreamDidFailToAuthenticate:(NSNotification*)notification
{
    _loginButton.userInteractionEnabled = YES;
    _registerButton.userInteractionEnabled = YES;
    _forgotButton.userInteractionEnabled = YES;
    _emailField.userInteractionEnabled = YES;
    _passwordField.userInteractionEnabled = YES;
    if([[[notification object] description] rangeOfString:@"<not-authorized/>"].location != NSNotFound)
    {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Wrong username or password for XMPP" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil] show];
    }
    NSLog(@"Authentication failed - %@",[notification object]);
}

@end
