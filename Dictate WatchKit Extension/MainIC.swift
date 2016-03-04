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
import CoreTelephony
//import MessageUI


class MainIC: WKInterfaceController {
    
    //let defaults = NSUserDefaults(suiteName: "group.com.thatsoft.dictateApp")!
    var defaults = NSUserDefaults(suiteName: "group.com.thatsoft.dictateApp")!

    
    var audioPlayer = AVAudioPlayer()
    
// TODO watchOS2 var player: WKAudioFilePlayer!
    
    var str:String              = ""
    
    var startDT:NSDate          = NSDate(dateString:"2014-12-12")
    var endDT:NSDate            = NSDate(dateString:"2014-12-12")
    
    var eventStartDT:NSDate     = NSDate(dateString:"2015-06-01")
    var eventEndDT:NSDate       = NSDate(dateString:"2015-06-01")
    
    var calendarName:String     = ""
    var reminderTitle:String    = ""
    var reminderList:String     = ""
    
    //var output:String           = ""
    var outputNote:String       = ""
    var day:String              = ""
    
   // var labelCreated:String     = ""
    
    //var player: WKAudioFilePlayer!
    
   // @IBOutlet weak var myLabel: WKInterfaceLabel!
    
   // @IBOutlet weak var myLabel: WKInterfaceLabel!
    
    @IBOutlet var myLabel: WKInterfaceLabel!
    
    @IBOutlet weak var resultType: WKInterfaceLabel!
    @IBOutlet weak var resultDay: WKInterfaceLabel!
    @IBOutlet weak var resultStart: WKInterfaceLabel!
   // @IBOutlet weak var resultEnd: WKInterfaceLabel!
    @IBOutlet weak var resultPhone: WKInterfaceLabel!
    @IBOutlet weak var resultCalendar: WKInterfaceLabel!
    
    @IBOutlet var resultTitle: WKInterfaceLabel!
    
    @IBOutlet var groupLabelTitle: WKInterfaceGroup!
    
    @IBOutlet var resultAlarm: WKInterfaceLabel!
    @IBOutlet var resultRepeat: WKInterfaceLabel!
    
    
    @IBOutlet var labelCreated: WKInterfaceLabel!   //large Green label after create button
    
    @IBOutlet weak var groupResults: WKInterfaceGroup!
    @IBOutlet weak var groupButtons: WKInterfaceGroup!
    @IBOutlet weak var groupNavigation: WKInterfaceGroup!
    
    @IBOutlet var labelButtonCreate: WKInterfaceLabel!
    
    
    @IBOutlet var buttonMicGr: WKInterfaceButton!
    
    @IBOutlet var groupMicMain: WKInterfaceGroup!
    @IBOutlet var buttonGrType: WKInterfaceButton!
    @IBOutlet var buttonGrDay: WKInterfaceButton!
    @IBOutlet var buttonGrPhone: WKInterfaceButton!
    
   
    @IBOutlet var buttonGrCalendar: WKInterfaceButton!
    @IBOutlet var buttonGrStart: WKInterfaceButton!
    //@IBOutlet var buttonGrEnd: WKInterfaceButton!
    
    @IBOutlet var buttonGrTitle: WKInterfaceButton!
    
    @IBOutlet var buttonGrAlarm: WKInterfaceButton!
    @IBOutlet var buttonGrRepeat: WKInterfaceButton!
 
    @IBOutlet var buttonCreateOutlet: WKInterfaceGroup!

    
    var actionType:String = NSUserDefaults(suiteName: "group.com.thatsoft.dictateApp")!.stringForKey("actionType") ?? "Event"

    var alert       = NSUserDefaults(suiteName: "group.com.thatsoft.dictateApp")!.objectForKey("defaultEventAlert") as? Double //added defualt 112715

    let eventRepeat      = NSUserDefaults(suiteName: "group.com.thatsoft.dictateApp")!.stringForKey("defaultEventRepeat") //added defualt 112715
    
    var output      = NSUserDefaults(suiteName: "group.com.thatsoft.dictateApp")!.stringForKey("output") ?? ""
    
    var phone       = NSUserDefaults(suiteName: "group.com.thatsoft.dictateApp")!.stringForKey("phone")
    
