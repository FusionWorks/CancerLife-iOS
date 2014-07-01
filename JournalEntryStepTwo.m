//
//  JournalEntryStepTwo.m
//  CancerLife
//
//  Created by Constantin Lungu on 11/9/13.
//  Copyright (c) 2013 FusionWorks. All rights reserved.
//

#import "JournalEntryStepTwo.h"
#import "Defines.h"
#import "Utils.h"
#import "AFHTTPRequestOperationManager.h"
#import "Defines.h"
#import "JournalEntryStepThree.h"

@interface JournalEntryStepTwo ()
{
    AppDelegate*            _appDel;
    NSMutableArray*         _symptoms;
    NSMutableArray*         _addedSymptomsNames;

    SymptomView*            _extraPickingView;
}

- (void)setupView;
- (void)populateView;
- (void)createSideEffectsFromArray:(NSArray*) sideEffects;
@end

@implementation JournalEntryStepTwo

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
    _appDel = (AppDelegate*) [UIApplication sharedApplication].delegate;
    _symptoms = [NSMutableArray array];
    _scrollView.contentSize = CGSizeMake(320, [UIScreen mainScreen].bounds.size.height + 80);
    _scrollView.frame = CGRectMake(_scrollView.frame.origin.x, _scrollView.frame.origin.y - 65, _scrollView.frame.size.width, _scrollView.frame.size.height+65);
    if (!IS_IOS_7) {
        _scrollView.frame = CGRectMake(_scrollView.frame.origin.x, _scrollView.frame.origin.y + 60, _scrollView.frame.size.width, _scrollView.frame.size.height - 15);
    }
    [self setupView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - Private API

- (void) setupView
{
    [_addSymptomButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_addSymptomButton setTitle:@"Add a symptom" forState:UIControlStateNormal];
    [_addSymptomButton.titleLabel setFont:[UIFont systemFontOfSize:18.0]];
    _addSymptomButton.titleLabel.shadowOffset = CGSizeMake(0, 0);
    [_addSymptomButton setTitleEdgeInsets:UIEdgeInsetsMake(-_addSymptomButton.frame.size.height, -_addSymptomButton.frame.size.width, -_addSymptomButton.frame.size.height, 0.0)];
    UIImageView* plusSign = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"plus_sign"]];
    plusSign.frame = CGRectMake(5, _addSymptomButton.frame.size.height/4, 19, 19);
    [_addSymptomButton addSubview:plusSign];

    [_nextStepButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_nextStepButton setTitle:@"Next: How are you feeling?      ⟩" forState:UIControlStateNormal];
    [_nextStepButton.titleLabel setFont:[UIFont systemFontOfSize:18.0]];
    _nextStepButton.titleLabel.shadowOffset = CGSizeMake(0, 0);
    [_nextStepButton setTitleEdgeInsets:UIEdgeInsetsMake(-_nextStepButton.frame.size.height, -_nextStepButton.frame.size.width, -_nextStepButton.frame.size.height, 0.0)];

    self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 80);
    _addedSymptomsNames = [NSMutableArray array];
    [self populateView];
    [self layoutButtons];
    _datePickerView.frame = CGRectMake(_datePickerView.frame.origin.x, [UIScreen mainScreen].bounds.size.height + (IS_IOS_7? 20 : 0), _datePickerView.frame.size.width, _datePickerView.frame.size.height);
}

- (void) populateView
{
    [self createSideEffectsFromArray:_sideEffects];
}

