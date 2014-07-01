//
//  RegisterChoice.m
//  CancerLife
//
//  Created by Andrew Galkin on 5/19/14.
//  Copyright (c) 2014 FusionWorks. All rights reserved.
//

#import "RegisterChoice.h"
#import "RegisterVC.h"

@interface RegisterChoice ()

@end

@implementation RegisterChoice

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[_doctorButton layer] setCornerRadius:7.f];
    [[_doctorButton layer] setMasksToBounds:YES];
    [[_patientButton layer] setCornerRadius:7.f];
    [[_patientButton layer] setMasksToBounds:YES];
    [[_caregiverButton layer] setCornerRadius:7.f];
    [[_caregiverButton layer] setMasksToBounds:YES];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
