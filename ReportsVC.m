//
//  ReportsVC.m
//  CancerLife
//
//  Created by Constantin Lungu on 12/7/13.
//  Copyright (c) 2013 FusionWorks. All rights reserved.
//

#import "ReportsVC.h"
#import "AFHTTPRequestOperationManager.h"
#import "AppDelegate.h"
#import "ReportsCell.h"
#import "Defines.h"
#import "MFSideMenu.h"
#import "Helper.h"
#import "Utils.h"

@interface ReportsVC ()
{
    AppDelegate* _appDel;
    NSString *selectedTime;
    NSString *lastGraficNumber;
}

- (void)loadReports;
@end

@implementation ReportsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (MFSideMenuContainerViewController*) menuContainerViewController
{
    return (MFSideMenuContainerViewController*)_appDel.window.rootViewController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _appDel = (AppDelegate*)[UIApplication sharedApplication].delegate;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _scrollView.delegate = self;
    _scrollView.showsVerticalScrollIndicator = YES;
    if (!IS_IOS_7) {
        _scrollView.frame = CGRectMake(5, 70, 310, 380);
        _scrollView.frame = CGRectMake(5, 120, 310, 380);
    }
    _scrollView.contentSize = CGSizeMake(310, 400);
    _scrollView.frame = CGRectMake(5, 120, 310, 450);
    selectedTime = @"7";
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _charts = [[NSMutableDictionary alloc] init];
    _listData = [[NSMutableDictionary alloc] init];
    [_reportsButton.layer setCornerRadius:6.0f];
    [_timeIntervalButton.layer setCornerRadius:6.0f];
    [self loadReports];
    if (![_appDel.role isEqualToString:@"Doctor"]){
        _appDel.container.panMode = MFSideMenuPanModeCenterViewController | MFSideMenuPanModeSideMenu;
        [self setupNavigationButtons];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setupNavigationButtons
{
    UIButton *toggleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [toggleButton setImage:[UIImage imageNamed:@"sideMenuButton"] forState:UIControlStateNormal];
    [toggleButton setFrame:CGRectMake(0, 0, 32, 22)];
    [toggleButton addTarget:self action:@selector(togglePressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *toggle = [[UIBarButtonItem alloc] initWithCustomView:toggleButton];
    self.navigationItem.leftBarButtonItem = toggle;
}

- (void) togglePressed
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{}];
}

- (IBAction)timeIntervalButtonActivity:(id)sender {
    _pickerArray = [[NSMutableArray alloc] initWithObjects:@"7", @"14",@"21",@"60", nil];
    [_pickerView setHidden:NO];
    [_picker reloadAllComponents];
}

- (IBAction)reportsButtonActivity:(id)sender {
    _pickerArray = [[NSMutableArray alloc] initWithObjects:@"Reports", nil];
    for(int i=1; i<=[_reports count]; i++){
        [_pickerArray addObject:[_reports objectForKey:[NSString stringWithFormat:@"%d",i]]];
    }
//    [_pickerArray addObjectsFromArray:[_reports allValues]];
    NSLog(@"pick %@", _pickerArray);
    [_pickerView setHidden:NO];
    [_picker reloadAllComponents];
}

#pragma mark -
#pragma mark - Private API

- (void)loadReports
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer* serializer = [AFHTTPRequestSerializer serializer];
    [serializer setValue:_appDel.authToken forHTTPHeaderField:@"token"];
    [manager setRequestSerializer:serializer];
    [manager GET:[NSString stringWithFormat:@"%@%@",API_GET_REPORTS,_patientID] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        _frequentSymptoms = [responseObject objectForKey:@"frequent_symptoms"];
        
        _newerSymptoms = [responseObject objectForKey:@"new_symptoms"];
        
        _qualityOfLife = [responseObject objectForKey:@"quality_of_life"];
        
        _reports = [responseObject objectForKey:@"reports"];
        NSLog(@"reports %@", _reports);
        [_tableView reloadData];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

- (void)loadGraphics:(NSNumber *)number
{
    lastGraficNumber = [NSString stringWithFormat:@"%@",number];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer* serializer = [AFHTTPRequestSerializer serializer];
    [serializer setValue:_appDel.authToken forHTTPHeaderField:@"token"];
//    [serializer setValue:@"270" forHTTPHeaderField:@"width"];
    [manager setRequestSerializer:serializer];
    [manager GET:[NSString stringWithFormat:@"%@%@/%@",API_GET_REPORTS,_patientID,number] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        for (int pos = 7; pos<=60; pos+=7){
            if (pos==28)
                pos = 60;
            NSString *imgURL = [responseObject valueForKey:[NSString stringWithFormat:@"%i",pos]];
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",API_MAIN,imgURL]]]];
//            image = [self resizeImage:image withWidth:270.f withHeight:360.f];
            NSLog(@"imgURL %@ image %@", imgURL, image);
            if ([imgURL length]>0){
                [_charts setObject:image forKey:[NSString stringWithFormat:@"%i",pos]];
            } else {
                [_charts setObject:[UIImage imageNamed:@"noGraphics"] forKey:[NSString stringWithFormat:@"%i",pos]];
            }
            
            if ([number isEqual:[NSNumber numberWithInt:1]] || [number isEqual:[NSNumber numberWithInt:2]]){
                NSDictionary *dict = [[responseObject objectForKey:@"list_data"] objectForKey:[NSString stringWithFormat:@"%i",pos]];
                NSLog(@"dict %@", dict);
                [_listData setObject:dict forKey:[NSString stringWithFormat:@"%i",pos]];
            }
        }
        NSLog(@"cha %@ %@", _charts, _listData);
        [_graficsView setImage:[_charts valueForKey:selectedTime]];
        if ([number isEqual:[NSNumber numberWithInt:1]] || [number isEqual:[NSNumber numberWithInt:2]]){
            [self putListDataWithTime:selectedTime];
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

//- (UIImage*)resizeImage:(UIImage*)image withWidth:(CGFloat)width withHeight:(CGFloat)height
//{
//    CGSize newSize = CGSizeMake(width, height);
//    CGFloat widthRatio = newSize.width/image.size.width;
//    CGFloat heightRatio = newSize.height/image.size.height;
//    
//    if(widthRatio > heightRatio)
//    {
//        newSize=CGSizeMake(image.size.width*heightRatio,image.size.height*heightRatio);
//    }
//    else
//    {
//        newSize=CGSizeMake(image.size.width*widthRatio,image.size.height*widthRatio);
//    }
//    
//    
//    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
//    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
//    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    return newImage;
//}

#pragma mark -
#pragma mark - Table View Delegate / Data Source

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _tableView) {
        return 1;
    }
    return 0;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tableView) {
        return [[_frequentSymptoms objectForKey:selectedTime] count] + [[_newerSymptoms objectForKey:selectedTime] count] + [[_qualityOfLife objectForKey:selectedTime] count] + 6;
    }
    return 0;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int freqCount = [[_frequentSymptoms objectForKey:selectedTime] count];
    int newerCount = [[_newerSymptoms objectForKey:selectedTime] count];
    int quality = [[_qualityOfLife objectForKey:selectedTime] count];
    NSLog(@"f %i, n %i, q %i", freqCount, newerCount, quality);
    if (tableView == _tableView) {
        NSString* CellIdentifier = @"ReportsCell";
        NSLog(@"indexpath %i", indexPath.row);
        ReportsCell *cell = (ReportsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ReportsCell" owner:nil options:nil];
            cell = (ReportsCell*)[nib objectAtIndex:0];
        }
        if(indexPath.row < freqCount+2){
            if(indexPath.row == 0){
                [cell.title setHidden:NO];
                cell.title.text = @"Frequently Reported Symptoms";
            }else if (indexPath.row == 1){
                cell.column1.text = @"Symptom";
                cell.column2.text = @"Avg Score";
                cell.column3.text = @"%";
            }else{
                int pos =indexPath.row-2;
                cell.column1.text = [[[_frequentSymptoms objectForKey:selectedTime] objectAtIndex:pos] objectForKey:@"name"];
                cell.column2.text= [NSString stringWithFormat:@"%@",[[[_frequentSymptoms objectForKey:selectedTime] objectAtIndex:pos] objectForKey:@"avg_score"]];
                cell.column3.text = [NSString stringWithFormat:@"%@",[[[_frequentSymptoms objectForKey:selectedTime] objectAtIndex:pos] objectForKey:@"percentage"]];
            }
            
        }else if ((indexPath.row - (freqCount+2)) < newerCount+2){
            if ((indexPath.row - (freqCount+2)) == 0){
                [cell.title setHidden:NO];
                cell.title.text = @"New Symptoms";
            }else if ((indexPath.row - (freqCount+3)) == 0){
                cell.column1.text = @"Symptom";
            }else{
                int pos = indexPath.row - (freqCount+4);
                cell.column1.text = [[_newerSymptoms objectForKey:selectedTime] objectAtIndex:pos];
            }
            
            NSLog(@"_newerSymptoms %@",[_newerSymptoms objectForKey:selectedTime]);
        
        }else{
            
            if (indexPath.row - (freqCount + newerCount + 4) == 0){
                [cell.title setHidden:NO];
                cell.title.text = @"Quality Of Life";
            }else if (indexPath.row - (freqCount + newerCount + 5) == 0) {
                cell.column1.text = @"Symptom";
                cell.column2.text = @"Previous";
                cell.column3.text = @"Change";
            }else{
                int pos = indexPath.row - (freqCount + newerCount + 6);
                cell.column1.text = [[[_qualityOfLife objectForKey:selectedTime] objectAtIndex:pos] objectForKey:@"change"];
                cell.column2.text = [NSString stringWithFormat:@"%@",[[[_qualityOfLife objectForKey:selectedTime] objectAtIndex:pos] objectForKey:@"current"]];
                cell.column3.text = [NSString stringWithFormat:@"%@",[[[_qualityOfLife objectForKey:selectedTime] objectAtIndex:pos] objectForKey:@"previous"]];
            }
            
            NSLog(@"symp %@",[_qualityOfLife objectForKey:_qualityOfLife]);
        }

        return cell;
    }
    return nil;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];

    }
}

- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView) {
        return 30.0;
    }
    return 0.0;
}

