//
//  PatientManagementVC.m
//  CancerLife
//
//  Created by Constantin Lungu on 11/29/13.
//  Copyright (c) 2013 FusionWorks. All rights reserved.
//

#import "PatientManagementVC.h"
#import "AppDelegate.h"
#import "AFHTTPRequestOperationManager.h"
#import "JournalEntryView.h"
#import "SORelativeDateTransformer.h"
#import "Defines.h"
#import "Utils.h"
#import "JournalVC.h"
#import "ReportsVC.h"

@interface PatientManagementVC ()
{
    AppDelegate*           _appDel;
    NSArray*               _patients;
    NSMutableArray*        _scrollViewSubviews;
    NSMutableDictionary*   _patientsBySeverity;
    int                     symptomOffset;
}

- (void)setupView;
- (void)loadPatients;
- (void)loadEntries:(NSArray*)entries;
@end

@implementation PatientManagementVC

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
    _scrollViewSubviews = [NSMutableArray array];
    _patientsBySeverity = [@{ @1: @[],
                              @2: @[],
                              @3: @[],
                              @4: @[]} mutableCopy];
    [self setupView];
    [self loadPatients];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark - Private API

- (void)setupView
{
    _scrollView.contentSize = CGSizeMake(320, IS_IOS_7? 20 : 30);
    _scrollView.frame = CGRectMake(_scrollView.frame.origin.x, _scrollView.frame.origin.y - 60, _scrollView.frame.size.width, _scrollView.frame.size.height + 65);
    _scrollView.showsVerticalScrollIndicator = YES;
    _scrollView.delegate = self;
}