- (void) createSideEffectsFromArray:(NSArray*) sideEffects
{
    int offsetY = 0;
    for (NSDictionary* sideEffect in sideEffects) {
        SymptomView *sv = [[[NSBundle mainBundle] loadNibNamed:@"SymptomView" owner:self options:nil] lastObject];
        [sv initWithName:[sideEffect valueForKey:@"name"]
                    type:@"slider"
             pictureName:nil
                minValue:[[[sideEffect valueForKey:@"level"] valueForKey:@"min"] unsignedIntegerValue]
                maxValue:[[[sideEffect valueForKey:@"level"] valueForKey:@"max"] unsignedIntegerValue]
                question:[[sideEffect valueForKey:@"level"] valueForKey:@"q"]
                 options:[[sideEffect valueForKey:@"level"] valueForKey:@"options"]
               minValue2:[[[sideEffect valueForKey:@"level2"] valueForKey:@"min"] unsignedIntegerValue]
               maxValue2:[[[sideEffect valueForKey:@"level2"] valueForKey:@"max"] unsignedIntegerValue]
               question2:[[sideEffect valueForKey:@"level2"] valueForKey:@"q"]
                options2:[[sideEffect valueForKey:@"level2"] valueForKey:@"options"]
         ];
        sv.frame = CGRectMake(0, offsetY, 320, sv.frame.size.height);
        if (sideEffect[@"question1"] != nil) {
            if ([sideEffect[@"question1"][@"type"] isEqualToString:@"select"]) {
                [sv setSelectOptions:sideEffect[@"question2"][@"options"]];
            }
            [sv addQuestion:sideEffect[@"question1"][@"q"] withType:sideEffect[@"question1"][@"type"]];
        }
        if (sideEffect[@"question2"] != nil) {
            if ([sideEffect[@"question2"][@"type"] isEqualToString:@"select"]) {
                [sv setSelectOptions:sideEffect[@"question2"][@"options"]];
            }
            [sv addQuestion:sideEffect[@"question2"][@"q"] withType:sideEffect[@"question2"][@"type"]];
        }
        sv.delegate = self;
        [_addedSymptomsNames addObject:sideEffect[@"name"]];
        [_symptoms addObject:sv];
        [self.scrollView addSubview:sv];
        self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, self.scrollView.contentSize.height + sv.frame.size.height + (sv.frame.size.height / 6));
        offsetY += sv.frame.size.height+ 3;
    }
}

#pragma mark -
#pragma mark - Symptom View Delegate

- (void) deleteSymptomPressed:(id)sender
{
    SymptomView* sv = sender;
    NSString* removedSymptom = [sv.symptomNameLabel.text lowercaseString];
    removedSymptom = [removedSymptom stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[[removedSymptom substringToIndex:1] uppercaseString]];
    [_addedSymptomsNames removeObject:removedSymptom];

    if (_scrollView.contentSize.height > [UIScreen mainScreen].bounds.size.height)
        _scrollView.contentSize = CGSizeMake(_scrollView.contentSize.width, _scrollView.contentSize.height - sv.frame.size.height - 10);

    [UIView animateWithDuration:0.25f delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         sv.alpha = 0;
                         int idx = [_symptoms indexOfObject:sv];
                         if (idx < _symptoms.count - 1) {
                             for (; idx < _symptoms.count; idx++) {
                                 SymptomView* viewBelow = [_symptoms objectAtIndex:idx];
                                 viewBelow.frame = CGRectOffset(viewBelow.frame, 0, -sv.frame.size.height);
                             }
                         }
                         [self layoutButtons];
                     }
                     completion:^(BOOL completion) {
                         [sv removeFromSuperview];
                         [_symptoms removeObject:sv];
                     }];

    int y = 0;
    for (SymptomView* sv in _symptoms) {
        y += sv.frame.size.height;
    }
    self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, y);
    [self layoutButtons];
}

- (void)sliderValueChanged:(id)sender
{
    for (SymptomView* sv in _symptoms) {
        if (sv != sender) {
            [sv dismissPopTip];
        }
    }
}

