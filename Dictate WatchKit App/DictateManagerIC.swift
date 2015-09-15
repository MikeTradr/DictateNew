//
//  DictateManagerIC.swift
//  Dictate
//
//  Created by Mike Derr on 9/13/15.
//  Copyright (c) 2015 ThatSoft.com. All rights reserved.
//

import WatchKit
import Foundation


var results = []

// ---- chagne strigngs here for testing ---
var str:String      = ""

var strRaw:String   = str


// ---- set Global Varbiables ----
var time:String         = ""
var mainType:String     = ""
var aptType:String      = ""
var phone:String        = ""
var day:String          = ""
var date:String         = ""
var todayDay:String     = ""
var timestamp:String    = ""
var word:String         = ""
var timeString:String   = ""
var endTime:NSDate      = NSDate()

var today               = NSDate()

var wordArr             = []


var output:String           = ""
var outputRaw:String        = ""

var resultProcessed:String  = ""
var resultRaw:String        = ""
var resultStartDate:String  = ""
var resultEndDate:String    = ""
var resultTitle:String      = ""
var resultCalendar:String   = ""

var calendarName            = ""

var eventDuration:Double     = 10

//var startDate = ""

var now = ""

var outputNote:String       = strRaw

var fullDT:String       = ""
var fullDTEnd:String    = ""




// ---- end set Global Varbiables ----


class DictateManagerIC: WKInterfaceController {
    
    class var sharedInstance : DictateManagerIC {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : DictateManagerIC? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = DictateManagerIC()
        }
        return Static.instance!
    }
    
    
    
    var str:String      = ""
    var startDT:NSDate          = NSDate(dateString:"2014-12-12")
    var endDT:NSDate            = NSDate(dateString:"2014-12-12")
    var actionType:String   = ""        //event, reminder, singleWordList, commaList, rawList, note?, text, email

    
    func grabvoice() -> (NSDate, NSDate, String, String, String, String, String)  {  //startDT, endDT, output, outputNote, day, calendarName, actionType
        //added actionType above
        
        var rawString = ""
        var fullDT:String       = ""
        var fullDTEnd:String    = ""
        
        // uncomment line below to get a string from simulator Anil :)
        // self.presentTextInputControllerWithSuggestions(["Today 2 PM test Appointment"], allowedInputMode: WKTextInputMode.Plain, completion: { results -> Void in
        
        self.presentTextInputControllerWithSuggestions([], allowedInputMode: WKTextInputMode.Plain, completion: { results -> Void in
            
            //println("34 Results: \(results)")
            //println("35 Results: \(results[0])")
            
            if results != nil {
                println("There are objects")
                self.str = results[0] as! String
                println("### 92 str: \(self.str)")
                
            } else {
                println("No objects")
            }
            
            println("### 99 str: \(self.str)")
            
            rawString = self.str
            
           // self.myLabel.setText(self.str)
            
            //let (startDT, endDT, outputNote) = self.parse(self.str)
            
            if results != nil {
                
                let (startDT, endDT, output, outputNote, day, calendarName, actionType) = DictateCode().parse(self.str)
                
                var formatter3 = NSDateFormatter()
                formatter3.dateFormat = "M-dd-yyyy h:mm a"
                
                fullDT = formatter3.stringFromDate(startDT)
                fullDTEnd = formatter3.stringFromDate(endDT)
                
                if (startDT != NSDate(dateString:"2014-12-12") ) {
                    println("p153 startDT: \(startDT)")
                    
                    fullDT = formatter3.stringFromDate(startDT)
                    fullDTEnd = formatter3.stringFromDate(endDT)
                } else {
                    fullDT = ""
                    fullDTEnd = ""
                }
                
                
                println("p164 startDT: \(startDT)")
                
                // self.eventStartDT = startDT
                //  self.eventEndDT = endDT
  /*
                self.startDT = startDT
                self.endDT = endDT
                self.output = output
                self.outputNote = outputNote
                self.day = day
                self.calendarName = calendarName
                
                if actionType == "Reminder" {
                    println("p181 actionType setColor: \(actionType)")
                    
                    self.resultType.setTextColor(UIColor.yellowColor())
                }
                
                if actionType == "Event" {
                    self.resultType.setTextColor(UIColor.orangeColor())
                }
                
                
                self.resultType.setText("type: \(actionType)")
                self.resultDay.setText("day: \(day)")
                self.resultStart.setText("start: \(fullDT)")
                self.resultEnd.setText("  end: \(fullDTEnd)")
                self.resultPhone.setText("cell: \(phone)")
                self.resultCalendar.setText("cal.: \(calendarName)")
                
                self.groupButtons.setHidden(false)
                self.groupResults.setHidden(false)
                self.groupNavigation.setHidden(true)
                
                self.buttonMicrophone.setHidden(true)
                
                
                
                
                
                //completion(“we finished!”)
                
            } else {
                println("p192 No objects")
                self.myLabel.setText("Tap Mic to dictate or force touch")
            }
                */
            }
        })
   
        println("p204 str: \(self.str)")
        println("p205 rawString: \(rawString)")
        //println("### 115 output: \(output)")
      //  println("p207 actionType: \(actionType)")
        
        //self.actionType = "Event"
        
        
        //return self.str
        return (startDT, endDT, output, outputNote, day, calendarName, actionType)
        
    }   //end func grabvoice
    
    
    
    
    

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
