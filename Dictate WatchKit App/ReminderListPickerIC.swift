//
//  ReminderListPickerIC.swift
//  Dictate
//
//  Created by Mike Derr on 9/11/15.
//  Copyright (c) 2015 ThatSoft.com. All rights reserved.
//

import WatchKit
import Foundation
import EventKit


class ReminderListPickerIC: WKInterfaceController {
    
    var selectedRow:Int! = nil
    let defaults = NSUserDefaults(suiteName: "group.com.thatsoft.dictateApp") // from course
    let eventStore = EKEventStore()
    
    @IBOutlet weak var table: WKInterfaceTable!
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        NSLog("%@ will activate", self)
        println("w26 in ReminderListPickerIC willActivate")
        
        loadTableData()
    }
  
    
    func loadTableData () {
         var allReminderLists: Array<EKCalendar> = self.eventStore.calendarsForEntityType(EKEntityTypeReminder) as! Array<EKCalendar>
        
        table.setNumberOfRows(allReminderLists.count, withRowType: "tableRow")

        //println("w38 allReminderLists: \(allReminderLists)")
        println("w39 allReminderLists.count: \(allReminderLists.count)")

        for (index, title) in enumerate(allReminderLists) {
            println("---------------------------------------------------")
            println("w40 index, title: \(index), \(title)")
            
            let row = table.rowControllerAtIndex(index) as! SettingsReminderTableRC
            let reminder = allReminderLists[index]
            
            row.tableRowLabel.setText(reminder.title)
            row.tableRowLabel.setTextColor(UIColor(CGColor: reminder.CGColor))
            row.verticalBar.setBackgroundColor(UIColor(CGColor: reminder.CGColor))
        }
    }   // end loadTableData func
    
  

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        // Configure interface objects here.
        println("w58 ReminderListPickerIC")
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
        
        
        loadTableData()     //reload table after item is deleted
        
        println("w82 we here?")
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        NSLog("%@ did deactivate", self)
        super.didDeactivate()
        println("w89 in ReminderListPickerIC didDeactivate")

    }
    
    override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject?
    {
        
      //  let reminderListID = allReminderLists[rowIndex]
        return "todo" //reminderTitle
    }
    
    @IBAction func buttonMainIC() {
        
        pushControllerWithName("Main", context: "Reminders")

    }

    @IBAction func buttonReminders() {
        
        pushControllerWithName("Reminders", context: "Reminders")
        
    }

}
