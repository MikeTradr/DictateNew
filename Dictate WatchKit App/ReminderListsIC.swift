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
import Parse


class ReminderListsIC: WKInterfaceController {
    
    let defaults = NSUserDefaults(suiteName: "group.com.thatsoft.dictateApp")!
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
    
    var showListsView:Bool = true
    var checked:Bool = false


    
   // var reminder: EKCalendar = EKCalendar()
    
    
    @IBOutlet weak var table: WKInterfaceTable!
    
    //@IBOutlet weak var labelReminderListID: WKInterfaceLabel!
    
    @IBOutlet weak var labelReminderListID: WKInterfaceLabel!
    
  
    @IBOutlet weak var verticalBar2: WKInterfaceGroup!
    @IBOutlet weak var labelShowCompleted: WKInterfaceLabel!
    @IBOutlet weak var table2: WKInterfaceTable!
    
    @IBOutlet weak var reminderListsGroup: WKInterfaceGroup!
    @IBOutlet weak var reminderItemsGroup: WKInterfaceGroup!
    @IBOutlet weak var navBarGroup: WKInterfaceGroup!
    
    @IBOutlet weak var backToReminders: WKInterfaceGroup!
    
//---- funcs below here -----------------------------------------------------------
    
    @IBAction func buttonBackToReminders() {
        reminderListsGroup.setHidden(false)     //show lists
        reminderItemsGroup.setHidden(true)      //Hide lower table2
        navBarGroup.setHidden(false)            //show  navBar
        
    }
    
    @IBAction func buttonToReminders() {
        reminderListsGroup.setHidden(false)     //show lists
        reminderItemsGroup.setHidden(true)      //Hide lower table2
        navBarGroup.setHidden(false)            //show  navBar
        
        showListsView = true
        self.loadTableData()
        
    }
    
    @IBAction func menuDictate() {
        
     //   let (startDT, endDT, output, outputNote, day, calendarName, actionType) = DictateManagerIC.sharedInstance.grabVoice()
        
    }
    
    @IBAction func menuSettings() {
         presentControllerWithName("Settings", context: "Reminders")
    }

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        NSLog("%@ w57 awakeWithContext", self)
   /*
        //TODO FIX THIS BOMBS MIKE USED TO WORK  LOL
        
        Parse.enableLocalDatastore()
        //  PFUser.enableAutomaticUser()
        
        // Enable data sharing in app extensions.
        
        Parse.enableDataSharingWithApplicationGroupIdentifier("group.com.thatsoft.dictateApp",
            containingApplication: "com.thatsoft.dictateApp")
        
        Parse.setApplicationId("1wwwPAQ0Of2Fp6flotUw4YzN64HFDmy3ijAlQZKE",
            clientKey: "EHeeek4uXhJQi0vXPBba945A4h0LQ4QddEGW8gSs")
        
        PFUser.enableAutomaticUser()
 */       
        //get Access to Reminders
        NSLog("%@ w60 appDelegate", self)
        println("w61 call getAccessToEventStoreForType")
        ReminderManager.sharedInstance.getAccessToEventStoreForType(EKEntityTypeReminder, completion: { (granted) -> Void in
            
            if granted{
                println("w65 Reminders granted: \(granted)")
            }
        })
        
        //get Access to Events
        NSLog("%@ w70 appDelegate", self)
        println("w71 call getAccessToEventStoreForType")
        EventManager.sharedInstance.getAccessToEventStoreForType(EKEntityTypeEvent, completion: { (granted) -> Void in
            
            if granted{
                println("w75 Events granted: \(granted)")
            }
        })
        
        
        

        // Configure interface objects here.
        
           println("w61 RemindersIC awakeWithContext")
        
        super.awakeWithContext(context)
        
        println("w65 context: \(context)")
// Crashed here TODO Mike
       // self.setTitle(context as? String)
        
      //  reminderItemsGroup.setHidden(true)  //Hide lower table2
        
        showListsView = true
        
        self.loadTableData()
        //self.loadTableData2()


    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        NSLog("%@ w78 will activate", self)
        println("w79 in ReminderListsIC willActivate")
        
       // ReminderManager.sharedInstance.createNewReminderList("TestMike", items: ["item 1","item 2", "This is item 3 hehe"])   //added to make reminder for testing.

        println("w83 in ReminderIC willActivate")

