//
//  DictateManagerIC.swift
//  Dictate
//
//  Created by Mike Derr on 9/13/15.
//  Copyright (c) 2015 ThatSoft.com. All rights reserved.
//

import WatchKit
import Foundation
//FIXWC import Parse
//import AVFoundation //commented for new watchExtension 040516


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
var endTime:Date      = Date()

var today               = Date()

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

//var eventDuration:Double    = 10

//var startDate = ""

var now = ""

var outputNote:String       = strRaw

var fullDT:String       = ""
var fullDTEnd:String    = ""

var eventLocation:String    = ""
var eventRepeat:Int         = 0
var duration:Int            = 0
var alert:Int               = 0







// ---- end set Global Varbiables ----


//class DictateManagerIC: NSObject {
    
class DictateManagerIC: WKInterfaceController {
    
    private static var __once: () = {
            Static.instance = DictateManagerIC()
        }()
    
    class var sharedInstance : DictateManagerIC {
        struct Static {
            static var onceToken : Int = 0
            static var instance : DictateManagerIC? = nil
        }
        _ = DictateManagerIC.__once
        return Static.instance!
    }
    
    var str:String      = ""
    var startDT:Date          = Date(dateString:"2014-12-12")
    var endDT:Date            = Date(dateString:"2014-12-12")
    var actionType:String   = ""        //event, reminder, singleWordList, commaList, rawList, note?, text, email
   // var audioPlayer = AVAudioPlayer()
    
    
    // return (startDT, endDT, output, outputNote, day, calendarName, actionType, duration, alert, eventLocation, eventRepeat)
    
    func grabVoice() -> (Date, Date, String, String, String, String, String, Int, Int, String, Int)  {  //startDT, endDT, output, outputNote, day, calendarName, actionType, duration, alert, eventLocation, eventRepeat)

        //added actionType above
        
       // initalizeParse()
        
        var rawString:String    = ""
        var fullDT:String       = ""
        var fullDTEnd:String    = ""
        
        // uncomment line below to get a string from simulator Anil :)
        // self.presentTextInputControllerWithSuggestions(["Today 2 PM test Appointment"], allowedInputMode: WKTextInputMode.Plain, completion: { results -> Void in
        
        self.presentTextInputController(withSuggestions: [], allowedInputMode: WKTextInputMode.plain, completion: { results -> Void in
            
            //println("34 Results: \(results)")
            //println("35 Results: \(results[0])")
            
            if results != nil {
                print("There are objects")
                self.str = results![0] as! String
                print("### 92 str: \(self.str)")
                
            } else {
                print("No objects")
            }
            
            print("### 99 str: \(self.str)")
            
            rawString = self.str
            
            // self.myLabel.setText(self.str)
            //let (startDT, endDT, outputNote) = self.parse(self.str)
            
            if results != nil {
                
                let (startDT, endDT, output, outputNote, day, calendarName, actionType, duration, alert, eventLocation, eventRepeat) = DictateCode().parse(self.str)
                
                let formatter3 = DateFormatter()
                formatter3.dateFormat = "M-dd-yyyy h:mm a"
                
                fullDT = formatter3.string(from: startDT)
                fullDTEnd = formatter3.string(from: endDT)
                
                if (startDT != Date(dateString:"2014-12-12") ) {
                    print("p153 startDT: \(startDT)")
                    
                    fullDT = formatter3.string(from: startDT)
                    fullDTEnd = formatter3.string(from: endDT)
                } else {
                    fullDT = ""
                    fullDTEnd = ""
                }
                
                print("p164 startDT: \(startDT)")
            }
        })
        
        
   
        print("p204 str: \(self.str)")
        print("p205 rawString: \(rawString)")
        // println("### 115 output: \(output)")
        // println("p207 actionType: \(actionType)")

        //return (startDT, endDT, output, outputNote, day, calendarName, actionType)
          return (startDT, endDT, output, outputNote, day, calendarName, actionType, duration, alert, eventLocation, eventRepeat)
        
        
    }   //end func grabvoice
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
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    
   //for watchOS2
/*    func showPopup(){
        
        let h0 = { print("ok")}
        
        let action1 = WKAlertAction(title: "Approve", style: .Default, handler:h0)
        let action2 = WKAlertAction(title: "Decline", style: .Destructive) {}
        let action3 = WKAlertAction(title: "Cancel", style: .Cancel) {}
        
        presentAlertControllerWithTitle("Voila", message: "", preferredStyle: .ActionSheet, actions: [action1, action2,action3])  
    }
 */
//FIXWC
/*
    func initalizeParse() {
        
        print("w107 in DictateManagerIC: initalizeParse")

        Parse.enableLocalDatastore()
        //  PFUser.enableAutomaticUser()
        
//FIXWC Parse.enableDataSharingWithApplicationGroupIdentifier("group.com.thatsoft.dictateApp", containingApplication: "com.thatsoft.dictateApp")
        
        Parse.setApplicationId("1wwwPAQ0Of2Fp6flotUw4YzN64HFDmy3ijAlQZKE",
            clientKey: "EHeeek4uXhJQi0vXPBba945A4h0LQ4QddEGW8gSs")
        
        PFUser.enableAutomaticUser()
        
    }
*/    
    
    

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
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
