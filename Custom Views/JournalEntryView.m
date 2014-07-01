//
//  JournalEntryView.m
//  CancerLife
//
//  Created by Constantin Lungu on 10/16/13.
//  Copyright (c) 2013 FusionWorks. All rights reserved.
//

#import "JournalEntryView.h"
#import <QuartzCore/QuartzCore.h>

#define SCALE_COLOR_VIEW_WIDTH  164.0f
#define IMPACT_COLOR_VIEW_WIDTH 139.0f

@interface JournalEntryView()
{
    NSMutableArray* _sideEffects;
}

@end

@implementation JournalEntryView

#pragma mark -
#pragma mark - Private API

- (void) setup
{
    [_audienceLabel sizeToFit];
    [_symptomParent sizeToFit];
    _moodImageView.contentMode = UIViewContentModeScaleAspectFill;
    _audienceLabel.frame = CGRectMake(_audienceLabel.frame.origin.x, _audienceIcon.frame.origin.y - 5, _audienceLabel.frame.size.width, _audienceLabel.frame.size.height);
    _scaleColorView.frame = CGRectMake(_scaleColorView.frame.origin.x, _scaleColorView.frame.origin.y, _scaleColorView.frame.size.width, _scaleColorView.frame.size.height);
    _scaleColorView.layer.cornerRadius = 7.75f;
    _messageHandler.layer.cornerRadius = 10.0f;
    
    _impactColorView.layer.cornerRadius = 6.0f;
    _impactColorView.frame = CGRectOffset(_impactColorView.frame, 0, -0.5);
    _impactColorView2.layer.cornerRadius = 6.0f;
    _impactColorView2.frame = CGRectOffset(_impactColorView2.frame, 0, -0.5);
    _impactLabel.frame = CGRectOffset(_impactLabel.frame, 0, 2);
    _scaleHead.layer.cornerRadius = 5.0f;
    [_messageLabel sizeToFit];
//    _messageLabel.frame = CGRectMake(5, 5, _messageCloud.frame.size.width - 7.5, _messageLabel.frame.size.height);
    _scaleColorView2.layer.cornerRadius = 7.75f;
    _scaleHead2.layer.cornerRadius = 5.0f;
    [_timestampLabel sizeToFit];
    _timestampLabel.center = CGPointMake(self.center.x + _timeIcon.frame.size.width - 5, _timeIcon.center.y - 1);
    CGSize maximumLabelSize = CGSizeMake(120, FLT_MAX);

    CGSize expectedLabelSize = [_timestampLabel.text sizeWithFont:_timestampLabel.font constrainedToSize:maximumLabelSize lineBreakMode:_timestampLabel.lineBreakMode];
    CGRect newFrame = _timestampLabel.frame;
    newFrame.size.height = expectedLabelSize.height;
    _timestampLabel.frame = newFrame;

    [_scaleHeadLabel sizeToFit];
    _scaleHeadLabel.frame = CGRectMake(3, 0, _scaleHeadLabel.frame.size.width, _scaleHeadLabel.frame.size.height);
    _scaleHead.frame = CGRectMake(_scaleHead.frame.origin.x, _scaleHead.frame.origin.y, _scaleHeadLabel.frame.size.width + 6, _scaleHead.frame.size.height);

    [_scaleHeadLabel2 sizeToFit];
    _scaleHeadLabel2.frame = CGRectMake(3, 0, _scaleHeadLabel2.frame.size.width, _scaleHeadLabel2.frame.size.height);
    _scaleHead2.frame = CGRectMake(_scaleHead2.frame.origin.x, _scaleHead2.frame.origin.y, _scaleHeadLabel2.frame.size.width + 6, _scaleHead2.frame.size.height);

    if ([_audienceLabel.text length] == 0) {
        [_audienceLabel removeFromSuperview];
        [_audienceIcon removeFromSuperview];
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height - 40);
    } else {
        if ([self lineCountForLabel:_audienceLabel] < 2) {
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height - 15);
        }
    }