- (void)loadPatients
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer* serializer = [AFHTTPRequestSerializer serializer];
    _appDel.authToken = @"cf7dcbcad47b1845100090fdcc988144";
    [serializer setValue:_appDel.authToken forHTTPHeaderField:@"token"];
    NSLog(@"Token:%@",_appDel.authToken);
    [manager setRequestSerializer:serializer];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [manager GET:API_GET_PATIENTS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Response: %@",responseObject);
        if ([responseObject[@"result"] integerValue] == 1) {
            _patients = [responseObject valueForKey:@"patients"];
            for (NSDictionary* patient in _patients) {
                NSMutableArray* patientsBySever = [_patientsBySeverity[patient[@"severity"]] mutableCopy];
                [patientsBySever addObject:patient];
                _patientsBySeverity[patient[@"severity"]] = patientsBySever;
            }
            NSLog(@"Patients by severity: %@",_patientsBySeverity);
            [_segmentedControl setSelectedSegmentIndex:0];
            [_segmentedControl sendActionsForControlEvents:UIControlEventValueChanged];
//            [self loadEntries:_patientsBySeverity[@1]];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Sorry, couldn't load patients. Please try again later." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil] show];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Sorry, an error occured." delegate:Nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show]; 
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)loadEntries:(NSArray*)entries
{
    int offsetY;
    if (_scrollView.contentSize.height == 0) {
        _scrollView.contentSize = CGSizeMake(320, 40);
        offsetY = 60;
    } else {
        offsetY = _scrollView.contentSize.height + (IS_IOS_7? 25 : 25);
    }
    for (NSDictionary* entry in entries) {
        symptomOffset = 0;
        // set up the view
        JournalEntryView *patient = [[[NSBundle mainBundle] loadNibNamed:@"JournalEntryView" owner:self options:nil] lastObject];
        NSString* photo = [entry valueForKey:@"public_image"];
        if (photo.length > 0) {
            patient.moodImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",API_MAIN,photo]]]];
        } else {
            patient.moodImageView.image = [UIImage imageNamed:@"noPhoto"];
        }
        NSString* phone = entry[@"cell_phone"];
        phone = [phone stringByReplacingOccurrencesOfString:@"(" withString:@""];
        phone = [phone stringByReplacingOccurrencesOfString:@" " withString:@""];
        phone = [phone stringByReplacingOccurrencesOfString:@")" withString:@""];
        phone = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
        phone = [@"+" stringByAppendingString:phone];
        patient.phoneNumber = phone;
        patient.nameLabel.text = entry[@"name"];
        patient.entryID = @([[entry valueForKey:@"id"] unsignedIntegerValue]);
        patient.tag = [[patient entryID] integerValue];
        patient.jid = [entry valueForKey:@"jid"];
        patient.frame = CGRectMake(0, offsetY, patient.frame.size.width, patient.frame.size.height);
//        patient.messageLabel.text = [entry valueForKey:@"message"];
//        NSLog(@"message %@",[patient.messageLabel text]);
//        [patient.messageLabel sizeToFit];
        
        if([[entry valueForKey:@"message"] length] < 1){
            patient.messageLabel.hidden = YES;
            patient.messageTriangle.hidden = YES;
        }else{
            UITextView *newTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 10, 0, 0)];
            [newTextView setFont:[UIFont systemFontOfSize:14]];
            newTextView.text = [entry valueForKey:@"message"];
            newTextView.userInteractionEnabled = NO;
            [newTextView.layer setCornerRadius:8.0f];
            [newTextView setBackgroundColor:[UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1.0f]];
            [newTextView sizeToFit];
            CGRect frame = newTextView.frame;
            frame.size.height = frame.size.height + 5;
            frame.origin.y = patient.nameLabel.frame.size.height;
            if(frame.size.width > 190){
                frame.size.width = 190;
            }
            newTextView.frame = frame;
            [patient.messageHandler addSubview:newTextView];
            
            frame = patient.messageTriangle.frame;
            frame.origin.y = patient.nameLabel.frame.size.height + patient.nameLabel.frame.origin.y + 30;
            patient.messageTriangle.frame = frame;
        }
//        NSDate* creationDate = [NSDate dateWithTimeIntervalSince1970:[[entry valueForKey:@"time"] doubleValue]];
//        patient.timestampLabel.text = [[SORelativeDateTransformer registeredTransformer] transformedValue:creationDate];
        NSTimeInterval _interval=[[entry valueForKey:@"time"] doubleValue];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
        NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
        [_formatter setDateFormat:@"dd/MM/yy HH:mm a"];
        CGRect newFrame = patient.timestampLabel.frame;
        newFrame.origin.y = 0;
        patient.timestampLabel.frame = newFrame;

        patient.timestampLabel.text = [_formatter stringFromDate:date];
        
        if ([entry[@"pending"] integerValue] == 1) {
            [patient enablePending];
        }
        patient.delegate = self;
        // side effects
        NSArray* sideEffects = [entry valueForKey:@"side_effects"];
//        if (sideEffects.count) {
//            patient.scaleHeadLabel.text = [[[sideEffects objectAtIndex:0] valueForKey:@"name"] uppercaseString];
//            [patient setScaleFactor:[[[sideEffects objectAtIndex:0] valueForKey:@"level"] unsignedIntegerValue] animated:NO];
//            [patient setImpactScaleFactor:[[[sideEffects objectAtIndex:0] valueForKey:@"level2"] unsignedIntegerValue] animated:NO];
//            if (sideEffects.count > 1) {
//                patient.scaleHeadLabel2.text = [[[sideEffects objectAtIndex:1] valueForKey:@"name"] uppercaseString];
//                [patient setSecondScaleFactor:[[[sideEffects objectAtIndex:1] valueForKey:@"level"] unsignedIntegerValue] animated:NO];
//                [patient setSecondImpactScaleFactor:[[[sideEffects objectAtIndex:1] valueForKey:@"level2"] unsignedIntegerValue] animated:NO];
//            } else {
//                [patient.scaleHeadLabel2 setText:@""];
//                [patient setSecondScaleFactor:0 animated:NO];
//            }
//        } else {
//            [patient removeAnySideEffects];
//        }
//        [patient setup];
        for(NSDictionary *dict in sideEffects){
            NSString *text = [NSString stringWithFormat:@"%@/10 %@ (%@)",[dict valueForKey:@"level"],[dict valueForKey:@"name"],[dict valueForKey:@"level2"]];
            if([[dict valueForKey:@"level"] intValue] == 0){
                text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"name"]];
            }
            if([[dict valueForKey:@"name"] isEqualToString:@"Fever"]){
                text = [NSString stringWithFormat:@"%@ %@",[dict valueForKey:@"name"], [dict valueForKey:@"level"]];
            }
            [self createSymptom:text inView:patient.symptomParent];
        }
        if([sideEffects count]<=2){
            symptomOffset = symptomOffset/2;
        }
        CGRect frame = patient.symptomParent.frame;
        frame.size.height = symptomOffset;
        patient.symptomParent.frame = frame;
        [patient setup];
        
//        self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, self.scrollView.contentSize.height + patient.frame.size.height);
//        [self.scrollView addSubview:patient];
//        [_scrollViewSubviews addObject:entry];
//        offsetY += patient.frame.size.height;
        [patient enableDoctorMode];

        self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, self.scrollView.contentSize.height + patient.frame.size.height);
        [self.scrollView addSubview:patient];
        [_scrollViewSubviews addObject:patient];
        offsetY += patient.frame.size.height;

        UIButton* sendMessageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [sendMessageButton setImage:[UIImage imageNamed:@"sendMessage"] forState:UIControlStateNormal];
        [sendMessageButton setTitle:patient.jid forState:UIControlStateNormal];
        [sendMessageButton setTag:[[patient entryID] integerValue]];
        [sendMessageButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [sendMessageButton addTarget:self action:@selector(sendMessagePressed:) forControlEvents:UIControlEventTouchUpInside];
        sendMessageButton.frame = CGRectMake(10, offsetY + 5, 146, 42);
        [_scrollViewSubviews addObject:sendMessageButton];
        [_scrollView addSubview:sendMessageButton];

        UIButton* makeCallButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [makeCallButton setImage:[UIImage imageNamed:@"makeCall"] forState:UIControlStateNormal];
        [makeCallButton addTarget:self action:@selector(makeCallPressed:) forControlEvents:UIControlEventTouchUpInside];
        makeCallButton.tag = [patient.entryID integerValue];
        makeCallButton.frame = CGRectMake(164, offsetY + 5, 146, 42);
        [_scrollViewSubviews addObject:makeCallButton];
        [_scrollView addSubview:makeCallButton];

        _scrollView.contentSize = CGSizeMake(_scrollView.contentSize.width, _scrollView.contentSize.height + makeCallButton.frame.size.height + 5);
        offsetY += 44;
    }

    _scrollView.contentSize = CGSizeMake(_scrollView.contentSize.width, _scrollView.contentSize.height + (IS_IOS_7? 25 : 25));
}

