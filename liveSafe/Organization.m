//
//  Organization.m
//  liveSafe
//
//  Created by liveSafe on 4/6/18.
//  Copyright © 2018 liveSafe. All rights reserved.
//

#import "Organization.h"

@interface Organization ()

@end

@implementation Organization

- (BOOL)openNow{
    //Get hours from Database in this format
    NSString *open = self.openHour;
    NSString *close = self.closeHour;
    
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
        return YES;
    } else if (nowMin > openMin && nowMin < closeMin) {
        return YES;
    } else {
        return NO;
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

#pragma mark - Inherited Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
