//
//  AccountViewController.m
//  liveSafe
//
//  Created by Garrett J. Borbe on 5/9/18.
//  Copyright © 2018 Garrett Borbe. All rights reserved.
//

#import "AccountViewController.h"
#import "ViewController.h"
#import "AppDelegate.h"
#import "OrganizationEditViewController.h"
#import "Organization.h"
#import "TableViewController.h"

@interface AccountViewController ()
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (strong, nonatomic) FUIAuth *authUI;

@end

@implementation AccountViewController

-(void)setup {
    if (!self.loggedIn) {
        [self authUser];
    }
    [self loggedIn];
    if ([self loggedIn]) {
        self.loginButton.hidden = YES;
        self.editButton.hidden = NO;
        self.logoutButton.hidden = NO;
    } else {
        self.editButton.hidden = YES;
        self.logoutButton.hidden = YES;
        self.loginButton.hidden = NO;
    }
}

- (BOOL)loggedIn
{
    FIRAuth *auth = [FIRAuth auth];
    if (auth.currentUser) {
        NSLog(@"%@ is signed in", auth.currentUser.displayName);
        return YES;
    } else {
        NSLog(@"Nobody is signed in");
        return NO;
    }
}

- (IBAction)loginButtonPressed:(UIButton *)sender {
    UINavigationController *authViewController = [self.authUI authViewController];
    [self presentViewController:authViewController animated:YES completion:nil];
}

- (IBAction)logoutButtonPressed:(UIButton *)sender {
    NSError *signOutError;
    BOOL status = [[FIRAuth auth] signOut:&signOutError];
    if (!status) {
        NSLog(@"Error signing out: %@", signOutError);
        return;
    }else{
        NSLog(@"Successfully Signout");
    }
}

- (void)authUser {
    self.authUI = [FUIAuth defaultAuthUI];
    // You need to adopt a FUIAuthDelegate protocol to receive callback
    self.authUI.delegate = self;
    NSArray<id<FUIAuthProvider>> *providers = @[[[FUIGoogleAuth alloc] init]];
    self.authUI.providers = providers;
}

- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary *)options {
    NSString *sourceApplication = options[UIApplicationOpenURLOptionsSourceApplicationKey];
    return [[FUIAuth defaultAuthUI] handleOpenURL:url sourceApplication:sourceApplication];
}

- (void)authUI:(FUIAuth *)authUI
didSignInWithUser:(nullable FIRUser *)user
         error:(nullable NSError *)error {
    // Implement this method to handle signed in user or error if any.
}

#pragma mark - Inherited Methods

- (void)viewDidLoad {
    [self setup];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidLoad];
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
