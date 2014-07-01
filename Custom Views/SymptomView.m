//
//  SymtomView.m
//  CancerLife
//
//  Created by Constantin Lungu on 11/9/13.
//  Copyright (c) 2013 FusionWorks. All rights reserved.
//

#import "SymptomView.h"
#import <QuartzCore/QuartzCore.h>
#import "CMPopTipView.h"

#define DATETIME_BUTTON 1
#define SELECT_BUTTON   2

#define GREEN_COLOR     [UIColor colorWithRed:40.0/255.0 green:166.0/255.0 blue:12.0/255.0 alpha:1.0]

@interface SymptomView()
{
    float           _sliderStep;
    __strong CMPopTipView*   _popTip;
    NSTimer*        _popTipTimer;
    UIDatePicker*   _dateTimePicker;
    NSNumber*       _selectedDate;
    NSArray*        _selections;
}

@end

@implementation SymptomView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) initWithName:(NSString *)name type:(NSString *)type pictureName:(NSString *)pictureName minValue:(NSInteger)min maxValue:(NSInteger)max question:(NSString *)question options:(NSArray *)options minValue2:(NSInteger)min2 maxValue2:(NSInteger)max2 question2:(NSString*)question2 options2:(NSArray*)options2
{
    if (self) {
        self.symptomHeaderView.userInteractionEnabled = YES;
        self.symptomNameLabel.text = [name uppercaseString];
        if ([type caseInsensitiveCompare:@"slider"] != NSOrderedSame) {
            //            [_levelSlider removeFromSuperview];
        }else {
            if (question) {
                _sliderStep = 1.0;
                [_levelLabel setText:[NSString stringWithFormat:@"%i",min]];
                [_maximumLabel setText:[NSString stringWithFormat:@"%i",max]];
                [_separator1 setHidden:NO];
            } else {
                [_levelLabel removeFromSuperview];
                [_maximumLabel removeFromSuperview];
                [_minusButton removeFromSuperview];
                [_plusButton removeFromSuperview];
            }
            if (question2) {
                [_levelLabel2 setText:[NSString stringWithFormat:@"%i",min2]];
                [_maximumLabel2 setText:[NSString stringWithFormat:@"%i",max2]];
                [_separator2 setHidden:NO];
            } else {
                [_levelLabel2 removeFromSuperview];
                [_maximumLabel2 removeFromSuperview];
                [_minusButton2 removeFromSuperview];
                [_plusButton2 removeFromSuperview];
            }
        }
        
        if (question) {
            _questionLabel.text = question;
            //            _levelSlider.frame = CGRectOffset(_questionLabel.frame, 0, 5);
            //            _levelSlider.minimumTrackTintColor = GREEN_COLOR;
            //            _levelView.frame = CGRectOffset(_questionLabel.frame, 0, 5);
            //            _levelLabel.text = [NSString stringWithFormat:@"%i",min];
            _options = options;
        } else {
            [_questionLabel removeFromSuperview];
            //            [_levelView removeFromSuperview];
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height - 62);
        }
        
        if (question2) {
            _questionLabel2.text = question2;
            _options2 = options2;
            _levelLabel2.text = [NSString stringWithFormat:@"%i",min2];
        } else {
            [_questionLabel2 removeFromSuperview];
            //            [_levelView2 removeFromSuperview];
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height - 72);
        }
    }
    [self setup];
}

#pragma mark -
#pragma mark - Setup

- (IBAction)deleteSymptomPressed
{
    [self dismissPopTip];
    if ([self.delegate respondsToSelector:@selector(deleteSymptomPressed:)]) {
        [self.delegate deleteSymptomPressed:self];
    }
}

