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
    
    var allRemindersHardcoded = [String]()
    var reminderLists = [String]()
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
        
        //check watch screen sixee 38mm or 42mm then set lable font size to 12 or 15
   /*
        if watchsize 14 {
            set font sixe 15
        } else {
            set font size 12
        }
    */
        
       // var allReminderItems: Array<EKCalendar> = ReminderManager.createReminderArray //get all individual reminders

        
         var allReminderLists: Array<EKCalendar>= self.eventStore.calendarsForEntityType(EKEntityTypeReminder) as! Array<EKCalendar>
        
        if defaults?.objectForKey("reminderStringArray") != nil {
            reminderLists = defaults?.objectForKey("reminderStringArray") as! [String] //array of the items
            
          //  println("w30 reminderLists: \(reminderLists)")
          //  println("w31 reminderLists.count: \(reminderLists.count)")
            println("-----------------------------------------")
            
            println("w46 allReminders: \(allReminderLists)")
            println("w47 allReminders.count: \(allReminderLists.count)")
            println("-----------------------------------------")
            
        }
        
        table.setNumberOfRows(allReminderLists.count, withRowType: "tableRow")

        println("p36 he here?")
        println("w37 reminderLists: \(reminderLists)")
        println("w38 allReminders: \(allReminderLists)")


        for (index, title) in enumerate(allReminderLists) {
            println("-----------------------------------")
            println("w40 index: \(index)")
            println("w41 title: \(title)")
            
            let row = table.rowControllerAtIndex(index) as! tableRowController
            
            let reminder = allReminderLists[index]
   
            //row.tableRowLabel.setText(title)  //works for string array
            
            row.tableRowLabel.setText(reminder.title)
            row.tableRowLabel.setTextColor(UIColor(CGColor: reminder.CGColor))
            row.verticalBar.setBackgroundColor(UIColor(CGColor: reminder.CGColor))
            
            println("w45 row.tableRowLabel.setText(reminder.title) \(row.tableRowLabel.setText(reminder.title))")
            
        }

        //Same loop as above?
/*
        for var i = 0; i < 16; i++ {
            
      //  for var i = 0; i < allReminders.count; i++ {

            
             println("w96 allReminders.count: \(allReminders.count)")
            println("w96 i: \(i)")

            
            
            let row = table.rowControllerAtIndex(i) as! tableRowController
            
            println("w96 row: \(row)")

            let reminder = allReminders[i]
            
            println("w96 reminder: \(reminder)")

            
            //row.tableRowLabel.setText(title)  //works for string array
            
            row.tableRowLabel.setText(reminder.title)
            
            println("w45 row.tableRowLabel.setText(reminder.title) \(row.tableRowLabel.setText(reminder.title))")
            
            println("w96 ----------------------------)")



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
