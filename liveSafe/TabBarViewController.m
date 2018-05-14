//
//  TabBarViewController.m
//  liveSafe
//
//  Created by Garrett Borbe on 5/2/18.
//  Copyright © 2018 Garrett Borbe. All rights reserved.
//

#import "TabBarViewController.h"
#import "AppDelegate.h"
#import "OrganizationEditViewController.h"
#import "Organization.h"
#import "TableViewController.h"

@interface TabBarViewController ()

@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) NSDictionary *shelterDataCollection;
@property (strong, nonatomic) NSMutableArray *orgObjectLibrary;
@property (nonatomic) BOOL loggedIn;
@property (strong, nonatomic) FUIAuth *authUI;

@end

@implementation TabBarViewController

- (void)setup
{
    
    
    if (!self.loggedIn) {
        [self authUser];
    }
    
    self.ref = [[FIRDatabase database] reference];
    self.orgObjectLibrary = [[NSMutableArray alloc] init];
    [self collectData];
    
}


#pragma mark - Database Compiling
//observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot)
- (void)collectData{
    [[self.ref child:@"Organizations"] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        self.shelterDataCollection = snapshot.value;
        
        NSMutableArray *restOrgs = [[NSMutableArray alloc] init];
        NSMutableArray *shelterOrgs = [[NSMutableArray alloc] init];
        NSMutableArray *mealOrgs = [[NSMutableArray alloc] init];
        
        for (NSString* rootData in self.shelterDataCollection) {
            
            //access dictionary of a specific location
            NSDictionary *entry = [self.shelterDataCollection objectForKey:rootData];
            
            //Bring this dictionary over to create new object for Organization class
            Organization *org = [[Organization alloc] init];
            
            org.name = [NSString stringWithString:[entry objectForKey:@"name"]];
            org.address = [NSString stringWithString:[entry objectForKey:@"address"]];
            org.phone = [NSString stringWithString:[entry objectForKey:@"phone"]];
            org.website = [NSString stringWithString:[entry objectForKey:@"website"]];
            org.space = [NSString stringWithString:[entry objectForKey:@"space"]];
            org.maxSpace = [NSString stringWithString:[entry objectForKey:@"maxSpace"]];
            org.openHour = [NSString stringWithString:[entry objectForKey:@"openTime"]];
            org.closeHour = [NSString stringWithString:[entry objectForKey:@"closeTime"]];
            org.servicesDescription = [NSString stringWithString:[entry objectForKey:@"servicesDescription"]];
            org.requirements = [NSString stringWithString:[entry objectForKey:@"requirements"]];
            org.imgURL = [NSString stringWithString:[entry objectForKey:@"img"]];
            org.meals = [[entry objectForKey:@"hasMeals"] boolValue];
            org.shelter = [[entry objectForKey:@"hasShelter"] boolValue];
            org.restStop = [[entry objectForKey:@"hasRest"] boolValue];
            org.about = [NSString stringWithString:[entry objectForKey:@"about"]];
            
            if (org.meals) {
                [mealOrgs addObject:org];
            }
            
            if (org.shelter) {
                [shelterOrgs addObject:org];
            }
            
            if (org.restStop) {
                [restOrgs addObject:org];
            }
            [self.orgObjectLibrary addObject:org];
            
        }
        
        for (UIViewController *childVC in self.childViewControllers) {
            if ([childVC isKindOfClass:[UINavigationController class]]) {
                UINavigationController *navigationVC = (UINavigationController *)childVC;
                if ([navigationVC.topViewController isKindOfClass:[TableViewController class]]) {
                    TableViewController *tableVC = (TableViewController *)navigationVC.topViewController;
                    tableVC.mealOrgs = mealOrgs;
                    tableVC.shelterOrgs = shelterOrgs;
                    tableVC.restOrgs = restOrgs;
                    [tableVC updateMapAndTable];
                }
            }
        }
        
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
    
}

#pragma mark - Firebase Authentication

//- (void)buttonChange {
//        if (FIRAuth.auth.currentUser != nil) {
//            
//        } else {
//            
//        }
//}

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

//- (IBAction)signInButtonPressed:(id)sender
//{
//    UINavigationController *authViewController = [self.authUI authViewController];
//    [self presentViewController:authViewController animated:YES completion:nil];
//}

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
    [self setup];
    [super viewDidLoad];
}

- (void)authUI:(FUIAuth *)authUI
didSignInWithUser:(nullable FIRUser *)user
error:(nullable NSError *)error {
    // Implement this method to handle signed in user or error if any.
}

#pragma mark - inherited methods
- (void)viewDidLoad {
    [self setup];
}
- (void)viewWillAppear:(BOOL)animated
{
    self.selectedIndex = self.selectedChildViewController;
}

@end
