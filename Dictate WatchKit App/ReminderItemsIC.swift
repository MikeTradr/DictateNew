//
//  ReminderItemsIC.swift
//  Dictate
//
//  Created by Mike Derr on 9/11/15.
//  Copyright (c) 2015 ThatSoft.com. All rights reserved.
//

import WatchKit
import Foundation
import EventKit


class ReminderItemsIC: WKInterfaceController {
    
    var selectedRow:Int! = nil    
    let defaults = NSUserDefaults(suiteName: "group.com.thatsoft.dictateApp")!

    var allReminders: Array<EKReminder> = []
    var reminderListID: String = ""
    var checked:Bool = false
    var numberOfItems:Int = 0
    
    @IBOutlet weak var table: WKInterfaceTable!
    @IBOutlet weak var labelReminderListID: WKInterfaceLabel!
    @IBOutlet weak var verticalBar: WKInterfaceGroup!
    @IBOutlet weak var buttonShowCompleted: WKInterfaceLabel!
    @IBOutlet weak var buttonCheckbox: WKInterfaceButton!
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        NSLog("%@ will activate", self)
        println("w33 in ReminderItemsIC willActivate")
        
       // loadTableData()
    }
  
    func loadTableData () {
        
        if self.allReminders.count >= 0 {
            table.setNumberOfRows(allReminders.count, withRowType: "tableRow")
        }
        
        println("w45 allCalendarLists: \(allReminders)")
        println("w46 allCalendarLists.count: \(allReminders.count)")
        
        for (index, title) in enumerate(allReminders) {
            println("---------------------------------------------------")
            println("w40 index, title: \(index), \(title)")
            
            let row = table.rowControllerAtIndex(index) as! ReminderItemsTableRC
            let item = allReminders[index]
            
            row.tableRowLabel.setText(item.title)
            row.reminder = item
        }
    }       // end loadTableData func
    
  

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        // Configure interface objects here.
        

    
        let calendarId = context as! String
        let calendar = ReminderManager.sharedInstance.eventStore.calendarWithIdentifier(calendarId)

        labelReminderListID.setTextColor(UIColor(CGColor: calendar.CGColor))
        verticalBar.setBackgroundColor(UIColor(CGColor: calendar.CGColor))
        buttonShowCompleted.setTextColor(UIColor(CGColor: calendar.CGColor))
        
        buttonCheckbox.setHidden(true)
  
        ReminderManager.sharedInstance.fetchCalendarReminders(calendar) { (reminders) -> Void in
            println(reminders)
            self.allReminders = reminders as [EKReminder]
            self.numberOfItems = self.allReminders.count
            self.labelReminderListID.setText("\(calendar.title): (\(self.numberOfItems))")
            self.loadTableData()
        }

       //TODO Anil TODO Mike neede awakeWithContent? or willActivate instead?
       // loadTableData()
        
        println("w73 he here?")
    }
    
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        println("w119 clicked on row: \(rowIndex)")
        
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

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        NSLog("%@ did deactivate", self)
        super.didDeactivate()
        println("p110 in ReminderListPickerIC didDeactivate")

    }
/*
    override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject? {
        
       // let reminderTitle = allRemindersHardcoded[rowIndex]
        return "todo" //reminderTitle
    }
*/

}

extension UIColor
{
    convenience init(red: Int, green: Int, blue: Int)
    {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
}
