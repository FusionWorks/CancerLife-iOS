//
//  MessageRightView.h
//  CancerLife
//
//  Created by AGalkin on 1/8/14.
//  Copyright (c) 2014 FusionWorks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageCell: UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (strong, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (strong, nonatomic) IBOutlet UIImageView *commentCloudImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextView *commentLabel;
@property (strong, nonatomic) IBOutlet UILabel *timestampLabel;

- (void) setup;
- (void) setRightHidden;
- (void) setLeftHidden;

@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageViewRight;
@property (weak, nonatomic) IBOutlet UIImageView *commentCloudImageViewRight;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabelRight;
@property (weak, nonatomic) IBOutlet UILabel *nameLabelRight;
@property (weak, nonatomic) IBOutlet UITextView *commentLabelRight;

@end
