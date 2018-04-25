//
//  Organization.h
//  liveSafe
//
//  Created by liveSafe on 4/6/18.
//  Copyright © 2018 liveSafe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Organization : UIViewController

//Attributes of each object/organization in our array
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *address;
@property (nonatomic) NSString *phone;
@property (nonatomic) NSString *website;
@property (nonatomic) NSString *space;
@property (nonatomic) NSString *openHour;
@property (nonatomic) NSString *closeHour;
@property (nonatomic) NSMutableArray *services;
@property (nonatomic) NSString *servicesDescription;
@property (nonatomic) NSString *requirements;
@property (nonatomic) NSString *imgURL;
@property (nonatomic) NSString *lastUpdate;
@property (nonatomic) NSInteger *minAge;
@property (nonatomic) NSInteger *maxAge;
@property (nonatomic) BOOL shelter;
@property (nonatomic) BOOL meals;
@property (nonatomic) BOOL restStop;

- (BOOL)openNow;

@end
