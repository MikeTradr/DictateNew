//
//  GlanceController.swift
//  Dictate WatchKit Extension
//
//  Created by Mike Derr on 7/29/15.
//  Copyright (c) 2015 ThatSoft.com. All rights reserved.
//

import WatchKit
import Foundation
import EventKit

class GlanceController: WKInterfaceController {
    
    let defaults = UserDefaults(suiteName: "group.com.thatsoft.dictateApp")!
    
    var showCalendarsView:Bool  = true
    var checked:Bool            = false
    var eventID:String          = ""
    var today:Date            = Date()      //current time
    var now:Date              = Date()      //current time, same as today
    var todayPlusSeven:Date   = Date()
    var allEvents: [EKEvent]    = []
    var timeUntil:String        = ""
    
    var timer:Timer!
    
    //@IBOutlet var labelDate: WKInterfaceLabel!
    // @IBOutlet var labelNow: WKInterfaceLabel!
    
    @IBOutlet var labelDate: WKInterfaceLabel!
    @IBOutlet var labelNow: WKInterfaceLabel!
    @IBOutlet var table: WKInterfaceTable!
    
    let dateFormatter = DateFormatter()
    
    //---- funcs below here -----------------------------------------------------------
    
 /*
    func fetchEvents(){
        
        //let dateHelper = JTDateHelper()
       // let dateHelper = JTDateHelper()
        let startDate =  NSDate()
        //let endDate = dateHelper.addToDate(startDate, days: 1)
        
        let calendar = NSCalendar.currentCalendar()
        let endDate: NSDate = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: 1, toDate: startDate, options: [])!
        
        print("w46 startDate: \(startDate)")
        print("w46 endDate: \(endDate)")
        
        EventManager.sharedInstance.fetchEventsFrom(startDate, endDate: endDate, completion: { (events) -> Void in
            self.allEvents = events
        })
        
        print("w56 self.allEvents: \(self.allEvents)")
        
    }
*/
    func fetchEvents(){
        let startDate =  Date()
        let calendar = Calendar.current
        let endDate: Date = (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.day, value: 1, to: startDate, options: [])!
        
        print("w46 startDate: \(startDate)")
        print("w46 endDate: \(endDate)")
        
        //FIXME:1
        EventManager.sharedInstance.fetchEventsFrom(startDate, endDate: endDate, completion: { (events) -> Void in
            self.allEvents = events
            //self.loadTableData()
        })
        
        print("w56 self.allEvents: \(self.allEvents)")
    }
    
    func updateScreen(){
        dateFormatter.dateFormat = "h:mm a"
        let nowString = dateFormatter.string(from: Date())   //set to today date for now
        
        self.labelNow.setText(nowString)
        self.loadTableData()
    }
    
