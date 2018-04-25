//
//  TableViewController.h
//  liveSafe
//
//  Created by liveSafe on 4/9/18.
//  Copyright © 2018 liveSafe. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreLocation;
@import MapKit;


@interface TableViewController : UIViewController
    <UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic) NSArray *orgLibrary;

@end
