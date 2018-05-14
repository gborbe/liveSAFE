//
//  TabBarViewController.h
//  liveSafe
//
//  Created by Garrett Borbe on 5/2/18.
//  Copyright © 2018 Garrett Borbe. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Firebase;
@import FirebaseAuthUI;
@import FirebaseGoogleAuthUI;


@interface TabBarViewController : UITabBarController <FUIAuthDelegate>

@property (nonatomic) int selectedChildViewController;

@end
