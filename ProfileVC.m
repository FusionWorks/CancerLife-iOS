//
//  ProfileVC.m
//  CancerLife
//
//  Created by Constantin Lungu on 9/25/13.
//  Copyright (c) 2013 FusionWorks. All rights reserved.
//

#import "ProfileVC.h"
#import "AppDelegate.h"
#import "MFSideMenu.h"
#import "Utils.h"
#import "AFHTTPRequestOperationManager.h"
#import "MBProgressHUD.h"
#import "AFURLResponseSerialization.h"
#import "Defines.h"

@interface ProfileVC (/* Private */)
{
    // ---------- PHOTO
    AppDelegate             *_appDel;
    UIActionSheet           *_imagePickerTypeSheet;

    UIImagePickerController *_privateImagePicker;
    UIImagePickerController *_publicImagePicker;

    BOOL                    _isPickingPrivatePhoto;
    BOOL                    _isPickingPublicPhoto;
    CGSize                  _photoScrollViewSize;
    CGSize                  _profileScrollViewSize;
    CGPoint                 _photoViewOrigin;

    // ----------- PROFILE
    NSMutableArray         *_profileTextFields;
    BOOL                    _isEditing;
}

- (void) setupView;
- (void) setupNavigationButtons;
- (void) togglePressed;

- (void) addPublicPhotoPressed;
- (void) addPrivatePhotoPressed;

- (void) disableButton:(UIButton*) button;
- (void) enableButton:(UIButton*) button;

- (void) showSuccessHUDNotification;
@end

@implementation ProfileVC

