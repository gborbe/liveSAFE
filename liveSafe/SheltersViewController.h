//
//  SheltersViewController.h
//  liveSafe
//
//  Created by Garrett Borbe on 3/10/18.
//  Copyright © 2018 Garrett Borbe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SheltersViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSDictionary *shelterDictionary;

@end
