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
@property (weak, nonatomic) IBOutlet UITextView *spaceText;
@property (weak, nonatomic) IBOutlet UITextView *addressText;
@property (weak, nonatomic) IBOutlet UITextView *phoneText;
@property (weak, nonatomic) IBOutlet UITextView *webText;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segControl;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *webLabel;
@property (weak, nonatomic) IBOutlet UILabel *spaceLabel;
@property (weak, nonatomic) IBOutlet UILabel *aboutUsLabel;
@property (weak, nonatomic) IBOutlet UITextView *aboutUsText;
@property (weak, nonatomic) IBOutlet UITextView *requireText;
@property (weak, nonatomic) IBOutlet UILabel *requireLabel;

@end

@implementation OrgDetailsViewController

- (void)viewDidLoad {
    [self setup];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)innerTabChanged:(UISegmentedControl *)sender {
    if (self.segControl.selectedSegmentIndex == 0) {
        self.addressText.hidden = NO;
        self.phoneText.hidden = NO;
        self.webText.hidden = NO;
        self.spaceText.hidden = NO;
        self.addressLabel.hidden = NO;
        self.phoneLabel.hidden = NO;
        self.webLabel.hidden = NO;
        self.spaceLabel.hidden = NO;
        self.aboutUsLabel.hidden = YES;
        self.aboutUsText.hidden = YES;
        self.requireLabel.hidden = YES;
        self.requireText.hidden = YES;
    } else if (self.segControl.selectedSegmentIndex == 1) {
        self.addressText.hidden = YES;
        self.phoneText.hidden = YES;
        self.webText.hidden = YES;
        self.spaceText.hidden = YES;
        self.addressLabel.hidden = YES;
        self.phoneLabel.hidden = YES;
        self.webLabel.hidden = YES;
        self.spaceLabel.hidden = YES;
        self.aboutUsLabel.hidden = YES;
        self.aboutUsText.hidden = YES;
        self.requireLabel.hidden = NO;
        self.requireText.hidden = NO;
    } else if (self.segControl.selectedSegmentIndex == 2) {
        self.addressText.hidden = YES;
        self.phoneText.hidden = YES;
        self.webText.hidden = YES;
        self.spaceText.hidden = YES;
        self.addressLabel.hidden = YES;
        self.phoneLabel.hidden = YES;
        self.webLabel.hidden = YES;
        self.spaceLabel.hidden = YES;
        self.aboutUsLabel.hidden = NO;
        self.aboutUsText.hidden = NO;
        self.requireLabel.hidden = YES;
        self.requireText.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setup {
    self.navigationItem.title = self.orgDetails.name;
    
    NSString *start = @"Space: ";
    NSString *slash = @"/";
    NSString *partOne = [start stringByAppendingString:self.orgDetails.space];
    NSString *partTwo = [slash stringByAppendingString:self.orgDetails.maxSpace];
    NSString *spaceResult = [partOne stringByAppendingString:partTwo];
    self.spaceText.text = spaceResult;
    
    self.addressText.text = self.orgDetails.address;
    self.webText.text = self.orgDetails.website;
    self.phoneText.text = self.orgDetails.phone;
    
    NSString *imgLink = self.orgDetails.imgURL;
    NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgLink]];
    self.imageView.image = [UIImage imageWithData:imgData];
    self.aboutUsText.text = self.orgDetails.about;
    self.requireText.text = self.orgDetails.requirements;
}

@end
