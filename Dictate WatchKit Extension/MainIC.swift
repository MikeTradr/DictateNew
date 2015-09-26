//
//  MainIC.swift
//  WatchInput WatchKit Extension
//
//  Created by Mike Derr on 5/8/15.
//  Copyright (c) 2015 ThatSoft.com. All rights reserved.
//

import WatchKit
import Foundation
import EventKit
import Parse
import AVFoundation
//import MessageUI

/*
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

*/


// ---- end set Global Varbiables ----



class MainIC: WKInterfaceController {
    
    let defaults = NSUserDefaults(suiteName: "group.com.thatsoft.dictateApp")!
    
    var audioPlayer = AVAudioPlayer()
    
// TODO watchOS2 var player: WKAudioFilePlayer!
    
    var str:String              = ""
    
    var startDT:NSDate          = NSDate(dateString:"2014-12-12")
    var endDT:NSDate            = NSDate(dateString:"2014-12-12")
    
    var eventStartDT:NSDate     = NSDate(dateString:"2015-06-01")
    var eventEndDT:NSDate       = NSDate(dateString:"2015-06-01")
    
    var calendarName:String     = ""
    
    var output:String           = ""
    var outputNote:String       = ""
    var day:String              = ""
    
   // @IBOutlet weak var myLabel: WKInterfaceLabel!
    
    @IBOutlet weak var myLabel: WKInterfaceLabel!
    @IBOutlet weak var resultType: WKInterfaceLabel!
    @IBOutlet weak var resultDay: WKInterfaceLabel!
    @IBOutlet weak var resultStart: WKInterfaceLabel!
    @IBOutlet weak var resultEnd: WKInterfaceLabel!
    @IBOutlet weak var resultPhone: WKInterfaceLabel!
    @IBOutlet weak var resultCalendar: WKInterfaceLabel!
    
    @IBOutlet weak var groupResults: WKInterfaceGroup!
    
    @IBOutlet weak var groupButtons: WKInterfaceGroup!
    
    @IBOutlet weak var groupNavigation: WKInterfaceGroup!
    
    @IBOutlet weak var buttonMicrophone: WKInterfaceButton! // added to set microphone to hidden
    
    //@IBOutlet weak var groupButtons: WKInterfaceGroup!
   // @IBOutlet weak var groupResults: WKInterfaceGroup!
    
    var actionType:String = NSUserDefaults(suiteName: "group.com.thatsoft.dictateApp")!.stringForKey("actionType") ?? "Event"
    

    
    
    
    
//#### functions #################################
    
 
    
    internal func grabvoice() -> (NSDate, NSDate, String, String, String, String, String)  {  //startDT, endDT, output, outputNote, day, calendarName, actionType
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
                print("There are objects")
                self.str = results![0] as! String
                print("### 92 str: \(self.str)")
                
            } else {
                print("No objects")
            }
            
            print("### 99 str: \(self.str)")
            
            rawString = self.str
            
            self.myLabel.setText(self.str)
            
            //let (startDT, endDT, outputNote) = self.parse(self.str)
            
            if results != nil {
                
                let (startDT, endDT, output, outputNote, day, calendarName, actionType) = DictateCode().parse(self.str)
                
                var formatter3 = NSDateFormatter()
                formatter3.dateFormat = "M-dd-yyyy h:mm a"
                
                fullDT = formatter3.stringFromDate(startDT)
                fullDTEnd = formatter3.stringFromDate(endDT)
                
                if (startDT != NSDate(dateString:"2014-12-12") ) {
                    print("p153 startDT: \(startDT)")
                    
                    fullDT = formatter3.stringFromDate(startDT)
                    fullDTEnd = formatter3.stringFromDate(endDT)
                } else {
                    fullDT = ""
                    fullDTEnd = ""
                }
                
                
                print("p164 startDT: \(startDT)")
                
                // self.eventStartDT = startDT
                //  self.eventEndDT = endDT
                
                self.startDT = startDT
                self.endDT = endDT
                self.output = output
                self.outputNote = outputNote
                self.day = day
                self.calendarName = calendarName
                
                if actionType == "Reminder" {
                    print("p181 actionType setColor: \(actionType)")

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
                print("p192 No objects")
                self.myLabel.setText("Tap Mic to dictate or force touch")
            }
        })
        
        print("p204 str: \(self.str)")
        print("p205 rawString: \(rawString)")
        //println("### 115 output: \(output)")
        print("p207 actionType: \(actionType)")
        
        //self.actionType = "Event"
        
        
        //return self.str
        return (startDT, endDT, output, outputNote, day, calendarName, actionType)
        
    }
    
