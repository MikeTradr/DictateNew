//
//  ReminderListsIC.swift
//  Dictate
//
//  Created by Mike Derr on 8/4/15.
//  Copyright (c) 2015 ThatSoft.com. All rights reserved.
//

import WatchKit
import Foundation
import EventKit


class ReminderListsIC: WKInterfaceController {
    
    let defaults = NSUserDefaults(suiteName: "group.com.thatsoft.dictateApp") // from course
    let eventStore = EKEventStore()
    
    var reminders:[EKReminder] = []
    var allReminders:[EKReminder] = []
    var allReminderLists:[EKReminder] = []

    var numberOfNewItems:Int    = 0
    var startDT:NSDate          = NSDate()
    var endDT:NSDate            = NSDate()
    var today:NSDate            = NSDate()
    var events:NSMutableArray   = []
    
   // var reminder: EKCalendar = EKCalendar()
    
    
    @IBOutlet weak var table: WKInterfaceTable!

    
    @IBAction func menuDictate() {
        
     //   let (startDT, endDT, output, outputNote, day, calendarName, actionType) = DictateManagerIC.sharedInstance.grabVoice()
        
    }
    
    @IBAction func menuSettings() {
         presentControllerWithName("Settings", context: "Reminders")
    }

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
           println("w37 RemindersIC awakeWithContext")
        
        super.awakeWithContext(context)
        self.setTitle(context as? String)
        ReminderManager.sharedInstance.fetchReminders({ (reminders) -> Void in
            
            self.allReminderLists = reminders
            
            //self.allReminders = reminders //TRY ABOVE LINE
            
            //self.tableView.reloadData()
            
            //println("w51 self.allReminders: \(self.allReminders)")
            println("w71 self.allReminderLists.count: \(self.allReminderLists.count)")
            
            self.loadTableData()
        })
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        NSLog("%@ will activate", self)
        println("w47 in ReminderIC willActivate")
 
        //ReminderManager.sharedInstance.createNewReminderList("TestMike", items: ["asd","weer"])   //added to make reminder for testing. 
        
     
        
        //println("w60 allReminders: \(self.allReminders.count)")

 
     //   println("w57 in ReminderIC after fetch events")
     //   println("w58 self.reminders: \(self.reminders)")


       
    }
 
    
    func loadTableData () {
        var allReminderLists: Array<EKCalendar> = self.eventStore.calendarsForEntityType(EKEntityTypeReminder) as! Array<EKCalendar>
        
        table.setNumberOfRows(allReminderLists.count, withRowType: "tableRow")
        
        //println("w38 allReminderLists: \(allReminderLists)")
        println("w39 allReminderLists.count: \(allReminderLists.count)")
        
        for (index, title) in enumerate(allReminderLists) {
            println("---------------------------------------------------")
            println("w40 index, title: \(index), \(title)")
            
            let row = table.rowControllerAtIndex(index) as! ReminderListsTableRC
            let reminder = allReminderLists[index]
            
            row.tableRowLabel.setText(reminder.title)
            row.tableRowLabel.setTextColor(UIColor(CGColor: reminder.CGColor))
            row.verticalBar.setBackgroundColor(UIColor(CGColor: reminder.CGColor))
        }
    }   // end loadTableData func
    

   // override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject? {
        
    override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject? {
        
        if segueIdentifier == "ReminderDetails" {
            let reminder = allReminderLists[rowIndex]
            let reminderListID = reminder.calendarItemIdentifier
            println("w113 reminderListID \(reminderListID)")
            
            return reminderListID
        }

        return nil
    }
    
    

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func buttonToday() {
        presentControllerWithName("TodayEvents", context: "Reminders")
    }
    
    @IBAction func buttonMain() {
        presentControllerWithName("Main", context: "Reminders")
    }

}
