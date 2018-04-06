//
//  Organizations.h
//  liveSafe
//
//  Created by Garrett Borbe on 4/6/18.
//  Copyright © 2018 Garrett Borbe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Organizations : UIViewController

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *address;
@property (nonatomic) NSString *phone;
@property (nonatomic) NSString *website;
@property (nonatomic) NSString *space;
@property (nonatomic) NSString *hours;
@property (nonatomic) NSString *services;
@property (nonatomic) NSString *requirements;
@property (nonatomic) NSString *imgURL;
@property (nonatomic) NSString *lastUpdate;
@property (nonatomic) NSInteger *minAge;
@property (nonatomic) NSInteger *maxAge;
@property (strong, nonatomic) NSDictionary *data;
@property (nonatomic) BOOL shelter;
@property (nonatomic) BOOL meals;
@property (nonatomic) BOOL restStop;

+ (instancetype)createOrg;
@end
