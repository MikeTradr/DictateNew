//
//  EventMnager.swift
//  Dictate
//
//  Created by Anil Varghese on 19/08/15.
//  Copyright (c) 2015 ThatSoft.com. All rights reserved.
//

import UIKit
import EventKit

class EventManager: NSObject {
    class var sharedInstance : EventManager {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : EventManager? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = EventManager()
        }
        return Static.instance!
    }
    
    let eventStore = EKEventStore()
    
    func fetchReminders(completion:([EKReminder])->Void) {
        
        getAccessToEventStoreForType(EKEntityTypeReminder, completion: { (granted) -> Void in
            
            if granted{
                println("granted: \(granted)")
                
              
                let calendars = self.eventStore.calendarsForEntityType(EKEntityTypeReminder)
                var predicate = self.eventStore.predicateForIncompleteRemindersWithDueDateStarting(nil, ending: nil, calendars: calendars)
                self.eventStore.fetchRemindersMatchingPredicate(predicate) { reminders in
                    completion(reminders as! [EKReminder]!)
                }
            }
        })
    }
    
    func getAccessToEventStoreForType(type:EKEntityType, completion:(granted:Bool)->Void){
        
        let status = EKEventStore.authorizationStatusForEntityType(type)
        if status != EKAuthorizationStatus.Authorized{
            self.eventStore.requestAccessToEntityType(EKEntityTypeReminder, completion: {
                granted, error in
                if (granted) && (error == nil) {
                    completion(granted: true)
                }else{
                    completion(granted: false)
                }
            })
            
        }else{
            completion(granted: true)
        }
    }
    
    func createNewReminderList(name:String, items:[String]){    //forgor e in create -added Mike 082915
        let calender = EKCalendar(forEntityType: EKEntityTypeReminder , eventStore: self.eventStore)
        calender.title = name
        var error:NSError?
        calender.source = eventStore.defaultCalendarForNewReminders().source
        self.eventStore.saveCalendar(calender, commit: true, error: &error)
        println("Error: \(error)")
        
        for item in items{
            let reminder = EKReminder(eventStore: self.eventStore)
            reminder.title = item
            reminder.calendar = calender
            self.eventStore.saveReminder(reminder, commit: true, error: &error)
        }
    }
    
//Add item to Reminder List - Mike 082915
    func addReminder(name:String, items:[String]){
        let calender = EKCalendar(forEntityType: EKEntityTypeReminder , eventStore: self.eventStore)
        calender.title = name
        var error:NSError?
        calender.source = eventStore.defaultCalendarForNewReminders().source
     //   self.eventStore.saveCalendar(calender, commit: true, error: &error)
        println("p84 Error: \(error)")
        
        println("p84 calender.title: \(calender.title)")

        
        for item in items{
            let reminder = EKReminder(eventStore: self.eventStore)
            reminder.title = item
            println("p84 reminder.title: \(reminder.title)")
            println("p84 calendar: \(calender)")

            reminder.calendar = calender
            println("p84 reminder.calendar: \(reminder.calendar)")
            println("p84 reminder: \(reminder)")
            
            self.eventStore.saveReminder(reminder, commit: true, error: &error)
            println("p97 Error: \(error)")

        }
    }
    
    
    
}