    /*
     func didAppear () {
     let dateFormatter = NSDateFormatter()
     dateFormatter.dateFormat = "h:mm a"
     let now = dateFormatter.stringFromDate(today)   //set to today date for now
     
     let watchBlue = UIColor(red: 102, green: 178, blue: 255, alpha: 1)
     
     self.labelNow.setTextColor(watchBlue)
     self.labelNow.setText(now)
     }
     */
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        
        // Create a timer to refresh the time every second
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(GlanceController.updateScreen), userInfo: nil, repeats: true)
        timer.fire()
        
        NSLog("%@ w41 TodayIC awakeWithContext", self)
        
        print("w43 Today awakeWithContext")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, MMM d"
        
        let dateString = dateFormatter.string(from: Date())   //set to today date for now
        self.labelDate.setText(dateString)
        self.labelDate.setTextColor(UIColor.yellow)
        
        //get Access to Reminders
        NSLog("%@ w60 appDelegate", self)
        print("w61 call getAccessToEventStoreForType")
        ReminderManager.sharedInstance.getAccessToEventStoreForType(EKEntityType.reminder, completion: { (granted) -> Void in
            
            if granted{
                print("w65 Reminders granted: \(granted)")
            }
        })
        
        //get Access to Events
        NSLog("%@ w70 appDelegate", self)
        print("w71 call getAccessToEventStoreForType")
        //FIXME:8
        EventManager.sharedInstance.getAccessToEventStoreForType(EKEntityType.event, completion: { (granted) -> Void in
            
            if granted{
                print("w75 Events granted: \(granted)")
            }
        })
        /*
         print("w65 context: \(context)")
         // showListsView = true
         self.setTitle("Events")
         */
        fetchEvents()
        
        self.loadTableData()
   /*
        dateFormatter.dateFormat = "h:mm a"
        let nowString = dateFormatter.stringFromDate(NSDate())   //set to today date for now
        
        // let watchBlue = UIColor(red: 102, green: 178, blue: 255, alpha: 1)
        
        // self.labelNow.setTextColor(watchBlue)
        self.labelNow.setText(nowString)
   */
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        NSLog("%@ w78 GlanceController will activate", self)
        print("w79 GlanceController willActivate")
        
        //  ReminderManager.sharedInstance.createNewReminderList("To Code Tomorrow", items: ["item 1","item 2", "This is item 3 hehe"])   //added to make reminder for testing.
        
        print("w83 in GlanceController willActivate")
        
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
    /*
        dateFormatter.dateFormat = "h:mm a"
        let nowString = dateFormatter.stringFromDate(NSDate())   //set to today date for now
        
        //let watchBlue = UIColor(red: 102, green: 178, blue: 255, alpha: 1)
        
        // self.labelNow.setTextColor(watchBlue)
        self.labelNow.setText(nowString)
    */
    }
    
    func loadTableData () {
        
        print("w117 allEvents.count: \(allEvents.count)")
        table.setNumberOfRows(allEvents.count, withRowType: "tableRow")
        //table.setNumberOfRows(1, withRowType: "tableRow")
        
        print("w46 allEvents.count: \(allEvents.count)")
        
        for (index, title) in allEvents.enumerated() {
            
            print("---------------------------------------------------")
            print("w40 index, title: \(index), \(title)")
            
            if let row = table.rowController(at: index) as? GlanceTodayEventsTableRC {
                print("w208 WE HERE????")
                
                let item = allEvents[index]
                
                dateFormatter.dateFormat = "h:mm a"
                
                let startTimeA = dateFormatter.string(from: item.startDate)
                var startTime = startTimeA.replacingOccurrences(of: ":00", with: "")
                NSLog("%@ w137", startTime)
                
                dateFormatter.dateFormat = "h:mm"
                
                let endTimeA = dateFormatter.string(from: item.endDate)
                let endTime = endTimeA.replacingOccurrences(of: ":00", with: "")
                
                var endTimeDash = "- \(endTime)"
                
                if item.startDate == item.endDate {     //for same start & end time event 
                    endTimeDash = ""
                }
                
                timeUntil = TimeManger.sharedInstance.timeInterval(item.startDate)
                
                if item.isAllDay {     // if allDay bool is true
                    row.groupTime.setHidden(true)
                }
                
                let startTimeItem = item.startDate
                let timeUntilStart = startTimeItem.timeIntervalSince(Date())
                //print("w187 timeUntilStart: \(timeUntilStart)")
                
                let endTimeItem = item.endDate
                let timeUntilEnd = endTimeItem.timeIntervalSince(Date())
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
                        UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
                    
                    let fontAttribute = [NSFontAttributeName: headlineFont]
                    
                    let attributedString = NSAttributedString(string: "Now😀  ",
                                                              attributes: fontAttribute)
                    
                    row.labelTimeUntil.setAttributedText(attributedString)
                    
                    
                    
                    
                    
                } else {
                    row.labelTimeUntil.setTextColor(UIColor.green)
                    row.labelTimeUntil.setText("\(timeUntil)  ")
                }
                
                //TODO Mike TODO Anil All day event spanning multiple days does not show up on multiple days
                
                print("w185 timeUntil: \(timeUntil)")
                
                row.labelEventTitle.setText(item.title)
                row.labelEventLocation.setText(item.location)
                row.labelStartTime.setText(startTime)
                row.labelEndTime.setText(endTimeDash)
               // row.labelTimeUntil.setText("\(timeUntil)  ")
                
                //row.labelEventTitle.setTextColor(UIColor(CGColor: item.calendar.CGColor))
                // row.labelStartTime.setTextColor(UIColor(CGColor: item.calendar.CGColor))
                // row.labelEndTime.setTextColor(UIColor(CGColor: item.calendar.CGColor))
                
                row.labelStartTime.setTextColor(UIColor.white.withAlphaComponent(0.8))
                row.labelEndTime.setTextColor(UIColor.white.withAlphaComponent(0.65))
                
                row.labelEventLocation.setTextColor(UIColor(cgColor: item.calendar.cgColor))
                
                row.verticalBar.setBackgroundColor(UIColor(cgColor: item.calendar.cgColor))
                
                row.imageVertBar.setTintColor(UIColor(cgColor: item.calendar.cgColor))
                
                // row.imageVertBar.image = [row.imageVertBar imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                
                row.groupEvent.setBackgroundColor(UIColor(cgColor: item.calendar.cgColor).withAlphaComponent(0.375))
            } // end if let row...
            
        }   // for loop
        
    }   //end loadTableData
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
}
