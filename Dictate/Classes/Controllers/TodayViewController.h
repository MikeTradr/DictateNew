//
//  TodayViewController
//  WatchInput
//
//  Created by Anil on 5/8/15.
//  Copyright (c) 2015 ThatSoft.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKitUI/EventKitUI.h>
#import "JTCalendar.h"

@interface TodayViewController : UIViewController<JTCalendarDelegate,UITableViewDataSource,UITableViewDelegate,EKEventEditViewDelegate>

@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;
@property (weak, nonatomic) IBOutlet JTHorizontalCalendarView *calendarContentView;

@property (strong, nonatomic) JTCalendarManager *calendarManager;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *pushButton;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *todayDateLabel;

@end
