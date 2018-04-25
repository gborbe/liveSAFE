//
//  TableViewController.m
//  liveSafe
//
//  Created by liveSafe on 4/9/18.
//  Copyright © 2018 liveSafe. All rights reserved.
//

#import "TableViewController.h"
#import "Organization.h"
#import "OrgDetailsViewController.h"

@interface TableViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic) NSUInteger index;

@end

@implementation TableViewController


#pragma mark - Setup
- (void)setupLocationManager
{
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager requestWhenInUseAuthorization];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 10.0;
    
    [self.locationManager startUpdatingLocation];

}
- (void)setupMap
{
    
    // center map on user's current location and add pin
    self.mapView.showsUserLocation = YES;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(self.locationManager.location.coordinate, 50000, 50000);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion animated:YES];
    self.mapView.showsUserLocation = YES;
    
    for (Organization *org in self.orgLibrary) {
        
        NSString *address = org.address;
        
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        
        [geocoder geocodeAddressString:address
                     completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                         
                         if (error) {
                             NSLog(@"ERROR! - %@", error.localizedDescription);
                         }
                         
                         if (placemarks[0]) {
                             
                             CLPlacemark *placemark = placemarks[0];
                             CLLocationCoordinate2D coordinate = placemark.location.coordinate;
                             MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
                             annotation.coordinate = coordinate;
                             annotation.title = org.name;
                             
                             [self.mapView addAnnotation:annotation];
                             
                             
                         }
                         
                     }];
        
        
    }
    
    
    
}
- (void)setup
{
    // make sure to add "<UITableViewDataSource>" to
    // CustomCellViewController.h for this to not
    // produce a warning
    self.tableView.dataSource = self;
    
    // make sure to add "<UITableViewDelegate>" to
    // CustomCellViewController.h for this to not
    // produce a warning
    self.tableView.delegate = self;
}
#pragma mark - location manager delegate methods
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    [self setupMap];
    for (CLLocation *location in locations) {
        NSLog(@"%@", location);
    }
}
#pragma mark - Table View Data Source and Delegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Our table only has one section...
    if (section == 0) {
        return self.orgLibrary.count;
    } else {
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // grab the location for this row
    Organization *selectedOrg = self.orgLibrary[indexPath.row];
    
    // get our custom cell
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"custom"];
    
    // components of the cell
    UILabel *OrgName = (UILabel *)[cell viewWithTag:1];
    UILabel *hours = (UILabel *)[cell viewWithTag:3];
    
    // populate the cell
    OrgName.text = selectedOrg.name;
    NSString *hour1 = selectedOrg.openHour;
    NSString *hour2 = [hour1 stringByAppendingString:@" - "];
    NSString *hourString = [hour2 stringByAppendingString:selectedOrg.closeHour];
    hours.text = hourString;
    [self locationOpen: selectedOrg.openHour: selectedOrg.closeHour];
    
    return cell;
}

    // Tap on table Row
- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    self.index = indexPath.row;
    [self performSegueWithIdentifier:@"orgSelectedSegue" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    OrgDetailsViewController *infoSegue = segue.destinationViewController;
    infoSegue.orgDetails = self.orgLibrary[self.index];
    infoSegue.orgLibrary = self.orgLibrary;
}

- (void)locationOpen: (NSString *)openTime: (NSString *)closeTime {
    //Get hours from Database in this format
    NSString *open = openTime;
    NSString *close = closeTime;
    
    //Get current time
    NSDate *nowDate = [[NSDate alloc] init];
    
    //Date Formatter
    NSDateFormatter *formatTime = [[NSDateFormatter alloc]init];
    [formatTime setDateFormat:@"hh:mm a"];
    
    //Open & Close NSString hours to NSDate
    NSDate *openDate = [formatTime dateFromString:open];
    NSDate *closeDate = [formatTime dateFromString:close];
    
    //Testing
    NSLog(@"Current Time: %@",[formatTime stringFromDate:nowDate]);
    NSLog(@"Open: %@",[formatTime stringFromDate:openDate]);
    NSLog(@"Close: %@",[formatTime stringFromDate:closeDate]);
    
    //Check to see if location is open
    int openMin = [self minutesSinceMidnight:openDate];
    int closeMin = [self minutesSinceMidnight:closeDate];
    int nowMin = [self minutesSinceMidnight:nowDate];
    
    if (nowMin < openMin && nowMin > closeMin) {
        NSLog(@"This location is open");
    } else if (nowMin > openMin && nowMin < closeMin) {
        NSLog(@"This location is open");
    } else {
        NSLog(@"This location is closed");
    }
    
}

-(int) minutesSinceMidnight:(NSDate *)date
{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned unitFlags =  NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *components = [gregorian components:unitFlags fromDate:date];
    
    return 60 * [components hour] + [components minute];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // we need to override the default cell height even thought we've set this
    // explicitly in interface builder (this may be a bug in apple's software)
    return 120;
}
#pragma mark - Inherited Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setup];
    [self setupLocationManager];
}


@end

