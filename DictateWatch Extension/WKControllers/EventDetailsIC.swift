//
//  EventDetailsIC.swift
//  Dictate
//
//  Created by Mike Derr on 8/4/15.
//  Copyright (c) 2015 ThatSoft.com. All rights reserved.
//

import WatchKit
import Foundation
import EventKit
//import Parse
//import AVFoundation   //commented for new watchExtension 040516


class EventDetailsIC: WKInterfaceController {
    
    let defaults = NSUserDefaults(suiteName: "group.com.thatsoft.dictateApp")!
    
    let eventStore = EKEventStore()

    var event:EKEvent = EKEvent(eventStore: EKEventStore())
    var sendID:String = ""
    
    var now:NSDate              = NSDate()      //current time, same as today
    var timeUntil:String        = ""
    
    let dateFormatter = NSDateFormatter()
    
    let tempAlarm = EKAlarm()
 
    @IBOutlet weak var labelEventTitle: WKInterfaceLabel!
    @IBOutlet weak var labelStartTime: WKInterfaceLabel!
    @IBOutlet weak var labelEndTime: WKInterfaceLabel!
    
    //@IBOutlet var labelTimeUntil: WKInterfaceLabel!
    
    @IBOutlet var labelTimeUntil: WKInterfaceLabel!
    @IBOutlet weak var verticalBar: WKInterfaceGroup!
    @IBOutlet weak var calendarName: WKInterfaceLabel!
    @IBOutlet weak var labelNotes: WKInterfaceLabel!
    @IBOutlet weak var labelLocation: WKInterfaceLabel!
    
    @IBOutlet weak var labelAlarms: WKInterfaceLabel!
    
    @IBOutlet weak var labelURL: WKInterfaceLabel!
    @IBOutlet weak var labelRepeats: WKInterfaceLabel!
    
    @IBOutlet weak var labelAttendees: WKInterfaceLabel!
    
    @IBOutlet weak var labelTravelTime: WKInterfaceLabel!
    
    @IBOutlet weak var groupTravel: WKInterfaceGroup!
    
    @IBOutlet weak var groupRepeats: WKInterfaceGroup!
    
    @IBOutlet weak var groupAlarms: WKInterfaceGroup!

    @IBOutlet weak var groupURL: WKInterfaceGroup!
    
    @IBOutlet weak var groupAttendees: WKInterfaceGroup!
    @IBOutlet weak var groupNotes: WKInterfaceGroup!
    
    @IBOutlet var buttonGrCalendarName: WKInterfaceButton!
    
    @IBOutlet var groupCalendar: WKInterfaceGroup!
    
    @IBOutlet var imageVerticalBar: WKInterfaceImage!
    
    @IBOutlet var imageVerticalBarRT: WKInterfaceImage!
    
    @IBOutlet var labelTitleAlarms: WKInterfaceLabel!
    
    
//---- funcs below here -----------------------------------------------------------
    
//---- Menu functions -------------------------------------------
    @IBAction func menuDictate() {
       let (startDT, endDT, output, outputNote, day, calendarName, actionType, duration, alert, eventLocation, eventRepeat) = DictateManagerIC.sharedInstance.grabVoice()
    }
    
    @IBAction func menuSettings() {
        presentControllerWithName("Settings", context: "«Events")
    }
//---- end Menu functions ----------------------------------------
    


    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        // Configure interface objects here.
        
        NSLog("%@ w41 TodayIC awakeWithContext", self)
        
        print("w43 Today awakeWithContext")
        
        self.setTitle("«Events")
        self.labelTimeUntil.setHidden(false)
        
        let eventID = context as! String
        
        event = eventStore.eventWithIdentifier(eventID)!
        
        print("w81 event: \(event)")
        
        let dateString = dateFormatter.stringFromDate(event.startDate)
        
        dateFormatter.dateFormat = "h:mm a"
        
        let startTimeA = dateFormatter.stringFromDate(event.startDate)
        var startTime = startTimeA.stringByReplacingOccurrencesOfString(":00", withString: "")
        
        dateFormatter.dateFormat = "h:mm"
        
        let endTimeA = dateFormatter.stringFromDate(event.endDate)
        let endTime = endTimeA.stringByReplacingOccurrencesOfString(":00", withString: "")
        
        var endTimeDash = "-\(endTime)"
        
        timeUntil = TimeManger.sharedInstance.timeInterval(event.startDate)
        print("w115 timeUntil: \(timeUntil)")
 
        if event.allDay {   // if allDay bool is true
            startTime = ""
            endTimeDash = "All Day"
            self.labelTimeUntil.setHidden(true)
        } else {
            self.labelTimeUntil.setHidden(false)
        }
 
        let startTimeItem = event.startDate
        let timeUntilStart = startTimeItem.timeIntervalSinceDate(NSDate())
        print("w187 timeUntilStart: \(timeUntilStart)")
        
