//
//  JournalEntryStepOne.m
//  CancerLife
//
//  Created by Constantin Lungu on 11/9/13.
//  Copyright (c) 2013 FusionWorks. All rights reserved.
//

#import "JournalEntryStepOne.h"
#import "Defines.h"
#import "Utils.h"
#import "JournalEntryStepTwo.h"
#import "AFHTTPRequestOperationManager.h"

@interface JournalEntryStepOne ()
{
    UIButton*       _selectedMoodButton;
    AppDelegate*    _appDel;
    NSArray*        _sideEffects;
    NSArray*        _sideEffectsIcons;
    NSArray*        _moods;
    NSString*       _selectedMoodImageName;
    NSMutableArray* _selectedSymptoms;
    NSArray*        _userCircles;
    
    IBOutlet UIView *contentView;
}

- (void)setupNavigationButtons;
- (void)setupView;
- (void)setupMoodButtons;
@end

@implementation JournalEntryStepOne

#pragma mark -
#pragma mark - View Controller's Lifecycle

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark - Private API

- (void) setupView
{
    [self setupNavigationButtons];
    _selectedSymptoms = [NSMutableArray array];
    [_nextStepButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_nextStepButton setTitle:@"Next: Select symptoms          ⟩" forState:UIControlStateNormal];
    [_nextStepButton.titleLabel setFont:[UIFont systemFontOfSize:18.0]];
    _nextStepButton.titleLabel.shadowOffset = CGSizeMake(0, 0);
    [_nextStepButton setTitleEdgeInsets:UIEdgeInsetsMake(-_nextStepButton.frame.size.height, -_nextStepButton.frame.size.width, -_nextStepButton.frame.size.height, 0.0)];
    
    if (!IS_IOS_7) {
        contentView.frame = CGRectOffset(contentView.frame, 0, -60);
    }

    _appDel = (AppDelegate*) [UIApplication sharedApplication].delegate;
    [self disableButton:_nextStepButton];

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer* serializer = [AFHTTPRequestSerializer serializer];
    [serializer setValue:_appDel.authToken forHTTPHeaderField:@"token"];
    [manager setRequestSerializer:serializer];
    [manager GET:API_GET_JOURNAL_FIELDS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _sideEffects = responseObject[@"SideEffects"];
        _moods = responseObject[@"Moods"];
        _sideEffectsIcons = responseObject[@"SideEffectIcons"];
        _userCircles = responseObject[@"UserCircles"];
        NSLog(@"Response object: %@",responseObject);
        [self setupMoodButtons];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

- (void) setupNavigationButtons
{

}

- (void) setupMoodButtons
{
    NSString* moodImageName = _moods[0];
    [_goodButton setImage:[UIImage imageNamed:moodImageName] forState:UIControlStateNormal];
    [_goodButton setImage:[UIImage imageNamed:[moodImageName stringByReplacingCharactersInRange:NSMakeRange(moodImageName.length - 5, 1) withString:@"1"]] forState:UIControlStateSelected];

    moodImageName = _moods[1];
    [_optimisticButton setImage:[UIImage imageNamed:moodImageName] forState:UIControlStateNormal];
    [_optimisticButton setImage:[UIImage imageNamed:[moodImageName stringByReplacingCharactersInRange:NSMakeRange(moodImageName.length - 5, 1) withString:@"1"]] forState:UIControlStateSelected];

    moodImageName = _moods[2];
    [_annoyedButton setImage:[UIImage imageNamed:moodImageName] forState:UIControlStateNormal];
    [_annoyedButton setImage:[UIImage imageNamed:[moodImageName stringByReplacingCharactersInRange:NSMakeRange(moodImageName.length - 5, 1) withString:@"1"]] forState:UIControlStateSelected];

    moodImageName = _moods[3];
    [_downButton setImage:[UIImage imageNamed:moodImageName] forState:UIControlStateNormal];
    [_downButton setImage:[UIImage imageNamed:[moodImageName stringByReplacingCharactersInRange:NSMakeRange(moodImageName.length - 5, 1) withString:@"1"]] forState:UIControlStateSelected];

    moodImageName = _moods[4];
    [_nervousButton setImage:[UIImage imageNamed:moodImageName] forState:UIControlStateNormal];
    [_nervousButton setImage:[UIImage imageNamed:[moodImageName stringByReplacingCharactersInRange:NSMakeRange(moodImageName.length - 5, 1) withString:@"1"]] forState:UIControlStateSelected];

    NSString* symptomImageName = _sideEffectsIcons[0][@"icon"];
    [_symptomButtonOne setImage:[UIImage imageNamed:symptomImageName] forState:UIControlStateNormal];
    [_symptomButtonOne setImage:[UIImage imageNamed:[symptomImageName stringByReplacingCharactersInRange:NSMakeRange(symptomImageName.length - 5, 1) withString:@"1"]] forState:UIControlStateSelected];
    [_symptomButtonOne setTitle:_sideEffectsIcons[0][@"name"] forState:UIControlStateNormal];

    symptomImageName = _sideEffectsIcons[1][@"icon"];
    [_symptomButtonTwo setImage:[UIImage imageNamed:symptomImageName] forState:UIControlStateNormal];
    [_symptomButtonTwo setImage:[UIImage imageNamed:[symptomImageName stringByReplacingCharactersInRange:NSMakeRange(symptomImageName.length - 5, 1) withString:@"1"]] forState:UIControlStateSelected];
    [_symptomButtonTwo setTitle:_sideEffectsIcons[1][@"name"] forState:UIControlStateNormal];

    symptomImageName = _sideEffectsIcons[2][@"icon"];
    NSLog(@"Image names: %@",_sideEffectsIcons);
    [_symptomButtonThree setImage:[UIImage imageNamed:symptomImageName] forState:UIControlStateNormal];
    [_symptomButtonThree setImage:[UIImage imageNamed:[symptomImageName stringByReplacingCharactersInRange:NSMakeRange(symptomImageName.length - 5, 1) withString:@"1"]] forState:UIControlStateSelected];
    [_symptomButtonThree setTitle:_sideEffectsIcons[2][@"name"] forState:UIControlStateNormal];
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

#pragma mark -
#pragma mark - Public API

- (IBAction)nextStepPressed
{
    JournalEntryStepTwo* stepTwo = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"JournalEntryStepTwo"];
    [stepTwo setSideEffects:[self symptomsDictionaries]];
    [stepTwo setAllSideEffects:_sideEffects];
    if (_selectedMoodButton == _goodButton) {
        _selectedMoodImageName = _moods[0];
    } else if (_selectedMoodButton == _optimisticButton) {
        _selectedMoodImageName = _moods[1];
    } else if (_selectedMoodButton == _annoyedButton) {
        _selectedMoodImageName = _moods[2];
    } else if (_selectedMoodButton == _downButton) {
        _selectedMoodImageName = _moods[3];
    } else if (_selectedMoodButton == _nervousButton) {
        _selectedMoodImageName = _moods[4];
    }
    [stepTwo setSelectedMoodImageName:_selectedMoodImageName];
    [stepTwo setUserCircles:_userCircles];
    [self.navigationController pushViewController:stepTwo animated:YES];
}

- (IBAction)moodPressed:(id)sender
{
    UIButton* mood = sender;

    if (_selectedMoodButton) {
        [_selectedMoodButton setUserInteractionEnabled:YES];
        [_selectedMoodButton setSelected:NO];
    }
    _selectedMoodButton = mood;
    [_selectedMoodButton setSelected:YES];
    [_selectedMoodButton setUserInteractionEnabled:NO];

    [self enableButton:_nextStepButton];
}

- (IBAction)symptomPressed:(id)sender
{
    UIButton* btn = sender;
    btn.selected = !btn.selected;
    if (btn.selected && ![_selectedSymptoms containsObject:[btn titleForState:UIControlStateNormal]]) {
        [_selectedSymptoms addObject:[btn titleForState:UIControlStateNormal]];
    } else if(!btn.selected && [_selectedSymptoms containsObject:[btn titleForState:UIControlStateNormal]]) {
        [_selectedSymptoms removeObject:[btn titleForState:UIControlStateNormal]];
    }
}

#pragma mark -
#pragma mark - Side Effects

- (NSArray*)symptomsDictionaries
{
    NSMutableArray* symptomsArray = [NSMutableArray array];
    for (NSString* symptom in _selectedSymptoms) {
        for (NSDictionary* symptomDictionary in _sideEffects) {
            if ([symptomDictionary[@"name"] isEqualToString:symptom]) {
                [symptomsArray addObject:symptomDictionary];
            }
        }
    }
    return symptomsArray;
}
@end
