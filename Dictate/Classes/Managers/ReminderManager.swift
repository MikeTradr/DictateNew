//
//  ReminderManager.swift
//  Renamed ReminderManager 090515 by Mike
//  Dictate
//
//  Created by Anil Varghese on 19/08/15.
//  Copyright (c) 2015 ThatSoft.com. All rights reserved.
//

import UIKit
import EventKit
//import MessageUI //commented for new watchExtension 040516

// TODO Anil wanted to add: UIViewController
// for this error in line 81              self.presentViewController(alert, animated: true, completion: nil)


class ReminderManager: NSObject {
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
    

    
    let defaults = NSUserDefaults(suiteName: "group.com.thatsoft.dictateApp")!

    let eventStore = EKEventStore()
    
    var calendarDatabase = EKEventStore()   // from EKTest code...


    func getAccessToEventStoreForType(type:EKEntityType, completion:(granted:Bool)->Void){
        
        let status = EKEventStore.authorizationStatusForEntityType(type)
        if status != EKAuthorizationStatus.Authorized{
            self.eventStore.requestAccessToEntityType(EKEntityType.Reminder, completion: {
                granted, error in
                if (granted) && (error == nil) {
                    completion(granted: true)
                }else{
                    completion(granted: false)
                }
            })
            
        } else {
            completion(granted: true)
        
            let defaultReminderID = defaults.stringForKey("defaultReminderID")
            if defaultReminderID == nil {    //added by Mike 11112015 to save users default reminder to NSUserDefaults for defaultReminderID
                let reminder = EKReminder(eventStore: self.eventStore)
                reminder.calendar = eventStore.defaultCalendarForNewReminders()
                let defaultReminderID = reminder.calendar.calendarIdentifier
                if defaultReminderID != "" {
                    defaults.setObject(defaultReminderID, forKey: "defaultReminderID") //sets Default Selected Reminder CalendarIdentifier
                    //need to fix def reminer list??? check 112615
                    let calendarName = reminder.title
                    defaults.setObject(calendarName, forKey: "reminderList") //sets Default Selected Calendar reminderList  //added 112615          
                }
            }

        }
    }
    
    
    func fetchRemindersFromCalendars(calendars:[EKCalendar]? = nil,includeCompleted:Bool = false, completion:([EKReminder])->Void) {
        
        getAccessToEventStoreForType(EKEntityType.Reminder, completion: { (granted) -> Void in
            
            if granted{
                print("granted: \(granted)")
                
                let cal = calendars ?? self.eventStore.calendarsForEntityType(EKEntityType.Reminder)
                
                print("p36 calendars: \(calendars)")
                
                var reminderArray:[EKReminder] = []
                let predicate = self.eventStore.predicateForIncompleteRemindersWithDueDateStarting(nil, ending: nil, calendars: cal)
                self.eventStore.fetchRemindersMatchingPredicate(predicate) { reminders in
                    
                    if reminders?.count > 0{
                        reminderArray.appendContentsOf(reminders!)
 
                    }
                    if includeCompleted{
                        let predicate = self.eventStore.predicateForCompletedRemindersWithCompletionDateStarting(nil, ending: nil, calendars: cal)
                        self.eventStore.fetchRemindersMatchingPredicate(predicate) { reminders in
                            if reminders?.count > 0{
                                reminderArray.appendContentsOf(reminders!)
                                
                            }
                            completion(reminderArray as [EKReminder]!)

                        }
                    }else{
                        completion(reminderArray as [EKReminder]!)
                    }
                }
            }
        })
    }
/* moved to RMSave
     
    func saveReminder(reminderItem:EKReminder) {
        
        print("p74 reminderItem: \(reminderItem)")
        
        getAccessToEventStoreForType(EKEntityType.Reminder, completion: { (granted) -> Void in
            
            if granted{
                print("granted: \(granted)")
                
                let reminderLists = self.eventStore.calendarsForEntityType(EKEntityType.Reminder)
                
                print("p81 reminderLists: \(reminderLists)")
                
                var saveError: NSError? = nil // Initially sets errors to nil
                
                do {
                    try self.eventStore.saveReminder(reminderItem, commit: true)
                } catch var error as NSError {
                    saveError = error
                } catch {
                    fatalError()
                }
         
                if saveError != nil {
                    print("p90 Saving ReminderItem to Calendar failed with error: \(saveError!)")
                } else {
                    print("p91 Now Completed: '\(reminderItem.title)' to '\(reminderItem.calendar.title)' calendar.")
                }
  
            }
        })
    }
*/
    
    
    
