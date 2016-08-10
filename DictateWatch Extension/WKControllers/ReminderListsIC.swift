//
//  ReminderListsIC.swift
//  DictateWatch
//
//  Created by Mike Derr on 8/4/15.
//  Copyright (c) 2015 ThatSoft.com. All rights reserved.
//

import WatchKit
import Foundation
import EventKit
//import Parse
//import AVFoundation  //commented for new watchExtension 040516
import WatchConnectivity



class ReminderListsIC: WKInterfaceController, DataSourceChangedDelegate {
    
    var session: WCSession? {
        didSet {
            if let session = session {
                session.delegate = self
                session.activateSession()
            }
        }
    }

    
    let defaults    = NSUserDefaults(suiteName: "group.com.thatsoft.dictateApp")!
    let eventStore  = EKEventStore()
    
    var reminders:[EKReminder]          = []
    var allReminders:[EKReminder]       = []
    var allReminderLists:[EKCalendar]   = []

    var numberOfItems:Int       = 0
    var startDT:NSDate          = NSDate()
    var endDT:NSDate            = NSDate()
    var today:NSDate            = NSDate()
    var events:NSMutableArray   = []
    
    var reminderListID:String   = ""
    
    var showListsView:Bool      = true
    var checked:Bool            = false
    
 //   var audioPlayer = AVAudioPlayer() //commented for new watchExtension 040516
    var reminderListColor:UIColor = UIColor.greenColor()
    
    var player: WKAudioFilePlayer!



    
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
   //parse     Parse.enableDataSharingWithApplicationGroupIdentifier("group.com.thatsoft.dictateApp", containingApplication: "group.com.thatsoft.dictateApp")
        
        // Setup Parse
  //parse      Parse.setApplicationId("1wwwPAQ0Of2Fp6flotUw4YzN64HFDmy3ijAlQZKE", clientKey: "EHeeek4uXhJQi0vXPBba945A4h0LQ4QddEGW8gSs")
        
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
        //NSLog("%@ w193 awakeWithContext", self)
        print("w105 RemindersIC awakeWithContext")

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
        //NSLog("%@ w60 appDelegate", self)
        print("w61 call getAccessToEventStoreForType")
        ReminderManager.sharedInstance.getAccessToEventStoreForType(EKEntityType.Reminder, completion: { (granted) -> Void in
            
            if granted{
                print("w65 Reminders granted: \(granted)")
            }
        })
        
        //get Access to Events
        //NSLog("%@ w70 appDelegate", self)
        print("w71 call getAccessToEventStoreForType")
        //FIXME:6
        EventManager.sharedInstance.getAccessToEventStoreForType(EKEntityType.Event, completion: { (granted) -> Void in
            
            if granted{
                print("w75 Events granted: \(granted)")
            }
        })
        
        print("w190 context: \(context)")
        showListsView = true
        self.setTitle("Reminders")
        self.loadTableData()
     
        let filePath = NSBundle.mainBundle().pathForResource("beep-08b", ofType: "mp3")!
        let fileUrl = NSURL.fileURLWithPath (filePath)
        let asset = WKAudioFileAsset (URL: fileUrl)
        let playerItem = WKAudioFilePlayerItem (asset: asset)
        player = WKAudioFilePlayer (playerItem: playerItem)
        
        //self.player.play()
 
        //let alertSound1: NSURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("beep-08b", ofType: "mp3")!)
        
        //TODO Mike Anil replace above with call to Manager!
        //GeneralWatch.sharedInstance.playSound(alertSound1)
    
        
        
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        //NSLog("%@ w78 will activate", self)
        print("w79 in ReminderListsIC willActivate")
        
      //  ReminderManager.sharedInstance.createNewReminderList("To Code Tomorrow", items: ["item 1","item 2", "This is item 3 hehe"])   //added to make reminder for testing.

        print("w83 in ReminderIC willActivate")

        self.reminderItemsGroup.setHidden(false)  //Hide lower table2
  
        if showListsView {
            self.loadTableData()
            print("w165 showListsView True")
        } else {
            self.loadTableData2()
            print("w165 showListsView False")
        }
  
