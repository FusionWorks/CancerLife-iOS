//
//  SelectModalVC.m
//  CancerLife
//
//  Created by Constantin Lungu on 11/28/13.
//  Copyright (c) 2013 FusionWorks. All rights reserved.
//

#import "SelectModalVC.h"
#import "Defines.h"
#import "Utils.h"

#define CELL_TAG 0x11

@interface SelectModalVC ()
{
    NSArray*        _displayItems;
    NSMutableArray* _selectedItems;
    NSString *orgId;
    NSString *docId;
}
@end

@implementation SelectModalVC

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
    if (!IS_IOS_7) {
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    }
    _displayItems = [_items allValues];
    
    _selectedItems = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([_displayItems count] != 0)
        return _items.count;
    else
        return [_doctorItems count];
        
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SelectModalCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    cell.tag = CELL_TAG;
    if([_displayItems count] != 0){
        cell.textLabel.text = [_displayItems objectAtIndex:indexPath.row];
    }else{
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:16.f];
        NSString *name = [NSString stringWithFormat:@"%@ : %@", [[_doctorItems objectAtIndex:indexPath.row] valueForKey:@"name"],[[_doctorItems objectAtIndex:indexPath.row] valueForKey:@"doctor_name"]];
        cell.textLabel.text = name;

    }
    
    
    return cell;
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if([_displayItems count] != 0){
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell.accessoryType == UITableViewCellAccessoryNone) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            if (![_selectedItems containsObject:_displayItems[indexPath.row]]) {
                [_selectedItems addObject:_displayItems[indexPath.row]];
            }
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
            if ([_selectedItems containsObject:_displayItems[indexPath.row]]) {
                [_selectedItems removeObject:_displayItems[indexPath.row]];
            }
        }
    }else{
        orgId = [[_doctorItems objectAtIndex:indexPath.row] valueForKey:@"id"];
        docId = [[_doctorItems objectAtIndex:indexPath.row] valueForKey:@"doctor_id"];
        if([[[_doctorItems objectAtIndex:indexPath.row] valueForKey:@"doctor_name"] length] < 1)
            [_selectedItems addObject:[[_doctorItems objectAtIndex:indexPath.row] valueForKey:@"name"]];
        else
            [_selectedItems addObject:[[_doctorItems objectAtIndex:indexPath.row] valueForKey:@"doctor_name"]];
        [self performSelectorOnMainThread:@selector(donePressed:) withObject:nil waitUntilDone:NO];
    }
}

- (IBAction)cancelPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)donePressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    if ([self.delegate respondsToSelector:@selector(modalSelectedItems:)]) {
        [self.delegate modalSelectedItems:_selectedItems];
    }else
        [self.delegate doctorSelectedItems:_selectedItems organizationId:orgId doctorId:docId];
    
    
}
@end
