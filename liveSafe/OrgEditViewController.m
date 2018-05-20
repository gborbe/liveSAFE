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
@property (weak, nonatomic) IBOutlet UIStepper *stepper;
@property (weak, nonatomic) IBOutlet UILabel *spacesLabel;
@property (weak, nonatomic) IBOutlet UILabel *spaceLimitLabel;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) NSMutableDictionary *dictToPush;
@property (strong, nonatomic) NSString *valueToPush;
@property (nonatomic) NSString *uid;
@property (nonatomic) Organization *userOrg;
@property (weak, nonatomic) IBOutlet UILabel *orgTitle;
@property (weak, nonatomic) IBOutlet UILabel *lastUpdateDate;
@property (weak, nonatomic) IBOutlet UILabel *lastUpdateSpace;
@property (weak, nonatomic) IBOutlet UILabel *lastUpdateTitle;
@property (weak, nonatomic) IBOutlet UISwitch *shelterBool;
@property (weak, nonatomic) IBOutlet UISwitch *mealBool;
@property (weak, nonatomic) IBOutlet UISwitch *restBool;

@property (weak, nonatomic) IBOutlet UITextField *orgTitleEditField;
@property (weak, nonatomic) IBOutlet UITextField *orgAddressEditField;
@property (weak, nonatomic) IBOutlet UITextField *orgPhoneEditField;
@property (weak, nonatomic) IBOutlet UITextField *orgWebEditField;
@property (weak, nonatomic) IBOutlet UITextField *orgMaxSpaceEditField;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@end

@implementation OrgEditViewController

- (IBAction)stepChanged:(UIStepper *)sender
{
    self.spacesLabel.text = [NSString stringWithFormat:@"%i", (int)self.stepper.value];
}

- (IBAction)resetStepper:(UIButton *)sender {
    self.stepper.value = 0.0;
    [self stepChanged:self.stepper];
}

- (IBAction)maxButtonPushed:(UIButton *)sender {
    self.stepper.value = [self.userOrg.maxSpace doubleValue];
    [self stepChanged:self.stepper];
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
    [self.stepper setIncrementImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateNormal];
    [self.stepper setDecrementImage:[UIImage imageNamed:@"minus.png"] forState:UIControlStateNormal];
    [self.stepper setBackgroundImage:[UIImage imageNamed:@"stepBkg.png"] forState:UIControlStateNormal];
//    [self.stepper setBackgroundImage:[UIImage imageNamed:@"stepHi.png"] forState:UIControlStateHighlighted];
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
        self.userOrg.maxSpace = [collection objectForKey:@"maxSpace"];
        self.userOrg.lastUpdate = [collection objectForKey:@"lastUpdate"];
        
        NSString *shelterCheck = [collection objectForKey:@"hasShelter"];
        NSString *restCheck = [collection objectForKey:@"hasRest"];
        NSString *mealCheck = [collection objectForKey:@"hasMeals"];
        
        self.userOrg.shelter = [shelterCheck boolValue];
        self.userOrg.restStop = [restCheck boolValue];
        self.userOrg.meals = [mealCheck boolValue];
        
        self.spacesLabel.text = self.userOrg.space;
        self.orgTitle.text = self.userOrg.name;
        self.stepper.value = [self.userOrg.space doubleValue];
        NSString *maxString = @"Space Limit: ";
        self.spaceLimitLabel.text = [maxString stringByAppendingString:self.userOrg.maxSpace];
        self.lastUpdateDate.text = self.userOrg.lastUpdate;
        NSString *spaceString = @"Space: ";
        self.lastUpdateSpace.text = [spaceString stringByAppendingString:self.userOrg.space];
        self.shelterBool.on = self.userOrg.shelter;
        self.mealBool.on = self.userOrg.meals;
        self.restBool.on = self.userOrg.restStop;
        
        self.orgTitleEditField.placeholder = self.userOrg.name;
        self.orgAddressEditField.placeholder = self.userOrg.address;
        self.orgPhoneEditField.placeholder = self.userOrg.phone;
        self.orgWebEditField.placeholder = self.userOrg.website;
        self.orgMaxSpaceEditField.placeholder = self.userOrg.maxSpace;
//        self.orgReqEditField.text = self.userOrg.requirements;
    }];
    
}

- (void)pushNewValueToDatabase
{
    // Initiate entries and get current time
    NSString *logEntry = @"";
    NSDate *now = [[NSDate alloc] init];
    NSDateFormatter *formatTime = [[NSDateFormatter alloc]init];
    [formatTime setDateFormat:@"MM|dd|yyyy hh:mm:ss a"];
    NSString *loggedTime = [formatTime stringFromDate:now];
    
    // Extract text value from field and change local dictionary in order to be updated
    self.dictToPush[@"space"] = [NSString stringWithFormat:@"%i",(int)self.stepper.value];
    if (self.orgTitleEditField != nil) {
        self.dictToPush[@"name"] = self.orgTitleEditField.text;
    }
    if (self.orgAddressEditField.text != nil) {
        self.dictToPush[@"address"] = self.orgAddressEditField.text;
    }
    if (self.orgPhoneEditField.text != nil) {
        self.dictToPush[@"phone"] = self.orgPhoneEditField.text;
    }
    if (self.orgWebEditField.text != nil) {
        self.dictToPush[@"website"] = self.orgWebEditField.text;
    }
    if (self.orgMaxSpaceEditField.text != nil) {
        self.dictToPush[@"maxSpace"] = self.orgMaxSpaceEditField.text;
    }
    self.dictToPush[@"lastUpdate"] = loggedTime;
    
    NSDictionary *childUpdates = @{[@"/Organizations/" stringByAppendingString:self.uid]: self.dictToPush};
    [self.ref updateChildValues:childUpdates];
    NSString *spaceEntry = [@"Space: " stringByAppendingString:[NSString stringWithFormat:@"%i",(int)self.stepper.value]];
    logEntry = [logEntry stringByAppendingString:spaceEntry];
    
    //Add to log/history in database
    NSString *logLocation = [@"/Data/" stringByAppendingString:self.uid];
    NSDictionary *logUpdate = @{[logLocation stringByAppendingString:loggedTime]: logEntry};
    [[[[_ref child:@"Data"] child:self.uid] child:loggedTime] setValue:self.dictToPush];
    
    self.lastUpdateDate.text = loggedTime;
    self.lastUpdateSpace.text = spaceEntry;
    
    
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

//- (IBAction)logoutButton:(id)sender {
//    NSError *signOutError;
//    BOOL status = [[FIRAuth auth] signOut:&signOutError];
//    if (!status) {
//        NSLog(@"Error signing out: %@", signOutError);
//        return;
//    }else{
//        NSLog(@"Successfully Signout");
//    }
//}

#pragma mark - Inherited Methods

- (void)viewWillAppear:(BOOL)animated {
    [self setupUser];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.scrollView.contentSize = CGSizeMake(414, 1287);
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
