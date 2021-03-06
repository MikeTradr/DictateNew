//
//  EditEventDetailsIC.swift
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


class EditEventDetailsIC: WKInterfaceController {
    
    let defaults = NSUserDefaults(suiteName: "group.com.thatsoft.dictateApp")!
    
    var showCalendarsView:Bool = true
    var checked:Bool = false
    
    var today:NSDate            = NSDate()
   // var startDT:NSDate          = NSDate(dateString:"2014-12-12")
//var endDT:NSDate            = NSDate(dateString:"2014-12-12")
    var todayPlusSeven:NSDate = NSDate()
    

    
    @IBOutlet weak var labelDate: WKInterfaceLabel!
    
    @IBOutlet weak var table: WKInterfaceTable!
    
   var allEvents: Array<EKEvent> = []
    
    
//---- funcs below here -----------------------------------------------------------
    
    
    func fetchEvents(){
        
        let dateHelper = JTDateHelper()
        let startDate =  NSDate()
        let endDate = dateHelper.addToDate(startDate, days: 7)
        
        println("w46 startDate: \(startDate)")
        println("w46 endDate: \(endDate)")


        
        
        EventManager.sharedInstance.fetchEventsFrom(startDate, endDate: endDate, completion: { (events) -> Void in
            self.allEvents = events
        })
        
        println("w56 self.allEvents: \(self.allEvents)")

        
    }
    
    
//---- Menu functions -------------------------------------------
    @IBAction func menuDictate() {
        let (startDT, endDT, output, outputNote, day, calendarName, actionType) = DictateManagerIC.sharedInstance.grabVoice()
    }
    
    @IBAction func menuSettings() {
        presentControllerWithName("Settings", context: "«Details")
    }
//---- end Menu functions ----------------------------------------
    
    
    
    

    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        // Configure interface objects here.
        
        NSLog("%@ w41 TodayIC awakeWithContext", self)
        
        println("w43 Today awakeWithContext")
        
        self.setTitle(context as? String)
        
        //get Access to Reminders
        NSLog("%@ w60 appDelegate", self)
        println("w61 call getAccessToEventStoreForType")
        ReminderManager.sharedInstance.getAccessToEventStoreForType(EKEntityTypeReminder, completion: { (granted) -> Void in
            
            if granted{
                println("w65 Reminders granted: \(granted)")
            }
        })
        
        //get Access to Events
        NSLog("%@ w70 appDelegate", self)
        println("w71 call getAccessToEventStoreForType")
        EventManager.sharedInstance.getAccessToEventStoreForType(EKEntityTypeEvent, completion: { (granted) -> Void in
            
            if granted{
                println("w75 Events granted: \(granted)")
            }
        })
        
        println("w65 context: \(context)")
       // showListsView = true
        self.setTitle("Events")
        
        fetchEvents()
        
        self.loadTableData()
    }
    
    func loadTableData () {
        table.setNumberOfRows(allEvents.count, withRowType: "tableRow")
        println("w46 allEvents.count: \(allEvents.count)")
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "E, MMM d"
        
        let dateString = dateFormatter.stringFromDate(NSDate())
   
        self.labelDate.setText(dateString)
        
        for (index, title) in enumerate(allEvents) {
            println("---------------------------------------------------")
            println("w40 index, title: \(index), \(title)")
            
            let row = table.rowControllerAtIndex(index) as! TodayEventsTableRC
            let item = allEvents[index]
            
            var dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "h:mm a"
            let startTime = dateFormatter.stringFromDate(item.startDate)
            let endTime = dateFormatter.stringFromDate(item.endDate)

            let endTimeDash = "- \(endTime)"
            
            row.labelEventTitle.setText(item.title)
            row.labelEventLocation.setText(item.location)
            row.labelStartTime.setText(startTime)
            row.labelEndTime.setText(endTimeDash)

            //row.labelEventTitle.setTextColor(UIColor(CGColor: item.calendar.CGColor))
            row.verticalBar.setBackgroundColor(UIColor(CGColor: item.calendar.CGColor))
        }
    }   //end loadTableData
    
    

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        NSLog("%@ w78 TodayIC will activate", self)
        println("w79 TodayIC willActivate")
        
        //  ReminderManager.sharedInstance.createNewReminderList("To Code Tomorrow", items: ["item 1","item 2", "This is item 3 hehe"])   //added to make reminder for testing.
        
        println("w83 in ShowIC willActivate")
        
        //self.reminderItemsGroup.setHidden(false)  //Hide lower table2
        
        if showCalendarsView {
          //  self.loadTableData()
            println("w155 showListsView True")
        } else {
         //   self.loadTableData2()
            println("w165 showListsView False")
        }
        
        loadTableData()
        
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
