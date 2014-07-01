//
//  JournalEntryStepThree.m
//  CancerLife
//
//  Created by Constantin Lungu on 11/23/13.
//  Copyright (c) 2013 FusionWorks. All rights reserved.
//

#import "JournalEntryStepThree.h"
#import <QuartzCore/QuartzCore.h>
#import "Defines.h"
#import "Utils.h"
#import "BSKeyboardControls.h"
#import "AFHTTPRequestOperationManager.h"
#import "AppDelegate.h"
#import "Defines.h"

@interface JournalEntryStepThree ()
{
    AppDelegate*        _appDel;
    NSString*           choisenCircle;
}

- (void)setupView;
@end

@implementation JournalEntryStepThree

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
    _appDel = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [self setupView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)automaticallyAdjustsScrollViewInsets
{
    return NO;
}

- (void)setupView
{
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:@[ self.textView ]]];
    self.keyboardControls.delegate = self;
    [self.keyboardControls setVisibleControls:BSKeyboardControlDone];

    if (!IS_IOS_7) {
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        _contentView.frame = CGRectOffset(_contentView.frame, 0, -70);
    }
    
    _textView.layer.cornerRadius = 5.0f;
    [_pickerView reloadAllComponents];
}

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls
{
    [self.textView resignFirstResponder];
}

- (void)makeJournalEntryWithPrivate:(BOOL)private
{
    NSMutableDictionary* postBody = [NSMutableDictionary dictionary];
    if (private) {
        [postBody setValue:@TRUE forKey:@"private"];
        if([choisenCircle length] > 0)
            [postBody setValue:choisenCircle forKey:@"circle"];
    } else {
        [postBody setValue:@FALSE forKey:@"private"];
    }
    [postBody setValue:_selectedMoodImageName forKey:@"mood"];
    if (_selectedSideEffects == nil)
        _selectedSideEffects = @[];
    [postBody setValue:_selectedSideEffects forKey:@"side_effects"];
    [postBody setValue:_textView.text forKey:@"message"];
    NSLog(@"Post body = %@",postBody);

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFJSONRequestSerializer* serializer = [AFJSONRequestSerializer serializer];
    [serializer setValue:_appDel.authToken forHTTPHeaderField:@"token"];
    [manager setRequestSerializer:serializer];

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [manager POST:API_POST_JOURNAL parameters:postBody success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"JSON: %@", responseObject);
        if ([[responseObject valueForKey:@"result"] integerValue] == 1) {
            NSDictionary *alerts = [responseObject valueForKey:@"alert"];
            NSLog(@"CL size %@", alerts);
            if([alerts count] > 0){
                for(int i=0; i < [alerts count]; i++){
                    if (i == 0) {
                        [[[UIAlertView alloc] initWithTitle:@"Alert" message:[[responseObject valueForKey:@"alert"] objectAtIndex:i] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                    }else{
                        [[[UIAlertView alloc] initWithTitle:@"Alert" message:[[responseObject valueForKey:@"alert"] objectAtIndex:i] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                    }
                    
                }
            }else{
                [self showSuccessHud];
            }
        } else {
            NSLog(@"Error: %@", responseObject);
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Sorry, couldn't post entry. Please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Sorry, couldn't post entry. Please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
}

- (void)showSuccessHud
{
    MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.delegate = self;
    HUD.labelText = @"Posted!";
    [HUD show:YES];
    [HUD hide:YES afterDelay:1.5];
    _appDel.journalVC.shouldRefreshJournal = YES;
    [self.navigationController popToViewController:_appDel.journalVC animated:YES];
}

- (IBAction)trackPressed
{
    [self makeJournalEntryWithPrivate:NO];
}

- (IBAction)broadcastPressed
{
    [_pickerView setHidden:NO];
}
#pragma mark UIAlertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
        [self showSuccessHud];
    
}
#pragma mark


#pragma mark -
#pragma mark PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return _pickerArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    
    return _pickerArray[row];
}

#pragma mark -
#pragma mark PickerView Delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    choisenCircle = [_pickerArray objectAtIndex:row];
    [self makeJournalEntryWithPrivate:YES];
    [_pickerView setHidden:YES];
   
}

@end