    var wordArrTrimmed  = NSUserDefaults(suiteName: "group.com.thatsoft.dictateApp")!.objectForKey("wordArrTrimmed") as? [String] ?? [] //array of the items

    
    let lightPink = UIColor(red: 255/255, green: 204/255, blue: 255/255, alpha: 1)
    let swiftColor = UIColor(red: 255/255, green: 165/255, blue: 0/255, alpha: 1)
    let moccasin = UIColor(red: 255/255, green: 228/255, blue: 181/255, alpha: 1)     //light biege color, for Word List
    let apricot = UIColor(red: 251/255, green: 206/255, blue: 177/255, alpha: 1)


//#### functions #################################
    
    internal func grabvoice() -> (NSDate, NSDate, String, String, String, String, String)  {  //startDT, endDT, output, outputNote, day, calendarName, actionType
        //added actionType above
        
        self.buttonMicGr.setHidden(true)
        
        var rawString = ""
        var fullDT:String       = ""
        var fullDTEnd:String    = ""
        
        let str31:String = "todo today, call mom, meeting at 10 AM, play tennis, pick up kids" // comma deliminated list, first phrase or word before comma is title
        
        let str27:String = "new list groceries cheese milk carrots lettace eggs tomatoes carrots crackers salsa dip pizza dressing water beer wine salt file newspapers"
        
        let str32:String = "list shower work workout dinner sleep"  //raw list one word speed list, title = "untitled list"
        
        let str38a:String = "Reminder mow the grass today 1 pm"
        
        let str38:String = "Reminder mow the grass today 1 pm list today"
        
        let str3:String = "New appointment 11 AM today show apartment with Sandi calendar Mike"
        
        let str49:String = "tomorrow all day study for exam calendar Mike"

        let str50:String = "Monday all day study for exam"

        let str27a:String = "new list groceries cheese milk carrots lettace eggs"
        
        let str4:String = "Appointment at 1:30 PM to see efficiency with Tony 608-255-9876"

   
        var str:String = str27a
        let str1:String = "Reminder wash the car"
        let str2:String = str4
        
        var suggestionArray:[String] = []
        //let suggestionArray = [str, str1, str2]       //TODO Comment out for non-testing
        
        var phone       = defaults.stringForKey("phone")
        var alert       = defaults.objectForKey("defaultEventAlert") as? Double //added defualt 112715
        let duration    = defaults.stringForKey("defaultEventDuration")         //added defualt 112715
        let eventRepeat = defaults.stringForKey("eventRepeat")
        let strRaw      = defaults.stringForKey("strRaw")
        var reminderTitle   = defaults.stringForKey("title") ?? ""
        var wordArrTrimmed  = defaults.objectForKey("wordArrTrimmed") as? [String] ?? [] //array of the items
        
        //TODO Mike Anil commented to fix nil error
        // var reminderArray = defaults.objectForKey("reminderArray") as! [String] //array of the items
        
        var reminderArray:[String] = []
        var reminderList    = defaults.stringForKey("reminderList") ?? ""
        
        var reminderAlarm   = defaults.objectForKey("reminderAlarm") as? NSDate
        var allDayFlag = self.defaults.objectForKey("allDayFlag") as? Bool ?? false     //Anil helped here :)
        
        print("w111Defaults ==================================")
        print("w111Defaults phone: \(phone)")
        print("w111Defaults alert: \(alert)")
        print("w111Defaults duration: \(duration)")
        print("w111Defaults eventRepeat: \(eventRepeat)")
        print("w111Defaults strRaw: \(strRaw)")
        print("w111Defaults reminderTitle: \(reminderTitle)")
        print("w111Defaults wordArrTrimmed: \(wordArrTrimmed)")

        print("w111Defaults reminderArray: \(reminderArray)")
        print("w111Defaults reminderList: \(reminderList)")
        print("w111Defaults reminderAlarm: \(reminderAlarm)")
        print("w111Defaults allDayFlag: \(allDayFlag)")
  
        print("w111FromDefaults end ==============================")





       
        self.presentTextInputControllerWithSuggestions(suggestionArray, allowedInputMode: WKTextInputMode.Plain, completion: { results -> Void in

            //println("34 Results: \(results)")
            //println("35 Results: \(results[0])")
            
            if results != nil {
                print("w197 There are objects")
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
                
                print("w200Main ==================================")
                print("w200Main startDT: \(startDT)")
                print("w200Main endDT: \(endDT)")
                print("w200Main output: \(output)")
                print("w200Main outputNote: \(outputNote)")
                print("w200Main day: \(day)")
                print("w200Main calandarName: \(calendarName)")
                print("w200Main actionType: \(actionType)")
                print("w200Main dictate ==================================")

                print("w200Main phone: \(phone)")
                print("w200Main duration: \(duration)")
                print("w200Main alert: \(alert)")
                print("w200Main eventRepeat: \(eventRepeat)")
                print("w200Main strRaw: \(strRaw)")
                print("w200Main mainType: \(mainType)")
                print("w200Main reminderTitle: \(reminderTitle)")
                print("w200Main wordArrTrimmed: \(wordArrTrimmed)")
                print("w200Main reminderList: \(reminderList)")
                print("w200Main reminderArray: \(reminderArray)")
                print("w200Main reminderAlarm: \(reminderAlarm)")
                
                print("w200Main allDayFlag: \(allDayFlag)")
                print("w200Main end ==================================")
        
                
                var formatter3 = NSDateFormatter()
                formatter3.dateFormat = "M-dd-yyyy h:mm a"
                
                fullDT = formatter3.stringFromDate(startDT)
                fullDTEnd = formatter3.stringFromDate(endDT)
                
                if (startDT != NSDate(dateString:"2014-12-12") ) {
                    print("w153 startDT: \(startDT)")
                    
                    fullDT = formatter3.stringFromDate(startDT)
                    fullDTEnd = formatter3.stringFromDate(endDT)
                } else {
                    fullDT = ""
                    fullDTEnd = ""
                }
                
                print("w245 startDT: \(startDT)")
                print("w246 fullDT: \(fullDT)")
                
                self.startDT    = startDT
                self.endDT      = endDT
                self.output     = output
                self.outputNote = outputNote
                self.day        = day
                self.calendarName = calendarName
                
                
               //format Times to look great!
                let dateFormatter = NSDateFormatter()
                let dateString = dateFormatter.stringFromDate(startDT)
                
                dateFormatter.dateFormat = "h:mm a"
                
                let startTimeA = dateFormatter.stringFromDate(startDT)
                var startTime = startTimeA.stringByReplacingOccurrencesOfString(":00", withString: "")
                
                let endTimeA = dateFormatter.stringFromDate(endDT)
                let endTime = endTimeA.stringByReplacingOccurrencesOfString(":00", withString: "")
                
                var endTimeDash = "-\(endTime)"
                
                var time = "\(startTime)\(endTimeDash)"
                
                //var allDayFlag = self.defaults.objectForKey("allDayFlag") as? Bool ?? false

                if allDayFlag {   // if allDay bool is true
                    formatter3.dateFormat = "M-dd-yyyy"
                    fullDT = formatter3.stringFromDate(startDT)
                    
                    startTime = ""
                    time = "\(fullDT), All Day"
                }
                
        
                self.resultType.setText("Type: \(actionType)")
                
                if (self.day == ""){
                    self.resultDay.setText("")
                    self.buttonGrDay.setHidden(true)
                } else {
                    self.resultDay.setText("Day: \(day)")
                    self.buttonGrDay.setHidden(false)
                }
               
                
                self.resultStart.setText("Time: \(time)")
                
                //self.resultEnd.setText("  end: \(fullDTEnd)")
                //self.buttonGrEnd.setHidden(true)                //no longer used

                
                self.resultPhone.setText("Cell: \(self.phone)")
                self.resultCalendar.setText("Cal.: \(calendarName)")
                
                self.resultTitle.setText("\"\(output)\"")
                
                var alertAsInt = 0
                if self.alert != nil {
                    alertAsInt = Int(self.alert!)               // to format 10.0  to 10  for minutes result
                }
                
                if (self.alert == 0.0 || self.alert == nil){
                    self.resultAlarm.setText("")
                    self.buttonGrAlarm.setHidden(true)
                } else {
                    self.resultAlarm.setText("Alert: \(String(alertAsInt)) minutes")
                    self.buttonGrAlarm.setHidden(false)
                }
                
                if (self.eventRepeat == "0" || self.eventRepeat == nil) {
                    self.resultRepeat.setText("")
                    self.buttonGrRepeat.setHidden(true)
                } else {
                    self.resultRepeat.setText("Repeat: \(self.eventRepeat)")
                    self.buttonGrRepeat.setHidden(false)
                }

                self.groupButtons.setHidden(false)
                self.groupResults.setHidden(false)
                self.groupNavigation.setHidden(true)
                self.groupMicMain.setHidden(true)
                
                if self.phone == "" || self.phone == nil {
                    self.buttonGrPhone.setHidden(true)
                } else {
                    self.buttonGrPhone.setHidden(false)
                }
                
                
                // ____ actionType Text ____________________________________
                
                //TODO Can we pass to phone or do these things on watch as we do on phone?
                switch (actionType) {
                case "Text":
                    print("w196 in Text Switch")
                    
                    break;
                    
                case "Call":
                    print("w431 in Call Switch")
                    
                    let toPhone:String    = self.defaults.stringForKey("toPhone")!
                    General().makeCall(toPhone)
                    
                    break;
                    
                case "Mail":
                    print("w456 in Mail Switch")
                    
                    break;
                    
                case "Mail List":
                    print("w588 in Mail List Switch")
                    
                    break;
                    
                case "Mail Events":
                    print("w632 in Mail Events Switch")
                    
                    break;
                    
                case "Reminder":
                    print("w224 in Reminder Switch")
                    self.resultType.setTextColor(UIColor.yellowColor())
                    self.labelButtonCreate.setText("Create Reminder")
                    self.buttonCreateOutlet.setBackgroundColor(UIColor.yellowColor())
                    if day == "No Day Found" {
                        self.buttonGrDay.setHidden(true)
                    }
                    
                    print("w317 fullDT: \(fullDT)")
                    if ( fullDT == "" ) {        // added 072315 no need to show if no date used
                        self.buttonGrStart.setHidden(true)
                    }
                    
                    let reminderTitle = self.defaults.stringForKey("reminderList") ?? ""
                    self.resultCalendar.setText("List: \(reminderTitle)")
                    self.resultTitle.setText("Items: \(output)")
                    
                   //if fullDT != "12-12-2014 12:00 AM" {        // means a blank date
                    if fullDT != "" {        // means a blank date
                        self.buttonGrAlarm.setHidden(false)
                        self.resultAlarm.setText("Alarm: \(startTime)")
                    } else {
                        self.buttonGrAlarm.setHidden(true)
                    }
                    
                    self.buttonGrStart.setHidden(true)
                    
                    break;
                    
                case "Event":
                    self.resultType.setTextColor(self.swiftColor)
                    //self.groupLabelTitle.setBackgroundColor(self.swiftColor)
                    self.labelButtonCreate.setText("Create Event")
                    self.buttonCreateOutlet.setBackgroundColor(UIColor.greenColor())
                    self.resultCalendar.setText("Calendar: \(calendarName)")
                    self.resultTitle.setText("Title: \(output)")
                    break;
                    
                case "New List", "List":
                    let wordArrTrimmed  = self.defaults.objectForKey("wordArrTrimmed") as? [String] ?? [] //array of the items
                    let stringOutput = wordArrTrimmed.joinWithSeparator(", ")
                    let reminderTitle = self.defaults.stringForKey("reminderList") ?? ""
                   // self.resultType.setTextColor(self.moccasin)
                    self.labelButtonCreate.setText("Create New List")
                    self.buttonCreateOutlet.setBackgroundColor(self.moccasin)
                    self.resultCalendar.setText("List: \(reminderTitle)")
                    self.resultTitle.setText("Items: \(stringOutput)")
                    if ( fullDT == "" ) {
                        self.buttonGrStart.setHidden(true)
                    }
                    //no alerts for lists so set to hidden
                    self.resultAlarm.setText("")
                    self.buttonGrAlarm.setHidden(true)
                    break;
                
                case "New OneItem List":
                    let wordArrTrimmed  = self.defaults.objectForKey("wordArrTrimmed") as? [String] ?? [] //array of the items
                    let stringOutput = wordArrTrimmed.joinWithSeparator(", ")
                    let reminderTitle = self.defaults.stringForKey("reminderList") ?? ""
                  //  self.resultType.setTextColor(self.moccasin)
                    self.labelButtonCreate.setText("Create New List")
                    self.buttonCreateOutlet.setBackgroundColor(self.moccasin)

                    self.resultCalendar.setText("List: \(reminderTitle)")
                    self.resultTitle.setText("Items: \(stringOutput)")
                    //no alerts for lists so set to hidden
                    self.resultAlarm.setText("")
                    self.buttonGrAlarm.setHidden(true)
                    break;
                    
                case "Phrase List":
                    let wordArrTrimmed  = self.defaults.objectForKey("wordArrTrimmed") as? [String] ?? [] //array of the items
                    let stringOutput = wordArrTrimmed.joinWithSeparator(", ")
                    let reminderTitle  = self.defaults.stringForKey("reminderList") ?? ""
                   // self.resultType.setTextColor(self.apricot)
                    self.labelButtonCreate.setText("Create Phrase List")
                    self.buttonCreateOutlet.setBackgroundColor(self.apricot)

                    self.resultCalendar.setText("List: \(reminderTitle)")
                    self.resultTitle.setText("Items: \(stringOutput)")
                    if ( fullDT == "" ) {        // added 072315 no need to show if no date used
                        self.buttonGrStart.setHidden(true)
                    }
                    //no alerts for lists so set to hidden
                    self.resultAlarm.setText("")
                    self.buttonGrAlarm.setHidden(true)
                    break;
                    
                default:
                    print("w200 Switch Default")
                    
                }   //end Switch

                //completion(“we finished!”)
                
            } else {
                print("p192 No objects or canceled")
                self.myLabel.setText("Tap Mic to dictate or force touch")
                self.buttonMicGr.setHidden(false)
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
        self.phone = ""
        startDT = NSDate(dateString:"2014-12-12")
        endDT = NSDate(dateString:"2014-12-12")
        
        output = ""
        outputNote = ""
        
        self.resultType.setText("")
        self.resultDay.setText("")
        self.resultStart.setText("")
        self.resultPhone.setText("")
        self.resultCalendar.setText("")
        self.resultStart.setHidden(false)
        
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
    
    
    @IBAction func buttonGroupMic() {
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
        
        self.buttonMicGr.setHidden(true)  //hide mircophone
        
        print("w581 eventStart: \(startDT)")
        print("w582 calendarName: \(calendarName)")
        
        var actionType:String    = defaults.stringForKey("actionType")!
        
        print("w586 mainIC, actionType: \(actionType)")
        
// ---- switch actionType in button Create ------------------------------------
        
        switch (actionType){
        case "Reminder":
            print("w592 in Reminder Switch")
            //createReminder()                      // worked with nothing in func call??? why?
            
            let title:String = output
            //let notes:String = outputNote
            
            //ReminderCode().createReminder(title, notes: notes, startDT: startDT)
            ReminderCode().createReminder()
            
            var reminderList    = defaults.stringForKey("reminderList") ?? ""
            
            print("w601 reminderList: \(reminderList)")
            
            self.labelCreated.setText("Reminder created on your \(reminderList.capitalizedString) list")
            break;
            
        case "Event":
            print("w568 in Event Switch")
            
            EventManager().createEvent()
            
            self.labelCreated.setText("Event created on your \(calendarName.capitalizedString) calendar!")

            break;
            
        case "New List", "List":
            
            let reminderTitle  = defaults.stringForKey("reminderList") ?? ""
            
            ReminderManager.sharedInstance.createNewReminderList(reminderList, items: wordArrTrimmed)
            
            self.labelCreated.setText("New List, \(reminderTitle), has been created")
            
            break;
            
        case "New OneItem List":
            
            let reminderTitle  = defaults.stringForKey("reminderList") ?? ""

            output      = defaults.stringForKey("output") ?? ""
            let outputArray:[String] = Array(arrayLiteral: output)
            
            ReminderManager.sharedInstance.createNewReminderList(reminderList, items: outputArray)
            
            self.labelCreated.setText("New List, \(reminderTitle), has been created")
            
            break;
            
    // ____ Phrase List ____________________________________
        case "Phrase List":
            print("w589 in phraseList Switch")
            
            let reminderTitle  = defaults.stringForKey("reminderList") ?? ""
            
            ReminderManager.sharedInstance.createNewReminderList(reminderList, items: wordArrTrimmed)
            
            self.labelCreated.setText("New Phrase List, \(reminderTitle), has been created")

            break;
            
            
        case "List":
            print("w150 in list Switch")
             self.labelCreated.setText("List created on your \(reminderList.capitalizedString) calendar!")
           
            break;
            
        case "CommaList":
            print("w151 in commaList Switch")
             self.labelCreated.setText("New Reminder List created: \(reminderList.capitalizedString)")
            break;
            
        case "Note":
            print("w152 in note Switch")
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
            
        //    rawDataObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                print("p697 MainIC rawDataObject has been saved.")
         //   }
            break;
            
     
        default:
            print("p155 in default switch so assume Event")
            
            EventManager().createEvent()
            
            // resultMessage.text = "Event created on your \(calendarName.capitalizedString) calendar!"
            break;
        }
        
    // ---- end switch actionType in button Create ------------------------------------
        
        
        self.labelCreated.setHidden(false)
        self.labelCreated.setTextColor(UIColor.greenColor())
        
        self.buttonMicGr.setHidden(true)  //hide mircophone
        
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
        
// ____ Save to Parse Database ____________________________________
        
        // Setup Parse
        Parse.setApplicationId("1wwwPAQ0Of2Fp6flotUw4YzN64HFDmy3ijAlQZKE",
            clientKey: "EHeeek4uXhJQi0vXPBba945A4h0LQ4QddEGW8gSs")
        
        let rawDataObject = PFObject(className: "UserData")
        rawDataObject["rawString"] = strRaw
        rawDataObject["output"] = output
        rawDataObject["fullDT"] = fullDT
        rawDataObject["fullDTEnd"] = fullDTEnd
        rawDataObject["actionType"] = actionType
        rawDataObject["calendarName"] = calendarName
        
        //TODO get these two fields from code!
        //TODO see here:
        print("p478 Device and Phone munber in here: \(NSUserDefaults.standardUserDefaults().dictionaryRepresentation())")
        
        let uuid = UIDevice.currentDevice().identifierForVendor!.UUIDString
        let device = UIDevice.currentDevice().model
        
        let systemVersion = UIDevice.currentDevice().systemVersion
        
        //let modelName = UIDevice.currentDevice().modelName
        let modelName = "Watch"

        
        let memory = NSProcessInfo.processInfo().physicalMemory/(1024 * 1024 * 1024)    //to convert to GB
        // memory = memory/(1024 * 1024 * 1024)
        
        // Setup the Network Info and create a CTCarrier object
        let networkInfo = CTTelephonyNetworkInfo()
        let carrier = networkInfo.subscriberCellularProvider
        
        // Get carrier name
        // TODO Mike Anil crashes on watch!
        //let carrierName: String = carrier!.carrierName!
        
        
        print("p822 uuid: \(uuid)")
        print("p822 device: \(device)")
        print("p822 systemVersion: \(systemVersion)")
        print("p822 modelName: \(modelName)")
        print("p822 memory: \(memory)")
   //     print("p822 carrierName: \(carrierName)")
        
        
       // let deviceComplete = "\(modelName) - \(memory) GB"    //was memory I desired capacity on phones.
        let deviceComplete = "\(modelName)"
        
        print("p822 deviceComplete: \(deviceComplete)")
        
        
        rawDataObject["device"] = deviceComplete
        rawDataObject["system"] = systemVersion
        rawDataObject["carrier"] = "Watch" //carrierName
        
        
        rawDataObject["userPhoneNumber"] = "608-242-7700"               //TODO hardcoded get device from code?
        
        //TODO get this from login Screen, hard coded for now...
        
        
        //TODO fix PFuser when is nil can be nil???
        
        if PFUser.currentUser() == nil {
            rawDataObject["userName"] = "Mike Watch Coded"
        } else {
            // rawDataObject["userName"] = "Mike Hard Coded"
            
            print("p824 PFUser.currentUser().username: \(PFUser.currentUser()!.username!)")
            
            // todo bombs below here.
            //TODO Anil I chnged as had nil, when we no longer sue login screen 123115 MJD
            //rawDataObject["userName"] = PFUser.currentUser()!.username
            rawDataObject["userName"] = PFUser.currentUser()!
        }
        
        print("p813 we here? ")
        
        //TODO works, hard coded name for now Anil help
        rawDataObject["userName"] = "Mike Watch Coded"
        
        // TODO used to have this alone:  rawDataObject["userName"] = PFUser.currentUser()?.username
        
        var query = PFQuery(className:"UserData")
        //TODO somehow get and save email to parse database
        // query.whereKey(“username”, equalTo: PFUser.currentUser()?.username)
        
        print("p824 query: \(query)")
        
        print("p826 PFUser.currentUser()?.email: \(PFUser.currentUser()?.email)")
        
        // rawDataObject["userEmail"] = PFUser.currentUser()?.email
        
        rawDataObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            print("p831 MainIC rawDataObject has been saved.")
        }
        
// ____ End Save to Parse Database ____________________________________
        
        
        
        
        
        
 /*
        //---- Save to Parse Database ----------------------------------------
        
        let rawDataObject = PFObject(className: "UserData")
        rawDataObject["rawString"] = strRaw
        rawDataObject["output"] = output
        rawDataObject["fullDT"] = fullDT
        rawDataObject["fullDTEnd"] = fullDTEnd
        rawDataObject["actionType"] = actionType
        rawDataObject["calendarName"] = calendarName
        
        //TODO Anil TODO Mike get these two fields from code!
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
        
        rawDataObject["userName"] = "Mike Watch Coded"

        
        
        var query = PFQuery(className:"UserData")
        //TODO somehow get and save email to parse database
        // query.whereKey(“username”, equalTo: PFUser.currentUser()?.username)
        
        print("w575 query: \(query)")
        
        print("w577 PFUser.currentUser()?.email: \(PFUser.currentUser()?.email)")
        
        // rawDataObject["userEmail"] = PFUser.currentUser()?.email
        
        var error:NSError? = nil
        
        rawDataObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            print("w584 vcTest1 rawDataObject has been saved.")
        }
        
        print("w587 Parse save Error: \(error)")
        
        //---- End Save to Parse Database ----------------------------------------
*/
        cleardata()
        
        print("w593 we here?")
        
        General().delay(3.0) {          // do stuff
            self.myLabel.setTextColor(UIColor.yellowColor())
            self.myLabel.setText("Tap Mic to dictate or force touch")
            self.groupNavigation.setHidden(false)
            self.buttonMicGr.setHidden(false)  //show mircophone
            self.labelCreated.setHidden(true)
            
        }
        
        
        defaults.setObject(eventDuration, forKey: "eventDuration")
        
        //resultMessage.text = "Event created on your \(calendarName.capitalizedString) calendar!"
        
        //resultMessageTopRight.text = "Dicatate has created your event :) "
        
        //resultError.text = ""
        
        actionType = ""
        defaults.setObject(actionType, forKey: "actionType")
        
        
        self.groupMicMain.setHidden(false)
        
        
    }       // end buttonCreate

    
    
    
    
    @IBAction func buttonCancel() {
        //self.buttonMicGr.setHidden(false)  //display mircophone
        self.myLabel.setText("Tap Mic to dictate or force touch")
        cleardata()
        self.groupMicMain.setHidden(false)       //show mircophone
        self.groupNavigation.setHidden(false)
        self.groupResults.setHidden(true)
        
        self.buttonMicGr.setHidden(false)  //show mircophone
        self.labelCreated.setHidden(true)
        
        cleardata()
    
    }
    
    
    @IBAction func buttonToday() {
        presentControllerWithName("Events", context: "Dictate")
    }
    
    @IBAction func buttonReminders() {
        presentControllerWithName("Reminders", context: "Dictate")
    }
    
    

    

//---- Override functions ----------------------------------------
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        // Configure interface objects here.
        NSLog("%@ w657 MainIC awakeWithContext", self)
        print("w658 in MainIC awakeWithContext")
     
        self.setTitle("Dictate™")
        self.myLabel.setTextColor(UIColor.yellowColor())
        self.myLabel.setText("Tap Mic to dictate or force touch")
        self.buttonMicGr.setHidden(false)       //show mircophone
        self.groupNavigation.setHidden(false)   //show navigation
        //hide these:
        self.groupResults.setHidden(true)       //hide results
        self.labelCreated.setHidden(true)       //hide label
        self.groupButtons.setHidden(true)


    }
//===== willActivate ==================================================
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        NSLog("%@ w671 MainIC willActivate", self)
        print("w672 in MainIC willActivate")
        
        //make Calendar's List Array
        ReminderManager.sharedInstance.createCalendarArray()
        
        //make ReminderStringList Array
        ReminderManager.sharedInstance.createReminderStringArray()

     /*
        self.myLabel.setTextColor(UIColor.yellowColor())
        self.myLabel.setText("Tap Mic to dictate or force touch")
        self.buttonMicGr.setHidden(false)       //show mircophone
        self.groupNavigation.setHidden(false)   //show navigation
        //hide these:
        self.groupResults.setHidden(true)       //hide results
        self.labelCreated.setHidden(true)       //hide label
        self.groupButtons.setHidden(true)       //hide buttons
     */
        super.willActivate()
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        
        
    }
    
    //---- End Override functions ----------------------------------------
    
}   // end InterfaceController



