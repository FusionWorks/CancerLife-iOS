//
//  ProfileVC.h
//  CancerLife
//
//  Created by Constantin Lungu on 9/25/13.
//  Copyright (c) 2013 FusionWorks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

typedef enum {
    ProfileSegmentedControlProfile = 0,
    ProfileSegmentedControlPhoto = 1
} ProfileSegmentedControlOptions;

@interface ProfileVC : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, MBProgressHUDDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *profileSegmentedControl;
// PHOTO
@property (strong, nonatomic) IBOutlet UIView *photoView;
@property (strong, nonatomic) IBOutlet UIImageView *privatePhotoImageView;
@property (strong, nonatomic) IBOutlet UIButton *deletePrivatePhotoButton;
@property (strong, nonatomic) IBOutlet UIImageView *publicPhotoImageView;
@property (strong, nonatomic) IBOutlet UIButton *deletePublicPhotoButton;
// PROFILE
@property (strong, nonatomic) IBOutlet UIView *profileView;
@property (strong, nonatomic) IBOutlet UITextField *firstNameField;
@property (strong, nonatomic) IBOutlet UITextField *lastNameField;
@property (strong, nonatomic) IBOutlet UITextField *homePhoneField;
@property (strong, nonatomic) IBOutlet UITextField *cellularPhoneField;
@property (strong, nonatomic) IBOutlet UITextField *addressField;
@property (strong, nonatomic) IBOutlet UITextField *cityField;
@property (strong, nonatomic) IBOutlet UITextField *stateField;
@property (strong, nonatomic) IBOutlet UITextField *countryField;
@property (strong, nonatomic) IBOutlet UITextField *languageField;
@property (strong, nonatomic) IBOutlet UITextField *timeZoneField;

@property (strong, nonatomic) IBOutlet UIButton *updateProfileButton;

- (IBAction)segmentedControlValueChanged;
// PHOTO
- (IBAction)deletePrivatePhotoPressed;
- (IBAction)deletePublicPhotoPressed;
// PROFILE
- (IBAction)updateProfilePressed;


@end
