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
        
        EventManager.sharedInstance.fetchEventsFrom(startDate, endDate: endDate, completion: { (events) -> Void in
            self.allEvents = events
        })
        
    }
    
    
    @IBAction func menuDictate() {
        println("w16 force touch tapped, Dictate Item")
        

        var rawString:String = ""
        //TODO Anil need to call that func! lol thx Bro
      // let (startDT, endDT, output, outputNote, day, calendarName, actionType) = MainIC.grabvoice()
  
    }
    
    

    
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
        
        for (index, title) in enumerate(allEvents) {
            println("---------------------------------------------------")
            println("w40 index, title: \(index), \(title)")
            
            let row = table.rowControllerAtIndex(index) as! TodayEventsTableRC
            let item = allEvents[index]
            
            row.labelEventTitle.setText(item.title)
            row.labelEventTime.setText(item.title)  //get start-end times
            row.labelEventTitle.setTextColor(UIColor(CGColor: item.calendar.CGColor))
            row.verticalBar.setBackgroundColor(UIColor(CGColor: item.calendar.CGColor))
        }
    }   //end loadTableData
    
    

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        NSLog("%@ w78 TodayIC will activate", self)
        println("w79 TodayIC willActivate")
        
        //  ReminderManager.sharedInstance.createNewReminderList("To Code Tomorrow", items: ["item 1","item 2", "This is item 3 hehe"])   //added to make reminder for testing.
        
        println("w83 in ReminderIC willActivate")
        
        //self.reminderItemsGroup.setHidden(false)  //Hide lower table2
        
        if showCalendarsView {
          //  self.loadTableData()
            println("w165 showListsView True")
        } else {
         //   self.loadTableData2()
            println("w165 showListsView False")
        }
        
        
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
