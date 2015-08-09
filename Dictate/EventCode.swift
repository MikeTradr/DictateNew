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
    
    func createEvent() {
        
        println("p18 WE HERE func createEvent")
        
        var store : EKEventStore = EKEventStore()               // this old delete?  TODO
        
        var eventStore : EKEventStore = EKEventStore()
        
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let mainType:String    = defaults.stringForKey("mainType")!
        let actionType:String    = defaults.stringForKey("actionType")!
        
        println("p75 mainType: \(mainType)")
        println("p26 actionType: \(actionType)")
        
        let day         = defaults.stringForKey("day")
        let phone       = defaults.stringForKey("phone")
        
        let startDT     = defaults.objectForKey("startDT")! as! NSDate
        let endDT       = defaults.objectForKey("endDT")! as! NSDate
        let output      = defaults.stringForKey("output")
        let outputNote  = defaults.stringForKey("outputNote")
        let eventDuration    = defaults.objectForKey("eventDuration") as! Double
        
        
        var calendarName    = defaults.stringForKey("calendarName")
        
        let alert       = defaults.objectForKey("eventAlert") as! Double
        let repeat      = defaults.stringForKey("eventRepeat")
        
        let strRaw      = defaults.stringForKey("strRaw")
        
        
        
        println("p71 phone: \(phone)")
        println("p79 eventDuration: \(eventDuration)")
        println("p80 outputNote: \(outputNote)")
        println("p81 output: \(output)")
        println("p98 mainType: \(mainType)")
        
        println("p114 calandarName: \(calendarName)")       //TODO WHY is "" ????
        
        if (calendarName == "") {                           // calendarName not set in parse so pill it from prefDefault
            calendarName = defaults.stringForKey("prefsDefaultCalendarName")
        }
        
        println("628 *** startDT: \(startDT)")
        println("629 endDT: \(endDT)")
        println("######## p804 calendarName: \(calendarName)")
        
        if (calendarName == "") {
            println("p68 we here: \(calendarName)")
            var calendarName = "dictate events"
        }
        
        //calendarName = "dictate events"
        
        
        println("p71 calendarName: \(calendarName)")
        
        
        // 1
        let calendars = eventStore.calendarsForEntityType(EKEntityTypeEvent)
            as! [EKCalendar]
        
        var userCalendarsArr = [String]()
        
        for calendar in calendars as [EKCalendar] {                         //make array of uses calendars
            // loops through all calendars users has :) make into array
            println("p820 Calendar = \(calendar.title)")
            
            userCalendarsArr.append(calendar.title.lowercaseString)
            println("p823 userCalendarArr = \(userCalendarsArr)")
            
            
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(userCalendarsArr, forKey: "userCalendarsArr")
            
        }
        
        
        
        
        var event:EKEvent = EKEvent(eventStore: eventStore)
        
        event.calendar = eventStore.defaultCalendarForNewEvents
        println("p97 event.calendar = \(event.calendar)")
        
        var calendarTitle = event.calendar.title
        println("p100 calendarTitle = \(calendarTitle)")
        
        var calendarColor = event.calendar.CGColor
        println("p103 calendarColor = \(calendarColor)")
        
        
        
        
        for calendar in calendars {
            // 2
            
            //calendar.calendar = eventStore.defaultCalendarForNewReminders()
            
            //   if calendarName != "" {
            
            // TODO FIX
            
            println("p119 calendar.title.lowercaseString = \(calendar.title.lowercaseString)")
            println("p120 calendarName.lowercaseString = \(calendarName!.lowercaseString)")
            
            
            
            if calendar.title.lowercaseString == calendarName!.lowercaseString {     //need match here to create event on calendar!!!
                
                //if calendar.title.lowercaseString == calendarTitle.lowercaseString {     //need match here to create event on calendar!!!
                
                
                println("p839 WE HERE?: \(calendarName)")
                
                // 3
                //let startDate = NSDate()
                println("p638 *** startDT: \(startDT)")
                println("p639 endDT: \(endDT)")
                println("p833 calendarName = \(calendarName)")
                
                
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
                
                let defaults = NSUserDefaults.standardUserDefaults()
                let eventAlert = defaults.objectForKey("eventAlert") as! Double
                println("p1185 eventAlert = \(eventAlert)")
                
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
                
                println("p1456 eventRepeat = \(eventRepeat)")
                
                let everySunday = EKRecurrenceDayOfWeek(1)
                let january = 1
                
                var returnValue: String = ""
                
                // TODO Fix why this below errors????
                let endRecurrence: EKRecurrenceEnd = EKRecurrenceEnd.recurrenceEndWithOccurrenceCount(5) as! EKRecurrenceEnd
                //let endRecurrence: Int = 5
                
                let oneYear:NSTimeInterval = 365 * 24 * 60 * 60
                let fiveDays:NSTimeInterval = 5 * 24 * 60 * 60
                
                let oneYearFromNow = startDT.dateByAddingTimeInterval(oneYear)
                let fiveDaysFromNow = startDT.dateByAddingTimeInterval(fiveDays)
                
                let recurringEnd = EKRecurrenceEnd.recurrenceEndWithEndDate(oneYearFromNow) as! EKRecurrenceEnd
                
                let recurringFive = EKRecurrenceEnd.recurrenceEndWithEndDate(fiveDaysFromNow) as! EKRecurrenceEnd
                
                
                
                switch (eventRepeat){  // 1 = daily, 2 = weekly, 3 = yearly   I made this to pass then change later in event method
                case 1:
                    let recur = EKRecurrenceRule(
                        recurrenceWithFrequency:EKRecurrenceFrequencyDaily,
                        interval:1,
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
                    println("p1491  in case 2? eventRepeat = \(eventRepeat)")
                    
                    let recur = EKRecurrenceRule(
                        recurrenceWithFrequency:EKRecurrenceFrequencyWeekly,
                        interval:1,
                        end: recurringEnd)
                    
                    event.addRecurrenceRule(recur)
                    
                    break;
                case 3:
                    let recur = EKRecurrenceRule(
                        recurrenceWithFrequency:EKRecurrenceFrequencyYearly,
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
                default:   println("p1511 no eventRepeat word matched")
                break;
                }
                
                
                /*
                
                let recur = EKRecurrenceRule(
                
                
                
                //recurrenceWithFrequency:EKRecurrenceFrequencyDaily,       // every daily
                recurrenceWithFrequency:returnValue,        // every week
                //recurrenceWithFrequency:EKRecurrenceFrequencyYearly,      // every year
                
                interval:1,                     // no,  2 = every *two* years
                //daysOfTheWeek:[everySunday],
                daysOfTheWeek:nil,
                
                daysOfTheMonth:nil,
                //monthsOfTheYear:[january],
                monthsOfTheYear:nil,
                weeksOfTheYear:nil,
                daysOfTheYear:nil,
                setPositions: nil,
                end:nil)
                
                */
                
                //event.addRecurrenceRule(recur)       //TODO commented to turn off this until fully coded
                
                
                //event.calendar = calendarName
                
                
                
                
                println("p862 output: \(output)")
                println("p863 startDT: \(startDT)")
                println("p864 endDT: \(endDT)")
                println("p865 from func endDate: \(endDate)")
                
                event.title = output
                event.startDate = startDT
                event.endDate = endDate
                event.notes = outputNote
                
                
                
                // TODO ADD eventDuration field to screen
                
                var saveError : NSError? = nil // Initially sets errors to nil
                
                let result = eventStore.saveEvent(event, span: EKSpanThisEvent, error: &saveError)  // Commits changes and allows saveEvent to change error from nil
                
                
                //// Following checks for errors and prints result to Debug Area ////
                if saveError != nil {
                    println("Saving event to Calendar failed with error: \(saveError!)")
                } else {
                    println("p283 Successfully saved '\(event.title)' to '\(event.calendar.title)' calendar.")
                }
                
            }
            
        }
        
    }
    
}
