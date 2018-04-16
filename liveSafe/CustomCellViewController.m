//
//  CustomCellViewController.m
//  liveSafe
//
//  Created by eddie on 4/9/18.
//  Copyright © 2018 Garrett Borbe. All rights reserved.
//

#import "CustomCellViewController.h"
#import "Organizations.h"

@import CoreLocation;
@import MapKit;
@interface CustomCellViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;


@end

@implementation CustomCellViewController


#pragma mark - Setup
- (void)setupMap
{
    NSString *address; // GRAB FROM DATA OBJECT
    
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
                         annotation.title = @"GRAB TITLE FROM DATA OBJECT";
                         
                         [self.mapView addAnnotation:annotation];
                         self.mapView.centerCoordinate = coordinate;
                         
                     }
                     
                 }];
    
    
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
    // grab the drone for this row
    Organizations *selectedOrg = self.orgLibrary[indexPath.row];
    
    // get our custom cell
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"custom"];
    
    // we assigned each component of the custom cell we created
    // in interface builder a unique tab number - this is how
    // we get references to those components
    UILabel *OrgName = (UILabel *)[cell viewWithTag:1];
    UILabel *hours = (UILabel *)[cell viewWithTag:3];
    
    // populate the cell
    OrgName.text = selectedOrg.name;
    hours.text = @"%@ - %@",selectedOrg.openHour, selectedOrg.closeHour;
    [self locationOpen: selectedOrg.openHour: selectedOrg.closeHour];
    
    // return our cell
    return cell;
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
}


@end

