//
//  OrganizationEditViewController.m
//  liveSafe
//
//  Created by Garrett Borbe on 3/29/18.
//  Copyright © 2018 Garrett Borbe. All rights reserved.
//

#import "OrganizationEditViewController.h"

@interface OrganizationEditViewController ()
@property (weak, nonatomic) IBOutlet UILabel *userTitle;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UITextField *spaceTextField;

@end

@implementation OrganizationEditViewController
- (IBAction)acceptChanges:(id)sender {
    [self.orgData setObject:self.spaceTextField.text forKey:@"space"];
    NSLog(@"%@",self.orgData);
}

- (void)setup {
    self.spaceTextField.placeholder = self.orgData[@"space"];
    self.userTitle.text = self.orgData[@"name"];
    [self getImage];
}

- (void)getImage {
    NSString *imageUrlString = self.orgData[@"image"];
    NSURL *url = [NSURL URLWithString:imageUrlString];
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    UIImage *collectedImage = [UIImage imageWithData:data];
    self.userImage.image = collectedImage;
}

//Inherited Methods

- (void)viewDidLoad {
    [self setup];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
