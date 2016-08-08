//
//  ReminderCode.swift
//  Dictate
//
//  Created by Mike Derr on 6/11/15.
//  Copyright (c) 2015 ThatSoft.com. All rights reserved.
//

/*
import UIKit
import EventKit
//import Foundation
//import EventKitUI

class ReminderCode: NSObject {
    
    let defaults = NSUserDefaults(suiteName: "group.com.thatsoft.dictateApp")!

    var store : EKEventStore = EKEventStore()
    
    var calendarDatabase = EKEventStore()   // from EKTest code...
    
    
    func createEvent() {
        
        var eventStore : EKEventStore = EKEventStore()
        
        // 'EKEntityTypeReminder' or 'EKEntityTypeEvent'
        
        eventStore.requestAccessToEntityType(EKEntityType.Event, completion: {
            (granted, error) in
            
            //added
            let calendars = self.store.calendarsForEntityType(EKEntityType.Event)
                
            
            //if calendar.title == "Mike" {       //added
            
            
            if (granted) && (error == nil) {
                print("p24 granted \(granted)")
                print("p25 error \(error)")
                
                var event:EKEvent = EKEvent(eventStore: eventStore)
                
                event.title = "Test Title"
                event.startDate = NSDate()
                event.endDate = NSDate()
                event.notes = "This is a note"
                event.calendar = eventStore.defaultCalendarForNewEvents
                
                do {
                    //           var calendarMike: EKCalendar! = Mike
                    //          event.calendar = calendarMike
                
                    
                    try eventStore.saveEvent(event, span: EKSpan.ThisEvent)
                } catch _ {
                }
                
                print("p39 Saved Event")
            }
            
            // } // if clendat.title
            
        })
    }
    
    //In order to create a new calendar, you should create it and store the id in NSUserDefaults so you can retrieve it next time. I use the following function to fetch the calendar if it exists and create it if it does not:
    
    func getCalendar() -> EKCalendar? {
        
        if let id = defaults.stringForKey("calendarID") {
            return store.calendarWithIdentifier(id)
        } else {
            let calendar = EKCalendar(forEntityType: EKEntityType.Event, eventStore: self.store)
            
            calendar.title = "My New Calendar"
            //  calendar.CGColor = UIColor.redColor()
            calendar.source = self.store.defaultCalendarForNewEvents.source
            
            var error: NSError?
            do {
                try self.store.saveCalendar(calendar, commit: true)
            } catch let error1 as NSError {
                error = error1
            }
            
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
        newEvent.calendar = getCalendar()!
        
        do {
            try self.store.saveEvent(newEvent, span: EKSpan.ThisEvent, commit: true)
        } catch _ {
        }
    }
    
    
    // ---- Reminder --------------  // from EKTest guy...
    
    func eventStoreAccessReminders() {
        
        calendarDatabase.requestAccessToEntityType(EKEntityType.Reminder) { (granted, error) -> Void in
            if !granted {
                print("Access to store not granted")
                print(error?.localizedDescription)
            }
    }
    }
    func accessCalendarInTheDatabase() {
        let calendars = calendarDatabase.calendarsForEntityType(EKEntityType.Reminder)
        
        for calendar in calendars {
            print("••• p130 Calendar = \(calendar.title)")
        }
    }
    
    
    func createReminder() {
                
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
        let `repeat`      = defaults.stringForKey("eventRepeat")
        
        let reminderTitle = output
        
        let reminder = EKReminder(eventStore: calendarDatabase)
        
        reminder.title = reminderTitle!
        
        //____ add Reminder Alarm ____________________

        print("p161 Reminder: startDT: \(startDT)")
        
        var alarm = EKAlarm()
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss +0000 "
        
        let noDate = dateFormatter.dateFromString("2014-12-12 00:00:00 +0000")  //need this to match set no date from DictateCode
        
        print("p171 Reminder noDate: \(noDate)")
        
        if (startDT != noDate) {        // if Date != no date string, set alarm for Reminder
            alarm = EKAlarm(absoluteDate: startDT)
        }
        
        reminder.addAlarm(alarm)
        
        //____ end add Reminder Alarm ____________________

        
        reminder.calendar = calendarDatabase.defaultCalendarForNewReminders()   // WORKS to Default
        
        //reminder.calendar = calendarDatabase.calendarWithIdentifier("0x1702ae400")
        
        //TODO Crashes... Error getting default calendar for new reminders: Error Domain=EKCADErrorDomain Code=1014 "(null)"
       // (lldb) po reminder.calendar
       // <uninitialized>
        
        print("p192 reminder.calendar: \(reminder.calendar)")

        //reminder.calendar = calendarDatabase.defaultCalendarForNewReminders()
        
        var error: NSError?
        
        if error != nil{
            print("errors: \(error?.localizedDescription)")
        }
        
        print("p192 reminder: \(reminder)")
        print("p192 reminder.calendar: \(reminder.calendar)")

        do {
            try calendarDatabase.saveReminder(reminder, commit: true)
        } catch let error1 as NSError {
            error = error1
        }
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
            print("errors: \(error?.localizedDescription)")
        }
        
        do {
            try calendarDatabase.saveReminder(reminder, commit: true)
        } catch let error1 as NSError {
            error = error1
        }
    }
    
    
    
    
    
}   //class event code
 
*/
