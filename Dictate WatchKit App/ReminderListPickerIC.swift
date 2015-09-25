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
    let defaults = NSUserDefaults(suiteName: "group.com.thatsoft.dictateApp")!
    let eventStore = EKEventStore()
    var checked:Bool = false
    var allReminders:[EKReminder] = []
    var allReminderLists: Array<EKCalendar> = EKEventStore().calendarsForEntityType(EKEntityTypeReminder) as! Array<EKCalendar>
    
    @IBOutlet weak var table: WKInterfaceTable!

    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        NSLog("%@ will activate", self)
        println("w26 in ReminderListPickerIC willActivate")
        
        //loadTableData()
    }
  
    
    func loadTableData () {
        table.setNumberOfRows(allReminderLists.count, withRowType: "tableRow")
        println("w39 allReminderLists.count: \(allReminderLists.count)")

        for (index, title) in enumerate(allReminderLists) {
            println("---------------------------------------------------")
            println("w40 index, title: \(index), \(title)")
            
            let row = table.rowControllerAtIndex(index) as! DefaultReminderListTableRC
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
    }   // end loadTableData func
    
  

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        // Configure interface objects here.
        println("w69 ReminderListPickerIC awakeWithContext")
        println("-----------------------------------------")
        
      //  var sceneTitle:String = (context as? String)!
        self.setTitle("«Settings")

        loadTableData()     //reload table after item is deleted
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        NSLog("%@ did deactivate", self)
        super.didDeactivate()
        println("w89 in ReminderListPickerIC didDeactivate")

    }
    
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        println("w94 clicked on row: \(rowIndex)")
        
        selectedRow = rowIndex //for use with insert and delete, save selcted row index
        let itemRow = self.table.rowControllerAtIndex(rowIndex) as! DefaultReminderListTableRC
        
        if self.checked {               // Turn checkmark off
            itemRow.imageCheckbox.setImageNamed("cbBlank40px")
            self.checked = false
        } else {                        // Turn checkmark on
            itemRow.imageCheckbox.setImageNamed("cbChecked40px")
            let defaultReminderList: EKCalendar = allReminderLists[rowIndex]
            let defaultReminderListID = defaultReminderList.calendarIdentifier
            
            println("w107 defaultReminderListID: \(defaultReminderListID)")
            
            defaults.setObject(defaultReminderListID, forKey: "defaultReminderListID")    //sets defaultReminderListID String
            
            self.checked = true
        }
    }
    
    override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject?
    {
        
      //  let reminderListID = allReminderLists[rowIndex]
        return "todo" //reminderTitle
    }

}
