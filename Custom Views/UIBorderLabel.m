//
//  UIBorderLabel.m
//  CancerLife
//
//  Created by Andrew Galkin on 2/10/14.
//  Copyright (c) 2014 FusionWorks. All rights reserved.
//

#import "UIBorderLabel.h"

#import "UIBorderLabel.h"
@implementation UIBorderLabel

@synthesize topInset, leftInset, bottomInset, rightInset;

- (void)drawTextInRect:(CGRect)rect
{
    UIEdgeInsets insets = {self.topInset, self.leftInset,
        self.bottomInset, self.rightInset};
    
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
