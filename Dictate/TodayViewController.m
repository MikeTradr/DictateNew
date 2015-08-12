//
//  TodayViewController
//  WatchInput
//
//  Created by Anil on 5/8/15.
//  Copyright (c) 2015 ThatSoft.com. All rights reserved.
//

#import "TodayViewController.h"
#import "CALEventManager.h"
#import "NSDate+CALAddition.h"
#import "Dictate-Swift.h"

@interface TodayViewController (){
    NSMutableDictionary *_eventsByDate;
    NSArray *_events;
    NSDate *_todayDate;
    NSDate *_startDate;
    NSDate *_endDate;
    NSDate *_dateSelected;
    NSDateFormatter *_dateFormatter;
}

@end

@implementation TodayViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(!self){
        return nil;
    }
    
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _dateFormatter = [NSDateFormatter new];
    _dateFormatter.dateFormat = @"cccc MMMM dd, yyyy";
    _calendarManager = [JTCalendarManager new];
    _calendarManager.delegate = self;
    self.tableView.tableFooterView = [UIView new];
    
    // Create a min and max date for limit the calendar, optional
    [self setStartDateAndEndDate];
        
    [_calendarManager setMenuView:_calendarMenuView];
    [_calendarManager setContentView:_calendarContentView];
    [_calendarManager setDate:_todayDate];
    [_calendarMenuView bringSubviewToFront:self.pushButton];
//    [self fetchEvents];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _todayDate = [NSDate date];
    [_calendarManager setDate:_todayDate];
    _dateSelected = _todayDate;
    _todayDateLabel.text = [_dateFormatter stringFromDate:_todayDate];
    [self fetchEvents];
    [_calendarManager reload];
}
-(void)fetchEvents{

    _events = [[CALEventManager sharedEventManager]eventsForTheDate:_dateSelected];
    [self.tableView reloadData];

}
#pragma mark - Buttons callback

- (IBAction)didGoTodayTouch
{
}

- (IBAction)didChangeModeTouch
{

    CGFloat newHeight = 300;
    if(!_calendarManager.settings.weekModeEnabled){
        newHeight = 85;
    }
    CGRect frame = self.calendarContentView.frame;
    frame.size.height = newHeight;
    
    _calendarManager.settings.weekModeEnabled = !_calendarManager.settings.weekModeEnabled;
    [_calendarManager reload];

    
    [UIView animateWithDuration:0.8 animations:^{
        [_calendarManager reload];

        self.calendarContentView.frame = frame;
        [self.calendarContentView layoutIfNeeded ];
        self.tableView.tableHeaderView = self.calendarContentView;
        [self.tableView layoutIfNeeded ];
        [self.view layoutIfNeeded];
        

    } completion:nil];
    
}

#pragma mark - CalendarManager delegate

// Used to customize the appearance of dayView
- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    // Today
    if([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [[UIColor alloc]initWithHexString:@"#FF2D55"];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
        dayView.textLabel.font = [UIFont systemFontOfSize:17];
    }
    // Selected date
    else if(_dateSelected && [_calendarManager.dateHelper date:_dateSelected isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [[UIColor alloc]initWithHexString:@"#1AD6FD"];//#55EFCB
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
        dayView.textLabel.font = [UIFont systemFontOfSize:17];
    }
    // Other month
    else if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [[UIColor alloc]initWithHexString:@"#FF5B37"];
        dayView.textLabel.textColor = [UIColor lightGrayColor];
        dayView.textLabel.font = [UIFont systemFontOfSize:17];
    }
    // Another day of the current month
    else{
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [[UIColor alloc]initWithHexString:@"#FF5B37"];
        dayView.textLabel.textColor = [UIColor whiteColor];
        dayView.textLabel.font = [UIFont systemFontOfSize:17];
    }
    
    if([self haveEventForDay:dayView.date]){
        dayView.dotView.hidden = NO;
    }
    else{
        dayView.dotView.hidden = YES;
    }
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    _dateSelected = dayView.date;
    self.todayDateLabel.text = [_dateFormatter stringFromDate:dayView.date];
    _events = [self eventsForTheDay:dayView.date];
    [self.tableView reloadData];
    
    // Animation for the circleView
    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    [UIView transitionWithView:dayView
                      duration:.3
                       options:0
                    animations:^{
                        dayView.circleView.transform = CGAffineTransformIdentity;
                        [_calendarManager reload];
                    } completion:nil];
    
    
    // Load the previous or next page if touch a day from another month
    
    if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        if([_calendarContentView.date compare:dayView.date] == NSOrderedAscending){
            [_calendarContentView loadNextPageWithAnimation];
        }
        else{
            [_calendarContentView loadPreviousPageWithAnimation];
        }
    }
}

