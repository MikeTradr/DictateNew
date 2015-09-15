//
//  RemindersIC.swift
//  Dictate
//
//  Created by Mike Derr on 8/4/15.
//  Copyright (c) 2015 ThatSoft.com. All rights reserved.
//

import WatchKit
import Foundation
import EventKit


class RemindersIC: WKInterfaceController {
    
    @IBOutlet weak var table: WKInterfaceTable!
    
    let defaults = NSUserDefaults(suiteName: "group.com.thatsoft.dictateApp") // from course
    let eventStore = EKEventStore()
    
    var reminders:[EKReminder] = []
    var allReminders:[EKReminder] = []

    var numberOfNewItems:Int    = 0
    var startDT:NSDate          = NSDate()
    var endDT:NSDate            = NSDate()
    var today:NSDate            = NSDate()
    var events:NSMutableArray   = []
    

    

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
           println("p19 RemindersIC")
        
        super.awakeWithContext(context)
        self.setTitle(context as? String)
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        NSLog("%@ will activate", self)
        println("w45 in ReminderIC willActivate")
 
        //ReminderManager.sharedInstance.createNewReminderList("TestMike", items: ["asd","weer"])   //added to make reminder for testing. 
        
        ReminderManager.sharedInstance.fetchReminders({ (reminders) -> Void in
            self.allReminders = reminders
            //self.tableView.reloadData()
            
            println("w51 self.allReminders: \(self.allReminders)")
            println("w52 self.allReminders.count: \(self.allReminders.count)")
            
        })
        
        println("w60 allReminders: \(self.allReminders.count)")

 
     //   println("w57 in ReminderIC after fetch events")
     //   println("w58 self.reminders: \(self.reminders)")


        loadTableData()
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
    
    func fetchReminders(completion:([EKReminder])->Void) {
        println("w89 we here? fetchReminders")
        
        getAccessToEventStoreForType(EKEntityTypeReminder, completion: { (granted) -> Void in
            
            if granted{
                println("granted: \(granted)")
                
                let allReminders = self.eventStore.calendarsForEntityType(EKEntityTypeReminder)
                
                println("w98 allReminders: \(allReminders)")
                
                var predicate = self.eventStore.predicateForIncompleteRemindersWithDueDateStarting(nil, ending: nil, calendars: allReminders)
                self.eventStore.fetchRemindersMatchingPredicate(predicate) { reminders in
                    completion(reminders as! [EKReminder]!)
                }
            }
            
            println("w106 allReminders: \(self.allReminders)")

            self.loadTableData()
        })
    }
 
    
    func loadTableData() {
        println("w114 in loadTableData")
        println("w115 allReminders: \(allReminders)")
        
        for (index, title) in enumerate(self.allReminders) {
            println("-----------------------------------")
            
            let reminder = self.allReminders[index]
            
            println("w126 index: \(index)")
            println("w127 title: \(reminder.title)")
            //  println("w128 color: \(reminder.color)")
            
            let row = self.table.rowControllerAtIndex(index) as! ReminderTableRowController
            
            
            
            //row.tableRowLabel.setText(title)  //works for string array
            
            row.tableRowLabel.setText(reminder.title)
            row.tableRowLabel.setTextColor(UIColor(CGColor: reminder.calendar.CGColor))
            //  row.verticalBar.setBackgroundColor(UIColor(CGColor: reminder.calendar.CGColor))
            
            println("w45 row.tableRowLabel.setText(reminder.title) \(row.tableRowLabel.setText(reminder.title))")
            
        }
        
    
    }
    
    
    func loadTableDataOLD () {
        println("w46 in loadTableData")
        
        ReminderManager.sharedInstance.fetchReminders({ (reminders) -> Void in
            self.reminders = reminders
            //self.tableView.reloadData()
            
            println("w117 self.reminders: \(self.reminders)")
            println("w118 self.reminders.count: \(self.reminders.count)")
        
        
        
        println("w122 self.reminders: \(self.reminders)")
        println("w123 self.reminders.count: \(self.reminders.count)")
        println("w124 here after call to fetchReminders")
        
        for (index, title) in enumerate(self.reminders) {
            println("-----------------------------------")
            
            let reminder = self.reminders[index]
            
            println("w126 index: \(index)")
            println("w127 title: \(reminder.title)")
          //  println("w128 color: \(reminder.color)")
            
            let row = self.table.rowControllerAtIndex(index) as! ReminderTableRowController
            
            
            
            //row.tableRowLabel.setText(title)  //works for string array
            
            row.tableRowLabel.setText(reminder.title)
            row.tableRowLabel.setTextColor(UIColor(CGColor: reminder.calendar.CGColor))
          //  row.verticalBar.setBackgroundColor(UIColor(CGColor: reminder.calendar.CGColor))
            
            println("w45 row.tableRowLabel.setText(reminder.title) \(row.tableRowLabel.setText(reminder.title))")
            
        }
            
    })
        

      /*
        var allReminders: Array<EKCalendar>= self.eventStore.calendarsForEntityType(EKEntityTypeReminder) as! Array<EKCalendar>
        
        if defaults?.objectForKey("reminderStringArray") != nil {
            reminderLists = defaults?.objectForKey("reminderStringArray") as! [String] //array of the items
            
            println("w30 reminderLists: \(reminderLists)")
            println("w31 reminderLists.count: \(reminderLists.count)")
            println("-----------------------------------------")
            
            println("w46 allReminders: \(allReminders)")
            println("w47 allReminders.count: \(allReminders.count)")
            println("-----------------------------------------")
            
        }
        
        table.setNumberOfRows(reminderLists.count, withRowType: "tableRow")
        
        println("p36 he here?")
        println("w37 reminderLists: \(reminderLists)")
        println("w38 allReminders: \(allReminders)")
        
        
        for (index, title) in enumerate(allReminders) {
            println("-----------------------------------")
            println("w40 index: \(index)")
            println("w41 title: \(title)")
            
            let row = table.rowControllerAtIndex(index) as! tableRowController
            
            let reminder = allReminders[index]
            
            //row.tableRowLabel.setText(title)  //works for string array
            
            row.tableRowLabel.setText(reminder.title)
            
            println("w45 row.tableRowLabel.setText(reminder.title) \(row.tableRowLabel.setText(reminder.title))")
            
        }
        
        //Same loop as above?
        
        for var i = 0; i < allReminders.count; i++ {
            
            let row = table.rowControllerAtIndex(i) as! tableRowController
            /*
            row.lightbulbImage.setImageNamed(lightbulbs[i]["state"])
            if lightbulbs[i]["state"] == "off" {
            row.lightbulbButton.setTitle("On")
            } else {
            row.lightbulbButton.setTitle("Off")
            }
            */
        }
      
*/
    }
    
    
    

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func buttonToday() {
        pushControllerWithName("TodayEvents", context: "Reminders")

    }
    
    @IBAction func buttonMain() {
        pushControllerWithName("Main", context: "Reminders")

    }

}