- (void)extraQuestionWantsAnswer:(id)sender onView:(id)sv
{
    _extraPickingView = sv;
    if ([sender isEqualToString:@"datetime"]) {
        _datePickerView.hidden = NO;
        _datePicker.maximumDate = [NSDate date];
        [UIView animateWithDuration:0.30f animations:^(void) {
            _datePickerView.frame = CGRectOffset(_datePickerView.frame, 0, -_datePickerView.frame.size.height - (IS_IOS_7? 0 : 20));
        }completion:nil];
    } else if ([sender isEqualToString:@"select"]) {
        SelectModalVC* selectModal = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"SelectModalVC"];
        selectModal.delegate = self;
        NSLog(@"ahast %@",_extraPickingView.selectOptions);
        selectModal.items = _extraPickingView.selectOptions;
        UINavigationController* contr = [[UINavigationController alloc] initWithRootViewController:selectModal];
        [self presentViewController:contr animated:YES completion:nil];
    }
}

#pragma mark -
#pragma mark - Select Modal Delegate

- (void)modalSelectedItems:(NSArray *)items
{
    [_extraPickingView setSelectValue:nil withSelections:items];
}

#pragma mark -
#pragma mark - Actions and other methods

- (IBAction)nextStepPressed
{
    JournalEntryStepThree* jest = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"JournalEntryStepThree"];
    [jest setSelectedMoodImageName:_selectedMoodImageName];
    [jest setSelectedSideEffects:[self sideEffectsDictionaryArray]];
    [jest setPickerArray:_userCircles];
    [self.navigationController pushViewController:jest animated:YES];
}

- (IBAction)addSymptomPressed
{
    NSLog(@"Side Effects: %@",_sideEffects);
    SelectSymptomVC* ssvc = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"SelectSymptomVC"];
    NSMutableArray* effectsNames = [NSMutableArray array];

    for (NSDictionary* effect in _allSideEffects) {
        [effectsNames addObject:effect[@"name"]];
    }
    [effectsNames removeObjectsInArray:_addedSymptomsNames];
    effectsNames = [[effectsNames sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)] mutableCopy];
    [ssvc setSymptoms:effectsNames];
    ssvc.delegate = self;
    UINavigationController* contr = [[UINavigationController alloc] initWithRootViewController:ssvc];
    [self presentViewController:contr animated:YES completion:nil];
}

- (IBAction)datePickerDonePressed:(id)sender
{
    [UIView animateWithDuration:0.30f animations:^(void) {
        _datePickerView.frame = CGRectOffset(_datePickerView.frame, 0, _datePickerView.frame.size.height + (IS_IOS_7? 0 : 20));
    }completion:^(BOOL completion) {
        _datePickerView.hidden = YES;
    }];
    NSDateFormatter *fm = [[NSDateFormatter alloc] init];
    fm.dateFormat = @"dd MMM yyyy HH:mm";
    NSString *selectedDate = [fm stringFromDate:_datePicker.date];
    [_extraPickingView setDateTimeValue:selectedDate withSelectedDate:_datePicker.date];
}

