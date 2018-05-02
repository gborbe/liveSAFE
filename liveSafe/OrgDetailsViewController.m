//
//  OrgDetailsViewController.m
//  liveSafe
//
//  Created by Garrett Borbe on 4/20/18.
//  Copyright © 2018 Garrett Borbe. All rights reserved.
//

#import "OrgDetailsViewController.h"
#import "TableViewController.h"
#import "ServicesView.h"
#import "GeneralInfoView.h"

@interface OrgDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *orgTitle;
@property (weak, nonatomic) IBOutlet UIView *genericContainerView;

@end

@implementation OrgDetailsViewController

- (void)setOrgLibrary:(NSArray *)orgLibrary
{
    _orgLibrary = orgLibrary;
}

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
- (IBAction)segmentDidChange:(UISegmentedControl *)sender
{
    
    
    if (sender.selectedSegmentIndex == 1) {
        ServicesView *servicesView = [[[NSBundle mainBundle] loadNibNamed:@"ServicesView" owner:self options:nil] objectAtIndex:0];
        
        servicesView.testLabel.text = @"This is a test string";
        
        [self.genericContainerView addSubview:servicesView];

    } else if (sender.selectedSegmentIndex == 2) {
        
        \
        GeneralInfoView *generalInfoView = [[[NSBundle mainBundle] loadNibNamed:@"GeneralInfoView" owner:self options:nil] objectAtIndex:0];
        
        generalInfoView.testLabel.text = @"General Info View";
        
        [self.genericContainerView addSubview:generalInfoView];

    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    TableViewController *infoSegue = segue.destinationViewController;
    infoSegue.orgLibrary = self.orgLibrary;
}
@end
