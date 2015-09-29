//
//  TodayIC.swift
//  Dictate
//
//  Created by Mike Derr on 8/4/15.
//  Copyright (c) 2015 ThatSoft.com. All rights reserved.
//

import WatchKit
import Foundation
import EventKit
import Parse
import AVFoundation


class TodayIC: WKInterfaceController {
    
    let defaults = NSUserDefaults(suiteName: "group.com.thatsoft.dictateApp")!
    
    var showCalendarsView:Bool = true
    var checked:Bool = false
    var eventID:String = ""
    var today:NSDate          = NSDate()
    var todayPlusSeven:NSDate = NSDate()
    var allEvents: Array<EKEvent> = []
  
    @IBOutlet weak var labelDate: WKInterfaceLabel!
    @IBOutlet weak var table: WKInterfaceTable!
    
    
//---- funcs below here -----------------------------------------------------------
    
    
    func fetchEvents(){
        
        let dateHelper = JTDateHelper()
        let startDate =  NSDate()
        let endDate = dateHelper.addToDate(startDate, days: 10)
        
        print("w46 startDate: \(startDate)")
        print("w46 endDate: \(endDate)")
        
        EventManager.sharedInstance.fetchEventsFrom(startDate, endDate: endDate, completion: { (events) -> Void in
            self.allEvents = events
        })
        
        print("w56 self.allEvents: \(self.allEvents)")
        
    }
    
    
//---- Menu functions -------------------------------------------
    @IBAction func menuDictate() {
        let (startDT, endDT, output, outputNote, day, calendarName, actionType) = DictateManagerIC.sharedInstance.grabVoice()
    }
    
    @IBAction func menuSettings() {
        presentControllerWithName("Settings", context: "«Events")
    }
//---- end Menu functions ----------------------------------------
    

    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        // Configure interface objects here.
        
        NSLog("%@ w41 TodayIC awakeWithContext", self)
        
        print("w43 Today awakeWithContext")
        
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
        
    }
    
    func loadTableData () {
        table.setNumberOfRows(allEvents.count, withRowType: "tableRow")
        print("w46 allEvents.count: \(allEvents.count)")
        
        for (index, title) in allEvents.enumerate() {
        
            print("---------------------------------------------------")
            print("w40 index, title: \(index), \(title)")
            
            let row = table.rowControllerAtIndex(index) as! TodayEventsTableRC
            let item = allEvents[index]
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "E, MMM d"
            
            let dateString = dateFormatter.stringFromDate(item.startDate)
            self.labelDate.setText(dateString)
            
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
    
    
    override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject? {
        
        if segueIdentifier == "EventDetails" {
            let selectedEvent = allEvents[rowIndex]
            eventID = selectedEvent.eventIdentifier
            print("w113 eventID \(eventID)")
        }
        return eventID
    }


    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func buttonMainIC() {
        presentControllerWithName("Main", context: "Today")
    }

    @IBAction func buttonReminders() {
        presentControllerWithName("Reminders", context: "Today")
    }

}