//    _audienceLabel.frame = CGRectMake(_audienceLabel.frame.origin.x, _symptomParent.frame.size.height + _symptomParent.frame.origin.y, _audienceLabel.frame.size.width, _audienceLabel.frame.size.height);
    _audienceIcon.frame = CGRectMake(_audienceIcon.frame.origin.x, _audienceLabel.frame.origin.y + 2, _audienceIcon.frame.size.width, _audienceIcon.frame.size.height);
    
    CGRect frame = self.frame;
    frame.size.height = _moodImageView.frame.size.height + _symptomParent.frame.size.height + _audienceLabel.frame.size.height + 50;
    self.frame = frame;
}

#pragma mark -
#pragma mark - Public API

- (void) setScaleFactor:(NSInteger)scale animated:(BOOL) animated
{
    if (scale > 10) scale = 10;
    if (scale < 0) scale = 0;
    if (animated) {
        [UIView animateWithDuration:0.5f delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             _scaleColorView.frame = CGRectMake(_scaleColorView.frame.origin.x, _scaleColorView.frame.origin.y, scale* (SCALE_COLOR_VIEW_WIDTH / 10.), _scaleColorView.frame.size.height);
                         }
                         completion:nil];
    } else {
        _scaleColorView.frame = CGRectMake(_scaleColorView.frame.origin.x, _scaleColorView.frame.origin.y, scale* (SCALE_COLOR_VIEW_WIDTH / 10.), _scaleColorView.frame.size.height);
    }
    float red = scale < 5 ? 1.0 - ((10 - scale) / 10.0) : 1.0;
    float green = 1.0 - (scale / 10.0);
    _scaleColorView.backgroundColor = [UIColor colorWithRed:red green:green blue:0 alpha:1.0];
    [_scaleLabel setText:[NSString stringWithFormat:@"%d",scale]];
    [_scaleLabel sizeToFit];
    _scaleLabel.center = CGPointMake(_scaleColorView.frame.origin.x - 12, _scaleColorView.center.y);
}

- (void) setImpactScaleFactor:(NSInteger)scale animated:(BOOL)animated
{
    if (scale > 10) scale = 10;
    if (scale < 0) scale = 0;
    if (animated) {
        [UIView animateWithDuration:0.5f delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             _impactColorView.frame = CGRectMake(_impactColorView.frame.origin.x, _impactColorView.frame.origin.y, scale* (IMPACT_COLOR_VIEW_WIDTH / 4.), _impactColorView.frame.size.height);
                         }
                         completion:nil];
    } else {
        _impactColorView.frame = CGRectMake(_impactColorView.frame.origin.x, _impactColorView.frame.origin.y, scale* (IMPACT_COLOR_VIEW_WIDTH / 10.), _impactColorView.frame.size.height);
    }
    float red = scale < 5 ? 1.0 - ((10 - scale) / 10.0) : 1.0;
    float green = 1.0 - (scale / 10.0);
    _impactColorView.backgroundColor = [UIColor colorWithRed:red green:green blue:0 alpha:1.0];
}

