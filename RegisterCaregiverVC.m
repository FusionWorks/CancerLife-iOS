//
//  RegisterCaregiverVC.m
//  CancerLife
//
//  Created by Andrew Galkin on 5/19/14.
//  Copyright (c) 2014 FusionWorks. All rights reserved.
//
#define SUCCESSFUL_REGISTRATION_ALERT_TAG           1231
#import "RegisterCaregiverVC.h"
#import "AFHTTPRequestOperationManager.h"
#import "Defines.h"
#import "AppDelegate.h"
@interface RegisterCaregiverVC (){
    NSArray *relationArray;
    NSArray *stageArray;
    NSMutableArray *currentArray;
    
    BOOL relation;
    BOOL stage;
    BOOL cancerType;
    
    NSArray* cancerTypes;
    NSArray* organizations;
    
    NSString *birthDate;
    NSString *cancerDate;
    NSString *relationChoisen;
    NSString *stageChoisen;
    NSString *cancerTypeChoisen;
    NSString *_orgId;
    NSString *_docId;
    
    BOOL birthDateBOOL;
    BOOL cancerDateBOOL;
}

@end

@implementation RegisterCaregiverVC

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
    [self setupView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setupView
{
    [self getFields];
    currentArray = [[NSMutableArray alloc] init];
    relationArray = [[NSArray alloc] initWithObjects:@"Spouse", @"Family Member", @"Parent", @"Other Caregiver", nil];
    stageArray = [[NSArray alloc] initWithObjects:@"1", @"2",@"3", @"4", @"5", @"don't know", nil];
    
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(320, 1100);
    
    CGRect frame = _scrollView.frame;
    frame.size.height = self.view.frame.size.height;
    frame.size.width = self.view.frame.size.width;
    _scrollView.frame = frame;
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTapped)]];
    _caregiverFirstName.delegate = self;
    _caregiverLastName.delegate = self;
    _caregiverEmail.delegate = self;
    _caregiverPassword.delegate = self;
    _caregiverRepeatPassword.delegate = self;
    _caregiverUsername.delegate = self;
    
    [_relationButton addTarget:self action:@selector(relation) forControlEvents:UIControlEventTouchUpInside];
    
    //patient
    _patientFirstName.delegate = self;
    _patientLastName.delegate = self;
    _patientUsername.delegate = self;
    _patientEmail.delegate = self;
    [_doctorButton addTarget:self action:@selector(choiceDoctor) forControlEvents:UIControlEventTouchUpInside];
    [_cancerTypeButton addTarget:self action:@selector(cancerType) forControlEvents:UIControlEventTouchUpInside];
    [_cancerDateButton addTarget:self action:@selector(cancerDate) forControlEvents:UIControlEventTouchUpInside];
    [_birthDate addTarget:self action:@selector(birthDateAction) forControlEvents:UIControlEventTouchUpInside];
    [_cancerStageButton addTarget:self action:@selector(cancerStage) forControlEvents:UIControlEventTouchUpInside];
    _patientZip.delegate = self;
    _patientCellphone.delegate = self;
    
    _picker.delegate = self;
    _picker.dataSource = self;
    
    [_registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_registerButton setTitle:@"Sign up" forState:UIControlStateNormal];
    [_registerButton.titleLabel setFont:[UIFont systemFontOfSize:18.0]];
    _registerButton.titleLabel.shadowOffset = CGSizeMake(0, 0);
    [_registerButton setTitleEdgeInsets:UIEdgeInsetsMake(-_registerButton.frame.size.height, -_registerButton.frame.size.width, -_registerButton.frame.size.height, 0.0)];
    _registerButton.frame = CGRectMake(_registerButton.frame.origin.x, _scrollView.contentSize.height - _registerButton.frame.size.height, _registerButton.frame.size.width, _registerButton.frame.size.height);
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
//    if (textField == _firstNameTextField || textField == _usernameField || textField == _zipCodeTextField) {
//        int firstNameOffset = IS_IOS_7? 10 : 40;
//        int usernameOffset = IS_IOS_7? 40 : 70;
//        int zipCodeOffset = IS_IOS_7? 70 : 100;
//        if (textField == _firstNameTextField) {
//            [_scrollView setContentOffset:CGPointMake(0, firstNameOffset) animated:YES];
//        } else if (textField == _usernameField) {
//            [_scrollView setContentOffset:CGPointMake(0, usernameOffset) animated:YES];
//        } else if (textField == _zipCodeTextField) {
//            [_scrollView setContentOffset:CGPointMake(0, zipCodeOffset) animated:YES];
//        }
//    }
    NSLog(@"offset %f", [textField superview].frame.origin.y + [textField superview].frame.size.height - 110);
    [_scrollView setContentOffset:CGPointMake(0, [textField superview].frame.origin.y + [textField superview].frame.size.height - 110) animated:YES];
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _caregiverFirstName) {
        [_caregiverFirstName resignFirstResponder];
        [_caregiverLastName becomeFirstResponder];
    } else if (textField == _caregiverLastName) {
        [_caregiverLastName resignFirstResponder];
        [_caregiverEmail becomeFirstResponder];
    } else if (textField == _caregiverEmail) {
        [_caregiverEmail resignFirstResponder];
        [_caregiverPassword becomeFirstResponder];
    } else if (textField == _caregiverPassword) {
        [_caregiverPassword resignFirstResponder];
        [_caregiverRepeatPassword becomeFirstResponder];
    } else if (textField == _caregiverRepeatPassword) {
        [_caregiverRepeatPassword resignFirstResponder];
        [_caregiverUsername becomeFirstResponder];
    } else if (textField == _caregiverUsername) {
        [_caregiverUsername resignFirstResponder];
        [_patientFirstName becomeFirstResponder];
    } else if (textField == _patientFirstName) {
        [_patientFirstName resignFirstResponder];
        [_patientLastName becomeFirstResponder];
    } else if (textField == _patientLastName) {
        [_patientLastName resignFirstResponder];
        [_patientUsername becomeFirstResponder];
    } else if (textField == _patientUsername) {
        [_patientUsername resignFirstResponder];
        [_patientEmail becomeFirstResponder];
    } else if (textField == _patientEmail) {
        [_patientEmail resignFirstResponder];
        [_patientZip becomeFirstResponder];
    } else if (textField == _patientZip) {
        [_patientZip resignFirstResponder];
        [_patientCellphone becomeFirstResponder];
    } else if (textField == _patientCellphone) {
        [_patientCellphone resignFirstResponder];
    }
    return YES;
}
#pragma mark -
#pragma mark - Select Modal Delegate
- (void) doctorSelectedItems:(NSArray *)items organizationId:(NSString *)orgId doctorId:(NSString *)docId
{
    _orgId = orgId;
    _docId = docId;
    NSLog(@"items %@", items);
    [_doctorButton setTitle:[NSString stringWithFormat:@"Doctor/Hospital: %@",[items objectAtIndex:0]] forState:UIControlStateNormal];
}
#pragma mark ----

