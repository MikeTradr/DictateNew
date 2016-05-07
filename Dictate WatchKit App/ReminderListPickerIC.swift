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
import WatchConnectivity


class ReminderListPickerIC: WKInterfaceController, WCSessionDelegate {
    
    var selectedRow:Int! = nil
    let defaults = NSUserDefaults(suiteName: "group.com.thatsoft.dictateApp")!
    let eventStore = EKEventStore()
    var checked:Bool = false
    var allReminders:[EKReminder] = []
    var allReminderLists: Array<EKCalendar> = EKEventStore().calendarsForEntityType(EKEntityType.Reminder)
    
    private let session : WCSession? = WCSession.isSupported() ? WCSession.defaultSession() : nil
    
    override init() {
        super.init()
        
        session?.delegate = self
        session?.activateSession()
    }
    
    @IBOutlet weak var table: WKInterfaceTable!

    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        NSLog("%@ will activate", self)
        print("w26 in ReminderListPickerIC willActivate")
        
        //loadTableData()
    }
  
    
    func loadTableData () {
        table.setNumberOfRows(allReminderLists.count, withRowType: "tableRow")
        print("w39 allReminderLists.count: \(allReminderLists.count)")

        for (index, title) in allReminderLists.enumerate() {
            print("---------------------------------------------------")
            print("w40 index, title: \(index), \(title)")
            
            let row = table.rowControllerAtIndex(index) as! DefaultReminderListTableRC
            let reminder = allReminderLists[index]
            
            
            // Check if deafults is there, then set default item to be checked
            if defaults.stringForKey("defaultReminderID") != "" {
                if let defaultReminderID  = defaults.stringForKey("defaultReminderID") {
                    
                    print("p133 defaultReminderID: \(defaultReminderID)")
                    print("p134 reminder.calendarIdentifier: \(reminder.calendarIdentifier)")
                    
                    if reminder.calendarIdentifier == defaultReminderID {               // add checkmark for default reminder
                        print("p135 WE HERE")
                        
                        row.imageCheckbox.setImageNamed("cbChecked40px")    // Turn checkmark on
                    } else {
                        row.imageCheckbox.setImageNamed("cbBlank40px")      // Turn checkmark off
                    }
                }
            }
            
            
            
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
        print("w69 ReminderListPickerIC awakeWithContext")
        print("-----------------------------------------")
        
      //  var sceneTitle:String = (context as? String)!
        self.setTitle("«Settings")

        loadTableData()     //reload table after item is deleted
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        NSLog("%@ did deactivate", self)
        super.didDeactivate()
        print("w89 in ReminderListPickerIC didDeactivate")

    }
    
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        print("w94 clicked on row: \(rowIndex)")
        
        selectedRow = rowIndex //for use with insert and delete, save selcted row index
        let row = self.table.rowControllerAtIndex(rowIndex) as! DefaultReminderListTableRC
        
        if self.checked {               // Turn checkmark off
            row.imageCheckbox.setImageNamed("cbBlank40px")
            self.checked = false
        } else {                        // Turn checkmark on
            row.imageCheckbox.setImageNamed("cbChecked40px")
            let defaultReminderList: EKCalendar = allReminderLists[rowIndex]
            let defaultReminderID = defaultReminderList.calendarIdentifier
            
            print("w122 defaultReminderID: \(defaultReminderID)")
            
           // defaults.setObject(defaultReminderListID, forKey: "defaultReminderListID")    //sets defaultReminderListID String   //removed had old key. 121215
            
            defaults.setObject(defaultReminderID, forKey: "defaultReminderID")    //sets defaultReminderListID String
            
            //send to Phone App
            let key = ["defaultReminderID" : defaultReminderID]
            print("w141 key: \(key)")
            
            // The paired iPhone has to be connected via Bluetooth.
            if let session = session where session.reachable {
                session.sendMessage(key,
                                    replyHandler: { replyData in
                                        // handle reply from iPhone app here
                                        print(replyData)
                    }, errorHandler: { error in
                        // catch any errors here
                        print(error.description)
                })
            } else {
                // when the iPhone is not connected via Bluetooth
            }
            
            
            
            
            self.checked = true
        }
    }
    
    override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject?
    {
        
      //  let reminderListID = allReminderLists[rowIndex]
        return "todo" //reminderTitle
    }

}
