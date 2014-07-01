//
//  RegisterVC.m
//  CancerLife
//
//  Created by Constantin Lungu on 9/25/13.
//  Copyright (c) 2013 FusionWorks. All rights reserved.
//

#import "RegisterVC.h"
#import "Utils.h"
#import "AFHTTPRequestOperationManager.h"
#import "Defines.h"

#define SUCCESSFUL_REGISTRATION_ALERT_TAG           1231

@interface RegisterVC ()
{
    NSArray                                 *_cancerTypes;
    NSArray                                 *_organizations;

    NSInteger                                _chosenCancerTypeIndex;
    NSTimeInterval                           _birthDate;

    UIDatePicker                            *_birthDatePicker;
    NSString *_orgId;
    NSString *_docId;
    
}
- (void) setupView;
- (void) screenTapped;
- (void) performRegistrationWithParameters:(NSDictionary*)params;
@end

@implementation RegisterVC

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
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTapped)]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - Text Field Delegate

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == _firstNameTextField || textField == _usernameField || textField == _zipCodeTextField) {
        int firstNameOffset = IS_IOS_7? 10 : 40;
        int usernameOffset = IS_IOS_7? 40 : 70;
        int zipCodeOffset = IS_IOS_7? 70 : 100;
        if (textField == _firstNameTextField) {
            [_scrollView setContentOffset:CGPointMake(0, firstNameOffset) animated:YES];
        } else if (textField == _usernameField) {
            [_scrollView setContentOffset:CGPointMake(0, usernameOffset) animated:YES];
        } else if (textField == _zipCodeTextField) {
            [_scrollView setContentOffset:CGPointMake(0, zipCodeOffset) animated:YES];
        }
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
        [_repeatPasswordField becomeFirstResponder];
    } else if (textField == _repeatPasswordField) {
        [_repeatPasswordField resignFirstResponder];
        [_firstNameTextField becomeFirstResponder];
    } else if (textField == _firstNameTextField) {
        [_firstNameTextField resignFirstResponder];
        [_usernameField becomeFirstResponder];
    } else if (textField == _usernameField) {
        [_usernameField resignFirstResponder];
        [_zipCodeTextField becomeFirstResponder];
    } else if (textField == _zipCodeTextField) {
        [_zipCodeTextField resignFirstResponder];
    }
    return YES;
}

- (IBAction)registerPressed
{
    if (_emailField.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter email" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    } else if (_passwordField.text.length == 0 || _repeatPasswordField.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    } else if (![_passwordField.text isEqualToString:_repeatPasswordField.text]) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"The passwords mismatch" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    } else if (_firstNameTextField.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter your first name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    } else if (_usernameField.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter your last name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    } else if (_zipCodeTextField.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter your zip code" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }else if (_cancerTypeButton.titleLabel.text.length < 15) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please choise cancer type" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    } else {
        [self performRegistrationWithParameters:[self buildRegistrationParameters]];
    }
}

- (IBAction)cancerTypePressed
{
    if (_chosenCancerTypeIndex == -1) {
        _chosenCancerTypeIndex = 0;
    }
    _cancerTypesPicker.delegate = self;
    _cancerTypesPicker.dataSource = self;
    _cancerPickerToolbarView.hidden = NO;
    [UIView animateWithDuration:0.30f animations:^(void) {
        _cancerPickerToolbarView.frame = CGRectOffset(_cancerPickerToolbarView.frame, 0, -_cancerPickerToolbarView.bounds.size.height);
    }completion:nil];
}

- (IBAction)doctorChoicePressed:(id)sender {
    SelectModalVC* selectModal = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"SelectModalVC"];
    selectModal.delegate = self;
    NSLog(@"_organizations %@",_organizations);
    selectModal.doctorItems = _organizations;
    UINavigationController* contr = [[UINavigationController alloc] initWithRootViewController:selectModal];
    [self presentViewController:contr animated:YES completion:nil];
}

- (IBAction)birthDatePressed
{
    _birthDatePickerView.hidden = NO;
    [UIView animateWithDuration:0.30f animations:^(void) {
        _birthDatePickerView.frame = CGRectOffset(_birthDatePickerView.frame, 0, -_birthDatePickerView.frame.size.height);
    }completion:nil];
}