        let endTimeItem = event.endDate
        let timeUntilEnd = endTimeItem.timeIntervalSinceDate(NSDate())
        print("w192 timeUntilEnd: \(timeUntilEnd)")
        
        if ((timeUntilStart <= 0) && (timeUntilEnd >= 0)) {
            timeUntil = "Now"
            let neonRed = UIColor(red: 255, green: 51, blue: 0, alpha: 1)
            let brightYellow = UIColor(red: 255, green: 255, blue: 0, alpha: 1)
            self.labelTimeUntil.setTextColor(brightYellow)
            
            // works
            let headlineFont =
                UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
            
            let fontAttribute = [NSFontAttributeName: headlineFont]
            
            let attributedString = NSAttributedString(string: "Now  ",
                                                      attributes: fontAttribute)
            
            self.labelTimeUntil.setAttributedText(attributedString)
            
        } else {
            self.labelTimeUntil.setTextColor(UIColor.greenColor())
            self.labelTimeUntil.setText(timeUntil)
        }

        self.labelEventTitle.setText(event.title)
        self.labelStartTime.setText(startTime)
        self.labelEndTime.setText(endTimeDash)
        self.labelLocation.setText(event.location)
        //self.labelTimeUntil.setText(timeUntil)
        
        self.labelStartTime.setTextColor(UIColor.whiteColor().colorWithAlphaComponent(0.8))
        
        self.labelEndTime.setTextColor(UIColor.whiteColor().colorWithAlphaComponent(0.65))
        
        self.labelLocation.setTextColor(UIColor(CGColor: event.calendar.CGColor))
        
        self.verticalBar.setBackgroundColor(UIColor(CGColor: event.calendar.CGColor))
        
        self.imageVerticalBar.setTintColor(UIColor(CGColor: event.calendar.CGColor))
        self.imageVerticalBarRT.setTintColor(UIColor(CGColor: event.calendar.CGColor))
        
        self.buttonGrCalendarName.setBackgroundColor(UIColor(CGColor: event.calendar.CGColor))
        
         self.groupCalendar.setBackgroundColor(UIColor(CGColor: event.calendar.CGColor).colorWithAlphaComponent(0.375))
        
        
       // self.calendarName.setTextColor(UIColor(CGColor: event.calendar.CGColor))
        self.calendarName.setText(event.calendar.title)
        self.labelRepeats.setText(event.recurrenceRules as? String)
        
        print("w173 event.alarms: \(event.alarms)")
        
        //TODO ANIL TODO MIKE fix alarms on watch if blanck shows label Alarm! why? solve! and downcasting always fails it warns!
        if event.alarms != nil {
            let tempAlarm:EKAlarm = (event.alarms as? EKAlarm)!
            
            self.labelAlarms.setText(tempAlarm as? String)
        }
        
        //TODO Mike TODO Anil why thse two URL cast error, travelTime not a member of eventkit it says!
     //   self.labelURL.setText(event.URL as? String)
        self.labelAttendees.setText(event.attendees as? String)
     //   self.labelTravelTime.setText(event.travelTime)

        self.labelNotes.setText(event.notes)
        
        print("w191 event.hasRecurrenceRules: \(event.hasRecurrenceRules)")
        
        if event.hasRecurrenceRules {
            print("w192 we here")
            self.groupRepeats.setHidden(false)
        } else {
            print("w195 we here")
            self.groupRepeats.setHidden(true)
        }
        
        if (tempAlarm as? String) == "" {
            print("w196 we here")
            self.groupAlarms.setHidden(true)
            self.labelTitleAlarms.setHidden(true)   //TODO did not work on Watch
        }
        
        if event.hasAlarms {
            self.groupAlarms.setHidden(false)
            
        } else {
            print("w139 we here")
            self.groupAlarms.setHidden(true)
            self.labelTitleAlarms.setHidden(true)   //TODO did not work on Watch
        }
        
        if event.hasAttendees {
            self.groupAttendees.setHidden(false)
        } else {
            print("w146 we here")
            self.groupAttendees.setHidden(true)
        }
        
  
        self.groupURL.setHidden(true)
        self.groupTravel.setHidden(true)

   

        if event.hasNotes {
            self.groupNotes.setHidden(false)
        } else {
            print("w156 here? groupNotes: \(groupNotes)")
            self.groupNotes.setHidden(true)
        }


        

    }
    
    
  override func contextForSegueWithIdentifier(segueIdentifier: String) ->  AnyObject? {
        if segueIdentifier == "EditNotes" {
            sendID = event.eventIdentifier
            print("w171 sendID \(sendID)")
        }
    
        if segueIdentifier == "SetCalendar" {
            sendID = event.eventIdentifier
            print("w178 sendID \(sendID)")
        }
    
            return sendID
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