- (MFSideMenuContainerViewController*) menuContainerViewController
{
    return (MFSideMenuContainerViewController*)_appDel.window.rootViewController;
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    _appDel = (AppDelegate*) [UIApplication sharedApplication].delegate;
    [self setupView];
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark - Private API

- (void) setupView
{
    if (IS_IOS_7) {
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        _scrollView.frame = CGRectMake(_scrollView.frame.origin.x, _scrollView.frame.origin.y - 65, _scrollView.frame.size.width, _scrollView.frame.size.height+65);
        _photoScrollViewSize = CGSizeMake(320, 685);
        _profileScrollViewSize = CGSizeMake(320, 800);
    } else {
        _profileSegmentedControl.frame = CGRectOffset(_profileSegmentedControl.frame, 0, -15);
        _scrollView.frame = CGRectMake(_scrollView.frame.origin.x, _scrollView.frame.origin.y - 20, _scrollView.frame.size.width, _scrollView.frame.size.height + 55);
        _photoScrollViewSize = CGSizeMake(320, 700);
        _profileScrollViewSize = CGSizeMake(320, 815);
    }

    _isPickingPrivatePhoto = NO;
    _isPickingPublicPhoto = NO;
    _photoView.alpha = 0;
    _photoView.frame = CGRectMake(_profileSegmentedControl.frame.origin.x, _profileSegmentedControl.frame.origin.y + _profileSegmentedControl.frame.size.height + 5, _photoView.frame.size.width, _photoView.frame.size.height);
    _profileView.frame = CGRectMake(_profileSegmentedControl.frame.origin.x, _profileSegmentedControl.frame.origin.y + _profileSegmentedControl.frame.size.height + 5, _profileView.frame.size.width, _profileView.frame.size.height);

    [self setupNavigationButtons];
    _profileSegmentedControl.selectedSegmentIndex = ProfileSegmentedControlProfile;
    _scrollView.contentSize = _profileScrollViewSize;
    _scrollView.userInteractionEnabled = YES;
    _photoView.userInteractionEnabled = YES;

    _privatePhotoImageView.contentMode = UIViewContentModeScaleAspectFill;
    _privatePhotoImageView.clipsToBounds = YES;
    if (!_appDel.privateImage) {
        [self disableButton:_deletePrivatePhotoButton];
        _privatePhotoImageView.image = [UIImage imageNamed:@"tapToSelectImage"];
        [_privatePhotoImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addPrivatePhotoPressed)]];
        _privatePhotoImageView.userInteractionEnabled = YES;
    } else {
        [self enableButton:_deletePrivatePhotoButton];
        _privatePhotoImageView.image = _appDel.privateImage;
        _privatePhotoImageView.userInteractionEnabled = NO;
    }

    _publicPhotoImageView.contentMode = UIViewContentModeScaleAspectFill;
    _publicPhotoImageView.clipsToBounds = YES;
    if (!_appDel.publicImage) {
        [self disableButton:_deletePublicPhotoButton];
        _publicPhotoImageView.image = [UIImage imageNamed:@"tapToSelectImage"];
        [_publicPhotoImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addPublicPhotoPressed)]];
        _publicPhotoImageView.userInteractionEnabled = YES;
    } else {
        [self enableButton:_deletePublicPhotoButton];
        _publicPhotoImageView.image = _appDel.publicImage;
        _publicPhotoImageView.userInteractionEnabled = NO;
    }

    [_deletePrivatePhotoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_deletePrivatePhotoButton setTitle:@"Delete this photo" forState:UIControlStateNormal];
    [_deletePrivatePhotoButton.titleLabel setFont:[UIFont systemFontOfSize:18.0]];
    _deletePrivatePhotoButton.titleLabel.shadowOffset = CGSizeMake(0, 0);
    [_deletePrivatePhotoButton setTitleEdgeInsets:UIEdgeInsetsMake(-_deletePrivatePhotoButton.frame.size.height, -_deletePrivatePhotoButton.frame.size.width, -_deletePrivatePhotoButton.frame.size.height, 0.0)];

    [_deletePublicPhotoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_deletePublicPhotoButton setTitle:@"Delete this photo" forState:UIControlStateNormal];
    [_deletePublicPhotoButton.titleLabel setFont:[UIFont systemFontOfSize:18.0]];
    _deletePublicPhotoButton.titleLabel.shadowOffset = CGSizeMake(0, 0);
    [_deletePublicPhotoButton setTitleEdgeInsets:UIEdgeInsetsMake(-_deletePublicPhotoButton.frame.size.height, -_deletePublicPhotoButton.frame.size.width, -_deletePublicPhotoButton.frame.size.height, 0.0)];

    [_updateProfileButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_updateProfileButton setTitle:@"Update profile" forState:UIControlStateNormal];
    [_updateProfileButton.titleLabel setFont:[UIFont systemFontOfSize:18.0]];
    _updateProfileButton.titleLabel.shadowOffset = CGSizeMake(0, 0);
    [_updateProfileButton setTitleEdgeInsets:UIEdgeInsetsMake(-_updateProfileButton.frame.size.height, -_updateProfileButton.frame.size.width, -_updateProfileButton.frame.size.height, 0.0)];

    // -------------- PROFILE
    _profileTextFields = [NSMutableArray array];
    [_profileTextFields addObject:_firstNameField];
    [_profileTextFields addObject:_lastNameField];
    [_profileTextFields addObject:_homePhoneField];
    [_profileTextFields addObject:_cellularPhoneField];
    [_profileTextFields addObject:_addressField];
    [_profileTextFields addObject:_cityField];
    [_profileTextFields addObject:_stateField];
    [_profileTextFields addObject:_countryField];
    [_profileTextFields addObject:_languageField];
    [_profileTextFields addObject:_timeZoneField];
    _firstNameField.delegate = self;
    _lastNameField.delegate = self;
    _homePhoneField.delegate = self;
    _cellularPhoneField.delegate = self;
    _addressField.delegate = self;
    _cityField.delegate = self;
    _stateField.delegate = self;
    _countryField.delegate = self;
    _languageField.delegate = self;
    _timeZoneField.delegate = self;

    _isEditing = NO;

    [_scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTapped)]];

    _firstNameField.text = _appDel.firstName;
    _lastNameField.text = _appDel.lastName;
    _countryField.text = _appDel.country;
    _languageField.text = _appDel.language;
    _stateField.text = _appDel.state;
    _timeZoneField.text = _appDel.timezone;
    _cellularPhoneField.text = _appDel.cellPhone;
    _homePhoneField.text = _appDel.homePhone;
}

- (void) setupNavigationButtons
{
    UIButton *toggleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [toggleButton setImage:[UIImage imageNamed:@"sideMenuButton"] forState:UIControlStateNormal];
    [toggleButton setFrame:CGRectMake(0, 0, 32, 22)];
    [toggleButton addTarget:self action:@selector(togglePressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *toggle = [[UIBarButtonItem alloc] initWithCustomView:toggleButton];
    self.navigationItem.leftBarButtonItem = toggle;
}

- (void) togglePressed
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{}];
}

