//
//  TodayIC.swift
//  Dictate
//
//  Created by Mike Derr on 8/4/15.
//  Copyright (c) 2015 ThatSoft.com. All rights reserved.
//
//  040816 Mike  added timeUntil to table rows
//

import WatchKit
import Foundation
import EventKit
//import Parse
//import AVFoundation   //commented for new watchExtension 040516


class TodayIC: WKInterfaceController {
    
    let defaults = NSUserDefaults(suiteName: "group.com.thatsoft.dictateApp")!
    
    var showCalendarsView:Bool  = true
    var checked:Bool            = false
    var eventID:String          = ""
    var today:NSDate            = NSDate()      //current time
    var now:NSDate              = NSDate()      //current time, same as today
    var todayPlusSeven:NSDate   = NSDate()
    var allEvents: Array<EKEvent> = []
    var timeUntil:String        = ""
  
    @IBOutlet weak var labelDate: WKInterfaceLabel!
    @IBOutlet var labelTime: WKInterfaceLabel!
    @IBOutlet weak var table: WKInterfaceTable!
    
    let dateFormatter = NSDateFormatter()
    var timer:NSTimer!

    
//---- funcs below here -----------------------------------------------------------
    
    
    func fetchEvents(){
        
      //  let dateHelper = JTDateHelper()
        let startDate =  NSDate()
        
       // let cal = NSCalendar(calendarIdentifier: NSGregorianCalendar)
       // let next10Days = cal!.dateByAddingUnit(NSCalendarUnit.Day, value: 10, toDate: today, options: .Day)
        
        let calendar = NSCalendar.currentCalendar()
        let endDate: NSDate = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: 4, toDate: startDate, options: [])!
        
        // value above was 10 Mke 061316
        
       // let endDate = dateHelper.addToDate(startDate, days: 10)
        
        print("w46 startDate: \(startDate)")
        print("w46 endDate: \(endDate)")
        
        //FIXME:4
        EventManager.sharedInstance.fetchEventsFrom(startDate, endDate: endDate, completion: { (events) -> Void in
            self.allEvents = events
            //self.loadTableData()
        })
        
        print("w56 self.allEvents: \(self.allEvents)")
        
    }
    
    func updateScreen(){
        dateFormatter.dateFormat = "h:mm"
        let nowString = dateFormatter.stringFromDate(NSDate())   //set to today date for now
        
        self.labelTime.setText(nowString)
        //self.loadTableData()
    }
    
    
//---- Menu functions -------------------------------------------
    @IBAction func menuDictate() {
        let (startDT, endDT, output, outputNote, day, calendarName, actionType) = DictateManagerIC.sharedInstance.grabVoice()
    }
    
    @IBAction func menuSettings() {
        presentControllerWithName("Settings", context: "Events")
    }
