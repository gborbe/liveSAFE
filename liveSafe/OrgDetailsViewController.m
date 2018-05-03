//
//  OrgDetailsViewController.m
//  liveSafe
//
//  Created by Garrett Borbe on 4/20/18.
//  Copyright © 2018 Garrett Borbe. All rights reserved.
//

#import "OrgDetailsViewController.h"
#import "TableViewController.h"

@interface OrgDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *orgTitle;

@end

@implementation OrgDetailsViewController

- (void)viewDidLoad {
    [self setup];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setup {
    self.orgTitle.text = self.orgDetails.name;
}

- (IBAction)backButtonPressed:(UIButton *)sender {
    [self performSegueWithIdentifier:@"backSegue" sender:nil];
}
@end
