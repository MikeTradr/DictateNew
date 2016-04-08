//
//  GlanceController.swift
//  Dictate WatchKit Extension
//
//  Created by Mike Derr on 7/29/15.
//  Copyright (c) 2015 ThatSoft.com. All rights reserved.
//

import WatchKit
import Foundation

class GlanceController: WKInterfaceController {
    
    let defaults = NSUserDefaults(suiteName: "group.com.thatsoft.dictateApp")!
    
    var showCalendarsView:Bool = true
    var checked:Bool = false
    var eventID:String = ""
    var today:NSDate          = NSDate()
    var todayPlusSeven:NSDate = NSDate()
    var allEvents: Array<EKEvent> = []
    
    @IBOutlet var labelDate: WKInterfaceLabel!
    @IBOutlet var labelNow: WKInterfaceLabel!
    @IBOutlet var labelinTime: WKInterfaceLabel!
    @IBOutlet var table: WKInterfaceTable!
    
    //---- funcs below here -----------------------------------------------------------
    
    
    func fetchEvents(){
        
        let dateHelper = JTDateHelper()
        let startDate =  NSDate()
        let endDate = dateHelper.addToDate(startDate, days: 1)
        
        print("w46 startDate: \(startDate)")
        print("w46 endDate: \(endDate)")
        
        EventManager.sharedInstance.fetchEventsFrom(startDate, endDate: endDate, completion: { (events) -> Void in
            self.allEvents = events
        })
        
        print("w56 self.allEvents: \(self.allEvents)")
        
        
        
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        
        NSLog("%@ w41 TodayIC awakeWithContext", self)
        
        print("w43 Today awakeWithContext")
  
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "E, MMM d"
        
        let dateString = dateFormatter.stringFromDate(today)   //set to today date for now
        self.labelDate.setText(dateString)
        self.labelDate.setTextColor(UIColor.yellowColor())
 /*
        dateFormatter.dateFormat = "h:m a"
        let now = dateFormatter.stringFromDate(today)   //set to today date for now
        self.labelNow.setText(now)
        
        let watchBlue = UIColor(red: 102, green: 178, blue: 255, alpha: 1)

        self.labelNow.setTextColor(watchBlue)

  */
        
        
        
        
        
        //  var sceneTitle:String = (context as? String)!
        //  self.setTitle("«\(sceneTitle)")
        self.setTitle("Events")
        
        //get Access to Reminders
        NSLog("%@ w60 appDelegate", self)
        print("w61 call getAccessToEventStoreForType")
        ReminderManager.sharedInstance.getAccessToEventStoreForType(EKEntityType.Reminder, completion: { (granted) -> Void in
            
            if granted{
                print("w65 Reminders granted: \(granted)")
            }
        })
        
        //get Access to Events
        NSLog("%@ w70 appDelegate", self)
        print("w71 call getAccessToEventStoreForType")
        EventManager.sharedInstance.getAccessToEventStoreForType(EKEntityType.Event, completion: { (granted) -> Void in
            
            if granted{
                print("w75 Events granted: \(granted)")
            }
        })
        
        print("w65 context: \(context)")
        // showListsView = true
        self.setTitle("Events")
        
        fetchEvents()
        
        self.loadTableData()
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        NSLog("%@ w78 TodayIC will activate", self)
        print("w79 TodayIC willActivate")
        
        //  ReminderManager.sharedInstance.createNewReminderList("To Code Tomorrow", items: ["item 1","item 2", "This is item 3 hehe"])   //added to make reminder for testing.
        
        print("w83 in ShowIC willActivate")
        
        //self.reminderItemsGroup.setHidden(false)  //Hide lower table2
        
        if showCalendarsView {
            //  self.loadTableData()
            print("w155 showListsView True")
        } else {
            //   self.loadTableData2()
            print("w165 showListsView False")
        }
        
        loadTableData()
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let now = dateFormatter.stringFromDate(today)   //set to today date for now
        self.labelNow.setText(now)
        
        let watchBlue = UIColor(red: 102, green: 178, blue: 255, alpha: 1)
        
        self.labelNow.setTextColor(watchBlue)
        
    }
    
    func loadTableData () {
        
        print("w117 allEvents.count: \(allEvents.count)")
        table.setNumberOfRows(allEvents.count, withRowType: "tableRow")
        //table.setNumberOfRows(1, withRowType: "tableRow")

        print("w46 allEvents.count: \(allEvents.count)")
        
        for (index, title) in allEvents.enumerate() {
            
            print("---------------------------------------------------")
            print("w40 index, title: \(index), \(title)")
            
            let row = table.rowControllerAtIndex(index) as! GlanceTodayEventsTableRC
            let item = allEvents[index]
            
            let dateFormatter = NSDateFormatter()
            
            dateFormatter.dateFormat = "h:mm a"
            
            let startTimeA = dateFormatter.stringFromDate(item.startDate)
            var startTime = startTimeA.stringByReplacingOccurrencesOfString(":00", withString: "")
            NSLog("%@ w137", startTime)
            
            let endTimeA = dateFormatter.stringFromDate(item.endDate)
            let endTime = endTimeA.stringByReplacingOccurrencesOfString(":00", withString: "")
            
            var endTimeDash = "- \(endTime)"
            
            if item.allDay {     // if allDay bool is true
                startTime = ""
                endTimeDash = "All Day"
                
            }
            
            //TODO Mike TODO Anil All day event spanning multiple days does not show up on multiple days
            
            let timeUntil = TimeManger.sharedInstance.timeInterval(item.startDate)
            print("w185 timeUntil: \(timeUntil)")
            
            if index == 0 {
                let timeUntil = TimeManger.sharedInstance.timeInterval(item.startDate)
                print("w186 timeUntil: \(timeUntil)")
                labelinTime.setText(timeUntil)
                if timeUntil == "" {    //none today so hide
                    labelinTime.setHidden(true)
                } else {
                    labelinTime.setHidden(false)
                }
            }
            
            
            row.labelEventTitle.setText(item.title)
            row.labelEventLocation.setText(item.location)
            row.labelStartTime.setText(startTime)
            row.labelEndTime.setText(endTimeDash)
            
            //row.labelEventTitle.setTextColor(UIColor(CGColor: item.calendar.CGColor))
            // row.labelStartTime.setTextColor(UIColor(CGColor: item.calendar.CGColor))
            // row.labelEndTime.setTextColor(UIColor(CGColor: item.calendar.CGColor))
            
            
            row.labelStartTime.setTextColor(UIColor.whiteColor().colorWithAlphaComponent(0.8))
            row.labelEndTime.setTextColor(UIColor.whiteColor().colorWithAlphaComponent(0.65))
            
            row.labelEventLocation.setTextColor(UIColor(CGColor: item.calendar.CGColor))
            
            row.verticalBar.setBackgroundColor(UIColor(CGColor: item.calendar.CGColor))
            
            row.imageVertBar.setTintColor(UIColor(CGColor: item.calendar.CGColor))
            
            // row.imageVertBar.image = [row.imageVertBar imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
            
            
            
            row.groupEvent.setBackgroundColor(UIColor(CGColor: item.calendar.CGColor).colorWithAlphaComponent(0.375))
            
            
            
            
            
            
        }
    }   //end loadTableData
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
}