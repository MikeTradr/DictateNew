//
//  ReminderCode.swift
//  WatchInput
//
//  Created by Mike Derr on 6/11/15.
//  Copyright (c) 2015 ThatSoft.com. All rights reserved.
//

import UIKit
import EventKit
//import Foundation
//import EventKitUI

class ReminderCode: NSObject {
    
    var store : EKEventStore = EKEventStore()
    
    var calendarDatabase = EKEventStore()   // from EKTest code...
    
    
    func createEvent() {
        
        var eventStore : EKEventStore = EKEventStore()
        
        // 'EKEntityTypeReminder' or 'EKEntityTypeEvent'
        
        eventStore.requestAccessToEntityType(EKEntityTypeEvent, completion: {
            (granted, error) in
            
            //added
            let calendars = self.store.calendarsForEntityType(EKEntityTypeEvent)
                as! [EKCalendar]
            
            //if calendar.title == "Mike" {       //added
            
            
            if (granted) && (error == nil) {
                println("p24 granted \(granted)")
                println("p25 error \(error)")
                
                var event:EKEvent = EKEvent(eventStore: eventStore)
                
                event.title = "Test Title"
                event.startDate = NSDate()
                event.endDate = NSDate()
                event.notes = "This is a note"
                event.calendar = eventStore.defaultCalendarForNewEvents
                
                //           var calendarMike: EKCalendar! = Mike
                //          event.calendar = calendarMike
                
                
                eventStore.saveEvent(event, span: EKSpanThisEvent, error: nil)
                
                println("p39 Saved Event")
            }
            
            // } // if clendat.title
            
        })
    }
    
    //In order to create a new calendar, you should create it and store the id in NSUserDefaults so you can retrieve it next time. I use the following function to fetch the calendar if it exists and create it if it does not:
    
    func getCalendar() -> EKCalendar? {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        
        if let id = defaults.stringForKey("calendarID") {
            return store.calendarWithIdentifier(id)
        } else {
            var calendar = EKCalendar(forEntityType: EKEntityTypeEvent, eventStore: self.store)
            
            calendar.title = "My New Calendar"
            //  calendar.CGColor = UIColor.redColor()
            calendar.source = self.store.defaultCalendarForNewEvents.source
            
            var error: NSError?
            self.store.saveCalendar(calendar, commit: true, error: &error)
            
            if error == nil {
                defaults.setObject(calendar.calendarIdentifier, forKey: "calendarID")
            }
            
            return calendar
        }
    }
    
    
    //    Now you use this calendar when creating a new event so you can add the event to this calendar:
    
    func addEvent() {
        
        let someTitle = "Test Title"
        let someLocation = "Test location"
        let someStartDate = NSDate()
        let someEndDate = NSDate()
        let someMoreInfo = "notes info"
        
        var newEvent = EKEvent(eventStore: self.store)
        
        newEvent.title = someTitle
        newEvent.location = someLocation
        newEvent.startDate = someStartDate
        newEvent.endDate = someEndDate
        newEvent.notes = someMoreInfo
        newEvent.calendar = getCalendar()
        
        self.store.saveEvent(newEvent, span: EKSpanThisEvent, commit: true, error: nil)
    }
    
    
    // ---- Reminder --------------  // from EKTest guy...
    
    func eventStoreAccessReminders() {
        
        calendarDatabase.requestAccessToEntityType(EKEntityTypeReminder, completion: {(granted: Bool, error:NSError!) -> Void in
            if !granted {
                println("Access to store not granted")
                println(error.localizedDescription)
            }
        })
        
    }
    
    func accessCalendarInTheDatabase() {
        var calendars = calendarDatabase.calendarsForEntityType(EKEntityTypeReminder)
        
        for calendar in calendars as! [EKCalendar] {
            println("••• p130 Calendar = \(calendar.title)")
        }
    }
    
    
    func createReminder() {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let mainType    = defaults.stringForKey("mainType")
        let actionType  = defaults.stringForKey("actionType")
        
        let day         = defaults.stringForKey("day")
        let phone       = defaults.stringForKey("phone")
        
        let startDT     = defaults.objectForKey("startDT")! as! NSDate
        let endDT       = defaults.objectForKey("endDT")! as! NSDate
        let output      = defaults.stringForKey("output")
        let outputNote  = defaults.stringForKey("outputNote")
        let duration    = defaults.stringForKey("eventDuration")
        let calendarName    = defaults.stringForKey("calendarName")
        let alert       = defaults.objectForKey("eventAlert") as! Double
        let repeat      = defaults.stringForKey("eventRepeat")
        
        let reminderTitle = output
        
        let reminder = EKReminder(eventStore: calendarDatabase)
        
        reminder.title = reminderTitle
        
        println("p161 Reminder: startDT: \(startDT)")
        
        var alarm = EKAlarm()
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss +0000 "
        
        let noDate = dateFormatter.dateFromString("2014-12-12 00:00:00 +0000")  //need this to match set no date from DictateCode
        
        println("p167 Reminder: noDate: \(noDate)")
        
        if (startDT != noDate) {        // if Date != no date string, set alarme for Reminder
            alarm = EKAlarm(absoluteDate: startDT)
        }
        
        //let date = startDT
        //alarm = EKAlarm(absoluteDate: startDT)
        
        reminder.addAlarm(alarm)
        
        reminder.calendar = calendarDatabase.defaultCalendarForNewReminders()   // WORKS to Default
        
        //reminder.calendar = calendarDatabase.calendarWithIdentifier("0x1702ae400")
        
        println("p192 reminder.calendar: \(reminder.calendar)")

        //reminder.calendar = calendarDatabase.defaultCalendarForNewReminders()
        
        var error: NSError?
        
        if error != nil{
            println("errors: \(error?.localizedDescription)")
        }
        
        println("p192 reminder: \(reminder)")
        println("p192 reminder.calendar: \(reminder.calendar)")

        calendarDatabase.saveReminder(reminder, commit: true, error: &error)
    }
    
    
    
    
    func createReminderORG(reminderTitle: String, notes: String, startDT: NSDate) {
        let reminder = EKReminder(eventStore: calendarDatabase)
        
        reminder.title = reminderTitle
        let date = startDT
        let alarm = EKAlarm(absoluteDate: startDT)
        
        reminder.addAlarm(alarm)
        
        reminder.calendar = calendarDatabase.defaultCalendarForNewReminders()
        
        var error: NSError?
        
        if error != nil{
            println("errors: \(error?.localizedDescription)")
        }
        
        calendarDatabase.saveReminder(reminder, commit: true, error: &error)
    }
    
    
    
    
    
}   //class event code
