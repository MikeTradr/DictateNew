//
//  NSDate+CALAddition.m
//  Calendar
//
//  Created by Anil Varghese on 09/01/14.
//  Copyright (c) 2014 Robosoft Technologies Pvt Ltd. All rights reserved.
//

#import "NSDate+CALAddition.h"

@implementation NSDate (CALAddition)



- (NSDate *)beginningOfDay
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:self];
    
    return [calendar dateFromComponents:components];
}

- (NSDate *)endOfDay
{

    return  [[self beginningOfDay] dateByAddingTimeInterval:60*60*24]; // 24 hours
}

-(NSDate *)firstDayOfWeek
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents* components = [calendar components:NSYearForWeekOfYearCalendarUnit |NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit fromDate:self];
    
    [components setWeekday:1]; // 1: sunday
    
    return [calendar dateFromComponents:components];
}

-(NSDate *)lastDayOfWeek
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents* components = [calendar components:NSYearForWeekOfYearCalendarUnit |NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit fromDate:self];
    [components setWeekday:7]; // 7: saturday
    return [calendar dateFromComponents:components];

}
-(NSDateComponents*)components
{
    NSCalendar *calendar = [NSCalendar currentCalendar];

     NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self];
    return components;
}
-(NSDate *)dateByRemovingTimeComponents
{
    // Zero out the time components
    NSDateComponents *comp = [[NSCalendar currentCalendar]components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self];
    
    //    date = [[[NSCalendar currentCalendar] dateFromComponents:comp]  dateByAddingTimeInterval:[[NSTimeZone localTimeZone]secondsFromGMT]];
    NSDate* date = [[NSCalendar currentCalendar] dateFromComponents:comp];
    
    return date;
}
-(NSDate *)dateByAddingNumberOfDays:(NSInteger)numberOfDays
{
    NSDateComponents *components = [[NSDateComponents alloc]init];
    [components setDay:numberOfDays];
    NSDate *finalDate = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:self options:0];
    
    return finalDate;
}
@end

