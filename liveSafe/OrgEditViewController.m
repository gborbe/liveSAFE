//
//  OrgEditViewController.m
//  
//
//  Created by Garrett Borbe on 4/2/18.
//

#import "OrgEditViewController.h"
#import "ViewController.h"
#import "AppDelegate.h"
#import "ViewController.h"
@import Firebase;
@import FirebaseAuthUI;
@import FirebaseGoogleAuthUI;

@interface OrgEditViewController ()
@property (weak, nonatomic) IBOutlet UILabel *welcomeTitle;

@end

@implementation OrgEditViewController

- (void)viewDidLoad {
    [self setup];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)signInButtonPressed:(UIButton *)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setup {
    FIRAuth *auth = [FIRAuth auth];
    self.welcomeTitle.text = [NSString stringWithFormat:@"Welcome, %@", auth.currentUser.displayName];
    
}
- (IBAction)logoutButton:(id)sender {
    NSError *signOutError;
    BOOL status = [[FIRAuth auth] signOut:&signOutError];
    if (!status) {
        NSLog(@"Error signing out: %@", signOutError);
        return;
    }else{
        NSLog(@"Successfully Signout");
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
