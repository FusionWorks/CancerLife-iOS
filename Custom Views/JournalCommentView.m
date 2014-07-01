//
//  JournalCommentView.m
//  CancerLife
//
//  Created by Constantin Lungu on 10/26/13.
//  Copyright (c) 2013 FusionWorks. All rights reserved.
//

#import "JournalCommentView.h"
#import <QuartzCore/QuartzCore.h>

@implementation JournalCommentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) setup
{
    self.avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.avatarImageView.layer.cornerRadius = 5.0f;
}

@end
