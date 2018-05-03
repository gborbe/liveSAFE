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
- (void)collectData{
    [[self.ref child:@"Organizations"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
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
            org.openHour = [NSString stringWithString:[entry objectForKey:@"openTime"]];
            org.closeHour = [NSString stringWithString:[entry objectForKey:@"closeTime"]];
            org.servicesDescription = [NSString stringWithString:[entry objectForKey:@"servicesDescription"]];
            org.requirements = [NSString stringWithString:[entry objectForKey:@"requirements"]];
            org.imgURL = [NSString stringWithString:[entry objectForKey:@"img"]];
            org.meals = [[entry objectForKey:@"hasMeals"] boolValue];
            org.shelter = [[entry objectForKey:@"hasShelter"] boolValue];
            org.restStop = [[entry objectForKey:@"hasRest"] boolValue];
            
            if (org.meals) {
                [mealOrgs addObject:org];
            }
            
            if (org.shelter) {
                [shelterOrgs addObject:org];
            }
            
            if (org.restStop) {
                [shelterOrgs addObject:org];
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
                }
            }
        }
        
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
    
}

#pragma mark - Firebase Authentication

- (void)buttonChange {
    //    if (FIRAuth.auth.currentUser != nil) {
    //        <#statements#>;
    //    } else {
    //        <#statements#>;
    //    }
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
    
}

- (void)authUI:(FUIAuth *)authUI
didSignInWithUser:(nullable FIRUser *)user
error:(nullable NSError *)error {
    // Implement this method to handle signed in user or error if any.
}

#pragma mark - inherited methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}


//- (void)locationOpen {
//    //Get hours from Database in this format
//    NSString *open = @"08:00 AM";
//    NSString *close = @"10:00 PM";
//
//    //Get current time
//    NSDate *nowDate = [[NSDate alloc] init];
//
//    //Date Formatter
//    NSDateFormatter *formatTime = [[NSDateFormatter alloc]init];
//    [formatTime setDateFormat:@"hh:mm a"];
//
//    //Open & Close NSString hours to NSDate
//    NSDate *openDate = [formatTime dateFromString:open];
//    NSDate *closeDate = [formatTime dateFromString:close];
//
//    //Testing
//    NSLog(@"Current Time: %@",[formatTime stringFromDate:nowDate]);
//    NSLog(@"Open: %@",[formatTime stringFromDate:openDate]);
//    NSLog(@"Close: %@",[formatTime stringFromDate:closeDate]);
//
//    //Check to see if location is open
//    int openMin = [self minutesSinceMidnight:openDate];
//    int closeMin = [self minutesSinceMidnight:closeDate];
//    int nowMin = [self minutesSinceMidnight:nowDate];
//
//    if (nowMin < openMin && nowMin > closeMin) {
//        NSLog(@"This location is open");
//    } else if (nowMin > openMin && nowMin < closeMin) {
//        NSLog(@"This location is open");
//    } else {
//        NSLog(@"This location is closed");
//    }
//
//}
//
//-(int) minutesSinceMidnight:(NSDate *)date
//{
//    NSCalendar *gregorian = [[NSCalendar alloc]
//                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//    unsigned unitFlags =  NSCalendarUnitHour | NSCalendarUnitMinute;
//    NSDateComponents *components = [gregorian components:unitFlags fromDate:date];
//
//    return 60 * [components hour] + [components minute];
//}
@end
