//
//  MealDetailViewController.m
//  liveSafe
//
//  Created by eddie on 3/7/18.
//  Copyright © 2018 Garrett Borbe. All rights reserved.
//

#import "MealDetailViewController.h"

@interface MealDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameTitle;
@property (weak, nonatomic) IBOutlet UITextView *addressLabel;
@property (weak, nonatomic) IBOutlet UITextView *phoneLabel;
@property (weak, nonatomic) IBOutlet UITextView *webLabel;
@property (weak, nonatomic) IBOutlet UITextView *hoursLabel;

@end

@implementation MealDetailViewController

- (void)setup
{
    self.addressLabel.text = self.mealData[@"address"];
    self.phoneLabel.text = self.mealData[@"phone"];
    self.webLabel.text = self.mealData[@"website"];
    self.nameTitle.text = self.mealData[@"name"];
    self.hoursLabel.text = self.mealData[@"hours"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
