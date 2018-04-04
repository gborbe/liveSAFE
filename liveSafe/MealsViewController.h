//
//  MealsViewController.h
//  liveSafe
//
//  Created by eddie on 3/7/18.
//  Copyright © 2018 Garrett Borbe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MealsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSDictionary *mealsDictionary;

@end