#pragma mark - CalendarManager delegate - Page mangement

// Used to limit the date for the calendar, optional
- (BOOL)calendar:(JTCalendarManager *)calendar canDisplayPageWithDate:(NSDate *)date
{
    return [_calendarManager.dateHelper date:date isEqualOrAfter:_startDate andEqualOrBefore:_endDate];
}

- (void)calendarDidLoadNextPage:(JTCalendarManager *)calendar
{
    //    NSLog(@"Next page loaded");
}

- (void)calendarDidLoadPreviousPage:(JTCalendarManager *)calendar
{
    //    NSLog(@"Previous page loaded");
}

#pragma mark - Event Management

- (void)setStartDateAndEndDate
{
    _todayDate = [NSDate date];
    
    _startDate = [_calendarManager.dateHelper addToDate:_todayDate months:-6];
    
    _endDate = [_calendarManager.dateHelper addToDate:_todayDate months:6];
}

// Used only to have a key for _eventsByDate
- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"dd-MM-yyyy";
    }
    
    return dateFormatter;
}

-(NSArray *)eventsForTheDay:(NSDate *)date{
    return  [[CALEventManager sharedEventManager]eventsForTheDate:[date beginningOfDay]];
}
- (BOOL)haveEventForDay:(NSDate *)date
{
    
    if([[self eventsForTheDay:date] count] > 0){
        return YES;
    }
    
    return NO;
    
}


#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  _events.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    EKEvent *event = _events[indexPath.row];
    cell.eventTitleLabel.text = [event title];
    cell.calendarNameLabel.text = event.calendar.title;
    cell.verticalBarView.backgroundColor = [UIColor colorWithCGColor: event.calendar.CGColor];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"h:mm a";
    
    NSString * eventStartDTString = [dateFormatter stringFromDate:event.startDate];
    NSString * eventEndDTString = [dateFormatter stringFromDate:event.endDate];
    
    cell.eventTitleLabel.text = event.title;
    
    if (event.allDay != true){
        cell.startTimeLabel.text = eventStartDTString;
        cell.endTimeLabel.text = eventEndDTString;
    }else{
        cell.startTimeLabel.text = @"all-day";
        cell.endTimeLabel.text = @"";
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EKEvent *selectedEvent = _events[indexPath.row];
    EKEventEditViewController *controller = [[EKEventEditViewController alloc]init];
    controller.eventStore =[[CALEventManager  sharedEventManager]eventStore];
    controller.editViewDelegate = self;
    controller.event = selectedEvent;
    [self presentViewController:controller animated:YES completion:nil];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return  YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //delete the particular event
        EKEvent *eventToDelete = _events[indexPath.row];
        [[CALEventManager sharedEventManager]deleteEventWithIdentifier:eventToDelete.eventIdentifier];
        _events = [self eventsForTheDay:_todayDate];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

#pragma mark EKEventEditViewDelegate

// Overriding EKEventEditViewDelegate method to update event store according to user actions.
- (void)eventEditViewController:(EKEventEditViewController *)controller
          didCompleteWithAction:(EKEventEditViewAction)action {
    
    NSError *error = nil;
    EKEvent *thisEvent = controller.event;
    
    switch (action) {
        case EKEventEditViewActionCanceled:
            // Edit action canceled, do nothing.
            break;
            
        case EKEventEditViewActionSaved:
            [controller.eventStore saveEvent:controller.event span:EKSpanThisEvent error:&error];
            break;
            
        case EKEventEditViewActionDeleted:
            
            [controller.eventStore removeEvent:thisEvent span:EKSpanThisEvent error:&error];
            [self fetchEvents];
            break;
            
        default:
            break;
    }
    // Dismiss the modal view controller
    [controller dismissViewControllerAnimated:YES completion:nil];
    
}
@end
