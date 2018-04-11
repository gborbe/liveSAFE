//
//  SignInViewController.m
//  
//
//  Created by Garrett Borbe on 4/2/18.
//

#import "SignInViewController.h"

@interface SignInViewController ()

@property (nonatomic) BOOL loggedIn;
@property (strong, nonatomic) FUIAuth *authUI;

@end

@implementation SignInViewController

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
- (IBAction)signInButtonPressed:(id)sender
{
    UINavigationController *authViewController = [self.authUI authViewController];
    [self presentViewController:authViewController animated:YES completion:nil];
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

- (void)viewDidAppear:(BOOL)animated
{
    if (!self.loggedIn) {
    } else {
        [self performSegueWithIdentifier:@"loggedInSegue" sender:self];
    }
}

- (void)authUI:(FUIAuth *)authUI
didSignInWithUser:(nullable FIRUser *)user
         error:(nullable NSError *)error {
    // Implement this method to handle signed in user or error if any.
}

- (void)setup{
    if (!self.loggedIn) {
        [self authUser];
    }
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
