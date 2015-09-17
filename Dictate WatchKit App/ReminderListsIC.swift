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
    var allReminderLists:[EKCalendar] = []

    var numberOfItems:Int       = 0
    var startDT:NSDate          = NSDate()
    var endDT:NSDate            = NSDate()
    var today:NSDate            = NSDate()
    var events:NSMutableArray   = []
    
    var reminderListID:String   = ""
    
   // var reminder: EKCalendar = EKCalendar()
    
    
    @IBOutlet weak var table: WKInterfaceTable!
    @IBOutlet weak var labelReminderListID: WKInterfaceLabel!
    @IBOutlet weak var verticalBar2: WKInterfaceGroup!
    @IBOutlet weak var labelShowCompleted: WKInterfaceLabel!
    @IBOutlet weak var table2: WKInterfaceTable!
    
    @IBOutlet weak var reminderListsGroup: WKInterfaceGroup!
    @IBOutlet weak var reminderItemsGroup: WKInterfaceGroup!
    
    
    
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
        
        println("w63 context: \(context)")
// Crashed here TODO Mike
       // self.setTitle(context as? String)
        
      //  reminderItemsGroup.setHidden(true)  //Hide lower table2
  
       // self.loadTableData()
        //self.loadTableData2()


    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        NSLog("%@ w78 will activate", self)
        println("w79 in ReminderIC willActivate")
        
        ReminderManager.sharedInstance.createNewReminderList("TestMike", items: ["item 1","item 2", "This is item 3 hehe"])   //added to make reminder for testing.

        println("w83 in ReminderIC willActivate")

        
        reminderItemsGroup.setHidden(true)  //Hide lower table2
        
        self.loadTableData()
        //self.loadTableData2()
 
        
        
        //println("w60 allReminders: \(self.allReminders.count)")

 
     //   println("w57 in ReminderIC after fetch events")
     //   println("w58 self.reminders: \(self.reminders)")


       
    }
 
    
    func loadTableData () {
        NSLog("%@ w102 loadTableData", self)

        self.allReminderLists = ReminderManager.sharedInstance.eventStore.calendarsForEntityType(EKEntityTypeReminder) as! Array<EKCalendar>
        
        table.setNumberOfRows(allReminderLists.count, withRowType: "tableRow")
        
        //println("w38 allReminderLists: \(allReminderLists)")
        println("w39 allReminderLists.count: \(allReminderLists.count)")
        
        if allReminderLists != [] {
            for (index, title) in enumerate(allReminderLists) {
                println("---------------------------------------------------")
                println("w40 index, title: \(index), \(title)")
                
                let row = table.rowControllerAtIndex(index) as! ReminderListsTableRC
                let reminder = allReminderLists[index]
                
                ReminderManager.sharedInstance.fetchCalendarReminders(reminder) { (reminders) -> Void in
                    //println(reminders)
                    self.allReminders = reminders as [EKReminder]
                    let numberOfItems = self.allReminders.count
                    //println("w98 numberOfItems: \(numberOfItems)")

                row.tableRowLabel.setText("\(reminder.title) (\(numberOfItems))")
                row.tableRowLabel.setTextColor(UIColor(CGColor: reminder.CGColor))
                row.verticalBar.setBackgroundColor(UIColor(CGColor: reminder.CGColor))
                }
            }
        }
    }   // end loadTableData func
    
    func loadTableData2 () {
        
        let calendarId = reminderListID
        println("w113 reminderListID: \(reminderListID)")
        let calendar = ReminderManager.sharedInstance.eventStore.calendarWithIdentifier(calendarId)
        
        labelReminderListID.setTextColor(UIColor(CGColor: calendar.CGColor))
        verticalBar2.setBackgroundColor(UIColor(CGColor: calendar.CGColor))
        labelShowCompleted.setTextColor(UIColor(CGColor: calendar.CGColor))
        
       // buttonCheckbox.setHidden(true)
        
        ReminderManager.sharedInstance.fetchCalendarReminders(calendar) { (reminders) -> Void in
            println(reminders)
            self.allReminders = reminders as [EKReminder]
            self.numberOfItems = self.allReminders.count
            self.labelReminderListID.setText("\(calendar.title): (\(self.numberOfItems))")
            
            self.reminderItemsGroup.setHidden(false)  //show lower table2

            if self.allReminders.count >= 0 {
                self.table2.setNumberOfRows(self.allReminders.count, withRowType: "tableRow2")
            }
            
            println("w45 allCalendarLists: \(self.allReminders)")
            println("w46 allCalendarLists.count: \(self.allReminders.count)")
            
            for (index, title) in enumerate(self.allReminders) {
                println("---------------------------------------------------")
                println("w40 index, title: \(index), \(title)")
                
                let row = self.table2.rowControllerAtIndex(index) as! ReminderItemsTableRC
                let item = self.allReminders[index]
                
                row.tableRowLabel.setText(item.title)
                row.reminder = item
            }
            //self.loadTableData()
        }
    }       // end loadTableData2 func
    
    
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        //selection of data and presenting it to
        
        let selectedList = allReminderLists[rowIndex]
        reminderListID = selectedList.calendarIdentifier
        println("w156 reminderListID \(reminderListID)")
        
        reminderItemsGroup.setHidden(false)  //show lower table2
        reminderListsGroup.setHidden(true)  //show lower table2
        
        self.loadTableData2()


       
        //code goes here
        //presentControllerWithName("Info", context: context)
    }
    
    

   // override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject? {
 /*  // removed for 2 table scene
    
    override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject? {
        
        if segueIdentifier == "ReminderDetails" {
            let selectedList = allReminderLists[rowIndex]
            let reminderListID = selectedList.calendarIdentifier
            println("w113 reminderListID \(reminderListID)")
            
            return reminderListID
        }

        return nil
    }
*/
    

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
