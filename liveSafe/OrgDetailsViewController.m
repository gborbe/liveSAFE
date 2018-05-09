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
@property (weak, nonatomic) IBOutlet UILabel *spaceLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *webLabel;

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
    self.spaceLabel.text = [@"Space: " stringByAppendingString:self.orgDetails.space];
    self.addressLabel.text = self.orgDetails.address;
    self.webLabel.text = self.orgDetails.website;
    self.phoneLabel.text = self.orgDetails.phone;
}

//- (IBAction)backButtonPressed:(UIButton *)sender {
//    [self performSegueWithIdentifier:@"backSegue" sender:nil];
//}
@end
