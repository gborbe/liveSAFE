//
//  ShelterDetailsViewController.m
//  liveSafe
//
//  Created by Garrett Borbe on 3/10/18.
//  Copyright © 2018 Garrett Borbe. All rights reserved.
//

#import "ShelterDetailsViewController.h"

@interface ShelterDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameTitle;
@property (weak, nonatomic) IBOutlet UITextView *addressLabel;
@property (weak, nonatomic) IBOutlet UITextView *phoneLabel;
@property (weak, nonatomic) IBOutlet UITextView *webLabel;
@property (weak, nonatomic) IBOutlet UITextView *hoursLabel;
@property (weak, nonatomic) IBOutlet UIImageView *orgImage;

@end

@implementation ShelterDetailsViewController

- (void)setup
{
    self.addressLabel.text = self.shelterData[@"address"];
    self.phoneLabel.text = self.shelterData[@"phone"];
    self.webLabel.text = self.shelterData[@"website"];
    self.nameTitle.text = self.shelterData[@"name"];
    self.hoursLabel.text = self.shelterData[@"hours"];
    [self getImage];
    
}


- (void)getImage {
    NSString *imageUrlString = self.shelterData[@"image"];
    NSURL *url = [NSURL URLWithString:imageUrlString];
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    UIImage *collectedImage = [UIImage imageWithData:data];
    self.orgImage.image = collectedImage;
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