#pragma mark -
#pragma mark - Select Modal Delegate
- (void)relation
{
    [self screenTapped];
    stage = NO;
    relation = YES;
    cancerType = NO;
    [_pickerView setHidden:NO];
    currentArray = [relationArray mutableCopy];
    [_picker reloadAllComponents];
    
    NSLog(@"relationArray up %@",currentArray);
}

- (void)choiceDoctor
{
    [self screenTapped];
    SelectModalVC* selectModal = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"SelectModalVC"];
    selectModal.delegate = self;
    NSLog(@"_organizations %@",organizations);
    selectModal.doctorItems = organizations;
    UINavigationController* contr = [[UINavigationController alloc] initWithRootViewController:selectModal];
    [self presentViewController:contr animated:YES completion:nil];
}

- (void)cancerType
{
    [self screenTapped];
    [_pickerView setHidden:NO];
    cancerType = YES;
    stage = NO;
    relation = NO;
    currentArray = [cancerTypes mutableCopy];
    [_picker reloadAllComponents];
    NSLog(@"cancerTypes up %@",currentArray);
}

- (void)cancerDate
{
    [self screenTapped];
    [_datePickerView setHidden:NO];
    birthDateBOOL = NO;
    cancerDateBOOL = YES;
    
}
- (void)birthDateAction
{
    [self screenTapped];
    [_datePickerView setHidden:NO];
    birthDateBOOL = YES;
    cancerDateBOOL = NO;
}