    func fetchCalendarReminders(calendar:EKCalendar, completion:([EKReminder])->Void) {
        print("p36 we here? fetchReminders")
        
        getAccessToEventStoreForType(EKEntityType.Reminder, completion: { (granted) -> Void in
            
            if granted{
                print("granted: \(granted)")
                
                let predicate = self.eventStore.predicateForIncompleteRemindersWithDueDateStarting(nil, ending: nil, calendars: [calendar])
                self.eventStore.fetchRemindersMatchingPredicate(predicate) { reminders in
                    if let _reminders = reminders{
                        completion(reminders!)
                    }else{
                        completion([])
                    }
                }
            }
        })
    }
    
    
    

    
    func fetchRemindersOLD(completion:([EKReminder])->Void) {
        print("p36 we here? fetchReminders")

        getAccessToEventStoreForType(EKEntityType.Reminder, completion: { (granted) -> Void in
            
            if granted{
                print("granted: \(granted)")
                
              
                let calendars = self.eventStore.calendarsForEntityType(EKEntityType.Reminder)
                
                print("p36 calendars: \(calendars)")
  
                var predicate = self.eventStore.predicateForIncompleteRemindersWithDueDateStarting(nil, ending: nil, calendars: calendars)
                self.eventStore.fetchRemindersMatchingPredicate(predicate) { reminders in
                    completion(reminders as! [EKReminder]!)
                }
            }
        })
    }
    

    
    func getAccessToEventStoreForType2(type:EKEntityType, completion:(granted:Bool)->Void){
        
        let status = EKEventStore.authorizationStatusForEntityType(type)
        if status != EKAuthorizationStatus.Authorized{
            self.eventStore.requestAccessToEntityType(EKEntityType.Event, completion: {
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
    
/* moved to RMSave
    
    func createNewReminderList(name:String, items:[String]){    //forgor e in create -added Mike 082915
        getAccessToEventStoreForType(EKEntityType.Reminder, completion: { (granted) -> Void in
            
        if granted{
            let calender = EKCalendar(forEntityType: EKEntityType.Reminder , eventStore: self.eventStore)
            calender.title = name
            var error:NSError? = nil                                // = nil added by Mike 082915
            calender.source = self.eventStore.defaultCalendarForNewReminders().source
            let calendarWasSaved: Bool
            do {
                try self.eventStore.saveCalendar(calender, commit: true)
                calendarWasSaved = true
            } catch var error1 as NSError {
                error = error1
                calendarWasSaved = false
            } catch {
                fatalError()
            }
            print("Error: \(error)")
       
            
            #if os(iOS) || os(tvOS)
                // Handle situation if the calendar could not be saved
                if calendarWasSaved == false {
                    let alert = UIAlertController(title: "Calendar could not save", message: error?.localizedDescription, preferredStyle: .Alert)
                    let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alert.addAction(OKAction)
                
                    
                    // self.presentViewController(alert, animated: true, completion: nil)
                } else {
                    
                    //todo Anil erro line below here
               // NSUserDefaults.standardUserDefaults().setObject(newCalendar.calendarIdentifier, forKey: "EventTrackerPrimaryCalendar")
                }
            #endif
            
            for item in items{
                let reminder = EKReminder(eventStore: self.eventStore)
                reminder.title = item
                reminder.calendar = calender
                do {
                    try self.eventStore.saveReminder(reminder, commit: true)
                } catch var error1 as NSError {
                    error = error1
                } catch {
                    fatalError()
                }
            }
                }
        })
    }
*/
    
    
    
// ____ addReminder func ____________________________________

/* moved to RMSave
    
    func addReminder(name:String, items:[String]){
        print("p90 in addReminder name: \(name)")
        
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
    
        var destCalendar:EKCalendar?
        let calendars = self.eventStore.calendarsForEntityType(EKEntityType.Reminder)
        
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
                break;
            }
            
            if calendar.title == name {
                destCalendar = calendar as? EKCalendar
                break;
            }
        }
        
*/


        for calendar in calendars {
            //var calendarTitle:String! = calendar.title
            
            // var calendarTitle = calendar.title
            
            print("p110 calendar.title: \(calendar.title)")
            print("p112 _________name: \(name)")
            
            if calendar.title == name {
                destCalendar = calendar as? EKCalendar
                break;
            }
        }
        
        let reminder = EKReminder(eventStore: self.eventStore)
        
        //____ add Reminder Alarm ____________________
        var alarm = EKAlarm()
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss +0000 "
        
        let noDate = dateFormatter.dateFromString("2014-12-12 00:00:00 +0000")  //need this to match set no date from DictateCode
        
        print("p223 Reminder: noDate: \(noDate)")
        
        if (startDT != noDate) {        // if Date != no date string, set alarm for Reminder
            alarm = EKAlarm(absoluteDate: startDT)
        }
        
        reminder.addAlarm(alarm)
        
        //____ end add Reminder Alarm ____________________


        
        
        print("p123 destCalendar: \(destCalendar)")
        
        if destCalendar != nil{
            for item in items{
               // let reminder = EKReminder(eventStore: self.eventStore)
                reminder.title = item
                print("p126 reminder.title: \(reminder.title)")
                print("p126 calendar: \(destCalendar)")
                
                reminder.calendar = destCalendar!
                print("p130 reminder.calendar: \(reminder.calendar)")
                print("p130 reminder: \(reminder)")
                
               
                var error:NSError?
                do {
                    try self.eventStore.saveReminder(reminder, commit: true)
                } catch var error1 as NSError {
                    error = error1
                }
                print("p97 Error: \(error)")
                
            }   //for item...
        } else {    //Save tp default calendar as no name matched.
            
            print("p145 we here??? destCalendar: \(destCalendar)")

            let reminder = EKReminder(eventStore: self.eventStore)

            let calender = EKCalendar(forEntityType: EKEntityType.Reminder , eventStore: self.eventStore)
            calender.title = name
            calender.source = eventStore.defaultCalendarForNewReminders().source
            
            var tempString = ""
            let reminderTitle = items.joinWithSeparator(tempString)  //convert [String] to String for reminder content
            reminder.title = reminderTitle

            var error:NSError? = nil                                // = nil added by Mike 082915
            reminder.calendar = eventStore.defaultCalendarForNewReminders()
            do {
                try self.eventStore.saveReminder(reminder, commit: true)
            } catch var error1 as NSError {
                error = error1
            }

        }   // if dest...
    }
    
*/
 
/* moved to RMSave
     
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
        
        var calendarDatabase = EKEventStore()   // from EKTest code...

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
   
*/
    
/* moved to RMSave
     
//Add item to Reminder List - Mike 082915
    func addReminderMike(name:String, items:[String]){
        let calender = EKCalendar(forEntityType: EKEntityType.Reminder , eventStore: self.eventStore)
        calender.title = name
        var error:NSError?
        calender.source = eventStore.defaultCalendarForNewReminders().source
     //   self.eventStore.saveCalendar(calender, commit: true, error: &error)
        print("p84 Error: \(error)")
        
        print("p84 calender.title: \(calender.title)")
        
        let calendars = self.eventStore.calendarsForEntityType(EKEntityType.Reminder)
        
        var reminderArray:[String] = []
        
        for calendar in calendars {
            var calendarTitle:String! = calendar.title
            
           // var calendarTitle = calendar.title

            print("p95 calendarTitle: \(calendarTitle)")
            
            reminderArray.append(calendarTitle)
            
            print("p95 reminderArray: \(reminderArray)")
       
            
        }
        
        print("p94 calendars: \(calendars)")

        
        for item in items{
            let reminder = EKReminder(eventStore: self.eventStore)
            reminder.title = item
            print("p84 reminder.title: \(reminder.title)")
            print("p84 calendar: \(calender)")

            reminder.calendar = calender
            print("p84 reminder.calendar: \(reminder.calendar)")
            print("p84 reminder: \(reminder)")
            
            do {
                try self.eventStore.saveReminder(reminder, commit: true)
            } catch var error1 as NSError {
                error = error1
            }
            print("p97 Error: \(error)")
   

        }
    }
*/
    
    
    
    func getCalendar(id:String) -> EKCalendar? {            //returns EKCalendar from CalendarID
            print("p447 we here? id: \(id)")
            let temp:EKCalendar = (self.eventStore.calendarWithIdentifier(id))!
            print("p449 temp: \(temp)")
            return self.eventStore.calendarWithIdentifier(id)
        }
    
    
    func getCalendars(type:EKEntityType) -> [EKCalendar]{
        return self.eventStore.calendarsForEntityType(type) as! [EKCalendar]
    }
    
    
    
    //let reminderList = ReminderManager.sharedInstance.getCalendars(EKEntityTypeReminder)
   // let calendarList = ReminderManager.sharedInstance.getCalendars(EKEntityTypeEvent)
    
    
    
    
        //http://www.appcoda.com/ios-event-kit-programming-tutorial/
        
        
        
        func getLocalEventCalendars() -> [AnyObject] {
            var allCalendars: [AnyObject] = self.eventStore.calendarsForEntityType(EKEntityType.Event)
            print("p296 allCalendars: \(allCalendars)")
            
            var localCalendars: [AnyObject] = NSMutableArray() as [AnyObject]
            
 /*
            for var i = 0; i < allCalendars.count; i++ {
                var currentCalendar: EKCalendar = allCalendars.objectAtIndex(i)
                
                if currentCalendar.type == EKCalendarTypeLocal {
                    localCalendars.addObject(currentCalendar)
                }

*/
            
            return localCalendars

       }
    
     /*
        -(NSArray *)getLocalEventCalendars{
            NSArray *allCalendars = [self.eventStore calendarsForEntityType:EKEntityTypeEvent];
            NSMutableArray *localCalendars = [[NSMutableArray alloc] init];
            
            for (int i=0; i<allCalendars.count; i++) {
                EKCalendar *currentCalendar = [allCalendars objectAtIndex:i];
                if (currentCalendar.type == EKCalendarTypeLocal) {
                    [localCalendars addObject:currentCalendar];
                }
            }
            
            return (NSArray *)localCalendars;
        }
        Let’s discuss it a bit. At first, you notice that we get an array with all calendars of any type using the calendarsForEntityType: method of the event store object and by specifying the EKEntityTypeEvent as the kind of the calendars we want to get. Note that this array contains calendars of all types, so we must get only the local ones. For that reason, we initialize a mutable array, and using a loop we check the type of each returned calendar. Every local calendar found in the first array is stored to the mutable one, which is returned at the end. Inside the loop, each calendar (the current calendar) is stored to a EKCalendar object temporarily. As you understand, the EKCalendar class represents a calendar in the Event Kit framework.
        
*/
/*
    func createReminderArray() -> [AnyObject]  {        //called from AppDelegate on startup
        
        
        var allReminders: Array<EKCalendar>= self.eventStore.calendarsForEntityType(EKEntityType.Reminder)
        var calendarList = Array<EKCalendar>()

        
     //   var allReminders: [AnyObject] = self.eventStore.calendarsForEntityType(EKEntityTypeReminder)
        print("p337 allReminders: \(allReminders)")
        
        var localReminders: [AnyObject] = NSMutableArray() as [AnyObject]
        var reminderStringArray:[String] = []
        
        if allReminders != [] {
            for (index, title) in allReminders.enumerate() {
                let reminderList = allReminders[index]
                reminderStringArray.append(reminderList.title)
                }
            }
        
        

      //  let allRemindersHardcoded = ["Reminder list1", "Today", "Tomorrow", "Groceries", "ToCode"]
      //  defaults.setObject(allRemindersHardcoded, forKey: "allRemindersHardcoded")            //sets allRemindersHardcoded
        
     //   var testArrayData = defaults.objectForKey("allRemindersHardcoded") as! [String] //array of the items
        
        print("p497 reminderStringArray: \(reminderStringArray)")
    
        defaults.setObject(reminderStringArray, forKey: "reminderArray")
        
        return allReminders
        
    }

    
*/
    
  
    func createReminderStringArray() {        //called from AppDelegate on startup
        print("p386 we here createReminderStringArray")
        getAccessToEventStoreForType(EKEntityType.Reminder, completion: { (granted) -> Void in
            
            if granted{
        
//        let calender = EKCalendar(forEntityType: EKEntityTypeReminder , eventStore: self.eventStore)
//     
//        var error:NSError?
//        calender.source = self.eventStore.defaultCalendarForNewReminders().source
//        println("p135 Error: \(error)")
        
        let calendars = self.eventStore.calendarsForEntityType(EKEntityType.Reminder)
        
        var reminderArray:[String] = []
    
        
        for calendar in calendars {
            var reminderTitle:String! = calendar.title
            //println("p229 reminderTitle: \(reminderTitle)")
            var length = reminderTitle.characters.count
            //println("p231 length: \(length)")
            
            reminderArray.append(reminderTitle)
        }
        print("p471 reminderArray: \(reminderArray)")
        print("p472 reminderArray.count: \(reminderArray.count)")

        self.defaults.setObject(reminderArray, forKey: "reminderStringArray")            //sets reminderArray
        
        self.defaults.setObject(reminderArray, forKey: "reminderArray")            //sets reminderArray
            }
        })

    }   //func CreateReminderArray

    func createCalendarArray() {        //called from AppDelegate on startup
        
        getAccessToEventStoreForType(EKEntityType.Reminder, completion: { (granted) -> Void in
            
            if granted{
                
        NSLog("%@ p462 createCalendarArray", self)
        print("p413 we here? createCalendarArray")
        
        var allCalendars: Array<EKCalendar>= self.eventStore.calendarsForEntityType(EKEntityType.Event) as!  Array<EKCalendar>
        
        print("p416 allCalendars: \(allCalendars)")
        
        let calender = EKCalendar(forEntityType: EKEntityType.Event , eventStore: self.eventStore)
        print("p418 calender: \(calender)")
            
        //TODO aboveline pints to: 
         //       p418 calender: EKCalendar <0x7f821b4e9350> {title = (null); type = Local; allowsModify = YES; color = (null);}
   
        // from https://www.andrewcbancroft.com/2015/06/17/creating-calendars-with-event-kit-and-swift/
        
        // Use Event Store to create a new calendar instance
        // Configure its title
        let newCalendar = EKCalendar(forEntityType: EKEntityType.Event, eventStore: self.eventStore)
        newCalendar.title = "Some New Calendar Title"
        
        // Access list of available sources from the Event Store
        let sourcesInEventStore = self.eventStore.sources as! [EKSource]
        print("p482 sourcesInEventStore: \(sourcesInEventStore)")
        
  //TODO Anil use only Local calendarsmaybe in out CalendarListArray I made???
        
   //     p167 sourcesInEventStore: [EKSource <0x1700cf880> {UUID = 855E381A-DEF0-4F78-846E-7B7EC1EE990D; type = Local; title = Default; externalID = (null)}, EKSource <0x1700cf5e0> {UUID = BA48C2E6-DA4E-40BA-BCE8-D20FA3F957AF; type = Other; title = Other; externalID = (null)}, EKSource <0x1700cf570> {UUID = 0B17DA80-1504-4142-AAE4-51CB6DC52327; type = CalDAV; title = iCloud; externalID = 0B17DA80-1504-4142-AAE4-51CB6DC52327}, EKSource <0x1700cf730> {UUID = 17673175-ACD9-4C7E-BE76-AE60BF850880; type = Subcribed; title = Subscribed Calendars; externalID = Subscribed Calendars}, EKSource <0x1700d0840> {UUID = 2F54B94E-CDED-491C-A812-760833A10C7A; type = CalDAV; title = Mike Main; externalID = 2F54B94E-CDED-491C-A812-760833A10C7A}, EKSource <0x1700d08b0> {UUID = CC9633E4-021B-4E85-8EE0-082AFFB5A232; type = CalDAV; title = MikeTradr; externalID = CC9633E4-021B-4E85-8EE0-082AFFB5A232}]

        
        // Filter the available sources and select the "Local" source to assign to the new calendar's
        // source property
        
    //TODO Anil can we filter for local calndars only. I get in Arry Mike Derr twice!
       //TODO Anil help we need to file ter calendars of type = calDAV
        
        newCalendar.source = sourcesInEventStore.filter{
            (source: EKSource) -> Bool in
            source.sourceType == EKSourceType.Local
            }.first!
        
        
        
        var error:NSError?
        calender.source = self.eventStore.defaultCalendarForNewEvents.source
        print("p181 Error: \(error)")
        
        let calendars = self.eventStore.calendarsForEntityType(EKEntityType.Event)
        
        var calendarArray:[String] = []
        
        for calendar in calendars {
            var calendarTitle:String! = calendar.title
            print("p189 calendarTitle: \(calendarTitle)")
            
            calendarArray.append(calendarTitle)
        }
        print("p193 calendarArray: \(calendarArray)")
        print("p193 calendarArray.count: \(calendarArray.count)")
        
        self.defaults.setObject(calendarArray, forKey: "calendarArray")            //sets calendarArray of String the names
        self.defaults.synchronize()

            }
        })
    }   //func CreateCalendarArray
   

    
}