- (IBAction)minusLevel:(id)sender
{
    if (sender == _minusButton) {
        int level = [[_levelLabel text] intValue];
        NSLog(@"level m %i str %@", level, [_levelLabel text]);
        if(level > 1){
            _levelLabel.text = [NSString stringWithFormat:@"%i",level-1];
            if (_options.count) {
                if (_popTip) {
                    [_popTip dismissAnimated:YES]; _popTip = nil;
                }
                NSString* message = [_options valueForKey:[NSString stringWithFormat:@"%d",[[_levelLabel text] intValue]]];
                NSLog(@"_popTip  %@ message %@", _popTip, message);
                _popTip = [[CMPopTipView alloc] initWithMessage:message];
                _popTip.backgroundColor = GREEN_COLOR;
                _popTip.delegate = self;
                [_popTip presentPointingAtView:_levelLabel inView:[self superview] animated:YES];
                _popTipTimer = [NSTimer scheduledTimerWithTimeInterval:7.0 target:self selector:@selector(dismissPopTip) userInfo:nil repeats:NO];
                
            }
        }
    } else if (sender == _minusButton2) {
        int level = [[_levelLabel2 text] intValue];
        if(level > 1){
            _levelLabel2.text = [NSString stringWithFormat:@"%i",level-1];
            NSLog(@"options count %@", _options2);
            if (_options2.count) {
                if (_popTip) {
                    [_popTip dismissAnimated:YES]; _popTip = nil;
                }
                NSString* message = [_options2 valueForKey:[NSString stringWithFormat:@"%d",[[_levelLabel2 text] intValue]]];
                NSLog(@"_popTip  %@ message %@", _popTip, message);
                _popTip = [[CMPopTipView alloc] initWithMessage:message];
                _popTip.backgroundColor = GREEN_COLOR;
                _popTip.delegate = self;
                [_popTip presentPointingAtView:_levelLabel2 inView:[self superview] animated:YES];
                _popTipTimer = [NSTimer scheduledTimerWithTimeInterval:7.0 target:self selector:@selector(dismissPopTip) userInfo:nil repeats:NO];
                
            }
        }
    }
}

- (IBAction)plusLevel:(id)sender
{
    if (sender == _plusButton) {
        int level = [[_levelLabel text] intValue];
        NSLog(@"level m %i str %@", level, [_maximumLabel2 text]);
        if(level < [[_maximumLabel text] intValue]){
            _levelLabel.text = [NSString stringWithFormat:@"%i",level+1];
            if (_options.count) {
                if (_popTip) {
                    [_popTip dismissAnimated:YES]; _popTip = nil;
                }
                NSString* message = [_options valueForKey:[NSString stringWithFormat:@"%d",[[_levelLabel text] intValue]]];
                _popTip = [[CMPopTipView alloc] initWithMessage:message];
                _popTip.backgroundColor = GREEN_COLOR;
                _popTip.delegate = self;
                [_popTip presentPointingAtView:_levelLabel inView:[self superview] animated:YES];
                _popTipTimer = [NSTimer scheduledTimerWithTimeInterval:7.0 target:self selector:@selector(dismissPopTip) userInfo:nil repeats:NO];
            
            }
        }
    } else if (sender == _plusButton2) {
        int level = [[_levelLabel2 text] intValue];
        NSLog(@"level m %i str %@", level, [_maximumLabel2 text]);
        if(level < [[_maximumLabel2 text] intValue]){
            _levelLabel2.text = [NSString stringWithFormat:@"%i",level+1];
            NSLog(@"_options2 %@", _options2);
            if (_options2.count) {
                if (_popTip) {
                    [_popTip dismissAnimated:YES]; _popTip = nil;
                }
                NSString* message = [_options2 valueForKey:[NSString stringWithFormat:@"%d",[[_levelLabel2 text] intValue]]];
                _popTip = [[CMPopTipView alloc] initWithMessage:message];
                _popTip.backgroundColor = GREEN_COLOR;
                _popTip.delegate = self;
                [_popTip presentPointingAtView:_levelLabel2 inView:[self superview] animated:YES];
                _popTipTimer = [NSTimer scheduledTimerWithTimeInterval:7.0 target:self selector:@selector(dismissPopTip) userInfo:nil repeats:NO];
            }
            
        }
    }
}

