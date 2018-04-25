//
//  OrgDetailsViewController.h
//  liveSafe
//
//  Created by Garrett Borbe on 4/20/18.
//  Copyright © 2018 Garrett Borbe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Organization.h"

@interface OrgDetailsViewController : UIViewController

@property (nonatomic) Organization *orgDetails;
@property (nonatomic) NSArray *orgLibrary;

@end