//---- my General functions ----------------------------------------
    
    func cleardata() {
        print("MainIC 236 we here cleardata: \(date)")
        
        date = ""
        phone = ""
        startDT = NSDate(dateString:"2014-12-12")
        endDT = NSDate(dateString:"2014-12-12")
        
        output = ""
        outputNote = ""
        
        self.resultType.setText("")
        self.resultDay.setText("")
        self.resultStart.setText("")
        self.resultEnd.setText("")
        self.resultPhone.setText("")
        self.resultCalendar.setText("")
        
        self.groupButtons.setHidden(true)
        self.groupResults.setHidden(true)

    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func playSound(sound: NSURL){
        var error:NSError?
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOfURL: sound)
        } catch var error1 as NSError {
            error = error1
        }
        self.audioPlayer.prepareToPlay()
        //player.delegate = self player.play()
        //audioPlayer.delegate = self
        self.audioPlayer.play()
    }
   
    func playSoundNew(sound: NSURL) {
        let filePath = NSBundle.mainBundle().pathForResource("se_tap", ofType: "m4a")!
        let fileUrl = NSURL.fileURLWithPath(filePath)

    }
    
//---- End my General functions ----------------------------------------
    
//---- Menu functions -------------------------------------------
    @IBAction func menuDictate() {
        let (startDT, endDT, output, outputNote, day, calendarName, actionType) = DictateManagerIC.sharedInstance.grabVoice()
    }
    
    @IBAction func menuSettings() {
        presentControllerWithName("Settings", context: "Dictate")
    }
//---- end Menu functions ----------------------------------------

    
    @IBAction func buttonMic() {
        
        var alertSound1: NSURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("button-14", ofType: "mp3")!)
        //General.playSound(alertSound3!)
        
