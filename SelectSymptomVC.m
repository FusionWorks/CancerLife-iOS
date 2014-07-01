//
//  SelectSymptomVC.m
//  CancerLife
//
//  Created by Constantin Lungu on 11/23/13.
//  Copyright (c) 2013 FusionWorks. All rights reserved.
//

#import "SelectSymptomVC.h"
#import "Defines.h"
#import "Utils.h"

@interface SelectSymptomVC ()

- (void)setupView;
@end

@implementation SelectSymptomVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setupView
{
    if (!IS_IOS_7) {
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _symptoms.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SymptomCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = _symptoms[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_delegate respondsToSelector:@selector(selectedSymptom:)]) {
        [_delegate selectedSymptom:_symptoms[indexPath.row]];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)cancelPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
