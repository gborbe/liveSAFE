//
//  CustomCellViewController.m
//  liveSafe
//
//  Created by eddie on 4/9/18.
//  Copyright © 2018 Garrett Borbe. All rights reserved.
//

#import "CustomCellViewController.h"
#import "Organizations.h"

@interface CustomCellViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CustomCellViewController


#pragma mark - Setup
- (void)setup
{
    // make sure to add "<UITableViewDataSource>" to
    // CustomCellViewController.h for this to not
    // produce a warning
    self.tableView.dataSource = self;
    
    // make sure to add "<UITableViewDelegate>" to
    // CustomCellViewController.h for this to not
    // produce a warning
    self.tableView.delegate = self;
}
#pragma mark - Table View Data Source and Delegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Our table only has one section...
    if (section == 0) {
        return self.orgLibrary.count;
    } else {
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // grab the drone for this row
    Organizations *selectedOrg = self.orgLibrary[indexPath.row];
    
    // get our custom cell
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"custom"];
    
    // we assigned each component of the custom cell we created
    // in interface builder a unique tab number - this is how
    // we get references to those components
    UILabel *label = (UILabel *)[cell viewWithTag:1];
    UILabel *label2 = (UILabel *)[cell viewWithTag:2];
    UILabel *label3 = (UILabel *)[cell viewWithTag:3];
    
    // populate the cell
    label.text = selectedOrg.name;
    label2.text = selectedOrg.phone;
    label3.text = selectedOrg.address;
    
    // return our cell
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // we need to override the default cell height even thought we've set this
    // explicitly in interface builder (this may be a bug in apple's software)
    return 120;
}
#pragma mark - Inherited Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setup];
}


@end

