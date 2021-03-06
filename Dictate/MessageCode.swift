//
//  ReminderCode.swift
//  WatchInput
//
//  Created by Mike Derr on 6/29/15.
//  Copyright (c) 2015 ThatSoft.com. All rights reserved.
//
// from:   http://www.techotopia.com/index.php/Using_iOS_8_Event_Kit_and_Swift_to_Create_Date_and_Location_Based_Reminders

import UIKit
import EventKit
import CoreLocation
//import Foundation
//import EventKitUI

class MessageCode: NSObject {
    
    let defaults = NSUserDefaults(suiteName: "group.com.thatsoft.dictateApp")!
    
    var store : EKEventStore = EKEventStore()
        
    var eventStore:EKEventStore = EKEventStore()
        
    var calendarDatabase = EKEventStore()   // from EKTest code...

    var startDT:NSDate          = NSDate()
    var endDT:NSDate            = NSDate()

    func createReminder(title:String, notes:String, startDT:NSDate) {
        
        println("p25 We in create reminder... Access to store not granted")

 
        eventStore.requestAccessToEntityType(EKEntityTypeReminder,
            completion: {(granted: Bool, error:NSError!) in
                if !granted {
                    println("Access to store not granted")
                }
        })
        
        
        
        println("p44 title: \(title)")

        
   
        let reminder = EKReminder(eventStore: self.eventStore)
        
        
        println("p44 output: \(output)")
        println("p45 startDT: \(startDT)")
        println("p46 endDT: \(endDT)")
        //println("p865 from func endDate: \(endDate)")
        
        //event.title = output
        //event.startDate = startDT
       // event.endDate = endDate
        //event.notes = outputNote
        
        let date = startDT
        let alarm = EKAlarm(absoluteDate: date)
        if (alarm != nil) {                     // if Alarm is not blank then set Reminder Alarm aka Due Date
            reminder.addAlarm(alarm)
        }
        
        reminder.title = title
        reminder.calendar = eventStore.defaultCalendarForNewReminders()
        //reminder.startDate = startDT
        //  off for now as the same as title.     reminder.notes = notes
        
        var error: NSError?
        
        eventStore.saveReminder(reminder, commit: true, error: &error)
        
    }
    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
       // locationManager.stopUpdatingLocation()
        
        //let reminder = EKReminder(eventStore: appDelegate!.eventStore)
        //reminder.title = locationText.text
        //reminder.calendar =
          //  appDelegate!.eventStore!.defaultCalendarForNewReminders()
        
        let location = EKStructuredLocation(title: "Current Location")
        location.geoLocation = locations.last as! CLLocation
        
        let alarm = EKAlarm()
        
        alarm.structuredLocation = location
        alarm.proximity = EKAlarmProximityLeave
        
       // reminder.addAlarm(alarm)
        
        var error: NSError?
        
       // appDelegate!.eventStore?.saveReminder(reminder,
        //    commit: true, error: &error)
        
        if error != nil {
            println("Reminder failed with error \(error?.localizedDescription)")
        }
    }
    
    
        
  //here down old stuff????
        
/*
        // 'EKEntityTypeReminder' or 'EKEntityTypeEvent'
        
        eventStore.requestAccessToEntityType(EKEntityTypereminder, completion: {
        (granted, error) in
            
     //added
        let reminders = self.store.calendarsForEntityType(EKEntityTypeReminder)
                as! [EKCalendar]
            
        //if calendar.title == "Mike" {       //added
            
        
        if (granted) && (error == nil) {
            println("p24 granted \(granted)")
            println("p25 error \(error)")
            
            var reminder:EKEvent = EKEvent(eventStore: eventStore)
            
            reminder.title = "Test ReminderTitle"
            reminder.startDate = NSDate()
            reminder.endDate = NSDate()
            reminder.notes = "This is a note"
            reminder.calendar = eventStore.defaultCalendarForNewEvents
            
 //           var calendarMike: EKCalendar! = Mike
  //          event.calendar = calendarMike

            
          //  eventStore.saveEvent(event, span: EKSpanThisEvent, error: nil)
            
            println("p39 Saved Event")
        }
            
       // } // if clendat.title


*/
    

    
//In order to create a new calendar, you should create it and store the id in NSUserDefaults so you can retrieve it next time. I use the following function to fetch the calendar if it exists and create it if it does not:
    
    func getCalendar() -> EKCalendar? {        
        
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
    
    
    func createReminder(reminderTitle: String, reminderDate: NSDate) {
        
        let reminder = EKReminder(eventStore: calendarDatabase)
        reminder.title = reminderTitle
        let date = reminderDate
        let alarm = EKAlarm(absoluteDate: date)
        
        reminder.addAlarm(alarm)
        
        reminder.calendar = calendarDatabase.defaultCalendarForNewReminders()
        
        var error: NSError?
        
        if error != nil{
            println("errors: \(error?.localizedDescription)")
        }
        
        calendarDatabase.saveReminder(reminder, commit: true, error: &error)
    }
    
    
    
    
   
}   //class event code