- (void) addPublicPhotoPressed
{
    _isPickingPublicPhoto = YES;
    _imagePickerTypeSheet = [[UIActionSheet alloc] initWithTitle:@"Select photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"From camera", @"From gallery", nil];
    [_imagePickerTypeSheet showInView:self.view];
}

- (void) addPrivatePhotoPressed
{
    _isPickingPrivatePhoto = YES;
    _imagePickerTypeSheet = [[UIActionSheet alloc] initWithTitle:@"Select photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"From camera", @"From library", nil];
    [_imagePickerTypeSheet showInView:self.view];
}

- (void) disableButton:(UIButton *)button
{
    button.alpha = 0.5;
    button.userInteractionEnabled = NO;
}

- (void) enableButton:(UIButton *)button
{
    button.alpha = 1.;
    button.userInteractionEnabled = YES;
}

- (void) showSuccessHUDNotification
{
    MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.delegate = self;
    HUD.labelText = @"Updated";
    [HUD show:YES];
    [HUD hide:YES afterDelay:2];
}

- (void) publicImageUpdated:(UIImage*) image
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer* serializer = [AFHTTPRequestSerializer serializer];
    [serializer setValue:_appDel.authToken forHTTPHeaderField:@"token"];
    [manager setRequestSerializer:serializer];
    [manager POST:API_POST_PHOTO parameters:nil constructingBodyWithBlock:^(id <AFMultipartFormData> formData){
        [formData appendPartWithFileData:UIImagePNGRepresentation(image) name:@"data[public_image]" fileName:[NSString stringWithFormat:@"%@_PUBLIC.png",_appDel.authToken] mimeType:@"image/png"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _appDel.publicImage = image;
        [self showSuccessHUDNotification];
        [[NSNotificationCenter defaultCenter] postNotificationName:PUBLIC_PHOTO_UPDATED_NOTIFICATION object:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void) privateImageUpdated:(UIImage*) image
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer* serializer = [AFHTTPRequestSerializer serializer];
    [serializer setValue:_appDel.authToken forHTTPHeaderField:@"token"];
    [manager setRequestSerializer:serializer];
    [manager POST:API_POST_PHOTO parameters:nil constructingBodyWithBlock:^(id <AFMultipartFormData> formData){
        [formData appendPartWithFileData:UIImagePNGRepresentation(image) name:@"data[private_image]" fileName:[NSString stringWithFormat:@"%@_PRIVATE.png",_appDel.authToken] mimeType:@"image/png"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _appDel.privateImage = image;
        [self showSuccessHUDNotification];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark -
#pragma mark - Public API

- (IBAction)segmentedControlValueChanged
{
    switch (_profileSegmentedControl.selectedSegmentIndex) {
        case ProfileSegmentedControlProfile:
        {
            [UIView animateWithDuration:0.3f delay:0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 _profileView.alpha = 1;
                                 _photoView.alpha = 0;
                             }
                             completion:nil];
            _scrollView.contentSize = _profileScrollViewSize;
            break;
        }
        case ProfileSegmentedControlPhoto:
        {
            [UIView animateWithDuration:0.3f delay:0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 _profileView.alpha = 0;
                                 _photoView.alpha = 1;
                             }
                             completion:nil];
            _scrollView.contentSize = _photoScrollViewSize;
            break;
        }
        default:
            break;
    }
}

- (IBAction)deletePrivatePhotoPressed
{
    _privatePhotoImageView.image = [UIImage imageNamed:@"tapToSelectImage"];
    _privatePhotoImageView.userInteractionEnabled = YES;
    [self disableButton:_deletePrivatePhotoButton];
}

- (IBAction)deletePublicPhotoPressed
{
    _publicPhotoImageView.image = [UIImage imageNamed:@"tapToSelectImage"];
    _publicPhotoImageView.userInteractionEnabled = YES;
    [self disableButton:_deletePublicPhotoButton];
}

- (IBAction)updateProfilePressed
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer* serializer = [AFHTTPRequestSerializer serializer];
    [serializer setValue:_appDel.authToken forHTTPHeaderField:@"token"];
    [manager setRequestSerializer:serializer];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                _firstNameField.text, @"first_name",
                                _lastNameField.text, @"last_name",
                                _homePhoneField.text, @"home_phone",
                                _cellularPhoneField.text, @"cell_phone",
                                _addressField.text, @"street",
                                _cityField.text, @"city",
                                _stateField.text, @"state",
                                _countryField.text, @"country",
                                _languageField.text, @"language",
                                _timeZoneField.text, @"timezone"
                                , nil];
    [manager POST:API_POST_PROFILE parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject valueForKey:@"result"] unsignedIntegerValue] == 1) {
            [self showSuccessHUDNotification];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Couldn't update profile. Please try again later" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Couldn't connect to the server. Please try again later" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark -
#pragma mark - UIActionSheet Delegate

- (void) actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (actionSheet == _imagePickerTypeSheet) {
        switch (buttonIndex) {
            case 0:
            {
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    if (_isPickingPrivatePhoto) {
                        _privateImagePicker = [[UIImagePickerController alloc] init];
                        _privateImagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                        _privateImagePicker.delegate = self;
                        [self presentViewController:_privateImagePicker animated:YES completion:nil];
                    } else if (_isPickingPublicPhoto) {
                        _publicImagePicker = [[UIImagePickerController alloc] init];
                        _publicImagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                        _publicImagePicker.delegate = self;
                        [self presentViewController:_publicImagePicker animated:YES completion:nil];
                    }
                } else {
                    [[[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Camera is not available." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                }
                break;
            }
            case 1:
            {
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                    if (_isPickingPrivatePhoto) {
                        _privateImagePicker = [[UIImagePickerController alloc] init];
                        _privateImagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                        _privateImagePicker.delegate = self;
                        [self presentViewController:_privateImagePicker animated:YES completion:nil];
                    } else if (_isPickingPublicPhoto) {
                        _publicImagePicker = [[UIImagePickerController alloc] init];
                        _publicImagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                        _publicImagePicker.delegate = self;
                        [self presentViewController:_publicImagePicker animated:YES completion:nil];
                    }
                } else {
                    [[[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Photo library is not available." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                }
                break;
            }
            default:
                break;
        }
    }
}

#pragma mark -
#pragma mark - UIImagePickerController Delegate

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage* pickedImage = [info valueForKey:UIImagePickerControllerOriginalImage];

    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(pickedImage, nil, nil, nil);
    }

    if (picker == _privateImagePicker) {
        _isPickingPrivatePhoto = NO;
        _privatePhotoImageView.image = pickedImage;
        [self enableButton:_deletePrivatePhotoButton];
        _privatePhotoImageView.userInteractionEnabled = NO;
        [self privateImageUpdated:pickedImage];
    } else if (picker == _publicImagePicker) {
        _isPickingPublicPhoto = NO;
        _publicPhotoImageView.image = pickedImage;
        [self enableButton:_deletePublicPhotoButton];
        _publicPhotoImageView.userInteractionEnabled = NO;
        [self publicImageUpdated:pickedImage];
    }
}

#pragma mark -
#pragma mark - UITextField Delegate

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    UITextField* current = textField;
    UITextField* next = nil;
    int index = [_profileTextFields indexOfObject:current];
    if (index < _profileTextFields.count - 1) {
        next = [_profileTextFields objectAtIndex:index + 1];
    }
    [current resignFirstResponder];
    _isEditing = NO;
    if (next) {
        [next becomeFirstResponder];
        _isEditing = YES;
    }

    return YES;
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    _isEditing = YES;
    int indexOfTextfield = [_profileTextFields indexOfObject:textField];
    if (indexOfTextfield > 0)
    [_scrollView setContentOffset:CGPointMake(0, (indexOfTextfield * 60) + indexOfTextfield) animated:YES];
    return YES;
}

- (BOOL) textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (void) screenTapped
{
    if ([_profileSegmentedControl selectedSegmentIndex] == 0) {
        if (_isEditing) {
            [self.view endEditing:YES];
            [_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x, _scrollView.contentOffset.y >= 230.0 ? _scrollView.contentOffset.y - 230.0 : _scrollView.contentOffset.y) animated:YES];
        }
    }
}

@end