- (void)cancerStage
{
    [self screenTapped];
    stage = YES;
    relation = NO;
    cancerType = NO;
    [_pickerView setHidden:NO];
    currentArray = [stageArray mutableCopy];
    [_picker reloadAllComponents];
    
    NSLog(@"stageArray up %@",currentArray);
}

- (IBAction)doneBirthday:(id)sender {
    NSLog(@"hide");
    [_datePickerView setHidden:YES];
    if(cancerDateBOOL){
        cancerDate = [NSString stringWithFormat:@"%f",[_datePicker.date timeIntervalSince1970]];
        
        NSDateFormatter *fm = [[NSDateFormatter alloc] init];
        fm.dateFormat = @"dd MMM yyyy";
        NSString *cancerDateTime = [fm stringFromDate:_datePicker.date];
        [_cancerDateButton setTitle:[NSString stringWithFormat:@"Cancer date: %@",cancerDateTime] forState:UIControlStateNormal];
        NSLog(@"picked up %f",[_datePicker.date timeIntervalSince1970]);
    }
    
    if(birthDateBOOL){
        birthDate = [NSString stringWithFormat:@"%f",[_datePicker.date timeIntervalSince1970]];
        
        NSDateFormatter *fm = [[NSDateFormatter alloc] init];
        fm.dateFormat = @"dd MMM yyyy";
        NSString *birthDateTime = [fm stringFromDate:_datePicker.date];
        [_birthDate setTitle:[NSString stringWithFormat:@"Birth date: %@",birthDateTime] forState:UIControlStateNormal];
        NSLog(@"picked up %f",[_datePicker.date timeIntervalSince1970]);
    }
}

- (IBAction)donePicker:(id)sender {
    [_pickerView setHidden:YES];
    if(relation){
        [_relationButton setTitle:[NSString stringWithFormat:@"Relation : %@",[currentArray objectAtIndex:[_picker selectedRowInComponent:0]]] forState:UIControlStateNormal];
        relationChoisen = [currentArray objectAtIndex:[_picker selectedRowInComponent:0]];
    }
    if(stage){
        [_cancerStageButton setTitle:[NSString stringWithFormat:@"Cancer stage : %@",[currentArray objectAtIndex:[_picker selectedRowInComponent:0]]] forState:UIControlStateNormal];
        stageChoisen = [currentArray objectAtIndex:[_picker selectedRowInComponent:0]];
    }
    if(cancerType){
        [_cancerTypeButton setTitle:[NSString stringWithFormat:@"Cancer type : %@",[currentArray objectAtIndex:[_picker selectedRowInComponent:0]]] forState:UIControlStateNormal];
        cancerTypeChoisen = [currentArray objectAtIndex:[_picker selectedRowInComponent:0]];
    }
    NSLog(@"hide");
}
#pragma mark

