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
import AVFoundation



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
    
    var audioPlayer = AVAudioPlayer()
    var reminderListColor:UIColor = UIColor.greenColor()



    
   // var reminder: EKCalendar = EKCalendar()
    
    
    @IBOutlet weak var table: WKInterfaceTable!
    
    //@IBOutlet weak var labelReminderListID: WKInterfaceLabel!
    
    //@IBOutlet weak var labelReminderListID: WKInterfaceLabel!
    @IBOutlet weak var labelReminderListID: WKInterfaceLabel!
    
    //@IBOutlet weak var verticalBar2: WKInterfaceGroup!
    
    @IBOutlet weak var verticalBar2: WKInterfaceGroup!
    @IBOutlet weak var labelShowCompleted: WKInterfaceLabel!
    @IBOutlet weak var labelCompleted: WKInterfaceLabel!
    
    @IBOutlet weak var table2: WKInterfaceTable!
    
    @IBOutlet weak var reminderListsGroup: WKInterfaceGroup!
    @IBOutlet weak var reminderItemsGroup: WKInterfaceGroup!
    @IBOutlet weak var navBarGroup: WKInterfaceGroup!
    
    @IBOutlet weak var backToReminders: WKInterfaceGroup!
    
//---- funcs below here -----------------------------------------------------------
    
    @IBAction func backToRemindersNew() {
        reminderListsGroup.setHidden(false)     //show lists
        reminderItemsGroup.setHidden(true)      //Hide lower table2
        navBarGroup.setHidden(false)            //show  navBar
        showListsView = true
        //self.loadTableData()
        self.setTitle("Reminders")
        
    }
    
    
    
    
    @IBAction func buttonBackToReminders() {
        reminderListsGroup.setHidden(false)     //show lists
        reminderItemsGroup.setHidden(true)      //Hide lower table2
        navBarGroup.setHidden(false)            //show  navBar
        self.setTitle("Reminders")

    }
    
    @IBAction func buttonToReminders() {
        reminderListsGroup.setHidden(false)     //show lists
        reminderItemsGroup.setHidden(true)      //Hide lower table2
        navBarGroup.setHidden(false)            //show  navBar
        showListsView = true
        //self.loadTableData()
        self.setTitle("Reminders")
    }
    
    @IBAction func buttonLeftArrow() {
        reminderListsGroup.setHidden(false)     //show lists
        reminderItemsGroup.setHidden(true)      //Hide lower table2
        navBarGroup.setHidden(false)            //show  navBar
        showListsView = true
        self.setTitle("Reminders")
    }
    
//---- Menu functions -------------------------------------------
    @IBAction func menuDictate() {
        let (startDT, endDT, output, outputNote, day, calendarName, actionType) = DictateManagerIC.sharedInstance.grabVoice()
    }
    
    @IBAction func menuSettings() {
        presentControllerWithName("Settings", context: "Reminders")
    }