- (void) setSecondScaleFactor:(NSInteger)scale animated:(BOOL)animated
{
    if (scale > 10) scale = 10;
    if (scale < 0) scale = 0;
    if (animated) {
        [UIView animateWithDuration:0.5f delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             _scaleColorView2.frame = CGRectMake(_scaleColorView2.frame.origin.x, _scaleColorView2.frame.origin.y, scale* (SCALE_COLOR_VIEW_WIDTH / 10.), _scaleColorView2.frame.size.height);
                         }
                         completion:nil];
    } else {
        _scaleColorView2.frame = CGRectMake(_scaleColorView2.frame.origin.x, _scaleColorView2.frame.origin.y, scale* (SCALE_COLOR_VIEW_WIDTH / 10.), _scaleColorView2.frame.size.height);
    }
    if (scale != 0) {
        [_scaleLabel2 setText:[NSString stringWithFormat:@"%d",scale]];
        [_scaleLabel2 sizeToFit];
        _scaleLabel2.center = CGPointMake(_scaleColorView2.frame.origin.x - 12, _scaleColorView2.center.y);
        float red = scale < 5 ? 1.0 - ((10 - scale) / 10.0) : 1.0;
        float green = 1.0 - (scale / 10.0);
        _scaleColorView2.backgroundColor = [UIColor colorWithRed:red green:green blue:0 alpha:1.0];
    } else {
        if ([_scaleHeadLabel2.text length] == 0) {
            [_scaleHeadLabel2 removeFromSuperview];
            [_scaleHead2 removeFromSuperview];
            _audienceIcon.frame = CGRectOffset(_audienceIcon.frame, 0, -60);
            _audienceLabel.frame = CGRectOffset(_audienceLabel.frame, 0, -60);
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height - 60);

        } else {
            _scaleHead2.frame = CGRectOffset(_scaleHead2.frame, -28, 0);
            _audienceIcon.frame = CGRectOffset(_audienceIcon.frame, 0, -20);
            _audienceLabel.frame = CGRectOffset(_audienceLabel.frame, 0, -20);
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height - 20);
        }
        [_scaleBar2 removeFromSuperview];
    }
}

- (void) setSecondImpactScaleFactor:(NSInteger)scale animated:(BOOL)animated
{
    if (scale > 10) scale = 10;
    if (scale < 0) scale = 0;
    if (animated) {
        [UIView animateWithDuration:0.5f delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             _impactColorView2.frame = CGRectMake(_impactColorView2.frame.origin.x, _impactColorView2.frame.origin.y, scale* (IMPACT_COLOR_VIEW_WIDTH / 4.), _impactColorView2.frame.size.height);
                         }
                         completion:nil];
    } else {
        _impactColorView2.frame = CGRectMake(_impactColorView2.frame.origin.x, _impactColorView2.frame.origin.y, scale* (IMPACT_COLOR_VIEW_WIDTH / 10.), _impactColorView2.frame.size.height);
    }
    float red = scale < 5 ? 1.0 - ((10 - scale) / 10.0) : 1.0;
    float green = 1.0 - (scale / 10.0);
    _impactColorView2.backgroundColor = [UIColor colorWithRed:red green:green blue:0 alpha:1.0];
}

- (void) addSideEffectWithName:(NSString *)name
{
    UIView* bg = [[UIView alloc] init];
    bg.backgroundColor = [UIColor colorWithRed:0.89 green:0.89 blue:0.89 alpha:1];
    bg.layer.cornerRadius = 6.0f;
    UILabel* sideEffectLabel = [self deepLabelCopy:_scaleHeadLabel2];
    sideEffectLabel.text = [name uppercaseString];
    [sideEffectLabel sizeToFit];
    if ([_audienceLabel text].length > 0) {
        bg.frame = CGRectOffset(_audienceLabel.frame, -27, 0);
        bg.frame = CGRectMake(bg.frame.origin.x, bg.frame.origin.y + 7, sideEffectLabel.frame.size.width + 6, sideEffectLabel.frame.size.height);
        bg.autoresizingMask = UIViewAutoresizingNone;
        sideEffectLabel.frame = CGRectMake(3, sideEffectLabel.frame.origin.y, sideEffectLabel.frame.size.width, sideEffectLabel.frame.size.height);
        if (!_sideEffects.count) {
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height + 25);
        }
    }
    [bg addSubview:sideEffectLabel];
    if (!_sideEffects) {
        _sideEffects = [NSMutableArray array];
    } else if (_sideEffects.count) {
        UIView* lastSideEffect = [_sideEffects lastObject];
        if (([UIScreen mainScreen].bounds.size.width - 5 - lastSideEffect.frame.size.width - lastSideEffect.frame.origin.x) >= bg.frame.size.width + 10) {
            bg.frame = CGRectMake(lastSideEffect.frame.origin.x + lastSideEffect.frame.size.width + 3, bg.frame.origin.y, bg.frame.size.width, bg.frame.size.height);
        } else {
            bg.frame = CGRectMake(lastSideEffect.frame.origin.x, bg.frame.origin.y + 5, bg.frame.size.width, bg.frame.size.height);
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height + 25);
        }
    }
    [self addSubview:bg];
    [_sideEffects addObject:bg];
}