- (void) putListDataWithTime:(NSString *)number
{
    NSArray *objects = [_listData objectForKey:number];
    int Y = 10;
    int offset = 0;
    for (id key in objects) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, Y, 10, 10)];
        [imageView setBackgroundColor:[Helper colorWithHexString:[key objectForKey:@"color"] alpha:1.f]];
        [_listDataView addSubview:imageView];
        
        UILabel  *label = [[UILabel alloc] initWithFrame:CGRectMake(20, Y-5, 310, 20)];
        label.numberOfLines=0;
        [label setText:[key objectForKey:@"text"]];
        [_listDataView addSubview:label];
        
        CGRect frame = _listDataView.frame;
        frame.size.height = _listDataView.frame.size.height+15;
        _listDataView.frame = frame;
        
        NSLog(@"label %@ imageview %@", label, imageView);
        Y+=20;
        
        if (!IS_IOS_7) {
            offset = 100;
        }
        _scrollView.contentSize = CGSizeMake(300, _listDataView.frame.size.height + _graficsView.frame.size.height + offset);
    }
    
}

#pragma mark -
#pragma mark PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return _pickerArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return _pickerArray[row];
}

#pragma mark -
#pragma mark PickerView Delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    for(UIView *subview in [_listDataView subviews]) {
        [subview removeFromSuperview];
    }
    
    CGRect frame = _listDataView.frame;
    frame.size.height = 1;
    _listDataView.frame = frame;
    
    NSString *selection = [_pickerArray objectAtIndex:row];
    [_pickerView setHidden:YES];
    if ([_pickerArray count]==4){
        [_timeIntervalButton setTitle:selection forState:UIControlStateNormal];
        selectedTime = selection;
        if ([_tableView isHidden]){
            if ([_charts valueForKey:selectedTime] != NULL){
                [_graficsView setImage:[_charts valueForKey:selectedTime]];
                if ([lastGraficNumber isEqual:[NSString stringWithFormat:@"%i",1]] || [lastGraficNumber isEqual:[NSString stringWithFormat:@"%i",2]]){
                    [self putListDataWithTime:selectedTime];
                }
            }
        }
        if ([_graficsView isHidden]){
            [_tableView reloadData];
        }
    }else{
        if(row == 0){
            [self loadReports];
            [_graficsView setHidden:YES];
            [_tableView setHidden:NO];
        }else{
            [self loadGraphics:[NSNumber numberWithInt:row]];
            [_charts removeAllObjects];
            [_graficsView setHidden:NO];
            [_tableView setHidden:YES];
        }
        [_reportsButton setTitle:selection forState:UIControlStateNormal];
        
    }
}


@end