- (IBAction)donePressed:(id)sender
{
    _cancerPickerToolbarView.hidden = NO;
    [_cancerTypeButton setTitle:[NSString stringWithFormat:@"Cancer type: %@", _cancerTypes[_chosenCancerTypeIndex]] forState:UIControlStateNormal];
//    int offset = IS_IOS_7 ? _cancerPickerToolbarView.bounds.size.height : _cancerPickerToolbarView.bounds.size.height + 30;
    [UIView animateWithDuration:0.30f animations:^(void) {
        _cancerPickerToolbarView.frame = CGRectOffset(_cancerPickerToolbarView.frame, 0, _cancerPickerToolbarView.bounds.size.height);
    }completion:^(BOOL finished){
        _cancerPickerToolbarView.hidden = YES;
    }];
}

- (IBAction)donePickingBirthDatePressed:(id)sender
{
    _birthDate = [_birthDatePicker.date timeIntervalSince1970];
    [UIView animateWithDuration:0.30f animations:^(void) {
        _birthDatePickerView.frame = CGRectOffset(_birthDatePickerView.frame, 0, _birthDatePickerView.frame.size.height);
    }completion:^(BOOL completion) {
        _birthDatePickerView.hidden = YES;
    }];
    NSDateFormatter *fm = [[NSDateFormatter alloc] init];
    fm.dateFormat = @"dd MMM yyyy";
    NSString *birthDate = [fm stringFromDate:_birthDatePicker.date];
    [_birthDateButton setTitle:[NSString stringWithFormat:@"Birth date: %@",birthDate] forState:UIControlStateNormal];
}

#pragma mark -
#pragma mark - Picker View Delegate / Data Source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{
    return _cancerTypes.count;

}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_cancerTypes objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (thePickerView == _cancerTypesPicker) {
        _chosenCancerTypeIndex = row;
        [_cancerTypeButton setTitle:[NSString stringWithFormat:@"Cancer type: %@",_cancerTypes[row]] forState:UIControlStateNormal];
    }
}
#pragma mark -
#pragma mark - Select Modal Delegate
- (void) doctorSelectedItems:(NSArray *)items organizationId:(NSString *)orgId doctorId:(NSString *)docId
{
    _orgId = orgId;
    _docId = docId;
    [_doctorChoiceButton setTitle:[NSString stringWithFormat:@"Doctor: %@",[items objectAtIndex:0]] forState:UIControlStateNormal];
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

#pragma mark -
#pragma mark - Private API

- (void) setupView
{
    [_registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_registerButton setTitle:@"Sign up" forState:UIControlStateNormal];
    [_registerButton.titleLabel setFont:[UIFont systemFontOfSize:18.0]];
    _registerButton.titleLabel.shadowOffset = CGSizeMake(0, 0);
    [_registerButton setTitleEdgeInsets:UIEdgeInsetsMake(-_registerButton.frame.size.height, -_registerButton.frame.size.width, -_registerButton.frame.size.height, 0.0)];
    _scrollView.contentSize = CGSizeMake(320, 670);
    _scrollView.userInteractionEnabled = YES;
    _cancerPickerToolbarView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, _cancerPickerToolbarView.frame.size.height + 20);
    _chosenCancerTypeIndex = -1;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(btn.frame.origin.x + 100, btn.frame.origin.y, 80, 40);
    [btn setTitle:@"Done" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(donePressed:) forControlEvents:UIControlEventTouchUpInside];
    _donePickerViewButton.customView = btn;

    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    doneBtn.frame = btn.frame;
    [doneBtn setTitle:@"Done" forState:UIControlStateNormal];
    [doneBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(donePickingBirthDatePressed:) forControlEvents:UIControlEventTouchUpInside];
    _birthDayPickerDoneButton.customView = doneBtn;
    _birthDatePicker.maximumDate = [NSDate date];
    _birthDatePickerView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, _birthDatePickerView.frame.size.height + (IS_IOS_7? 20. : 0.));

    _cancerPickerToolbarView.userInteractionEnabled = YES;
    _birthDatePickerView.userInteractionEnabled = YES;

    _registerButton.frame = CGRectMake(_registerButton.frame.origin.x, _scrollView.contentSize.height - _registerButton.frame.size.height, _registerButton.frame.size.width, _registerButton.frame.size.height);
    _cancerPickerToolbarView.frame = CGRectMake(0, self.view.bounds.size.height, _cancerPickerToolbarView.frame.size.width, _cancerPickerToolbarView.frame.size.height + (IS_IOS_7? 20. : 0.));
    _cancerPickerToolbarView.hidden = YES;

    if (!IS_IOS_7) {
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        _usernameView.frame = CGRectOffset(_usernameView.frame, 0, -10);
        _emailView.frame = CGRectOffset(_emailView.frame, 0, -10);
        _firstNameView.frame = CGRectOffset(_firstNameView.frame, 0, -10);
        _zipCodeView.frame = CGRectOffset(_zipCodeView.frame, 0, -10);
        _passwordView.frame = CGRectOffset(_passwordView.frame, 0, -10);
        _repeatPasswordView.frame = CGRectOffset(_repeatPasswordView.frame, 0, -10);
    } else {
        //        _registerButton.frame = CGRectOffset(_registerButton.frame, 0, 40);
        _scrollView.frame = CGRectMake(_scrollView.frame.origin.x, _scrollView.frame.origin.y - 70, _scrollView.frame.size.width, _scrollView.frame.size.height + 70);
    }

    _birthDateButton.frame = CGRectOffset(_zipCodeView.frame, 0, 30 + _birthDateButton.frame.size.height);
    _cancerTypeButton.frame = CGRectOffset(_birthDateButton.frame, 0, 25 + _cancerTypeButton.frame.size.height);
    _doctorChoiceButton.frame = CGRectOffset(_cancerTypeButton.frame, 0, 25 + _doctorChoiceButton.frame.size.height);
    _rolesControl.frame = CGRectOffset(_doctorChoiceButton.frame, 0, 25 + _rolesControl.frame.size.height);
    _genderControl.frame = CGRectOffset(_rolesControl.frame, 0, 10 + _rolesControl.frame.size.height);

    _usernameField.delegate = self;
    _firstNameTextField.delegate = self;
    _zipCodeTextField.delegate = self;
    _emailField.delegate = self;
    _passwordField.delegate = self;
    _repeatPasswordField.delegate = self;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:API_REGISTER_FIELDS_ENDPOINT parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

        if ([[responseObject valueForKey:@"result"] integerValue] == 1) {
            _cancerTypes = [responseObject valueForKey:@"cancer"];
            _organizations = [responseObject valueForKey:@"organizations"];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Sorry, could not connect to the server. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Sorry, could not connect to the server. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
}

