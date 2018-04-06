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
#import "Organizations.h"

@import Firebase;

@interface ViewController ()
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) NSMutableDictionary *databaseCollection;
@property (strong, nonatomic) NSDictionary *shelterDataCollection;
@property (strong, nonatomic) NSMutableDictionary *mealsDataCollection;
@property (strong, nonatomic) NSMutableArray *orgObjectLibrary;
@property (weak, nonatomic) IBOutlet UIButton *checkArray;

@end

@interface ViewController ()

@end

@implementation ViewController
- (IBAction)checkArray:(id)sender {
    NSLog(@"Array: %@",self.orgObjectLibrary);
}

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