        self.reminderItemsGroup.setHidden(false)  //Hide lower table2
    /*
        if showListsView {
            self.loadTableData()
        } else {
            self.loadTableData2()
        }
    */
        
    }
 
    
    func loadTableData () {
        NSLog("%@ w102 loadTableData", self)
        showListsView = true
        
        reminderListsGroup.setHidden(false)     //show lists
        reminderItemsGroup.setHidden(true)      //Hide lower table2
        navBarGroup.setHidden(false)            //show  navBar
        backToReminders.setHidden(true)      //Hide lower table2


        self.allReminderLists = ReminderManager.sharedInstance.eventStore.calendarsForEntityType(EKEntityTypeReminder) as! Array<EKCalendar>
        
        table.setNumberOfRows(allReminderLists.count, withRowType: "tableRow")
        
        //println("w38 allReminderLists: \(allReminderLists)")
        println("w137 allReminderLists.count: \(allReminderLists.count)")
        
        if allReminderLists != [] {
            for (index, title) in enumerate(allReminderLists) {
                println("---------------------------------------------------")
                println("w40 index, title: \(index), \(title)")
                
                let row = table.rowControllerAtIndex(index) as! ReminderListsTableRC
                let reminder = allReminderLists[index]
                println("w146 reminder: \(reminder)")
/*
                // get count or items in each reminder list and set the Text Label
                ReminderManager.sharedInstance.fetchCalendarReminders(reminder) { (reminders) -> Void in
                    println("w148 reminders: \(reminders)")
                    self.allReminders = reminders as [EKReminder]
                    let numberOfItems = self.allReminders.count
                    println("w151 numberOfItems: \(numberOfItems)")
                    if numberOfItems != 0 {
                        println("w156 reminder.title: \(reminder.title)")
                        println("w157 numberOfItems: \(numberOfItems)")

                        row.tableRowLabel.setText("\(reminder.title) (\(numberOfItems))")
                        
                        row.tableRowLabel.setTextColor(UIColor(CGColor: reminder.CGColor))
                        row.verticalBar.setBackgroundColor(UIColor(CGColor: reminder.CGColor))
                        
                        println("w162 here? reminder: \(reminder)")
                    }
                        
                }
             */
                
                row.tableRowLabel.setText("\(reminder.title)")
                row.tableRowLabel.setTextColor(UIColor(CGColor: reminder.CGColor))

            }
        }
    }   // end loadTableData func
    
    func loadTableData2 () {
        
        showListsView = false   //set flag when awakes to go to view user was in
        
        navBarGroup.setHidden(false)            //show  navBar

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
        
        self.reminderItemsGroup.setHidden(false)  //show lower table2
        self.reminderListsGroup.setHidden(true)  //hide lists
        self.navBarGroup.setHidden(true)  //hide lists

        self.loadTableData2()

   
        //code goes here
        //presentControllerWithName("Info", context: context)
    }
/*
    override func table2(table2: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        println("w119 clicked on row: \(rowIndex)")
        
        var selectedRow:Int! = nil

        selectedRow = rowIndex //for use with insert and delete, save selcted row index
        let itemRow = self.table.rowControllerAtIndex(rowIndex) as! ReminderItemsTableRC
        let reminderItem = allReminders[rowIndex]
        let veryDarkGray = UIColor(red: 128, green: 128, blue: 128)     //light biege color, for Word List
        
        if self.checked {               // Turn checkmark off
            itemRow.imageCheckbox.setImageNamed("cbBlank40px")
            itemRow.tableRowLabel.setTextColor(UIColor.whiteColor())
            reminderItem.completed == false
            self.checked = false
        } else {                        // Turn checkmark on
            itemRow.imageCheckbox.setImageNamed("cbChecked40px")
            itemRow.tableRowLabel.setTextColor(veryDarkGray)
            reminderItem.completed == true
            self.checked = true
        }
        
        //ReminderManager.sharedInstance.eventStore.saveCalendar(reminder?.calendar, commit: true, error: nil)
        
        // gameRow.rowLabel.setText(object["name"] as? String)
        
        // table.tableRowLabel.setBackgroundColor(UIColor.yellowColor)
        
        //to remove an item from array if clicked row.
        /*      reminderLists.removeAtIndex(rowIndex)
        defaults?.setObject(reminderLists,forKey: "allRemindersHardcoded")
        defaults?.synchronize()
        
        // from tutorial: build a context for the data
        //   var avgPace = RunData.paceSeconds(runData.avgPace(rowIndex))
        //  let context: AnyObject = avgPace as AnyObject
        //  presentControllerWithName("Info", context: context) //present the viewcontroller
        */
        
        //loadTableData()     //reload table after item is deleted
        println("p93 he here?")
    }
    
*/

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
