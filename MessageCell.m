//
//  MessageRightView.m
//  CancerLife
//
//  Created by AGalkin on 1/8/14.
//  Copyright (c) 2014 FusionWorks. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell

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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void) setRightHidden
{
    [_rightView isHidden];
    [_leftView setHidden:NO];
}

- (void) setLeftHidden
{
    [_leftView isHidden];
    [_rightView setHidden:NO];
}


@end
