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

@property (strong, nonatomic) NSArray *orgsToShow;



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
    
    for (Organization *org in self.orgsToShow) {
        
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
- (void)updateMapAndTable
{
    NSLog(@"RestID: %@", self.restorationIdentifier);
    
    if ([self.restorationIdentifier isEqualToString:@"Shelters"]) {
        self.orgsToShow = self.shelterOrgs;
    } else if ([self.restorationIdentifier isEqualToString:@"Rests"]) {
        self.orgsToShow = self.restOrgs;
    } else if ([self.restorationIdentifier isEqualToString:@"Food"]) {
        self.orgsToShow = self.mealOrgs;
    }
    
    [self.tableView reloadData];
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
        return self.orgsToShow.count;
    } else {
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // grab the location for this row
    Organization *selectedOrg = self.orgsToShow[indexPath.row];
    
    // get our custom cell
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"custom"];
    
    // components of the cell
    UILabel *OrgName = (UILabel *)[cell viewWithTag:1];
    UILabel *hours = (UILabel *)[cell viewWithTag:3];
    UILabel *openNowLabel = (UILabel *)[cell viewWithTag:5];
    UILabel *infoLabel = (UILabel *)[cell viewWithTag:9];
    
    // populate the cell
    OrgName.text = selectedOrg.name;
    NSString *hour1 = selectedOrg.openHour;
    NSString *hour2 = [hour1 stringByAppendingString:@" - "];
    NSString *hourString = [hour2 stringByAppendingString:selectedOrg.closeHour];
    hours.text = hourString;
    
    if ([self.restorationIdentifier isEqualToString:@"Shelters"]) {
        NSString *spaceInit = @"Space: ";
        NSString *spaceStart = [spaceInit stringByAppendingString:selectedOrg.space];
        NSString *slash = @"/";
        NSString *spaceEnd = [slash stringByAppendingString:selectedOrg.maxSpace];
        infoLabel.text = [spaceStart stringByAppendingString:spaceEnd];
    } else if ([self.restorationIdentifier isEqualToString:@"Rests"]) {
        infoLabel.text = @"";
    } else if ([self.restorationIdentifier isEqualToString:@"Food"]) {
        infoLabel.text = @"";
    }
    
    if (selectedOrg.openNow) {
        openNowLabel.text = @"Open";
        openNowLabel.textColor = [UIColor colorWithRed:0.0 green:175.0/255.0 blue:0.0 alpha:1.0];
    } else {
        openNowLabel.text = @"Closed";
        openNowLabel.textColor = [UIColor colorWithRed:200.0/255.0 green:0 blue:0 alpha:1];
    }
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
    infoSegue.orgDetails = self.orgsToShow[self.index];
    infoSegue.orgLibrary = self.orgsToShow;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // we need to override the default cell height even thought we've set this
    // explicitly in interface builder (this may be a bug in apple's software)
    return 120;
}
#pragma mark - Inherited Methods
- (void)viewDidLoad {
    [self setup];
    [self setupLocationManager];
    [self setupLogo];
    [super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"view with restorationID %@ will appear", self.restorationIdentifier);
    [self updateMapAndTable];
    [self setupLogo];
}

- (void) setupLogo {
    UIImage *navImage = [UIImage imageNamed:@"navLogo.png"];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [imgView setImage:navImage];
    [imgView setContentMode:UIViewContentModeScaleAspectFit];
    self.navigationItem.titleView = imgView;
}
@end

