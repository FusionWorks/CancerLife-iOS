//
//  JournalEntryView.h
//  CancerLife
//
//  Created by Constantin Lungu on 10/16/13.
//  Copyright (c) 2013 FusionWorks. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JournalEntryView;

@protocol JournalEntryDelegate <NSObject>

- (void)journalPressedOnEntry:(JournalEntryView*) entry;
- (void)reportsPressedOnEntry:(JournalEntryView*) entry;

@end

@interface JournalEntryView : UIView
@property (weak, nonatomic) IBOutlet UIView *symptomParent;
@property (weak, nonatomic) IBOutlet UIImageView *messageTriangle;
@property (weak, nonatomic) IBOutlet UIView *messageHandler;

@property (strong, nonatomic) NSNumber* entryID;
@property (strong, nonatomic) NSNumber* totalComments;
@property (strong, nonatomic) id <JournalEntryDelegate> delegate;

@property (strong, nonatomic) NSString* phoneNumber;
@property (strong, nonatomic) NSString* jid;
@property (strong, nonatomic) IBOutlet UIView *scaleBar1;
@property (strong, nonatomic) IBOutlet UIView *scaleBar2;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@property (strong, nonatomic) IBOutlet UIImageView *timeIcon;
@property (strong, nonatomic) IBOutlet UIImageView *timeHeader;
@property (strong, nonatomic) IBOutlet UILabel *timestampLabel;
@property (strong, nonatomic) IBOutlet UIImageView *moodImageView;
@property (strong, nonatomic) IBOutlet UIImageView *pendingImageView;
@property (strong, nonatomic) IBOutlet UILabel *audienceLabel;
@property (strong, nonatomic) IBOutlet UIImageView *audienceIcon;
@property (strong, nonatomic) IBOutlet UIImageView *scaleBarBackground;
@property (strong, nonatomic) IBOutlet UIView *scaleColorView;
@property (strong, nonatomic) IBOutlet UILabel *scaleLabel;
@property (strong, nonatomic) IBOutlet UIView *impactColorView;
@property (strong, nonatomic) IBOutlet UIView *impactColorView2;
@property (strong, nonatomic) IBOutlet UIImageView *impactScaleBackground;
@property (strong, nonatomic) IBOutlet UILabel *impactLabel;
//@property (strong, nonatomic) IBOutlet UIView *messageCloud;
@property (weak, nonatomic) IBOutlet UITextView *messageLabel;
@property (strong, nonatomic) IBOutlet UIView *scaleHead;
@property (strong, nonatomic) IBOutlet UILabel *scaleHeadLabel;
@property (strong, nonatomic) IBOutlet UILabel *scaleHeadLabel2;

@property (strong, nonatomic) IBOutlet UIView *scaleHead2;
@property (strong, nonatomic) IBOutlet UIImageView *scaleBarBackground2;
@property (strong, nonatomic) IBOutlet UIView *scaleColorView2;
@property (strong, nonatomic) IBOutlet UILabel *scaleLabel2;

- (void) setup;
- (void) setScaleFactor:(NSInteger) scale animated:(BOOL)animated;
- (void) setImpactScaleFactor:(NSInteger) scale animated:(BOOL)animated;
- (void) setSecondImpactScaleFactor:(NSInteger)scale animated:(BOOL)animated;
- (void) setSecondScaleFactor:(NSInteger)scale animated:(BOOL)animated;

- (void) addSideEffectWithName:(NSString*) name;
- (void) addSideEffectWithName:(NSString*) name scale:(NSInteger) scale impactScale:(NSInteger) impactScale;
- (void) removeAnySideEffects;

- (void) enableDoctorMode;
- (void) enablePending;
@end
