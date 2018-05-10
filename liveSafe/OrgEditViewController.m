//
//  OrgEditViewController.m
//
//
//  Created by liveSafe on 4/2/18.
//


#import "OrgEditViewController.h"
#import "ViewController.h"
#import "AppDelegate.h"
#import "ViewController.h"
#import "Organization.h"
@import Firebase;
@import FirebaseAuthUI;
@import FirebaseGoogleAuthUI;

@interface OrgEditViewController ()
@property (weak, nonatomic) IBOutlet UILabel *welcomeTitle;
@property (weak, nonatomic) IBOutlet UITextField *hoursTextField;
@property (weak, nonatomic) IBOutlet UIStepper *stepper;
@property (weak, nonatomic) IBOutlet UILabel *spacesLabel;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) NSMutableDictionary *dictToPush;
@property (strong, nonatomic) NSString *valueToPush;
@property (nonatomic) NSString *uid;
@property (nonatomic) Organization *userOrg;

@end

@implementation OrgEditViewController
- (IBAction)stepChanged:(UIStepper *)sender
{
    self.spacesLabel.text = [NSString stringWithFormat:@"Spaces: %i", (int)self.stepper.value];
}

-(void)setupUser {
    self.ref = [[FIRDatabase database] reference];
    FIRAuth *auth = [FIRAuth auth];
    self.uid = auth.currentUser.uid;
    [self getUserInfo];
    [self getDatabaseNodeToChange];
    [self setupUserScreen];
}

-(void)setupUserScreen {
    self.welcomeTitle.text = [NSString stringWithFormat:@"Welcome, %@", self.userOrg.name];
}

- (void)getDatabaseNodeToChange{
    
    NSString *pathEndpoint = self.uid;
    
    FIRDatabaseReference *ref = [[_ref child:@"Organizations"] child:pathEndpoint];
    [ref observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *oldDict = snapshot.value;
        self.dictToPush = [[NSMutableDictionary alloc] initWithDictionary:oldDict];
        
    }];
}

- (void)getUserInfo
{
    self.userOrg = [[Organization alloc] init];
    NSString *pathEndpoint = self.uid;
    
    FIRDatabaseReference *ref = [[_ref child:@"Organizations"] child:pathEndpoint];
    [ref observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *collection = snapshot.value;
        self.userOrg.name = [NSString stringWithString:[collection objectForKey:@"name"]];
        self.userOrg.address = [NSString stringWithString:[collection objectForKey:@"address"]];
        self.userOrg.phone = [NSString stringWithString:[collection objectForKey:@"phone"]];
        self.userOrg.website = [NSString stringWithString:[collection objectForKey:@"website"]];
        self.userOrg.space = [NSString stringWithString:[collection objectForKey:@"space"]];
        self.userOrg.openHour = [NSString stringWithString:[collection objectForKey:@"openTime"]];
        self.userOrg.closeHour = [NSString stringWithString:[collection objectForKey:@"closeTime"]];
        self.userOrg.servicesDescription = [NSString stringWithString:[collection objectForKey:@"servicesDescription"]];
        self.userOrg.requirements = [NSString stringWithString:[collection objectForKey:@"requirements"]];
        self.userOrg.imgURL = [NSString stringWithString:[collection objectForKey:@"img"]];
    }];
}

- (void)pushNewValueToDatabase
{
    // Property to be editted
        // NSString *newKey = @"space";
    NSString *logEntry = @"";
    
    // Extract text value from field and change local dictionary in order to be updated
    self.dictToPush[@"space"] = [NSString stringWithFormat:@"%i",(int)self.stepper.value];
    NSDictionary *childUpdates = @{[@"/Organizations/" stringByAppendingString:self.uid]: self.dictToPush};
    [self.ref updateChildValues:childUpdates];
    NSString *spaceEntry = [@"Space: " stringByAppendingString:[NSString stringWithFormat:@"%i",(int)self.stepper.value]];
    logEntry = [logEntry stringByAppendingString:spaceEntry];
    
    //Add to log/history
    NSDate *now = [[NSDate alloc] init];
    NSDateFormatter *formatTime = [[NSDateFormatter alloc]init];
    [formatTime setDateFormat:@"MM|dd|yy hh:mm:ss a"];
    NSString *loggedTime = [formatTime stringFromDate:now];
    NSString *logLocation = [@"/Data/" stringByAppendingString:self.uid];
    NSDictionary *logUpdate = @{[logLocation stringByAppendingString:loggedTime]: logEntry};
    [[[[_ref child:@"Data"] child:self.uid] child:loggedTime] setValue:logEntry];
}

- (IBAction)submitButtonPressed:(UIButton *)sender {
    
    self.valueToPush = [NSString stringWithFormat:@"%i",(int)self.stepper.value];
    [self pushNewValueToDatabase];
    
    // Add update to history log with date and time of submission
    NSDate *now = [[NSDate alloc] init];
    NSDateFormatter *formatTime = [[NSDateFormatter alloc]init];
    [formatTime setDateFormat:@"MM/dd/yy hh:mm:ss a"];
    NSString *loggedTime = [formatTime stringFromDate:now];
    NSLog(loggedTime);
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

#pragma mark - Inherited Methods

- (void)viewDidLoad {
    [self setupUser];
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
