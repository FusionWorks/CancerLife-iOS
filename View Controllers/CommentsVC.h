//
//  CommentsVC.h
//  CancerLife
//
//  Created by Constantin Lungu on 11/13/13.
//  Copyright (c) 2013 FusionWorks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentsVC : UIViewController

@property (nonatomic, strong) NSNumber* selectedPostID;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end