//Second, we currently can't control sounds or haptic feedback from our app's code.
        self.playSound(alertSound1)
       
        let (startDT, endDT, output, outputNote, day, calendarName, actionType) = grabvoice()
        
        print("p268 startDT: \(startDT)")
        print("p269 endDT: \(endDT)")
        print("p270 actionType: \(actionType)")
        print("p271 calendarName: \(calendarName)")
    }
    

    
    @IBAction func buttonCreate() {
        
        self.buttonMicrophone.setHidden(true)  //hide mircophone
        
        print("p277 eventStart: \(startDT)")
        print("p278 calendarName: \(calendarName)")
        
        // CHECK Do I have to call this again??? else 12/12/2014 event
        //Don't need to parse again? commented out 7/4/15 8 am
        
        //let (startDT, endDT, output, outputNote, day, calendarName) = DictateCode().parse(str)
        
        //println("### pl240 startDT: \(startDT)")
        
        var actionType:String    = defaults.stringForKey("actionType")!
        
        print("p299 watchIC, actionType: \(actionType)")
        
        //actionType = "Reminder"
        
        switch (actionType){
        case "Reminder":
            print("p242 in Reminder Switch")
            //createReminder()                      // worked with nothing in func call??? why?
            
            let title:String = output
            //let notes:String = outputNote
            
            //ReminderCode().createReminder(title, notes: notes, startDT: startDT)
            ReminderCode().createReminder()
            
           // resultMessage.text = "Reminder created on your \(calendarName.capitalizedString) list"
            break;
            
        case "Event":
            print("p255 in Event Switch")
            
            // TODO MIKE  remove this parsing again! pass with NSUser Data in method
            //   let (startDT, endDT, output, outputNote, day, calendarName, actionType) = DictateCode().parse(str)
            
            //DictateCode().insertEvent(eventStore, startDT: startDT, endDT: endDT, output: output, outputNote: outputNote, calendarName: calendarName )
            
            EventCode().createEvent()
            
            //resultMessage.text = "Event created on your \(calendarName.capitalizedString) calendar!"
            break;
            
        case "List":
            print("p150 in list Switch")
            break;
        case "CommaList":
            print("p151 in commaList Switch")
            break;
        case "Note":
            print("p152 in note Switch")
            break;
            
        case "Call":
                print("w387 in Call Switch")
                
                //resultMessage.text = "Switching to Phone for your call"
                
                let toPhone:String    = defaults.stringForKey("toPhone")!
                
                General().makeCall(toPhone)
                
              //  enteredText2.text = ""      // set to blank for return
             //   resultMessage.text = ""     // set to blank for return
                
                //let actionType = ""         // set to "" for next processing
                let mainType = ""
                defaults.setObject(actionType, forKey: "actionType")        //saves actionType
                defaults.setObject(actionType, forKey: "mainType")        //saves actionType
                
                let rawDataObject = PFObject(className: "UserData")
                rawDataObject["actionType"] = actionType
                rawDataObject["rawString"] = outputNote
                rawDataObject["userName"] = PFUser.currentUser()?.username
                
                //TODO get these two fields from code!
                rawDataObject["device"] = "iPhone"               //TODO hardcoded get device from code?
                rawDataObject["userPhoneNumber"] = "608-242-7700"               //TODO hardcoded get device from code?
                
                rawDataObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                    print("p490 vcDictate rawDataObject has been saved.")
                }
               break;
                
     

            
            
            
            
        default:
            print("p155 in default switch so assume Event")
            
            //TODO MIke add back fixed call...
            //DictateCode().insertEvent(eventStore, startDT: startDT, endDT: endDT, output: output, outputNote: outputNote, calendarName: calendarName )
            EventCode().createEvent()
            
           // resultMessage.text = "Event created on your \(calendarName.capitalizedString) calendar!"
            break;
        }
        
        
        self.myLabel.setTextColor(UIColor.greenColor())
        
        self.buttonMicrophone.setHidden(true)  //hide mircophone
        
        let labelText = "Event created on your \(calendarName.capitalizedString) calendar!"
        
        let font:UIFont? = UIFont(name: "Arial", size: 22.0)
        
        let attributedString =  NSAttributedString(string: labelText, attributes: [NSFontAttributeName : font!])

        
        self.myLabel.setAttributedText(attributedString)
        
       // ORGINAL self.myLabel.setText("Event created on your \(calendarName.capitalizedString) calendar!")

        
        strRaw          = defaults.stringForKey("strRaw")!
        output          = defaults.stringForKey("output")!
        calendarName    = defaults.stringForKey("calendarName")!
        
        
        print("p485 strRaw: \(strRaw)")
        print("p485 output: \(output)")
        print("p485 outputNote: \(outputNote)")
        print("p485 fullDT: \(fullDT)")
        print("p485 fullDTEnd: \(fullDTEnd)")
        print("p485 calendarName: \(calendarName)")
        print("p485 actionType: \(actionType)")
        
        if (fullDT == "12-12-2014 12:00 AM") {      // set to "" for database
            fullDT = ""
            fullDTEnd = ""
        }
 
//---- Save to Parse Database ----------------------------------------
 
        let rawDataObject = PFObject(className: "UserData")
        rawDataObject["rawString"] = strRaw
        rawDataObject["output"] = output
        rawDataObject["fullDT"] = fullDT
        rawDataObject["fullDTEnd"] = fullDTEnd
        rawDataObject["actionType"] = actionType
        rawDataObject["calendarName"] = calendarName
        
//TODO get these two fields from code!
        rawDataObject["device"] = "Watch"               //TODO hardcoded get device from code?
        rawDataObject["userPhoneNumber"] = "watch phone number"               //TODO hardcoded get device from code?

        //TODO get this from login Screen, hard coded for now...
        
        //rawDataObject["userName"] = "Mike Watch H.Coded"

        print("p349 PFUser.currentUser(): \(PFUser.currentUser())")
        
        if PFUser.currentUser() == nil {
            print("p483 we in here? PFUser.currentUser(): \(PFUser.currentUser())")
            rawDataObject["userName"] = "Watch User"
            
        } else {
            rawDataObject["userName"] = PFUser.currentUser()?.username
        }
        
        
        var query = PFQuery(className:"UserData")
        //TODO somehow get and save email to parse database
        // query.whereKey(“username”, equalTo: PFUser.currentUser()?.username)
        
        print("p358 query: \(query)")
        
        print("p354 PFUser.currentUser()?.email: \(PFUser.currentUser()?.email)")
        
        // rawDataObject["userEmail"] = PFUser.currentUser()?.email
        
        var error:NSError? = nil

        rawDataObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            print("p502 vcTest1 rawDataObject has been saved.")
        }
        
         print("p505 Parse save Error: \(error)")
        
