//
//  CustomCellViewController.h
//  liveSafe
//
//  Created by eddie on 4/9/18.
//  Copyright © 2018 Garrett Borbe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCellViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) NSArray *orgLibrary;

@end