//---- end Menu functions ----------------------------------------
    
    override init() {
        super.init()
        
        // Enable data sharing in app extensions.
        Parse.enableDataSharingWithApplicationGroupIdentifier("group.com.thatsoft.dictateApp", containingApplication: "group.com.thatsoft.dictateApp")
        
        // Setup Parse
        Parse.setApplicationId("1wwwPAQ0Of2Fp6flotUw4YzN64HFDmy3ijAlQZKE", clientKey: "EHeeek4uXhJQi0vXPBba945A4h0LQ4QddEGW8gSs")
        
           /*
        //TODO FIX THIS BOMBS MIKE USED TO WORK  LOL
        
        Parse.enableLocalDatastore()
        Parse.enableDataSharingWithApplicationGroupIdentifier("group.com.thatsoft.dictateApp",
            containingApplication: "com.thatsoft.dictateApp")
        Parse.setApplicationId("1wwwPAQ0Of2Fp6flotUw4YzN64HFDmy3ijAlQZKE",
            clientKey: "EHeeek4uXhJQi0vXPBba945A4h0LQ4QddEGW8gSs")
        PFUser.enableAutomaticUser()
     
       */
        
        // other init code, Parse queries, etc here
        
        
        
        
        
        
    }
    


    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        // Configure interface objects here.
        NSLog("%@ w193 awakeWithContext", self)
        println("w105 RemindersIC awakeWithContext")

   /*
        //TODO FIX THIS BOMBS MIKE USED TO WORK  LOL
        
       // Parse.enableLocalDatastore()
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
        
        println("w65 context: \(context)")
        showListsView = true
        self.setTitle("Reminders")
        self.loadTableData()
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        NSLog("%@ w78 will activate", self)
        println("w79 in ReminderListsIC willActivate")
        
      //  ReminderManager.sharedInstance.createNewReminderList("To Code Tomorrow", items: ["item 1","item 2", "This is item 3 hehe"])   //added to make reminder for testing.

        println("w83 in ReminderIC willActivate")

        self.reminderItemsGroup.setHidden(false)  //Hide lower table2
  
        if showListsView {
            self.loadTableData()
            println("w165 showListsView True")
        } else {
            self.loadTableData2()
            println("w165 showListsView False")
        }
  
        //DictateManagerIC.sharedInstance.initalizeParse()
        
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
                let reminderList = allReminderLists[index]
                println("w146 reminderList: \(reminderList)")
  /*
                //TODO Mike TODO Anil  this crashes watch used to work!!!!!!!
  
                // get count or items in each reminder list and set the Text Label
                ReminderManager.sharedInstance.fetchCalendarReminders(reminderList) { (reminders) -> Void in
                    println("w148 reminders: \(reminders)")
                    self.allReminders = reminders as [EKReminder]
                    let numberOfItems = self.allReminders.count
                
                    println("w151 numberOfItems: \(numberOfItems)")
                    if numberOfItems != 0 {
                        println("w156 reminder.title: \(reminderList.title)")
                        println("w157 numberOfItems: \(numberOfItems)")

                       row.tableRowLabel.setText("\(reminderList.title) (\(numberOfItems))")
                        
                        println("w162 here? reminder: \(reminderList)")
                    }

                }   // end ReminderManager call
   */
    
                row.tableRowLabel.setText("\(reminderList.title)")
                row.tableRowLabel.setTextColor(UIColor(CGColor: reminderList.CGColor))
                row.verticalBar.setBackgroundColor(UIColor(CGColor: reminderList.CGColor))

            }
        }
    }   // end loadTableData func
    
    func loadTableData2 () {
        
        self.setTitle("")

        showListsView = false   //set flag when awakes to go to view user was in
        
        backToReminders.setHidden(false)        //show text
        navBarGroup.setHidden(false)            //show  navBar

        let calendarId = reminderListID
        println("w113 reminderListID: \(reminderListID)")
        let calendar = ReminderManager.sharedInstance.eventStore.calendarWithIdentifier(calendarId)
        
        labelReminderListID.setTextColor(UIColor(CGColor: calendar.CGColor))
        verticalBar2.setBackgroundColor(UIColor(CGColor: calendar.CGColor))
        labelShowCompleted.setTextColor(UIColor(CGColor: calendar.CGColor))
        
        self.reminderListColor = UIColor(CGColor: calendar.CGColor)!    //save for selected row later
        
        let reminderListColor:UIColor = UIColor(CGColor: calendar.CGColor)!

        
       // buttonCheckbox.setHidden(true)
        
        ReminderManager.sharedInstance.fetchCalendarReminders(calendar) { (reminders) -> Void in
            println(reminders)
            self.allReminders = reminders as [EKReminder]
            self.numberOfItems = self.allReminders.count
            self.labelReminderListID.setText("\(calendar.title) (\(self.numberOfItems))")
            
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
               //TODO MIKE why here?  Anil row.reminder = item
            }
            //self.loadTableData()
        }
    }       // end loadTableData2 func
    
    
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        //selection of data and presenting it to
        
        if table == self.table {
            let selectedList = allReminderLists[rowIndex]
            reminderListID = selectedList.calendarIdentifier
            println("w156 reminderListID \(reminderListID)")
            
            self.reminderItemsGroup.setHidden(false)  //show lower table2
            self.reminderListsGroup.setHidden(true)  //hide lists
            self.navBarGroup.setHidden(true)  //hide lists

            self.loadTableData2()
        } else {
            var selectedRow:Int! = nil
            
            selectedRow = rowIndex //for use with insert and delete, save selcted row index
            let itemRow = self.table2.rowControllerAtIndex(rowIndex) as! ReminderItemsTableRC
            let reminderItem = allReminders[rowIndex]
            let veryDarkGray = UIColor(red: 128, green: 128, blue: 128)     //light biege color, for Word List
            
            if self.checked {               // Turn checkmark off
                itemRow.imageCheckbox.setImageNamed("cbBlank40px")
                itemRow.tableRowLabel.setTextColor(UIColor.whiteColor())
                reminderItem.completed == false
                self.checked = false
                
                var alertSound1: NSURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("beep-08b", ofType: "mp3")!)!
                
                self.playSound(alertSound1)
            } else {                        // Turn checkmark on
                itemRow.imageCheckbox.setImageNamed("cbChecked40px")
                itemRow.tableRowLabel.setTextColor(veryDarkGray)
                
                var alertSound1: NSURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("124-DeleteWhoosh", ofType: "mp3")!)!
                //TODO Mike TODO Anil fix sound call.
                //DictateManagerIC.sharedInstance.playSound(alertSound1)
                
                self.playSound(alertSound1)
                //self.labelShowCompleted.setText("Item Completed")
                //self.labelShowCompleted.setTextColor(UIColor.yellowColor())
                
                self.labelShowCompleted.setHidden(true)
                self.labelCompleted.setHidden(false)
                
                General().delay(3.0) {          // do stuff
                    self.labelShowCompleted.setHidden(false)
                    self.labelCompleted.setHidden(true)
                   // self.labelShowCompleted.setText("Show Completed")
                    //self.labelShowCompleted.setTextColor(self.reminderListColor)
                    //TODO good to do this???
                    self.loadTableData2()    //refresh table2 after item completed
                }
                
                println("w305 reminderItem: \(reminderItem)")
                println("w306 reminderItem.completed: \(reminderItem.completed)")
                
                reminderItem.completed = true
          
                ReminderManager.sharedInstance.saveReminder(reminderItem)
                
                println("w325 reminderItem.completed: \(reminderItem.completed)")
                
                self.checked = true
            }
        }   //end else if table
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
    
    func playSound(sound: NSURL){
        var error:NSError?
        self.audioPlayer = AVAudioPlayer(contentsOfURL: sound, error: &error)
        self.audioPlayer.prepareToPlay()
        //player.delegate = self player.play()
        //audioPlayer.delegate = self
        self.audioPlayer.play()
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