//---- end Menu functions ----------------------------------------
    

  /*
     override func didAppear() {
        
    }
   */
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        // Configure interface objects here.
        
        NSLog("%@ w68 TodayIC awakeWithContext", self)
        print("w70 TodayIC awakeWithContext")
        
        // Create a timer to refresh the time every second
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("updateScreen"), userInfo: nil, repeats: true)
        timer.fire()

        
      //  var sceneTitle:String = (context as? String)!
      //  self.setTitle("«\(sceneTitle)")
        self.setTitle("Events")

        //get Access to Reminders
        NSLog("%@ w60 appDelegate", self)
        print("w61 call getAccessToEventStoreForType")
        ReminderManager.sharedInstance.getAccessToEventStoreForType(EKEntityType.Reminder, completion: { (granted) -> Void in
            
            if granted{
                print("w65 Reminders granted: \(granted)")
            }
        })
        
        //get Access to Events
        NSLog("%@ w70 appDelegate", self)
        print("w71 call getAccessToEventStoreForType")
        //FIXME:9
        EventManager.sharedInstance.getAccessToEventStoreForType(EKEntityType.Event, completion: { (granted) -> Void in
            
            if granted{
                print("w75 Events granted: \(granted)")
            }
        })
        
        print("w95 context: \(context)")
       // showListsView = true
        self.setTitle("Events")
        
        //fetchEvents()
        
        self.loadTableData()
        
        dateFormatter.dateFormat = "h:mm"
        let nowString = dateFormatter.stringFromDate(NSDate())
        self.labelTime.setText(nowString)
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        NSLog("%@ w78 TodayIC will activate", self)
        print("w79 TodayIC willActivate")
        
        //  ReminderManager.sharedInstance.createNewReminderList("To Code Tomorrow", items: ["item 1","item 2", "This is item 3 hehe"])   //added to make reminder for testing.
                
        //self.reminderItemsGroup.setHidden(false)  //Hide lower table2
        
        if showCalendarsView {
            //  self.loadTableData()
            print("w155 showListsView True")
        } else {
            //   self.loadTableData2()
            print("w165 showListsView False")
        }
        
        fetchEvents()
        
        loadTableData()
  
    }
    
    func loadTableData () {
        
        fetchEvents()
        
        print("w173 allEvents.count: \(allEvents.count)")
        
        table.setNumberOfRows(allEvents.count, withRowType: "tableRow")
        
        for (index, title) in allEvents.enumerate() {
        
            print("---------------------------------------------------")
            print("w175 index, title: \(index), \(title)")
            print("w176 index: \(index)")
            print("w177 table: \(table)")
            print("w178 table.rowControllerAtIndex(index): \(table.rowControllerAtIndex(index))")
           
            
            if let row = table.rowControllerAtIndex(index) as? TodayEventsTableRC {
                print("w183 WE HERE????")
                
                let item = allEvents[index]
                
                dateFormatter.dateFormat = "h:mm a"
                
                let startTimeA = dateFormatter.stringFromDate(item.startDate)
                var startTime = startTimeA.stringByReplacingOccurrencesOfString(":00", withString: "")
                NSLog("%@ w137", startTime)
                
                dateFormatter.dateFormat = "h:mm"
                
                let endTimeA = dateFormatter.stringFromDate(item.endDate)
                let endTime = endTimeA.stringByReplacingOccurrencesOfString(":00", withString: "")
                
                var endTimeDash = "- \(endTime)"
                
                timeUntil = TimeManger.sharedInstance.timeInterval(item.startDate)
                
                if item.allDay {     // if allDay bool is true
                    row.groupTime.setHidden(true)
                }
                
                let startTimeItem = item.startDate
                let timeUntilStart = startTimeItem.timeIntervalSinceDate(NSDate())
                //print("w187 timeUntilStart: \(timeUntilStart)")
                
                let endTimeItem = item.endDate
                let timeUntilEnd = endTimeItem.timeIntervalSinceDate(NSDate())
                //print("w192 timeUntilEnd: \(timeUntilEnd)")
                
                if ((timeUntilStart <= 0) && (timeUntilEnd >= 0)) {
                    timeUntil = "Now"
                    let neonRed = UIColor(red: 255, green: 51, blue: 0, alpha: 1)
                    let brightYellow = UIColor(red: 255, green: 255, blue: 0, alpha: 1)
                    
                    //let swiftColor = UIColor(red: 1, green: 165/255, blue: 0, alpha: 1)
                    row.labelTimeUntil.setTextColor(brightYellow)
                    //row.labelTimeUntil.setTextColor(UIColor.yellowColor())
                    
                    // works
                    let headlineFont =
                        UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
                    
                    let fontAttribute = [NSFontAttributeName: headlineFont]
                    
                    let attributedString = NSAttributedString(string: "Now  ",
                                                              attributes: fontAttribute)
                    
                    row.labelTimeUntil.setAttributedText(attributedString)

                    
                } else {
                    row.labelTimeUntil.setTextColor(UIColor.greenColor())
                    row.labelTimeUntil.setText("\(timeUntil)  ")                   
                }
                
                //TODO Mike TODO Anil All day event spanning multiple days does not show up on multiple days
                
                print("w185 timeUntil: \(timeUntil)")
                
                row.labelEventTitle.setText(item.title)
                row.labelEventLocation.setText(item.location)
                row.labelStartTime.setText(startTime)
                row.labelEndTime.setText(endTimeDash)
                //row.labelTimeUntil.setText("\(timeUntil)  ")
                
                //row.labelEventTitle.setTextColor(UIColor(CGColor: item.calendar.CGColor))
                // row.labelStartTime.setTextColor(UIColor(CGColor: item.calendar.CGColor))
                // row.labelEndTime.setTextColor(UIColor(CGColor: item.calendar.CGColor))
                
                row.labelStartTime.setTextColor(UIColor.whiteColor().colorWithAlphaComponent(0.8))
                row.labelEndTime.setTextColor(UIColor.whiteColor().colorWithAlphaComponent(0.65))
                
                row.labelEventLocation.setTextColor(UIColor(CGColor: item.calendar.CGColor))
                
                row.verticalBar.setBackgroundColor(UIColor(CGColor: item.calendar.CGColor))
                
                row.imageVertBar.setTintColor(UIColor(CGColor: item.calendar.CGColor))
                
                // row.imageVertBar.image = [row.imageVertBar imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                
                row.groupEvent.setBackgroundColor(UIColor(CGColor: item.calendar.CGColor).colorWithAlphaComponent(0.375))
            } // end if let row...
            
            
        
        }
    }   //end loadTableData
    
    
    override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject? {
        
        if segueIdentifier == "EventDetails" {
            let selectedEvent = allEvents[rowIndex]
            eventID = selectedEvent.eventIdentifier
            print("w113 eventID \(eventID)")
        }
        return eventID
    }


    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func buttonMainIC() {
        presentControllerWithName("Main", context: "Today")
    }

    @IBAction func buttonReminders() {
        presentControllerWithName("Reminders", context: "Today")
    }

}