- (void)selectedSymptom:(NSString *)symptom
{
    [_addedSymptomsNames addObject:symptom];
    NSDictionary* sideEffect;
    for (NSDictionary* effect in _allSideEffects) {
        if ([effect[@"name"] isEqualToString:symptom]) {
            sideEffect = effect;
            NSLog(@"effect: %@",sideEffect);
            break;
        }
    }
    int currentOffset = IS_IOS_7? 0 : 5;

    for (SymptomView* sv in _symptoms) {
        currentOffset += sv.frame.size.height;
    }
    
    SymptomView *sv = [[[NSBundle mainBundle] loadNibNamed:@"SymptomView" owner:self options:nil] lastObject];
    [sv initWithName:[sideEffect valueForKey:@"name"]
                type:@"slider"
         pictureName:nil
            minValue:[[[sideEffect valueForKey:@"level"] valueForKey:@"min"] unsignedIntegerValue]
            maxValue:[[[sideEffect valueForKey:@"level"] valueForKey:@"max"] unsignedIntegerValue]
            question:[[sideEffect valueForKey:@"level"] valueForKey:@"q"]
             options:[[sideEffect valueForKey:@"level"] valueForKey:@"options"]
           minValue2:[[[sideEffect valueForKey:@"level2"] valueForKey:@"min"] unsignedIntegerValue]
           maxValue2:[[[sideEffect valueForKey:@"level2"] valueForKey:@"max"] unsignedIntegerValue]
           question2:[[sideEffect valueForKey:@"level2"] valueForKey:@"q"]
            options2:[[sideEffect valueForKey:@"level2"] valueForKey:@"options"]
     ];
//    
//    if (sideEffect[@"question1"] != nil) {
//        [sv addQuestion:sideEffect[@"question1"][@"q"] withType:sideEffect[@"question1"][@"type"]];
//    }
//    if (sideEffect[@"question2"] != nil) {
//        [sv addQuestion:sideEffect[@"question2"][@"q"] withType:sideEffect[@"question2"][@"type"]];
//    }
    
    if (sideEffect[@"question1"] != nil) {
        if ([sideEffect[@"question1"][@"type"] isEqualToString:@"select"]) {
            [sv setSelectOptions:sideEffect[@"question2"][@"options"]];
        }
        [sv addQuestion:sideEffect[@"question1"][@"q"] withType:sideEffect[@"question1"][@"type"]];
    }
    if (sideEffect[@"question2"] != nil) {
        if ([sideEffect[@"question2"][@"type"] isEqualToString:@"select"]) {
            [sv setSelectOptions:sideEffect[@"question2"][@"options"]];
        }
        [sv addQuestion:sideEffect[@"question2"][@"q"] withType:sideEffect[@"question2"][@"type"]];
    }
    sv.frame = CGRectMake(0, currentOffset, 320, sv.frame.size.height);
    
    sv.delegate = self;

    [_symptoms addObject:sv];
    [self.scrollView addSubview:sv];

    _scrollView.contentSize = CGSizeMake(_scrollView.contentSize.width, _scrollView.contentSize.height + sv.frame.size.height + 3);

    [self layoutButtons];
}

- (void)layoutButtons
{
    if (self.scrollView.contentSize.height < [UIScreen mainScreen].bounds.size.height) {
        _nextStepButton.frame = CGRectMake(_nextStepButton.frame.origin.x, [UIScreen mainScreen].bounds.size.height - 5 - _nextStepButton.frame.size.height - ( IS_IOS_7? 70 : 55), _nextStepButton.frame.size.width, _nextStepButton.frame.size.height);
    } else {
        _nextStepButton.frame = CGRectMake(_nextStepButton.frame.origin.x, _scrollView.contentSize.height - (IS_IOS_7? 65 : 50), _nextStepButton.frame.size.width, _nextStepButton.frame.size.height);
    }
    _addSymptomButton.frame = CGRectOffset(_nextStepButton.frame, 0, _addSymptomButton.frame.size.height - (IS_IOS_7? 25 : 40) - ( IS_IOS_7? 70 : 50) );
}

- (NSArray*)sideEffectsDictionaryArray
{
    NSMutableArray* effects = [NSMutableArray array];
    for (SymptomView* ssvc in _symptoms) {
        NSMutableDictionary* effect = [NSMutableDictionary dictionary];
        effect[@"name"] = [[ssvc.symptomNameLabel.text lowercaseString] stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[[ssvc.symptomNameLabel.text substringToIndex:1] uppercaseString]];
        if([ssvc.levelLabel.text intValue] != 0){
            effect[@"level"] = @([ssvc.levelLabel.text intValue]);
            effect[@"level2"] = @([ssvc.levelLabel2.text intValue]);
            if (ssvc.selectResponse) {
                effect[@"question2"] = ssvc.selectResponse;
            }
            if (ssvc.dateTimeResponse) {
                effect[@"question1"] = ssvc.dateTimeResponse;
            }
        }
        
        [effects addObject:effect];
        
        NSLog(@"effects %@", effects);
    }
    NSLog(@"All effects: %@",effects);
    return effects;
}

@end
