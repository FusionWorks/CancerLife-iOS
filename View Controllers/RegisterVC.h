//
//  RegisterVC.h
//  CancerLife
//
//  Created by Constantin Lungu on 9/25/13.
//  Copyright (c) 2013 FusionWorks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectModalVC.h"


@interface RegisterVC : UIViewController <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIAlertViewDelegate, SelectModalDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *zipCodeTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UITextField *repeatPasswordField;
@property (strong, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (strong, nonatomic) IBOutlet UIButton *registerButton;
@property (strong, nonatomic) IBOutlet UIView *emailView;
@property (strong, nonatomic) IBOutlet UIView *passwordView;
@property (strong, nonatomic) IBOutlet UIView *repeatPasswordView;
@property (strong, nonatomic) IBOutlet UIView *usernameView;
@property (strong, nonatomic) IBOutlet UIView *firstNameView;
@property (strong, nonatomic) IBOutlet UIView *zipCodeView;
@property (strong, nonatomic) IBOutlet UIPickerView *cancerTypesPicker;
@property (strong, nonatomic) IBOutlet UIButton *birthDateButton;
@property (weak, nonatomic) IBOutlet UIButton *doctorChoiceButton;
@property (strong, nonatomic) IBOutlet UIButton *cancerTypeButton;
@property (strong, nonatomic) IBOutlet UIView *cancerPickerToolbarView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *donePickerViewButton;
@property (strong, nonatomic) IBOutlet UISegmentedControl *rolesControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *genderControl;
@property (strong, nonatomic) IBOutlet UIView *birthDatePickerView;
@property (strong, nonatomic) IBOutlet UIDatePicker *birthDatePicker;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *birthDayPickerDoneButton;

- (IBAction)registerPressed;
- (IBAction)cancerTypePressed;
- (IBAction)doctorChoicePressed:(id)sender;
- (IBAction)birthDatePressed;
- (IBAction)donePressed:(id)sender;
- (IBAction)donePickingBirthDatePressed:(id)sender;

//

@end
