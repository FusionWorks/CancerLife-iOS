//
//  SymtomView.h
//  CancerLife
//
//  Created by Constantin Lungu on 11/9/13.
//  Copyright (c) 2013 FusionWorks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMPopTipView.h"

@class SymptomView;

@protocol SymptomViewDelegate <NSObject>

- (void) deleteSymptomPressed:(id)sender;
- (void) sliderValueChanged:(id)sender;
- (void) extraQuestionWantsAnswer:(NSString*)type onView:(SymptomView*)sv;

@end

@interface SymptomView : UIView <CMPopTipViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *separator1;
@property (weak, nonatomic) IBOutlet UILabel *separator2;
// UI
@property (strong, nonatomic) IBOutlet UIView *symptomHeaderView;
@property (strong, nonatomic) IBOutlet UILabel *symptomNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *questionLabel;
@property (strong, nonatomic) IBOutlet UILabel *levelLabel;
@property (strong, nonatomic) IBOutlet UILabel *questionLabel2;
@property (strong, nonatomic) IBOutlet UILabel *levelLabel2;
@property (weak, nonatomic) IBOutlet UILabel *maximumLabel;
@property (weak, nonatomic) IBOutlet UILabel *maximumLabel2;

// MODEL
@property (strong, nonatomic) id <SymptomViewDelegate> delegate;
@property (strong, nonatomic) NSArray* options;
@property (strong, nonatomic) NSArray* options2;
@property (strong, nonatomic) NSDictionary* selectOptions;
@property (weak, nonatomic) IBOutlet UIButton *minusButton;
@property (weak, nonatomic) IBOutlet UIButton *minusButton2;
@property (weak, nonatomic) IBOutlet UIButton *plusButton;
@property (weak, nonatomic) IBOutlet UIButton *plusButton2;

- (IBAction)deleteSymptomPressed;
- (IBAction)minusLevel:(id)sender;
- (IBAction)plusLevel:(id)sender;

- (void)setup;
- (void)initWithName:(NSString *)name type:(NSString *)type pictureName:(NSString *)pictureName minValue:(NSInteger)min maxValue:(NSInteger)max question:(NSString *)question options:(NSArray *)options minValue2:(NSInteger)min2 maxValue2:(NSInteger)max2 question2:(NSString*)question2 options2:(NSArray*)options2;
- (void)dismissPopTip;
- (void)addQuestion:(NSString*)question withType:(NSString*)type;

- (NSNumber*)dateTimeResponse;
- (NSArray*)selectResponse;
- (void)setDateTimeValue:(NSString *)val withSelectedDate:(NSDate*)date;
- (void)setSelectValue:(NSString *)val withSelections:(NSArray*)selections;
@end
