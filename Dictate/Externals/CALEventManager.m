//
//  RSEventManager.m
//  Calendar
//
//  Created by Anil Varghese on 31/12/13.
//  Copyright (c) 2013 Robosoft Technologies Pvt Ltd. All rights reserved.
//

#import "CALEventManager.h"
#import "NSDate+CALAddition.h"

@interface CALEventManager()
@property (nonatomic, strong) NSMutableArray *arrCustomCalendarIdentifiers;

@end

@implementation CALEventManager

-(id)init
{
    if (self = [super init])
    {
        _eventStore = [[EKEventStore alloc] init];
    }
    return self;
}

+(instancetype)sharedEventManager
{
    static CALEventManager *sharedManger = nil;
 
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        sharedManger = [[CALEventManager alloc]init];
        
    });
    return sharedManger;
}

-(BOOL)getAccessPermissionToEventStore
{
    // From iOS6+ need user permission
    __block BOOL accessGranted;
    
    if ([EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent] == EKAuthorizationStatusAuthorized)
    {
        accessGranted = YES;
    }
    else
    {
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        [_eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error)
        {
            accessGranted = granted;
            dispatch_semaphore_signal(semaphore);
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    }
    return accessGranted;
}
-(NSArray *)eventsForTheDate:(NSDate *)date
{
    NSArray *events = nil;
    
    NSDate *startDate = [date beginningOfDay];
    NSDate *endDate = [startDate dateByAddingTimeInterval:60*60*24]; // 24 hours

    if ([self getAccessPermissionToEventStore])
    {
        NSPredicate *predicate = [_eventStore predicateForEventsWithStartDate:startDate endDate:endDate calendars:nil];
        events = [_eventStore eventsMatchingPredicate:predicate];
    }
    return events;
}
-(NSArray *)eventsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate{
   
    NSArray *events = nil;
    
    NSDate *startDate = [fromDate beginningOfDay];
    NSDate *endDate = [toDate endOfDay];
    
    if ([self getAccessPermissionToEventStore])
    {
        NSPredicate *predicate = [_eventStore predicateForEventsWithStartDate:startDate endDate:endDate calendars:nil];
        events = [_eventStore eventsMatchingPredicate:predicate];
    }
    return events;
}

#pragma mark - Private method implementation

-(NSArray *)getLocalEventCalendars{
    NSArray *allCalendars = [self.eventStore calendarsForEntityType:EKEntityTypeEvent];
    NSMutableArray *localCalendars = [[NSMutableArray alloc] init];
    
    for (int i=0; i<allCalendars.count; i++) {
        EKCalendar *currentCalendar = [allCalendars objectAtIndex:i];
        if (currentCalendar.type == EKCalendarTypeLocal) {
            [localCalendars addObject:currentCalendar];
        }
    }
    
    return (NSArray *)localCalendars;
}


-(void)saveCustomCalendarIdentifier:(NSString *)identifier{
    [self.arrCustomCalendarIdentifiers addObject:identifier];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.arrCustomCalendarIdentifiers forKey:@"eventkit_cal_identifiers"];
}


-(BOOL)checkIfCalendarIsCustomWithIdentifier:(NSString *)identifier{
    BOOL isCustomCalendar = NO;
    
    for (int i=0; i<self.arrCustomCalendarIdentifiers.count; i++) {
        if ([[self.arrCustomCalendarIdentifiers objectAtIndex:i] isEqualToString:identifier]) {
            isCustomCalendar = YES;
            break;
        }
    }
    
    return isCustomCalendar;
}


-(void)removeCalendarIdentifier:(NSString *)identifier{
    [self.arrCustomCalendarIdentifiers removeObject:identifier];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.arrCustomCalendarIdentifiers forKey:@"eventkit_cal_identifiers"];
}


-(NSString *)getStringFromDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [NSLocale currentLocale];
    [dateFormatter setDateFormat:@"d MMM yyyy, HH:mm"];
    NSString *stringFromDate = [dateFormatter stringFromDate:date];
    return stringFromDate;
}


-(NSArray *)getEventsOfSelectedCalendar{
    // Specify the calendar that will be used to get the events from.
    EKCalendar *calendar = nil;
    if (self.selectedCalendarIdentifier != nil && self.selectedCalendarIdentifier.length > 0) {
        calendar = [self.eventStore calendarWithIdentifier:self.selectedCalendarIdentifier];
    }
    
    // If no selected calendar identifier exists and the calendar variable has the nil value, then all calendars will be used for retrieving events.
    NSArray *calendarsArray = nil;
    if (calendar != nil) {
        calendarsArray = @[calendar];
    }
    
    // Create a predicate value with start date a year before and end date a year after the current date.
    int yearSeconds = 365 * (60 * 60 * 24);
    NSPredicate *predicate = [self.eventStore predicateForEventsWithStartDate:[NSDate dateWithTimeIntervalSinceNow:-yearSeconds] endDate:[NSDate dateWithTimeIntervalSinceNow:yearSeconds] calendars:calendarsArray];
    
    // Get an array with all events.
    NSArray *eventsArray = [self.eventStore eventsMatchingPredicate:predicate];
    
    // Copy all objects one by one to a new mutable array, and make sure that the same event is not added twice.
    NSMutableArray *uniqueEventsArray = [[NSMutableArray alloc] init];
    for (int i=0; i<eventsArray.count; i++) {
        EKEvent *currentEvent = [eventsArray objectAtIndex:i];
        
        BOOL eventExists = NO;
        
        // Check if the current event has any recurring rules set. If not, no need to run the next loop.
        if (currentEvent.recurrenceRules != nil && currentEvent.recurrenceRules.count > 0) {
            for (int j=0; j<uniqueEventsArray.count; j++) {
                if ([[[uniqueEventsArray objectAtIndex:j] eventIdentifier] isEqualToString:currentEvent.eventIdentifier]) {
                    // The event already exists in the array.
                    eventExists = YES;
                    break;
                }
            }
        }
        
        // If the event does not exist to the new array, then add it now.
        if (!eventExists) {
            [uniqueEventsArray addObject:currentEvent];
        }
    }
    
    // Sort the array based on the start date.
    uniqueEventsArray = (NSMutableArray *)[uniqueEventsArray sortedArrayUsingSelector:@selector(compareStartDateWithEvent:)];
    
    // Return that array.
    return (NSArray *)uniqueEventsArray;
}


-(void)deleteEventWithIdentifier:(NSString *)identifier{
    // Get the event that's about to be deleted.
    EKEvent *event = [self.eventStore eventWithIdentifier:identifier];
    
    // Delete it.
    NSError *error;
    if (![self.eventStore removeEvent:event span:EKSpanFutureEvents error:&error]) {
        // Display the error description.
        NSLog(@"%@", [error localizedDescription]);
    }
}

@end
