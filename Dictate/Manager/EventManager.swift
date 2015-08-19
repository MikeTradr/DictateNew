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
}