#pragma mark -
#pragma mark - Picker View Delegate / Data Source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{
    NSLog(@"cur a %@", currentArray);
    return [currentArray count];
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
        return [currentArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
        NSLog(@"picked up %@",[currentArray objectAtIndex:row]);
        if(relation)
            relationChoisen = [currentArray objectAtIndex:row];
        if(stage)
            stageChoisen = [currentArray objectAtIndex:row];
        if(cancerType)
            cancerTypeChoisen = [currentArray objectAtIndex:row];
        
    
}
#pragma mark -
#pragma mark getFields
- (void) getFields
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:API_REGISTER_FIELDS_ENDPOINT parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject valueForKey:@"result"] integerValue] == 1) {
            cancerTypes = [responseObject valueForKey:@"cancer"];
            organizations = [responseObject valueForKey:@"organizations"];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Sorry, could not connect to the server. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Sorry, could not connect to the server. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
}
#pragma mark
- (void) screenTapped
{
    [self.view endEditing:YES];
}
- (void) performRegistrationWithParameters:(NSDictionary*) params
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSLog(@"params %@", params);
    [manager POST:API_CAREGIVER_REGISTER_ENDPOINT parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Response = %@",responseObject);
        if([[responseObject objectForKey:@"error"] isEqualToString:@"Validation errors"]){
            [[[UIAlertView alloc] initWithTitle:@"Error" message:[[responseObject objectForKey:@"validation_errors"] objectAtIndex:0] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        }
        
        if ([[responseObject valueForKey:@"result"] integerValue] == 1) {
            AppDelegate *appDel = (AppDelegate*) [UIApplication sharedApplication].delegate;
            appDel.userID = [NSNumber numberWithUnsignedInteger:[[responseObject valueForKey:@"id"] unsignedIntegerValue]];
            appDel.authToken = [responseObject valueForKey:@"auth_token"];
            appDel.firstName = _caregiverFirstName.text;
            UIAlertView *successfulRegistration = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"Registartion successful!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            successfulRegistration.tag = SUCCESSFUL_REGISTRATION_ALERT_TAG;
            [successfulRegistration show];
        } else if ([[responseObject valueForKey:@"result"] integerValue] == 0) {
            if ([[responseObject valueForKey:@"error"] isEqualToString:@"Not available"]) {
                NSString* existingUser = [[responseObject valueForKey:@"data"] objectAtIndex:0];
                [[[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Sorry, a user with that %@ already exists. Please choose a different %@", existingUser, existingUser] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Sorry, could not connect to the server. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
}
- (IBAction)registerPressed
{
    if (_caregiverUsername.text.length == 0) {
    [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter your username" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }else if (_caregiverEmail.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter your email" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }else if (_caregiverFirstName.text.length == 0) {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter your first name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }else if (_patientEmail.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter patients email" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }else if (_patientFirstName.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter patients first name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    } else if (_caregiverPassword.text.length == 0 || _caregiverRepeatPassword.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    } else if (![_caregiverPassword.text isEqualToString:_caregiverRepeatPassword.text]) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"The passwords mismatch" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    } else if (_caregiverLastName.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter your last name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    } else if (_patientZip.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter your zip code" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }else if (_cancerTypeButton.titleLabel.text.length < 15) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please choise patients cancer type" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }else if (_patientCellphone.text.length < 5) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter patients phone number" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    } else {
        [self performRegistrationWithParameters:[self buildRegistrationParameters]];
    }
}

- (NSDictionary*) buildRegistrationParameters
{
    NSString *donate = [_donateInfo state] ? @"true" : @"false";
    NSNumber *genderNum = [NSNumber numberWithInt:_gender.selectedSegmentIndex == 0? 2 : 1];
    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                _caregiverFirstName.text, @"caregiver_first_name",
                                _caregiverLastName.text, @"caregiver_last_name",
                                relationChoisen, @"caregiver_relation",
                                _caregiverEmail.text, @"caregiver_email",
                                _caregiverPassword.text, @"caregiver_password",
                                _caregiverRepeatPassword.text, @"confirm_password",
                                _caregiverUsername.text, @"caregiver_username",
                                
                                _patientEmail.text, @"patient_email",
                                _patientFirstName.text, @"patient_first_name",
                                _patientLastName.text, @"patient_last_name",
                                _orgId, @"patient_organization_id",
                                _docId, @"patient_doctor_id",
                                _patientCellphone.text, @"patient_cell_phone",
                                _patientZip.text, @"patient_zip",
                                cancerTypeChoisen, @"patient_cancer_type",
                                stageChoisen, @"patient_cancer_stage",
                                cancerDate, @"patient_cancer_date",
                                donate, @"donate_info",
                                genderNum, @"patient_gender",
                                birthDate, @"patient_date_of_birth",
                                
                                nil];

    return parameters;
}
#pragma mark -
#pragma mark - Alert View Delegate

- (void) alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == SUCCESSFUL_REGISTRATION_ALERT_TAG) {
        LoginVC* loginVC = [self.navigationController.viewControllers objectAtIndex:0];
        [self.navigationController popToViewController:loginVC animated:NO];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
