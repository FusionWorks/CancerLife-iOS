//
//  DynamicLabel.h
//  CancerLife
//
//  Created by Andrew Galkin on 2/19/14.
//  Copyright (c) 2014 FusionWorks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (dynamicSizeMe)

-(float)resizeToFit;
-(float)expectedHeight;

@end