        //DictateManagerIC.sharedInstance.initalizeParse()
        
    }
 
    
    func loadTableData () {
        //NSLog("%@ w102 loadTableData", self)
        showListsView = true
        
        reminderListsGroup.setHidden(false)     //show lists
        reminderItemsGroup.setHidden(true)      //Hide lower table2
        navBarGroup.setHidden(false)            //show  navBar
        backToReminders.setHidden(true)         //Hide lower table2


        self.allReminderLists = ReminderManager.sharedInstance.eventStore.calendarsForEntityType(EKEntityType.Reminder) 
        
        table.setNumberOfRows(allReminderLists.count, withRowType: "tableRow")
        
        print("w235 allReminderLists: \(allReminderLists)")
        print("w236 allReminderLists.count: \(allReminderLists.count)")
  
        if allReminderLists != [] {
            for (index, title) in allReminderLists.enumerate() {
                print("---------------------------------------------------")
                print("w243 index, title: \(index), \(title)")
                print("w244 table.rowControllerAtIndex(index): \(table.rowControllerAtIndex(index))")
                
                if table.rowControllerAtIndex(index) != nil {
                    let row = table.rowControllerAtIndex(index) as! ReminderListsTableRC
                
                    let reminderList = allReminderLists[index]
                    print("w146 reminderList: \(reminderList)")
     // /*
                    //TODO Mike TODO Anil  this crashes watch used to work!!!!!!!
      
                    // get count or items in each reminder list and set the Text Label
                    ReminderManager.sharedInstance.fetchCalendarReminders(reminderList) { (reminders) -> Void in
                        print("w148 reminders: \(reminders)")
                        self.allReminders = reminders as [EKReminder]
                        let numberOfItems = self.allReminders.count
                    
                        print("w151 numberOfItems: \(numberOfItems)")
                        if numberOfItems != 0 {
                            print("w156 reminder.title: \(reminderList.title)")
                            print("w157 numberOfItems: \(numberOfItems)")

                           row.tableRowLabel.setText("\(reminderList.title) (\(numberOfItems))")
                            
                            print("w162 here? reminder: \(reminderList)")
                        }

                    }   // end ReminderManager call
     //  */
        
                    row.tableRowLabel.setText("\(reminderList.title)")
                    row.tableRowLabel.setTextColor(UIColor(CGColor: reminderList.CGColor))
                    row.verticalBar.setBackgroundColor(UIColor(CGColor: reminderList.CGColor))
                    
                    row.imageVerticalBar.setTintColor(UIColor(CGColor: reminderList.CGColor))
                    
                    row.imageVerticalBarRT.setTintColor(UIColor(CGColor: reminderList.CGColor))
                }
            }
        }
    }   // end loadTableData func
    
    func loadTableData2 () {
        
        self.setTitle("")

        showListsView = false   //set flag when awakes to go to view user was in
        
        backToReminders.setHidden(false)        //show text
        navBarGroup.setHidden(false)            //show  navBar

        let calendarId = reminderListID
        print("w113 reminderListID: \(reminderListID)")
        let calendar = ReminderManager.sharedInstance.eventStore.calendarWithIdentifier(calendarId)
        
        labelReminderListID.setTextColor(UIColor(CGColor: calendar!.CGColor))
        verticalBar2.setBackgroundColor(UIColor(CGColor: calendar!.CGColor))
        labelShowCompleted.setTextColor(UIColor(CGColor: calendar!.CGColor))
        
        self.reminderListColor = UIColor(CGColor: calendar!.CGColor)    //save for selected row later
        
        let reminderListColor:UIColor = UIColor(CGColor: calendar!.CGColor)

        
       // buttonCheckbox.setHidden(true)
        
        ReminderManager.sharedInstance.fetchCalendarReminders(calendar!) { (reminders) -> Void in
            print(reminders)
            self.allReminders = reminders as [EKReminder]
            self.numberOfItems = self.allReminders.count
            self.labelReminderListID.setText("\(calendar!.title) (\(self.numberOfItems))")
            
            self.reminderItemsGroup.setHidden(false)  //show lower table2

            if self.allReminders.count >= 0 {
                self.table2.setNumberOfRows(self.allReminders.count, withRowType: "tableRow2")
            }
            
            print("w45 allReminders: \(self.allReminders)")
            print("w46 allReminders.count: \(self.allReminders.count)")
            
            for (index, title) in self.allReminders.enumerate() {
                print("---------------------------------------------------")
                print("w40 index, title: \(index), \(title)")
                
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
            print("w156 reminderListID \(reminderListID)")
            
            self.reminderItemsGroup.setHidden(false)  //show lower table2
            self.reminderListsGroup.setHidden(true)  //hide lists
            self.navBarGroup.setHidden(true)  //hide lists

            self.loadTableData2()
        } else {
            var selectedRow:Int! = nil
            
            selectedRow = rowIndex //for use with insert and delete, save selcted row index
            let row = self.table2.rowControllerAtIndex(rowIndex) as! ReminderItemsTableRC
            let reminderItem = allReminders[rowIndex]
            let veryDarkGray = UIColor(red: 128, green: 128, blue: 128, alpha: 1)     //light biege color, for Word List
            
            if self.checked {               // Turn checkmark off
                row.imageCheckbox.setImageNamed("cbBlank40px")
                row.tableRowLabel.setTextColor(UIColor.whiteColor())
                reminderItem.completed = false
                self.checked = false
                
//                var alertSound1: NSURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("beep-08b", ofType: "mp3")!)
                
 //               self.playSound(alertSound1) ////commented for new watchExtension 040516
            } else {                        // Turn checkmark on
                row.imageCheckbox.setImageNamed("cbChecked40px")
                row.tableRowLabel.setTextColor(veryDarkGray)
                
                var alertSound1: NSURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("124-DeleteWhoosh", ofType: "mp3")!)
                //TODO Mike TODO Anil fix sound call.
                //DictateManagerIC.sharedInstance.playSound(alertSound1)
                
 //               self.playSound(alertSound1) ////commented for new watchExtension 040516
                //self.labelShowCompleted.setText("Item Completed")
                //self.labelShowCompleted.setTextColor(UIColor.yellowColor())
                
                self.labelShowCompleted.setHidden(true)
                self.labelCompleted.setHidden(false)

                print("w305 reminderItem: \(reminderItem)")
                print("w306 reminderItem.completed: \(reminderItem.completed)")
                
                reminderItem.completed = true
          
                //TODO WCFIX ReminderManager.sharedInstance.saveReminder(reminderItem)
                //TODO Anil Mike add code to updated/save reminder as it is completed!!! broke in watchOS2
                let actionType = "saveReminder"
                
                session = WCSession.defaultSession()
                let messageDict = ["action":actionType, "reminderItem":reminderItem]
                
                print("w423 messageDict: \(messageDict)")
                
                session?.sendMessage(messageDict, replyHandler: { (response) in
                    
                    print("w427 Message sent status: \(response["status"])")
                    
                    }, errorHandler: { (error) in
                        //handle error
                        print("w717 error : \(error.localizedDescription)")
                })
                
                
                
                
                
                print("w325 reminderItem.completed: \(reminderItem.completed)")
                
                self.checked = true
                
                WatchGeneral().delay(3.0) {          // do stuff
                    self.labelShowCompleted.setHidden(false)
                    self.labelCompleted.setHidden(true)
                    // self.labelShowCompleted.setText("Show Completed")
                    //self.labelShowCompleted.setTextColor(self.reminderListColor)
                    //TODO good to do this???
                    self.loadTableData2()    //refresh table2 after item completed
                }
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
/*
    func playSound(sound: NSURL){
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOfURL: sound)
        } catch {
        }
        self.audioPlayer.prepareToPlay()
        //player.delegate = self player.play()
        //audioPlayer.delegate = self
        self.audioPlayer.play()
    }
 */

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func buttonToday() {
        presentControllerWithName("Events", context: "Reminders")
    }
    
    @IBAction func buttonMain() {
        presentControllerWithName("Main", context: "Reminders")
    }
    
    func dataSourceDidUpdate(dataSource: DataSource){
        
    }

}

extension ReminderListsIC: WCSessionDelegate {
    
}
