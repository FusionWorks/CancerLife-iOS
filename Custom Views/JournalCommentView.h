//
//  JournalCommentView.h
//  CancerLife
//
//  Created by Constantin Lungu on 10/26/13.
//  Copyright (c) 2013 FusionWorks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JournalCommentView : UIView

@property (strong, nonatomic) NSNumber *entryID;

@property (strong, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (strong, nonatomic) IBOutlet UIImageView *commetCloudImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *commentLabel;
@property (strong, nonatomic) IBOutlet UILabel *timestampLabel;

- (void) setup;

@end
