//
//  NSDate+CALAddition.h
//  Calendar
//
//  Created by Anil Varghese on 09/01/14.
//  Copyright (c) 2014 Robosoft Technologies Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (CALAddition)

//
- (NSDate *)beginningOfDay;
- (NSDate *)endOfDay;

// Find the first/last day of the week in which the date belongs
-(NSDate*)firstDayOfWeek;
-(NSDate*)lastDayOfWeek;

-(NSDateComponents*)components;
-(NSDate *)dateByRemovingTimeComponents;

-(NSDate *)dateByAddingNumberOfDays:(NSInteger)numberOfDays;

@end
