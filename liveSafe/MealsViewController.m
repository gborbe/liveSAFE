//
//  MealsViewController.m
//  liveSafe
//
//  Created by eddie on 3/7/18.
//  Copyright © 2018 Garrett Borbe. All rights reserved.
//

#import "MealsViewController.h"
#import "MealDetailViewController.h"

@interface MealsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *mealsDataArray;
@property (nonatomic) NSUInteger mealRowIndex;

@end

@implementation MealsViewController

- (void)setup
{
    // Set tableview properties
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithRed:(248)
                                                     green:(254)
                                                      blue:(254)
                                                     alpha:(0)];

    // Create array from dictionary
    self.mealsDataArray = [self.mealsDictionary allValues];
    
    
}
#pragma mark - UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.mealsDictionary.count;
        
    } else {
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Create empty cell
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                                   reuseIdentifier:@"asdfadsf"];
    
    // Get row index and retrive dictionary for this row
    NSUInteger row = indexPath.row;
    NSDictionary *mealDataThisRow = self.mealsDataArray[row];
    
    // Populate the fields of our cell
    cell.textLabel.text = mealDataThisRow[@"name"];
    cell.detailTextLabel.text = mealDataThisRow[@"space"];
    cell.accessoryType = UITableViewCellAccessoryDetailButton;
    cell.textLabel.textColor=[UIColor colorWithRed:(0)
                                             green:(195)
                                              blue:(188)
                                             alpha:(1.0)];
    cell.textLabel.font = [UIFont fontWithName:@"optima" size:15.0f];
    cell.backgroundColor = [UIColor colorWithRed:(0)
                                           green:(0)
                                            blue:(0)
                                           alpha:(0)];
    return cell;
    
}
#pragma mark - UITableViewDelegate Methods
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    self.mealRowIndex = indexPath.row;
    [self performSegueWithIdentifier:@"mealDetailSegue" sender:nil];

}
#pragma mark - Inherited Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setup];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MealDetailViewController *MDVC = segue.destinationViewController;
    MDVC.mealData = self.mealsDataArray[self.mealRowIndex];
}

@end
