//
//  RSEventManager.h
//  Calendar
//
//  Created by Anil Varghese on 31/12/13.
//  Copyright (c) 2013 Robosoft Technologies Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

@interface CALEventManager : NSObject

@property (nonatomic,strong)NSDate *selectedDate;
@property (nonatomic, strong) NSString *selectedCalendarIdentifier;
@property (nonatomic, strong) NSString *selectedEventIdentifier;
@property (nonatomic,strong)EKEventStore *eventStore;

+(instancetype)sharedEventManager;
-(NSArray *)eventsForTheDate:(NSDate *)date;
-(NSArray *)eventsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;

-(NSArray *)getLocalEventCalendars;

-(void)saveCustomCalendarIdentifier:(NSString *)identifier;

-(BOOL)checkIfCalendarIsCustomWithIdentifier:(NSString *)identifier;

-(void)removeCalendarIdentifier:(NSString *)identifier;

-(NSString *)getStringFromDate:(NSDate *)date;

-(NSArray *)getEventsOfSelectedCalendar;

-(void)deleteEventWithIdentifier:(NSString *)identifier;
@end