- (void) addSideEffectWithName:(NSString *)name scale:(NSInteger)scale impactScale:(NSInteger)impactScale
{
    
}

- (void) removeAnySideEffects
{
    [_scaleHead removeFromSuperview];
    [_scaleHead2 removeFromSuperview];
    [_scaleBar1 removeFromSuperview];
    [_scaleBar2 removeFromSuperview];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height - 60);
    _sideEffects = nil;
}

#pragma mark -
#pragma mark - Private

- (int)lineCountForLabel:(UILabel *)label
{
    CGSize constrain = CGSizeMake(label.bounds.size.width, 1000000);
    CGSize size = [label.text sizeWithFont:label.font constrainedToSize:constrain lineBreakMode:NSLineBreakByWordWrapping];
    return ceil(size.height / label.font.lineHeight);
}

- (UILabel *)deepLabelCopy:(UILabel *)label
{
    UILabel *duplicateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    duplicateLabel.textColor = label.textColor;
    duplicateLabel.backgroundColor = [UIColor clearColor];
    duplicateLabel.font = label.font;
    duplicateLabel.lineBreakMode = label.lineBreakMode;
    duplicateLabel.layer.cornerRadius = label.layer.cornerRadius;
    return duplicateLabel;
}

- (void)enableDoctorMode
{
    [_timeHeader removeFromSuperview];
    _timeHeader = nil;
    _timestampLabel.frame = CGRectMake(self.center.x/1.5, 0, _timestampLabel.frame.size.width, _timestampLabel.frame.size.height);
    _timeIcon.frame = CGRectMake(_timestampLabel.frame.origin.x - 15, _timestampLabel.frame.origin.y, _timeIcon.frame.size.width, _timeIcon.frame.size.height);
    [_audienceLabel removeFromSuperview];
    _audienceLabel = nil;
    [_audienceIcon removeFromSuperview];
    _audienceIcon = nil;

    _nameLabel.hidden = NO;
//    _messageLabel.frame = CGRectMake(_messageLabel.frame.origin.x, _messageLabel.frame.origin.y + 10, _messageLabel.frame.size.width, _messageLabel.frame.size.height);
    [_messageLabel sizeToFit];
    UIButton* patientsJournalButton = [UIButton buttonWithType:UIButtonTypeCustom];
    patientsJournalButton.frame = CGRectMake(0, (_moodImageView.frame.origin.y + _moodImageView.frame.size.height) + 5, 97, 32);
    patientsJournalButton.center = CGPointMake(_moodImageView.center.x, patientsJournalButton.center.y);
    [patientsJournalButton setImage:[UIImage imageNamed:@"patientJournalButton"] forState:UIControlStateNormal];
    [patientsJournalButton addTarget:self action:@selector(patientsJournalPressed) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:patientsJournalButton];

    UIButton* patientsReportsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    patientsReportsButton.frame = CGRectMake(0, 0, 97, 32);
    [patientsReportsButton setImage:[UIImage imageNamed:@"patientReportsButton"] forState:UIControlStateNormal];
    [patientsReportsButton addTarget:self action:@selector(patientsReportsPressed) forControlEvents:UIControlEventTouchUpInside];
    patientsReportsButton.frame = CGRectMake(patientsJournalButton.frame.origin.x, (patientsJournalButton.frame.origin.y + patientsJournalButton.frame.size.height) + 5, 97, 32);
    [self addSubview:patientsReportsButton];

}

- (void) enablePending
{
    _pendingImageView.hidden = NO;
}

- (void)patientsJournalPressed
{
    if ([self.delegate respondsToSelector:@selector(journalPressedOnEntry:)]) {
        [self.delegate journalPressedOnEntry:self];
    }
}

- (void)patientsReportsPressed
{
    if ([self.delegate respondsToSelector:@selector(reportsPressedOnEntry:)]) {
        [self.delegate reportsPressedOnEntry:self];
    }
}

@end