- (void) dismissPopTip
{
    [_popTipTimer invalidate];
    [_popTip dismissAnimated:YES];
    _popTip = nil;
}

- (void) setup
{
    _symptomHeaderView.layer.cornerRadius = 5.0f;
}

- (void) popTipViewWasDismissedByUser:(CMPopTipView *)popTipView
{
    [_popTipTimer invalidate];
    popTipView = nil;
}

- (void) addQuestion:(NSString *)question withType:(NSString *)type
{
    UILabel* extraQuestionLabel = [[UILabel alloc] init];
    extraQuestionLabel.text = question;
    extraQuestionLabel.frame = CGRectMake(extraQuestionLabel.frame.origin.x, self.frame.size.height - 3, 280, 40);
    extraQuestionLabel.hidden = NO;
    extraQuestionLabel.backgroundColor = [UIColor clearColor];
    extraQuestionLabel.font = _questionLabel.font;
    extraQuestionLabel.numberOfLines = 2;
    extraQuestionLabel.textAlignment = NSTextAlignmentCenter;
    extraQuestionLabel.center = CGPointMake(self.center.x, extraQuestionLabel.center.y);
    [self addSubview:extraQuestionLabel];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height + extraQuestionLabel.frame.size.height + 2);
    
    UIButton* dateTimeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dateTimeButton.frame = CGRectMake(0, 0, 280, 30);
    
    if ([type isEqualToString:@"datetime"]) {
        [dateTimeButton setTitle:@"Select time" forState:UIControlStateNormal];
        dateTimeButton.tag = DATETIME_BUTTON;
    } else if ([type isEqualToString:@"select"]) {
        [dateTimeButton setTitle:@"Select" forState:UIControlStateNormal];
        dateTimeButton.tag = SELECT_BUTTON;
    }
    [dateTimeButton addTarget:self action:@selector(extraQuestionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    dateTimeButton.center = CGPointMake(self.center.x, dateTimeButton.center.y);
    dateTimeButton.frame = CGRectOffset(extraQuestionLabel.frame, 0, extraQuestionLabel.frame.size.height + 3);
    [dateTimeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [dateTimeButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height + dateTimeButton.frame.size.height + 2);
    [self addSubview:dateTimeButton];
}

- (void)extraQuestionButtonPressed:(UIButton*)sender
{
    if ([self.delegate respondsToSelector:@selector(extraQuestionWantsAnswer:onView:)]) {
        if (sender.tag == DATETIME_BUTTON) {
            [self.delegate extraQuestionWantsAnswer:@"datetime" onView:self];
        } else if (sender.tag == SELECT_BUTTON) {
            [self.delegate extraQuestionWantsAnswer:@"select" onView:self];
        }
    }
}

- (void)setDateTimeValue:(NSString *)val withSelectedDate:(NSDate*)date
{
    UIButton* btn = (UIButton*)[self viewWithTag:DATETIME_BUTTON];
    [btn setTitle:val forState:UIControlStateNormal];
    [btn setTitle:val forState:UIControlStateHighlighted];
    _selectedDate = [NSNumber numberWithFloat:[date timeIntervalSince1970]];
}

- (void)setSelectValue:(NSString *)val withSelections:(NSArray*)selections
{
    UIButton* btn = (UIButton*)[self viewWithTag:SELECT_BUTTON];
    NSString* value = [selections componentsJoinedByString:@", "];
    [btn setTitle:value forState:UIControlStateNormal];
    [btn setTitle:value forState:UIControlStateHighlighted];
    _selections = selections;
}

- (NSNumber*)dateTimeResponse
{
    return _selectedDate;
}

- (NSArray*)selectResponse
{
    return _selections;
}

@end
