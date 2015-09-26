//
//  EventCode.swift
//  Dictate™
//
//  Created by Mike Derr on 7/4/15.
//  Copyright (c) 2015 ThatSoft.com. All rights reserved.
//

import UIKit
import EventKit

class EventCode: NSObject {
    class var sharedInstance : ReminderManager {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : ReminderManager? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = ReminderManager()
        }
        return Static.instance!
    }
    
    let eventStore = EKEventStore()
    let defaults = NSUserDefaults(suiteName: "group.com.thatsoft.dictateApp")!

    
    func createEvent() {
        
        print("p18 WE HERE func createEvent")
        
        var store : EKEventStore = EKEventStore()               // this old delete?  TODO
        
        var eventStore : EKEventStore = EKEventStore()
        
        let mainType:String    = defaults.stringForKey("mainType")!
        let actionType:String    = defaults.stringForKey("actionType")!
        
        print("p75 mainType: \(mainType)")
        print("p26 actionType: \(actionType)")
        
        let day         = defaults.stringForKey("day")
        let phone       = defaults.stringForKey("phone")
        
        let startDT     = defaults.objectForKey("startDT")! as! NSDate
        let endDT       = defaults.objectForKey("endDT")! as! NSDate
        let output      = defaults.stringForKey("output")
        let outputNote  = defaults.stringForKey("outputNote")
        let eventDuration    = defaults.objectForKey("eventDuration") as! Double
        
        
        var calendarName    = defaults.stringForKey("calendarName")
        
        let alert       = defaults.objectForKey("eventAlert") as! Double
        let `repeat`      = defaults.stringForKey("eventRepeat")
        
        let strRaw      = defaults.stringForKey("strRaw")
        
        
        
        print("p71 phone: \(phone)")
        print("p79 eventDuration: \(eventDuration)")
        print("p80 outputNote: \(outputNote)")
        print("p81 output: \(output)")
        print("p98 mainType: \(mainType)")
        
        print("p114 calandarName: \(calendarName)")       //TODO WHY is "" ????
        
        if (calendarName == "") {                       // calendarName not set in parse so pill it from prefDefault
            calendarName = defaults.stringForKey("prefsDefaultCalendarName")
        }
        
        print("628 *** startDT: \(startDT)")
        print("629 endDT: \(endDT)")
        print("######## p804 calendarName: \(calendarName)")
        
        if (calendarName == "") {
            print("p68 we here: \(calendarName)")
            var calendarName = "dictate events"
        }
        
        //calendarName = "dictate events"
        
        
        print("p71 calendarName: \(calendarName)")
        
        
        // 1
        let calendars = eventStore.calendarsForEntityType(EKEntityType.Event)
            
        
        var userCalendarsArr = [String]()
 /*
        for calendar in calendars as [EKCalendar] {                         //make array of uses calendars
            // loops through all calendars users has :) make into array
            println("p820 Calendar = \(calendar.title)")
            
            userCalendarsArr.append(calendar.title.lowercaseString)
            println("p823 userCalendarArr = \(userCalendarsArr)")
            
            
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(userCalendarsArr, forKey: "userCalendarsArr"
        
        }
        
 */
        
        
        var event:EKEvent = EKEvent(eventStore: eventStore)
        
        event.calendar = eventStore.defaultCalendarForNewEvents
        print("p97 event.calendar = \(event.calendar)")
        
        var calendarTitle = event.calendar.title
        print("p100 calendarTitle = \(calendarTitle)")
        
        var calendarColor = event.calendar.CGColor
        print("p103 calendarColor = \(calendarColor)")
        
        
        
        
        for calendar in calendars {
            // 2
            
            //calendar.calendar = eventStore.defaultCalendarForNewReminders()
            
            //   if calendarName != "" {
            
            // TODO FIX
            
            print("p119 calendar.title.lowercaseString = \(calendar.title.lowercaseString)")
            print("p120 calendarName.lowercaseString = \(calendarName!.lowercaseString)")
            
            
            
            if calendar.title.lowercaseString == calendarName!.lowercaseString {     //need match here to create event on calendar!!!
                
                //if calendar.title.lowercaseString == calendarTitle.lowercaseString {     //need match here to create event on calendar!!!
                
                
                print("p839 WE HERE?: \(calendarName)")
                
                // 3
                //let startDate = NSDate()
                print("p638 *** startDT: \(startDT)")
                print("p639 endDT: \(endDT)")
                print("p833 calendarName = \(calendarName)")
                
                
                // Duration, set End Date Time
                let endDate = startDT.dateByAddingTimeInterval(eventDuration * 60)
                
                
                // 4
                // Create Event
                
                var event = EKEvent(eventStore: eventStore)
                
                //TODO set to user set calendar tried here
                //event.calendar = calendar
                
                // event.calendar = event.defaultCalendarForNewEvents // Selects default calendar
                
                
                
                //WORKS to default
                //event.calendar = eventStore.defaultCalendarForNewEvents
                
                event.calendar = calendar
                
                
                // Create Alarm aka Alert...
                //let alertMinutes:Double = 10
                
                let eventAlert = defaults.objectForKey("eventAlert") as! Double
                print("p1185 eventAlert = \(eventAlert)")
                
                if (eventAlert != 0.0){
                    let alertOffset:Double = -( eventAlert * 60 )            //60 minutes * 60 seconds = 1 hour
                    let alert = EKAlarm(relativeOffset: alertOffset)        // at user Offset
                    event.addAlarm(alert)
                }
                
                let alertNow = EKAlarm(relativeOffset: 0.0)             // at time of event
                event.addAlarm(alertNow)
                
                
                // Create Reccurring Event...
                
                // TODO MIKE Clean this code? add more features... end date! make class to use in Reminders also
                
                /* Add the rule */
                // let rule = EKRecurrenceRule(recurrenceWithFrequency: EKRecurrenceFrequencyDaily, interval: 1, end: EKRecurrenceEnd.recurrenceEndWithEndDate(NSDate.distantFuture() as! NSDate) as! EKRecurrenceEnd)
                
                //   event.addRecurrenceRule(rule)
                
                let eventRepeat:Int = defaults.objectForKey("eventRepeat") as! Int
                
                print("p1456 eventRepeat = \(eventRepeat)")
                
                let everySunday = EKRecurrenceDayOfWeek()
                let january = 1
                
                var returnValue: String = ""
                
                // TODO Fix why this below errors????
                let endRecurrence: EKRecurrenceEnd = EKRecurrenceEnd(occurrenceCount: 5)
                //let endRecurrence: Int = 5
                
                let oneYear:NSTimeInterval = 365 * 24 * 60 * 60
                let fiveDays:NSTimeInterval = 5 * 24 * 60 * 60
                
                let oneYearFromNow = startDT.dateByAddingTimeInterval(oneYear)
                let fiveDaysFromNow = startDT.dateByAddingTimeInterval(fiveDays)
                
                let recurringEnd = EKRecurrenceEnd(endDate:oneYearFromNow)
                
                let recurringFive = EKRecurrenceEnd(endDate: fiveDaysFromNow)
                
                
                
                switch (eventRepeat){  // 1 = daily, 2 = weekly, 3 = yearly, 4 = monthly   I made this to pass then change later in event method
                case 1:
                    let recur = EKRecurrenceRule(
                        recurrenceWithFrequency:EKRecurrenceFrequency.Daily,
                        interval:3,                     // test 3 days
                        //daysOfTheWeek:[everySunday],
                        daysOfTheWeek:nil,
                        daysOfTheMonth:nil,
                        //monthsOfTheYear:[january],
                        monthsOfTheYear:nil,
                        weeksOfTheYear:nil,
                        daysOfTheYear:nil,
                        setPositions: nil,
                        //end: endRecurrence) // errors  TODO
                        end: endRecurrence)
                    
                    event.addRecurrenceRule(recur)
                    
                    break;
                    
                    
                    
                case 2:
                    print("p1491  in case 2? eventRepeat = \(eventRepeat)")
                    
                    let recur = EKRecurrenceRule(
                        recurrenceWithFrequency:EKRecurrenceFrequency.Weekly,
                        interval:1,
                        end: recurringEnd)
                    
                    event.addRecurrenceRule(recur)
                    
                    break;
                    
                case 3:
                    let recur = EKRecurrenceRule(
                        recurrenceWithFrequency:EKRecurrenceFrequency.Yearly,
                        interval:1,
                        //daysOfTheWeek:[everySunday],
                        daysOfTheWeek:nil,
                        daysOfTheMonth:nil,
                        //monthsOfTheYear:[january],
                        monthsOfTheYear:nil,
                        weeksOfTheYear:nil,
                        daysOfTheYear:nil,
                        setPositions: nil,
                        end:nil)
                    
                    event.addRecurrenceRule(recur)
                    
                    break;
                    
                case 4:
                    let recur = EKRecurrenceRule(
                        recurrenceWithFrequency:EKRecurrenceFrequency.Monthly,
                        interval:1,
                        //daysOfTheWeek:[everySunday],
                        daysOfTheWeek:nil,
                        daysOfTheMonth:nil,
                        //monthsOfTheYear:[january],
                        monthsOfTheYear:nil,
                        weeksOfTheYear:nil,
                        daysOfTheYear:nil,
                        setPositions: nil,
                        end:nil)
                    
                    event.addRecurrenceRule(recur)
                    
                    break;
                    
                default:   print("p1511 no eventRepeat word matched")
                break;
                }
                

 
                print("p862 output: \(output)")
                print("p863 startDT: \(startDT)")
                print("p864 endDT: \(endDT)")
                print("p865 from func endDate: \(endDate)")
                
                event.title = output!
                event.startDate = startDT
                event.endDate = endDate
                event.notes = outputNote
                
                
                
                // TODO ADD eventDuration field to screen
                
                let result: Bool
                do {
                    try eventStore.saveEvent(event, span: EKSpan.ThisEvent)
                    result = true
                    print("p283 Successfully saved '\(event.title)' to '\(event.calendar.title)' calendar.")
                } catch  let error as NSError{
                    result = false
                    print("Saving event to Calendar failed with error: \(error.description)")
                }  // Commits changes and allows saveEvent to change error from nil
                
            }
            
        }
        
    }
    
}
