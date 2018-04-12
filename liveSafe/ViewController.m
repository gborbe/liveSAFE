//
//  ViewController.m
//  liveSafe
//
//  Created by Garrett Borbe on 3/5/18.
//  Copyright © 2018 Garrett Borbe. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "OrganizationEditViewController.h"
#import "Organizations.h"
#import "CustomCellViewController.h"

@import Firebase;

@interface ViewController ()

@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) NSDictionary *shelterDataCollection;
@property (strong, nonatomic) NSMutableArray *orgObjectLibrary;
@property (nonatomic) BOOL loggedIn;
@property (strong, nonatomic) FUIAuth *authUI;

@end

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    self.ref = [[FIRDatabase database] reference];
    self.orgObjectLibrary = [[NSMutableArray alloc] init];
    [self collectData];
    [self setup];
    [super viewDidLoad];
}

#pragma mark - Database Compiling

- (void)collectData{
    [[self.ref child:@"Shelters"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        self.shelterDataCollection = snapshot.value;
        for (NSString* rootData in self.shelterDataCollection) {
            
            //access dictionary of a specific location
            NSDictionary *entry = [self.shelterDataCollection objectForKey:rootData];
            
            //Bring this dictionary over to create new object for Organization class
            Organizations *org = [[Organizations alloc] init];
            org.name = [NSString stringWithString:[entry objectForKey:@"name"]];
            org.address = [NSString stringWithString:[entry objectForKey:@"address"]];
            org.phone = [NSString stringWithString:[entry objectForKey:@"phone"]];
            org.website = [NSString stringWithString:[entry objectForKey:@"website"]];
            
            [self.orgObjectLibrary addObject:org];

        }
        
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"tableSegue"]) {
        
        CustomCellViewController *CVC = segue.destinationViewController;
        CVC.orgLibrary = self.orgObjectLibrary;
    }
    
}

#pragma mark - Firebase Authentication

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
