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
@import Firebase;
@import FirebaseAuthUI;
@import FirebaseGoogleAuthUI;

@interface OrgEditViewController ()
@property (weak, nonatomic) IBOutlet UILabel *welcomeTitle;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (weak, nonatomic) IBOutlet UITextField *hoursTextField;
@property (strong, nonatomic) NSMutableDictionary *dictToPush;
@property (strong, nonatomic) NSString *valueToPush;
@property (nonatomic) NSString *uid;

@end

@implementation OrgEditViewController


-(void)setup {
    self.ref = [[FIRDatabase database] reference];
    FIRAuth *auth = [FIRAuth auth];
    self.welcomeTitle.text = [NSString stringWithFormat:@"Welcome, %@", auth.currentUser.displayName];
    self.uid = auth.currentUser.uid;
    [self getDatabaseNodeToChange];
    
}

- (void)getDatabaseNodeToChange
{
    
    NSString *pathEndpoint = self.uid;
    
    FIRDatabaseReference *ref = [[_ref child:@"Organizations"] child:pathEndpoint];
    [ref observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *oldDict = snapshot.value;
        self.dictToPush = [[NSMutableDictionary alloc] initWithDictionary:oldDict];
        
    }];
    
    
}

- (void)pushNewValueToDatabase
{
    // Property to be editted
    NSString *newKey = @"space";
    
    // Extract text value from field and change local dictionary in order to be updated
    self.dictToPush[newKey] = self.hoursTextField.text;
    NSDictionary *childUpdates = @{[@"/Organizations/" stringByAppendingString:self.uid]: self.dictToPush};
    [self.ref updateChildValues:childUpdates];
}

- (IBAction)submitButtonPressed:(UIButton *)sender {
    
    self.valueToPush = self.hoursTextField.text;
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
    [self setup];
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
