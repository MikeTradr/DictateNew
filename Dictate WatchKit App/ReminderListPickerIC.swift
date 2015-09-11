//
//  ReminderListPickerIC.swift
//  Dictate
//
//  Created by Mike Derr on 9/11/15.
//  Copyright (c) 2015 ThatSoft.com. All rights reserved.
//

import WatchKit
import Foundation


class ReminderListPickerIC: WKInterfaceController {
    
    var allRemindersHardcoded = [String]()
    var reminderLists = [String]()
    
    @IBOutlet weak var table: WKInterfaceTable!
    
    let defaults = NSUserDefaults(suiteName: "group.com.thatsoft.dictateApp") // from course

  
    
    private func loadTableData () {
    
        if defaults?.objectForKey("allRemindersHardcoded") != nil {
            reminderLists = defaults?.objectForKey("allRemindersHardcoded") as! [String] //array of the items
            
            println("w30 reminderLists: \(reminderLists)")
            println("w31 reminderLists.count: \(reminderLists.count)")
            println("-----------------------------------------")
        }
        
        table.setNumberOfRows(reminderLists.count, withRowType: "tableRowController")

        println("p36 he here?")
        println("w37 reminderLists: \(reminderLists)")

        for (index, title) in enumerate(reminderLists) {
            println("-----------------")
            println("w40 index: \(index)")
            println("w41 title: \(title)")
            
            let row = table.rowControllerAtIndex(index) as! tableRowController
   
            row.tableRowLabel.setText(title)
            
            println("w45 row.tableRowLabel.setText(item): \(row.tableRowLabel.setText(title))")
            
        }
        
            println("p52 he here?")

    }
    
    
    

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        // Configure interface objects here.
        println("p19 ReminderListPickerIC")
        println("-----------------------------------------")
 /*
        allRemindersHardcoded = defaults?.objectForKey("allRemindersHardcoded") as! [String] //array of the items
        
        println("w30 allRemindersHardcoded: \(allRemindersHardcoded)")   //from rob course
        
        
        if defaults?.objectForKey("allRemindersHardcoded") != nil {
            var allRemindersHardcoded = defaults?.objectForKey("allRemindersHardcoded") as! [String] //array of the items
            
            println("w64 allRemindersHardcoded: \(allRemindersHardcoded)")   //from rob course
            println("w64 allRemindersHardcoded.count: \(allRemindersHardcoded.count)")
        }
*/
        loadTableData()
        
        println("p79 he here?")

    }
    
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        println("w69 Item been removed from array at index: \(rowIndex)")
        
        //to remove an item from array if clicked row.
        reminderLists.removeAtIndex(rowIndex)
        defaults?.setObject(reminderLists,forKey: "allRemindersHardcoded")
        defaults?.synchronize()
        
        loadTableData()     //reload table after item is deleted
        
        println("p93 he here?")
    }


    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        NSLog("%@ will activate", self)
        println("p93 in ReminderListPickerIC willActivate")
        
        loadTableData()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        NSLog("%@ did deactivate", self)
        super.didDeactivate()
        println("p110 in ReminderListPickerIC didDeactivate")

    }
    
    override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject?
    {
        
        let reminderTitle = allRemindersHardcoded[rowIndex]
        return reminderTitle
    }
    
    @IBAction func buttonMainIC() {
        
        pushControllerWithName("Main", context: "Today")

    }

    @IBAction func buttonReminders() {
        
        pushControllerWithName("Reminders", context: "Today")
        
    }

}
