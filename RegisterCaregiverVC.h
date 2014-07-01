//
//  RegisterCaregiverVC.h
//  CancerLife
//
//  Created by Andrew Galkin on 5/19/14.
//  Copyright (c) 2014 FusionWorks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectModalVC.h"

@interface RegisterCaregiverVC : UIViewController <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIAlertViewDelegate, SelectModalDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
//caregiver
@property (weak, nonatomic) IBOutlet UITextField *caregiverFirstName;
@property (weak, nonatomic) IBOutlet UITextField *caregiverLastName;
@property (weak, nonatomic) IBOutlet UITextField *caregiverEmail;
@property (weak, nonatomic) IBOutlet UITextField *caregiverPassword;
@property (weak, nonatomic) IBOutlet UITextField *caregiverRepeatPassword;
@property (weak, nonatomic) IBOutlet UITextField *caregiverUsername;
@property (weak, nonatomic) IBOutlet UIButton *relationButton;

//patient
@property (weak, nonatomic) IBOutlet UITextField *patientFirstName;
@property (weak, nonatomic) IBOutlet UITextField *patientLastName;
@property (weak, nonatomic) IBOutlet UITextField *patientUsername;
@property (weak, nonatomic) IBOutlet UITextField *patientEmail;
@property (weak, nonatomic) IBOutlet UIButton *doctorButton;
@property (weak, nonatomic) IBOutlet UIButton *cancerTypeButton;
@property (weak, nonatomic) IBOutlet UIButton *cancerDateButton;
@property (weak, nonatomic) IBOutlet UIButton *cancerStageButton;
@property (weak, nonatomic) IBOutlet UIButton *birthDate;
@property (weak, nonatomic) IBOutlet UITextField *patientZip;
@property (weak, nonatomic) IBOutlet UITextField *patientCellphone;
@property (weak, nonatomic) IBOutlet UISwitch *donateInfo;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gender;


@property (strong, nonatomic) IBOutlet UIPickerView *picker;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
- (IBAction)doneBirthday:(id)sender;
- (IBAction)donePicker:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *pickerView;
@property (weak, nonatomic) IBOutlet UIView *datePickerView;
- (IBAction)registerPressed;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@end
