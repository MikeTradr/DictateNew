//
//  EventMnager.swift
//  Dictate
//
//  Created by Anil Varghese on 19/08/15.
//  Copyright (c) 2015 ThatSoft.com. All rights reserved.
//

import UIKit
import EventKit
//import MessageUI

// TODO Anil wanted to add: UIViewController
// for this error in line 81              self.presentViewController(alert, animated: true, completion: nil)


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
    let defaults = NSUserDefaults.standardUserDefaults()

    
    func fetchReminders(completion:([EKReminder])->Void) {
        
        getAccessToEventStoreForType(EKEntityTypeReminder, completion: { (granted) -> Void in
            
            if granted{
                println("granted: \(granted)")
                
              
                let calendars = self.eventStore.calendarsForEntityType(EKEntityTypeReminder)
                
                println("p36 calendars: \(calendars)")
  
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
        var error:NSError? = nil                                // = nil added by Mike 082915
        calender.source = eventStore.defaultCalendarForNewReminders().source
        let calendarWasSaved = self.eventStore.saveCalendar(calender, commit: true, error: &error)
        println("Error: \(error)")
        
        // Handle situation if the calendar could not be saved
        if calendarWasSaved == false {
            let alert = UIAlertController(title: "Calendar could not save", message: error?.localizedDescription, preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(OKAction)
            
    //        self.presentViewController(alert, animated: true, completion: nil)
        } else {
            
    //todo Anil erro line below here
       //     NSUserDefaults.standardUserDefaults().setObject(newCalendar.calendarIdentifier, forKey: "EventTrackerPrimaryCalendar")
        }
        
        for item in items{
            let reminder = EKReminder(eventStore: self.eventStore)
            reminder.title = item
            reminder.calendar = calender
            self.eventStore.saveReminder(reminder, commit: true, error: &error)
        }
    }
    
// ____ addReminder func ____________________________________
    func addReminder(name:String, items:[String]){
        println("p90 in addReminder name: \(name)")
    
        var destCalendar:EKCalendar?
        let calendars = self.eventStore.calendarsForEntityType(EKEntityTypeReminder)
        
        //var reminderArray:[String] = []
/*
        var reminderArray       = defaults.objectForKey("reminderArray") as! [String] //array of the items
        let reminderArrayLowerCased = reminderArray.map { return $0.lowercaseString}    //lowercase ever word in array -from Anil 083115 thank you Bro :)

        for list in reminderArrayLowerCased {
            //var calendarTitle:String! = calendar.title
            
            // var calendarTitle = calendar.title
            
          //  println("p110 calendar.title: \(calendar.title)")
            println("p112 _________name: \(name)")

            if (name == list) {
                //println("p528 we in condition reminderList: \(reminderList)")
                
                destCalendar = name as? EKCalendar

                
                calendarName = reminderList
                break
            }
            
            if calendar.title == name {
                destCalendar = calendar as? EKCalendar
                break
            }
        }
        
*/


        for calendar in calendars {
            //var calendarTitle:String! = calendar.title
            
            // var calendarTitle = calendar.title
            
            println("p110 calendar.title: \(calendar.title)")
            println("p112 _________name: \(name)")
            
            if calendar.title == name {
                destCalendar = calendar as? EKCalendar
                break;
            }
        }
        
   /*
        for calendar in calendars {
            //var calendarTitle:String! = calendar.title
            
            // var calendarTitle = calendar.title
            
            println("p110 calendar.title: \(calendar.title)")
            println("p112 _________name: \(name)")
            
            if calendar.title == name {
                destCalendar = calendar as? EKCalendar
                break
            }
        }
  */
        //println("p94 calendars: \(calendars)")
        
        println("p123 destCalendar: \(destCalendar)")
        
        if destCalendar != nil{
            for item in items{
                let reminder = EKReminder(eventStore: self.eventStore)
                reminder.title = item
                println("p126 reminder.title: \(reminder.title)")
                println("p126 calendar: \(destCalendar)")
                
                reminder.calendar = destCalendar
                println("p130 reminder.calendar: \(reminder.calendar)")
                println("p130 reminder: \(reminder)")
                
                var error:NSError?
                self.eventStore.saveReminder(reminder, commit: true, error: &error)
                println("p97 Error: \(error)")
                
            }   //for item...
        } else {
            
            println("p145 we here??? destCalendar: \(destCalendar)")

            let reminder = EKReminder(eventStore: self.eventStore)

            let calender = EKCalendar(forEntityType: EKEntityTypeReminder , eventStore: self.eventStore)
            calender.title = name
            calender.source = eventStore.defaultCalendarForNewReminders().source
            
            var tempString = ""
            let reminderTitle = tempString.join(items)  //convert [String] to String for reminder content
            reminder.title = reminderTitle

            var error:NSError? = nil                                // = nil added by Mike 082915
            reminder.calendar = eventStore.defaultCalendarForNewReminders()
            self.eventStore.saveReminder(reminder, commit: true, error: &error)

        }// if dest...
    }
    
    
    
//Add item to Reminder List - Mike 082915
    func addReminderMike(name:String, items:[String]){
        let calender = EKCalendar(forEntityType: EKEntityTypeReminder , eventStore: self.eventStore)
        calender.title = name
        var error:NSError?
        calender.source = eventStore.defaultCalendarForNewReminders().source
     //   self.eventStore.saveCalendar(calender, commit: true, error: &error)
        println("p84 Error: \(error)")
        
        println("p84 calender.title: \(calender.title)")
        
        let calendars = self.eventStore.calendarsForEntityType(EKEntityTypeReminder)
        
        var reminderArray:[String] = []
        
        for calendar in calendars {
            var calendarTitle:String! = calendar.title
            
           // var calendarTitle = calendar.title

            println("p95 calendarTitle: \(calendarTitle)")
            
            reminderArray.append(calendarTitle)
            
            println("p95 reminderArray: \(reminderArray)")
       
            
        }
        
        println("p94 calendars: \(calendars)")

        
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
    
    func createReminderArray() {        //called from AppDelegate on startup
        let calender = EKCalendar(forEntityType: EKEntityTypeReminder , eventStore: self.eventStore)
     
        var error:NSError?
        calender.source = eventStore.defaultCalendarForNewReminders().source
        println("p135 Error: \(error)")
        
        let calendars = self.eventStore.calendarsForEntityType(EKEntityTypeReminder)
        
        var reminderArray:[String] = []
        
        for calendar in calendars {
            var reminderTitle:String! = calendar.title
            println("p229 reminderTitle: \(reminderTitle)")
            var length = count(reminderTitle)
            println("p231 length: \(length)")
            
            reminderArray.append(reminderTitle)
        }
        println("p148 reminderArray: \(reminderArray)")
        println("p148 reminderArray.count: \(reminderArray.count)")
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(reminderArray, forKey: "reminderArray")            //sets reminderArray

    }   //func CreateReminderArray   
    
    func createCalendarArray() {        //called from AppDelegate on startup
        let calender = EKCalendar(forEntityType: EKEntityTypeEvent , eventStore: self.eventStore)
        
        // from https://www.andrewcbancroft.com/2015/06/17/creating-calendars-with-event-kit-and-swift/
        
        // Use Event Store to create a new calendar instance
        // Configure its title
        let newCalendar = EKCalendar(forEntityType: EKEntityTypeEvent, eventStore: eventStore)
        newCalendar.title = "Some New Calendar Title"
        
        // Access list of available sources from the Event Store
        let sourcesInEventStore = eventStore.sources() as! [EKSource]
        println("p167 sourcesInEventStore: \(sourcesInEventStore)")
        
  //TODO Anil use only Local calendarsmaybe in out CalendarListArray I made???
        
   //     p167 sourcesInEventStore: [EKSource <0x1700cf880> {UUID = 855E381A-DEF0-4F78-846E-7B7EC1EE990D; type = Local; title = Default; externalID = (null)}, EKSource <0x1700cf5e0> {UUID = BA48C2E6-DA4E-40BA-BCE8-D20FA3F957AF; type = Other; title = Other; externalID = (null)}, EKSource <0x1700cf570> {UUID = 0B17DA80-1504-4142-AAE4-51CB6DC52327; type = CalDAV; title = iCloud; externalID = 0B17DA80-1504-4142-AAE4-51CB6DC52327}, EKSource <0x1700cf730> {UUID = 17673175-ACD9-4C7E-BE76-AE60BF850880; type = Subcribed; title = Subscribed Calendars; externalID = Subscribed Calendars}, EKSource <0x1700d0840> {UUID = 2F54B94E-CDED-491C-A812-760833A10C7A; type = CalDAV; title = Mike Main; externalID = 2F54B94E-CDED-491C-A812-760833A10C7A}, EKSource <0x1700d08b0> {UUID = CC9633E4-021B-4E85-8EE0-082AFFB5A232; type = CalDAV; title = MikeTradr; externalID = CC9633E4-021B-4E85-8EE0-082AFFB5A232}]

        
        // Filter the available sources and select the "Local" source to assign to the new calendar's
        // source property
        
    //TODO Anil can we filter for local calndars only. I get in Arry Mike Derr twice!
        newCalendar.source = sourcesInEventStore.filter{
            (source: EKSource) -> Bool in
            source.sourceType.value == EKSourceTypeLocal.value
            }.first
        
        
        
        var error:NSError?
        calender.source = eventStore.defaultCalendarForNewEvents.source
        println("p181 Error: \(error)")
        
        let calendars = self.eventStore.calendarsForEntityType(EKEntityTypeEvent)
        
        var calendarArray:[String] = []
        
        for calendar in calendars {
            var calendarTitle:String! = calendar.title
            println("p189 calendarTitle: \(calendarTitle)")
            
            calendarArray.append(calendarTitle)
        }
        println("p193 calendarArray: \(calendarArray)")
        println("p193 calendarArray.count: \(calendarArray.count)")
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(calendarArray, forKey: "calendarArray")            //sets calendarArray
        
    }   //func CreateCalendarArray
    
}
