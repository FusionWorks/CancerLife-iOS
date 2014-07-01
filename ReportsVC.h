//
//  ReportsVC.h
//  CancerLife
//
//  Created by Constantin Lungu on 12/7/13.
//  Copyright (c) 2013 FusionWorks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface ReportsVC : UIViewController <MBProgressHUDDelegate, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) NSNumber* patientID;
@property (weak, nonatomic) IBOutlet UIButton *reportsButton;
@property (weak, nonatomic) IBOutlet UIButton *timeIntervalButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (weak, nonatomic) IBOutlet UIView *pickerView;
@property (weak, nonatomic) IBOutlet UIImageView *graficsView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableArray *pickerArray;
@property (strong, nonatomic) NSDictionary *frequentSymptoms;
@property (strong, nonatomic) NSDictionary *newerSymptoms;
@property (strong, nonatomic) NSDictionary *qualityOfLife;
@property (strong, nonatomic) NSDictionary *reports;
@property (strong, nonatomic) NSMutableDictionary *charts;
@property (strong, nonatomic) NSMutableDictionary *listData;
@property (weak, nonatomic) IBOutlet UIView *listDataView;






- (IBAction)timeIntervalButtonActivity:(id)sender;
- (IBAction)reportsButtonActivity:(id)sender;
@end
