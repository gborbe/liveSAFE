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
@property (weak, nonatomic) IBOutlet UITextView *spaceText;
@property (weak, nonatomic) IBOutlet UITextView *addressText;
@property (weak, nonatomic) IBOutlet UITextView *phoneText;
@property (weak, nonatomic) IBOutlet UITextView *webText;
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
    self.spaceText.text = [@"Space: " stringByAppendingString:self.orgDetails.space];
    self.addressText.text = self.orgDetails.address;
    self.webText.text = self.orgDetails.website;
    self.phoneText.text = self.orgDetails.phone;
}

//- (IBAction)backButtonPressed:(UIButton *)sender {
//    [self performSegueWithIdentifier:@"backSegue" sender:nil];
//}
@end