- (void)sendMessagePressed:(id)sender
{
    JournalEntryView *entryView = (JournalEntryView *)[self.scrollView viewWithTag:[sender tag]];
    MessagesVC* messages = [self.storyboard instantiateViewControllerWithIdentifier:@"MessagesVC"];
    [messages setJid:[entryView jid]];
    [messages setName:[[entryView nameLabel] text]];
    [messages setPhoto:[[entryView moodImageView] image]];
    [messages setMyName:_appDel.firstName];
    [messages setMyPhoto:_appDel.publicImage];
    [self.navigationController pushViewController:messages animated:YES];
}

- (void) createSymptom:(NSString *)text inView:(UIView *)parentView{
    UITextView *newTextView = [[UITextView alloc] initWithFrame:CGRectMake(110, symptomOffset, 300, 0)];
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

- (void)makeCallPressed:(id)sender
{
    NSString* phoneNumber;
    for (JournalEntryView* entry in _scrollViewSubviews) {
        if ([entry isMemberOfClass:[JournalEntryView class]]) {
            if ([entry.entryID integerValue] == [sender tag]) {
                phoneNumber = [@"telprompt://" stringByAppendingString:entry.phoneNumber];
                break;
            }
        }
    }
    if (phoneNumber) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    }
}

#pragma mark -
#pragma mark - Public API

- (IBAction)segmentedControlValueChanged
{
    _scrollView.contentSize = CGSizeMake(320, IS_IOS_7? 20 : 30);
    [_scrollViewSubviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if ([[_segmentedControl titleForSegmentAtIndex:_segmentedControl.selectedSegmentIndex] isEqualToString:@"Search"]) {
        [self addCommentPressed:nil];
    }else if([[_segmentedControl titleForSegmentAtIndex:_segmentedControl.selectedSegmentIndex] isEqualToString:@"All"]){
        NSMutableArray *array = [[NSMutableArray alloc] init];
        array = [[[_patientsBySeverity objectForKey:@(1)] arrayByAddingObjectsFromArray:[_patientsBySeverity objectForKey:@(2)]] mutableCopy];
        array = [[array arrayByAddingObjectsFromArray:[_patientsBySeverity objectForKey:@(3)]] mutableCopy];
        array = [[array arrayByAddingObjectsFromArray:[_patientsBySeverity objectForKey:@(4)]] mutableCopy];
        NSLog(@"all arr %@",array);
        [self loadEntries:array];
    }else{
        [self loadEntries:[_patientsBySeverity objectForKey:@(_segmentedControl.selectedSegmentIndex)]];
    }
}

- (void) addCommentPressed:(id)sender
{
    UIAlertView *addComment = [[UIAlertView alloc]initWithTitle:@"Type to search" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    addComment.alertViewStyle = UIAlertViewStylePlainTextInput;
    [addComment show];
}

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ([[[alertView textFieldAtIndex:0] text] length] > 0) {
        MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [HUD show:YES];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPRequestSerializer* serializer = [AFHTTPRequestSerializer serializer];
        [serializer setValue:_appDel.authToken forHTTPHeaderField:@"token"];
        [manager setRequestSerializer:serializer];
        NSString *searchUrl = [NSString stringWithFormat:@"%@%@",API_GET_SEARCH, [[alertView textFieldAtIndex:0] text]];
        [manager GET:searchUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([[responseObject valueForKey:@"result"] integerValue] == 1) {
                
                [self.navigationController.view addSubview:HUD];
                HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
                HUD.mode = MBProgressHUDModeCustomView;
                HUD.delegate = self;
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                
                [HUD hide:YES afterDelay:1.25];
                [self loadEntries:[responseObject valueForKey:@"patients"]];
            } else {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Sorry, can't find anything. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Sorry, can't find anything. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }];
    }else{
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Add at least 1 char" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

- (void)journalPressedOnEntry:(JournalEntryView *)entry
{
    NSUInteger userId = [entry.entryID unsignedIntegerValue];
    JournalVC* journal = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"JournalVC"];
    [journal setJournalToLoad:[NSString stringWithFormat:@"%@%u",API_GET_JOURNAL,userId]];
    [self.navigationController pushViewController:journal animated:YES];
}

- (void)reportsPressedOnEntry:(JournalEntryView *)entry
{
    ReportsVC* reports = [self.storyboard instantiateViewControllerWithIdentifier:@"ReportsVC"];
    [reports setPatientID:entry.entryID];
    [self.navigationController pushViewController:reports animated:YES];
}
@end
