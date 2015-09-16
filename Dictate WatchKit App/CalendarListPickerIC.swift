//
//  CalendarListPickerIC.swift
//  Dictate
//
//  Created by Mike Derr on 9/15/15.
//  Copyright (c) 2015 ThatSoft.com. All rights reserved.
//

import WatchKit
import Foundation
import EventKit


class CalendarListPickerIC: WKInterfaceController {
    
   // var allRemindersHardcoded = [String]()
   // var allCalendarLists = [String]()
    var selectedRow:Int! = nil
    
    @IBOutlet weak var table: WKInterfaceTable!
    
    let defaults = NSUserDefaults(suiteName: "group.com.thatsoft.dictateApp") // from course

    let eventStore = EKEventStore()
    
   // var allReminders: Array<EKCalendar> = []
    
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        NSLog("%@ will activate", self)
        println("p93 in ReminderListPickerIC willActivate")
        
        loadTableData()
    }
  
    
    func loadTableData () {
        let allCalendarLists: Array<EKCalendar> = self.eventStore.calendarsForEntityType(EKEntityTypeEvent) as! Array<EKCalendar>
        
        table.setNumberOfRows(allCalendarLists.count, withRowType: "tableRow")
        
        //println("w45 allCalendarLists: \(allCalendarLists)")
        println("w46 allCalendarLists.count: \(allCalendarLists.count)")
        
        for (index, title) in enumerate(allCalendarLists) {
            println("---------------------------------------------------")
            println("w40 index, title: \(index), \(title)")
            
            let row = table.rowControllerAtIndex(index) as! SettingsCalendarTableRC
            let item = allCalendarLists[index]
            
            row.tableRowLabel.setText(item.title)
            row.tableRowLabel.setTextColor(UIColor(CGColor: item.CGColor))
            row.verticalBar.setBackgroundColor(UIColor(CGColor: item.CGColor))
        }
    }   //end loadTableData
    
  

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        // Configure interface objects here.
        println("p19 ReminderListPickerIC")
        println("-----------------------------------------")
        //someone on stackoverflow ttied this... application?  //Anil this help?
        // http://stackoverflow.com/questions/30561310/fetching-reminders-in-background-using-eventkit
     /*
        // First let iOS know you're starting a background task
        let taskIdentifier = application.beginBackgroundTaskWithExpirationHandler() {
            () -> Void in
            // Do something when task is taking too long
        }
        // Then do the async call to EKEventStore
        eventStore.fetchRemindersMatchingPredicate(predicate, completion: {
            [unowned self] reminders in
            // Do what I have to do, and afterwards end the background task:
            application.endBackgroundTask(taskIdentifier)
            })
        
     */
        
        
        
        self.eventStore.reset() //did not fix: 2015-09-12 00:13:38.233 Dictate WatchKit Extension[68474:820907] Error getting all calendars: Error Domain=EKCADErrorDomain Code=1013 "The operation couldn’t be completed. (EKCADErrorDomain error 1013.)w69 allReminders: []
        
        var allReminders: Array<EKCalendar>= self.eventStore.calendarsForEntityType(EKEntityTypeReminder) as!  Array<EKCalendar>
        
       // let allCalendars : [EKCalendar] = self.eventStore.calendarsForEntityType(EKEntityTypeEvent) as! [EKCalendar]
        //let calendars = allCalendars.filter { $0.calendarIdentifier == self.calendarIdentifier }
        
        //println("w69 allCalendars: \(allCalendars)")
        
        println("w69 allReminders: \(allReminders)")

        
 /*
        allRemindersHardcoded = defaults?.objectForKey("allRemindersHardcoded") as! [String] //array of the items
        
        println("w30 allRemindersHardcoded: \(allRemindersHardcoded)")   //from rob course
        
        
        if defaults?.objectForKey("allRemindersHardcoded") != nil {
            var allRemindersHardcoded = defaults?.objectForKey("allRemindersHardcoded") as! [String] //array of the items
            
            println("w64 allRemindersHardcoded: \(allRemindersHardcoded)")   //from rob course
            println("w64 allRemindersHardcoded.count: \(allRemindersHardcoded.count)")
        }
*/
       //TODO Anil TODO Mike needed? or willActivate instead?
        loadTableData()
        
        println("p79 he here?")

    }
    
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        println("w119 clicked on row: \(rowIndex)")
        
        selectedRow = rowIndex //for use with insert and delete, save selcted row index
        
        //to remove an item from array if clicked row.
  /*      reminderLists.removeAtIndex(rowIndex)
        defaults?.setObject(reminderLists,forKey: "allRemindersHardcoded")
        defaults?.synchronize()
   */
     //TODO Mike TODO Anil get reuseablecell working
    //    let cell = NSObject.dequeueReusableCellWithIdentifier("tableRowController", forIndexPath: indexPath) as! tableRowController
        //need to set the background of button at index
        
   //     self.table.tableRowLabel.setTextColor(UIColor.yellowColor(), context: rowIndex)
        


  //      self.table.buttonCheckbox.setBackgroundImage(UIImage(named: "cbChecked40px"))
        
        //to segue...
       // self.pushControllerWithName("anotherController", context: rowIndex))
        
        // from tutorial: build a context for the data
     //   var avgPace = RunData.paceSeconds(runData.avgPace(rowIndex))
     //  let context: AnyObject = avgPace as AnyObject
      //  presentControllerWithName("Info", context: context) //present the viewcontroller
        
        
    
        
        loadTableData()     //reload table after item is deleted
        
        println("p93 he here?")
    }




    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        NSLog("%@ did deactivate", self)
        super.didDeactivate()
        println("p110 in ReminderListPickerIC didDeactivate")

    }
/*
    override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject?
    {
        
      //  let calendarTitle = allCalendarLists[rowIndex]
        return //calendarTitle
    }
*/
    @IBAction func buttonMainIC() {
        
        pushControllerWithName("Main", context: "Today")

    }

    @IBAction func buttonReminders() {
        
        pushControllerWithName("Reminders", context: "Today")
        
    }

}