//---- End Save to Parse Database ----------------------------------------
        
        cleardata()
        
        print("462 we here?")

        General().delay(3.0) {          // do stuff
            self.myLabel.setTextColor(UIColor.yellowColor())
            self.myLabel.setText("Tap Mic to dictate or force touch")
            self.groupNavigation.setHidden(false)
            self.buttonMicrophone.setHidden(false)  //hide mircophone
        }
        
        
        defaults.setObject(eventDuration, forKey: "eventDuration")
        
        //resultMessage.text = "Event created on your \(calendarName.capitalizedString) calendar!"
        
        //resultMessageTopRight.text = "Dicatate has created your event :) "
        
        //resultError.text = ""
        
        actionType = ""
        defaults.setObject(actionType, forKey: "actionType")
        
        //self.buttonMicrophone.setHidden(false)  //display mircophone

        
        
    }
    
    
    @IBAction func buttonToday() {
        presentControllerWithName("TodayEvents", context: "Dictate")
    }
    
    @IBAction func buttonReminders() {
        presentControllerWithName("Reminders", context: "Dictate")
    }
    
    
    
    @IBAction func buttonEdit() {
    }

    
    @IBAction func buttonCancel() {
        self.buttonMicrophone.setHidden(false)  //display mircophone
        self.myLabel.setText("Tap Mic to dictate or force touch")
        cleardata()
        
    }
    

//---- Override functions ----------------------------------------
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        // Configure interface objects here.
        NSLog("%@ w536 MainIC awakeWithContext", self)
        print("p471 in MainIC awakeWithContext")
     
       //TODO stops app from running on watch!
       // DictateManagerIC.sharedInstance.initalizeParse()
        
 /*
 //TODO FIX THIS BOMBS MIKE USED TO WORK  LOL
  
        Parse.enableLocalDatastore()
      //  PFUser.enableAutomaticUser()
        
        // Enable data sharing in app extensions.
 
        Parse.enableDataSharingWithApplicationGroupIdentifier("group.com.thatsoft.dictateApp",
            containingApplication: "com.thatsoft.dictateApp")

        Parse.setApplicationId("1wwwPAQ0Of2Fp6flotUw4YzN64HFDmy3ijAlQZKE",
            clientKey: "EHeeek4uXhJQi0vXPBba945A4h0LQ4QddEGW8gSs")
        
        PFUser.enableAutomaticUser()
*/
/*
        // Enable data sharing in app extensions.
        Parse.enableDataSharingWithApplicationGroupIdentifier("group.com.thatsoft.dictateApp", containingApplication: "com.thatsoft.dictateApp")
        
        //Parse.enableLocalDatastore()
        
        // Initialize Parse.
        Parse.setApplicationId("1wwwPAQ0Of2Fp6flotUw4YzN64HFDmy3ijAlQZKE",
            clientKey: "EHeeek4uXhJQi0vXPBba945A4h0LQ4QddEGW8gSs")
*/
        self.setTitle("Dictate™")
        self.myLabel.setTextColor(UIColor.yellowColor())
        self.myLabel.setText("Tap Mic to dictate or force touch")
        self.buttonMicrophone.setHidden(false)  //hide mircophone

    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        NSLog("%@ w536 MainIC willActivate", self)
        print("p589 in MainIC willActivate")
        
        self.myLabel.setTextColor(UIColor.yellowColor())
        self.myLabel.setText("Tap Mic to dictate or force touch")
        self.buttonMicrophone.setHidden(false)  //hide mircophone
        
        super.willActivate()
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        
        
    }
    
    //---- End Override functions ----------------------------------------
    
}   // end InterfaceController