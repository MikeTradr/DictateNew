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
//import Parse
//import AVFoundation   //commented for new watchExtension 040516


class EditEventDetailsIC: WKInterfaceController {
    
    let defaults = UserDefaults(suiteName: "group.com.thatsoft.dictateApp")!
    
    var showCalendarsView:Bool = true
    var checked:Bool = false
    
    var today:Date            = Date()
   // var startDT:NSDate          = NSDate(dateString:"2014-12-12")
//var endDT:NSDate            = NSDate(dateString:"2014-12-12")
    var todayPlusSeven:Date = Date()
    

    
    @IBOutlet weak var labelDate: WKInterfaceLabel!
    
    @IBOutlet weak var table: WKInterfaceTable!
    
   var allEvents: Array<EKEvent> = []
    
    
//---- funcs below here -----------------------------------------------------------
    
    
    func fetchEvents(){
        
       // let dateHelper = JTDateHelper()
        //let dateHelper = JTDate
        let startDate =  Date()
        //let endDate = dateHelper.addToDate(startDate, days: 7)
        
        let calendar = Calendar.current
        let endDate: Date = (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.day, value: 7, to: startDate, options: [])!
        
        print("w46 startDate: \(startDate)")
        print("w46 endDate: \(endDate)")
        
        //FIXME:3
        EventManager.sharedInstance.fetchEventsFrom(startDate, endDate: endDate, completion: { (events) -> Void in
            self.allEvents = events
        })
        
        print("w56 self.allEvents: \(self.allEvents)")

        
    }
    
    
//---- Menu functions -------------------------------------------
    @IBAction func menuDictate() {
         let (startDT, endDT, output, outputNote, day, calendarName, actionType, duration, alert, eventLocation, eventRepeat) = DictateManagerIC.sharedInstance.grabVoice()
    }
    
    @IBAction func menuSettings() {
        presentController(withName: "Settings", context: "«Details")
    }
//---- end Menu functions ----------------------------------------
    
    
    
    

    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
        
        NSLog("%@ w41 TodayIC awakeWithContext", self)
        
        print("w43 Today awakeWithContext")
        
        self.setTitle(context as? String)
        
        //get Access to Reminders
        NSLog("%@ w60 appDelegate", self)
        print("w61 call getAccessToEventStoreForType")
        ReminderManager.sharedInstance.getAccessToEventStoreForType(EKEntityType.reminder, completion: { (granted) -> Void in
            
            if granted{
                print("w65 Reminders granted: \(granted)")
            }
        })
        
        //get Access to Events
        NSLog("%@ w70 appDelegate", self)
        print("w71 call getAccessToEventStoreForType")
        //FIXME:5
        EventManager.sharedInstance.getAccessToEventStoreForType(EKEntityType.event, completion: { (granted) -> Void in
            
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
    
    func loadTableData () {
        table.setNumberOfRows(allEvents.count, withRowType: "tableRow")
        print("w46 allEvents.count: \(allEvents.count)")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, MMM d"
        
        let dateString = dateFormatter.string(from: Date())
   
        self.labelDate.setText(dateString)
        
        for (index, title) in allEvents.enumerated() {
            print("---------------------------------------------------")
            print("w40 index, title: \(index), \(title)")
            
            let row = table.rowController(at: index) as! TodayEventsTableRC
            let item = allEvents[index]
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a"
            let startTime = dateFormatter.string(from: item.startDate)
            let endTime = dateFormatter.string(from: item.endDate)

            var endTimeDash = "- \(endTime)"
            
            if item.startDate == item.endDate {     //for same start & end time event
                endTimeDash = ""
            }
            
            row.labelEventTitle.setText(item.title)
            row.labelEventLocation.setText(item.location)
            row.labelStartTime.setText(startTime)
            row.labelEndTime.setText(endTimeDash)

            //row.labelEventTitle.setTextColor(UIColor(CGColor: item.calendar.CGColor))
            row.verticalBar.setBackgroundColor(UIColor(cgColor: item.calendar.cgColor))
        }
    }   //end loadTableData
    
    

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

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func buttonMainIC() {
        presentController(withName: "Main", context: "Today")
    }

    @IBAction func buttonReminders() {
        presentController(withName: "Reminders", context: "Today")
    }

}