- (void) screenTapped
{
    [self.view endEditing:YES];
}

- (void) performRegistrationWithParameters:(NSDictionary*) params
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    [manager POST:API_REGISTER_ENDPOINT parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Response = %@",responseObject);
        if ([[responseObject valueForKey:@"result"] integerValue] == 1) {
            AppDelegate *appDel = (AppDelegate*) [UIApplication sharedApplication].delegate;
            appDel.userID = [NSNumber numberWithUnsignedInteger:[[responseObject valueForKey:@"id"] unsignedIntegerValue]];
            appDel.authToken = [responseObject valueForKey:@"auth_token"];
            appDel.firstName = _firstNameTextField.text;
            appDel.gender = [NSNumber numberWithInt:_genderControl.selectedSegmentIndex == 0? 2 : 1];
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

- (NSDictionary*) buildRegistrationParameters
{
    NSInteger patientType = 0;
    if ([_rolesControl selectedSegmentIndex] == 0) {
        patientType = 1;
    } else if ([_rolesControl selectedSegmentIndex] == 1) {
        patientType = 2;
    }

    NSInteger sex = 0;
    if ([_genderControl selectedSegmentIndex] == 0) {
        sex = 2;
    } else if ([_genderControl selectedSegmentIndex] == 1) {
        sex = 1;
    }
//    NSString *orgId = @"";
//    NSString *docId = @"";
//    NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@" : "];
//    NSRange range = [choisenDoctor rangeOfCharacterFromSet:charSet];
//    NSLog(@"range %i doctor %@", range.location, choisenDoctor);
//    if (range.location != NSNotFound) {
//        for (NSDictionary *dict in _organizations){
//
//            NSString *docName = [choisenDoctor substringFromIndex:range.location];
//            NSString *orgName = [choisenDoctor substringToIndex:range.location];
//            if([docName isEqualToString:[dict valueForKey:@"doctor_name"]]){
//                docId = [dict valueForKey:@"doctor_id"];
//            }
//            if([orgName isEqualToString:[dict valueForKey:@"name"]]){
//                orgId = [dict valueForKey:@"id"];
//            }
//           
//        }
//    }
//    
    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:_emailField.text, @"email",
                                _passwordField.text, @"password",
                                _usernameField.text, @"username",
                                [NSNumber numberWithInt:patientType], @"roles",
                                _firstNameTextField.text, @"first_name",
                                [NSNumber numberWithInt:sex], @"gender",
                                [NSNumber numberWithFloat:_birthDate], @"date_of_birth",
                                _zipCodeTextField.text, @"zip",
                                [_cancerTypes objectAtIndex:_chosenCancerTypeIndex], @"cancer_type",
                                _orgId, @"organization_id",
                                _docId, @"doctor_id",
                                nil];
    NSLog(@"params %@", parameters);
    return parameters;
}

@end
