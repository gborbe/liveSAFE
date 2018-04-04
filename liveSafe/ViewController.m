//
//  ViewController.m
//  liveSafe
//
//  Created by Garrett Borbe on 3/5/18.
//  Copyright © 2018 Garrett Borbe. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "MealsViewController.h"
#import "SheltersViewController.h"
#import "OrganizationEditViewController.h"

@import Firebase;

@interface ViewController ()
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) NSMutableDictionary *databaseCollection;
@property (strong, nonatomic) NSMutableDictionary *shelterDataCollection;
@property (strong, nonatomic) NSMutableDictionary *mealsDataCollection;

@end

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    self.ref = [[FIRDatabase database] reference];
    [self collectData];
    [super viewDidLoad];
}
- (void)collectData{
    [[self.ref child:@"Shelters"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        self.shelterDataCollection = snapshot.value;
        for (NSString* rootData in self.shelterDataCollection) {
            
            //access dictionary of a specific location
            NSDictionary *entry = [self.shelterDataCollection objectForKey:rootData];
            
            //check to see location's resource classifications (shelter and/or food and/or urban rest stops)
            NSString *shelter = [entry objectForKey:@"hasShelter"];
            
            if ([shelter isEqualToString:@"YES"]) {
                NSLog(@"Imma shelter: %@",entry);
            }

        }
        
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
    
    [[self.ref child:@"Meals"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        self.mealsDataCollection = snapshot.value;
        NSLog(@"%@",self.mealsDataCollection);
        
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
    
    
    
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"mealsSegue"]) {

        MealsViewController *MVC = segue.destinationViewController;
        MVC.mealsDictionary = self.mealsDataCollection;
        
    } else if ([segue.identifier isEqualToString:@"sheltersSegue"]) {
        
        SheltersViewController *SVC = segue.destinationViewController;
        SVC.shelterDictionary = self.shelterDataCollection;
        
    } else if ([segue.identifier isEqualToString:@"editSegue"]) {
        
        OrganizationEditViewController *OVC = segue.destinationViewController;
        OVC.orgData = self.shelterDataCollection[@"ROOTS"];
    }
    
}

@end
