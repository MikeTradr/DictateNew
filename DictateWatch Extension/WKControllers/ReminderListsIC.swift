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
                session.activate()
            }
        }
    }

    
    let defaults    = UserDefaults(suiteName: "group.com.thatsoft.dictateApp")!
    let eventStore  = EKEventStore()
    
    var reminders:[EKReminder]          = []
    var allReminders:[EKReminder]       = []
    var allReminderLists:[EKCalendar]   = []
    
    var calendars:[EKCalendar]          = []

    var numberOfItems:Int       = 0
    var startDT:Date          = Date()
    var endDT:Date            = Date()
    var today:Date            = Date()
    var events:NSMutableArray   = []
    
    var reminderListID:String   = ""
    
    var showListsView:Bool      = true
    var checked:Bool            = false
    
 //   var audioPlayer = AVAudioPlayer() //commented for new watchExtension 040516
    var reminderListColor:UIColor = UIColor.green
    
    var player: WKAudioFilePlayer!
    
    var showCompleted = false
    





    
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
        let (startDT, endDT, output, outputNote, day, calendarName, actionType, duration, alert, eventLocation, eventRepeat) = DictateManagerIC.sharedInstance.grabVoice()
    }
    
    
    @IBAction func menuSettings() {
        presentController(withName: "Settings", context: "Reminders")
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
    


    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
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
        ReminderManager.sharedInstance.getAccessToEventStoreForType(EKEntityType.reminder, completion: { (granted) -> Void in
            
            if granted{
                print("w65 Reminders granted: \(granted)")
            }
        })
        
        //get Access to Events
        //NSLog("%@ w70 appDelegate", self)
        print("w71 call getAccessToEventStoreForType")
        //FIXME:6
        //TODO this needed events????
   /*     EventManager.sharedInstance.getAccessToEventStoreForType(EKEntityType.Event, completion: { (granted) -> Void in
            
            if granted{
                print("w75 Events granted: \(granted)")
            }
        })
   */
        print("w190 context: \(context)")
        showListsView = true
        self.setTitle("Reminders")
        self.loadTableData()
     
        let filePath = Bundle.main.path(forResource: "beep-08b", ofType: "mp3")!
        let fileUrl = URL (fileURLWithPath: filePath)
        let asset = WKAudioFileAsset (url: fileUrl)
        let playerItem = WKAudioFilePlayerItem (asset: asset)
        player = WKAudioFilePlayer (playerItem: playerItem)
        
        //self.player.play()
 
        //let alertSound1: NSURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("beep-08b", ofType: "mp3")!)
        
        //TODO Mike Anil replace above with call to Manager!
        //GeneralWatch.sharedInstance.playSound(alertSound1)
        
        calendars = ReminderManager.sharedInstance.eventStore.calendars(for: EKEntityType.reminder)
        print("w230 calendars: \(calendars)")
        print("w230 calendars.count: \(calendars.count)")


        //fetchReminders()
        
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        //NSLog("%@ w78 will activate", self)
        print("w79 in ReminderListsIC willActivate")
        
      //  ReminderManager.sharedInstance.createNewReminderList("To Code Tomorrow", items: ["item 1","item 2", "This is item 3 hehe"])   //added to make reminder for testing.

        print("w83 in ReminderIC willActivate")

        self.reminderItemsGroup.setHidden(false)  //Hide lower table2
  
        if showListsView {                  //true case
            print("w165 showListsView True")
            self.loadTableData()
        } else {
            self.loadTableData2()
            print("w165 showListsView False")
        }
  
        //DictateManagerIC.sharedInstance.initalizeParse()
        
    }
    
    func fetchReminders(){
       
        fetchRemindersFromCalendars(showComplted:showCompleted)
        
    }
    
    func fetchRemindersFromCalendars(_ calendars:[EKCalendar]? = nil, showComplted:Bool=false){
        
        ReminderManager.sharedInstance.fetchRemindersFromCalendars(calendars,includeCompleted:showComplted ) { (reminders) -> Void in
            
            print("w270 self.reminders: \(self.reminders)")
            print("w271 self.reminders.count: \(self.reminders.count)")
        }
    }
 
    
    func loadTableData () {
        //NSLog("%@ w102 loadTableData", self)
        showListsView = true
        
        reminderListsGroup.setHidden(false)     //show lists
        reminderItemsGroup.setHidden(true)      //Hide lower table2
        navBarGroup.setHidden(false)            //show  navBar
        backToReminders.setHidden(true)         //Hide lower table2


        self.allReminderLists = ReminderManager.sharedInstance.eventStore.calendars(for: EKEntityType.reminder) 
        
        table.setNumberOfRows(allReminderLists.count, withRowType: "tableRow")
        
        print("w292 allReminderLists: \(allReminderLists)")
        print("w293 allReminderLists.count: \(allReminderLists.count)")
  
        if allReminderLists != [] {
            for (index, title) in allReminderLists.enumerated() {
                print("---------------------------------------------------")
                print("w298 title: \(title.title)")
                print("---------------------------------------------------")

                print("w301 index, title: \(index), \(title)")
                print("w302 table.rowControllerAtIndex(index): \(table.rowController(at: index))")
                
                if table.rowController(at: index) != nil {
                    let row = table.rowController(at: index) as! ReminderListsTableRC
                
                    let reminderList = allReminderLists[index]
                    print("w308 reminderList: \(reminderList)")
     // /*
                    //TODO Mike TODO Anil  this crashes watch used to work!!!!!!!
      
                    // get count or items in each reminder list and set the Text Label
                    ReminderManager.sharedInstance.fetchCalendarReminders(reminderList) { (reminders) -> Void in
                        print("w314 reminders: \(reminders)")
                        self.allReminders = reminders as [EKReminder]
                        let numberOfItems = self.allReminders.count
                    
                        print("w318 numberOfItems: \(numberOfItems)")
                        if numberOfItems != 0 {
                            print("w320 reminder.title: \(reminderList.title)")
                            print("w321 numberOfItems: \(numberOfItems)")

                           row.tableRowLabel.setText("\(reminderList.title) (\(numberOfItems))")
                            
                            //print("w162 here? reminder: \(reminderList)")
                        }

                    }   // end ReminderManager call
     //  */
        
                    row.tableRowLabel.setText("\(reminderList.title)")
                    row.tableRowLabel.setTextColor(UIColor(cgColor: reminderList.cgColor))
                    row.verticalBar.setBackgroundColor(UIColor(cgColor: reminderList.cgColor))
                    
                    row.imageVerticalBar.setTintColor(UIColor(cgColor: reminderList.cgColor))
                    
                    row.imageVerticalBarRT.setTintColor(UIColor(cgColor: reminderList.cgColor))
                }
            }
        }
    }   // end loadTableData func
    
    func loadTableData2 () {    //loads reminders for one list.
        
        self.setTitle("")

        showListsView = false   //set flag when awakes to go to view user was in
        
        backToReminders.setHidden(false)        //show text
        navBarGroup.setHidden(false)            //show  navBar

        let calendarId = reminderListID
        print("w353 reminderListID: \(reminderListID)")
        let calendar = ReminderManager.sharedInstance.eventStore.calendar(withIdentifier: calendarId)
        
        labelReminderListID.setTextColor(UIColor(cgColor: calendar!.cgColor))
        verticalBar2.setBackgroundColor(UIColor(cgColor: calendar!.cgColor))
        labelShowCompleted.setTextColor(UIColor(cgColor: calendar!.cgColor))
        
        self.reminderListColor = UIColor(cgColor: calendar!.cgColor)    //save for selected row later
        
        let reminderListColor:UIColor = UIColor(cgColor: calendar!.cgColor)

        
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
            
            print("w379 allReminders: \(self.allReminders)")
            print("w380 allReminders.count: \(self.allReminders.count)")
            
            for (index, title) in self.allReminders.enumerated() {
                print("---------------------------------------------------")
                print("w384 index, title: \(index), \(title)")
                
                let row = self.table2.rowController(at: index) as! ReminderItemsTableRC
                let item = self.allReminders[index]
                
                row.tableRowLabel.setText(item.title)
               //TODO MIKE why here?  Anil row.reminder = item
            }
            //self.loadTableData()    //populate teh reminders with there items!
        }
    }       // end loadTableData2 func
    
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
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
            let row = self.table2.rowController(at: rowIndex) as! ReminderItemsTableRC
            let reminderItem = allReminders[rowIndex]
            let veryDarkGray = UIColor(red: 128, green: 128, blue: 128, alpha: 1)     //light biege color, for Word List
            
            if self.checked {               // Turn checkmark off
                row.imageCheckbox.setImageNamed("cbBlank40px")
                row.tableRowLabel.setTextColor(UIColor.white)
                reminderItem.isCompleted = false
                self.checked = false
                
//                var alertSound1: NSURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("beep-08b", ofType: "mp3")!)
                
 //               self.playSound(alertSound1) ////commented for new watchExtension 040516
            } else {                        // Turn checkmark on
                row.imageCheckbox.setImageNamed("cbChecked40px")
                row.tableRowLabel.setTextColor(veryDarkGray)
                
                var alertSound1: URL = URL(fileURLWithPath: Bundle.main.path(forResource: "124-DeleteWhoosh", ofType: "mp3")!)
                //TODO Mike TODO Anil fix sound call.
                //DictateManagerIC.sharedInstance.playSound(alertSound1)
                
 //               self.playSound(alertSound1) ////commented for new watchExtension 040516
                //self.labelShowCompleted.setText("Item Completed")
                //self.labelShowCompleted.setTextColor(UIColor.yellowColor())
                
                self.labelShowCompleted.setHidden(true)
                self.labelCompleted.setHidden(false)

                print("w305 reminderItem: \(reminderItem)")
                print("w306 reminderItem.completed: \(reminderItem.isCompleted)")
                
                reminderItem.isCompleted = true
          
                //TODO WCFIX ReminderManager.sharedInstance.saveReminder(reminderItem)
                //TODO Anil Mike add code to updated/save reminder as it is completed!!! broke in watchOS2
                let actionType = "saveReminder"
                
                session = WCSession.default()
                let messageDict = ["action":actionType, "reminderItem":reminderItem] as [String : Any]
                
                print("w423 messageDict: \(messageDict)")
                
                session?.sendMessage(messageDict, replyHandler: { (response) in
                    
                    print("w427 Message sent status: \(response["status"])")
                    
                    }, errorHandler: { (error) in
                        //handle error
                        print("w717 error : \(error.localizedDescription)")
                })
                
                
                
                
                
                print("w325 reminderItem.completed: \(reminderItem.isCompleted)")
                
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
        presentController(withName: "Events", context: "Reminders")
    }
    
    @IBAction func buttonMain() {
        presentController(withName: "Main", context: "Reminders")
    }
    
    func dataSourceDidUpdate(_ dataSource: DataSource){
        
    }

}

extension ReminderListsIC: WCSessionDelegate {
    
}
