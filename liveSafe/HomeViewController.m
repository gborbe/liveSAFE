//
//  HomeViewController.m
//  liveSafe
//
//  Created by Garrett J. Borbe on 5/14/18.
//  Copyright © 2018 Garrett Borbe. All rights reserved.
//

#import "HomeViewController.h"
#import "TabBarViewController.h"
@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"restStopSegue"]) {
        TabBarViewController *tabBarVC = (TabBarViewController *)segue.destinationViewController;
        tabBarVC.selectedChildViewController = 1;
    }
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
