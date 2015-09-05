//
//  DictateCode.swift
//  WatchInput
//
//  Created by Mike Derr on 5/20/15.
//  Copyright (c) 2015 ThatSoft.com. All rights reserved.
//

import UIKit
import EventKit

/*
func delay(delay:Double, closure:()->()) {
dispatch_after(
dispatch_time(
DISPATCH_TIME_NOW,
Int64(delay * Double(NSEC_PER_SEC))
),
dispatch_get_main_queue(), closure)
}
*/

class DictateCode: NSObject {
    
    var startDT:NSDate          = NSDate(dateString:"2014-12-12")
    var endDT:NSDate            = NSDate(dateString:"2014-12-12")
    
    var outputNote:String       = ""
    var output:String           = ""
    var day:String              = ""
    
    var priorWord:String        = ""
    var priorWord2:String       = ""
    var nextWord:String         = ""
    var nextWord2:String        = ""
    var numberFound:String      = ""
    var startDate:String        = ""
    var currentMonthNumber:Int  = 0
    var wordMonthNumber:Int     = 0
    
    var errorMsg:String         = ""
    var calendarToUse:String    = ""
    var calendarName:String     = ""
    var listName:String         = ""
    var listToUse:String        = ""

    
    //var startDate:String        = ""
    
    var database                = EKEventStore()
    var napid:String!
    
    var wordArrTrimmed:[String] = []
    
    var userAlertMinutes:Double = 0
    var eventAlert:Double       = 0
    var eventRepeatInterval:Int = 0
    
    var numberWordArray:[String] = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten"]
    
    enum NumberWord:Int { case one=1, two=2, three=3, four=4, five=5, six=6, seven=7, eight=8, nine=9, ten=10 }
    
    var userDuration:Int = 0
    
    var actionType:String   = ""        //event, reminder, singleWordList, commaList, rawList, note?, text, email
    var mainType:String   = ""
    
    let defaults = NSUserDefaults.standardUserDefaults()
   
// new for new start...
    var eventDuration:Double     = 10   //TODO get this from settings
    var now = ""
    var word = ""
    var timeString = ""
    var phone = ""
    var today = NSDate()
    var date = ""
    var aptType = ""
    var outputRaw = ""
    
    //#### my functions #################################
    
    func stripListWords(wordArr:[String]) -> ([String]) {
        
        for (i, element) in enumerate(wordArr) {
            
            word = wordArr[i] //as! String
        }
        
        return wordArr
    }


    
    func parse (str: String) -> (NSDate, NSDate, String, String, String, String, String) {
        //returning startDT, endDT, output, outputNote, day, calendarName, eventDuration, actionType
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        var wordArr:[String]        = []
        
        actionType = ""     // set to blank so can process...
        mainType = ""
        calendarName = ""   // set to blank so can process...
        listName = ""
        
        
        //eventDuration = 10  // TODO get from defaults screen
        //eventDuration = 0  // TODO get from defaults screen
        
        var eventDuration:Double     = 10

        
        defaults.setObject(actionType, forKey: "actionType")        //sets actionType for processing
        defaults.setObject(mainType, forKey: "mainType")            //sets mainType
        defaults.setObject(eventDuration, forKey: "eventDuration")
        defaults.setObject(wordArrTrimmed, forKey: "wordArrTrimmed")

        
        println("p116 eventDuration from NSDefaults: \(eventDuration)")              // see what NSDefaults has!
        println("p87 calendarName: \(calendarName)")              // see what NSDefaults has!
        
        
        
        if (str != "") {
            
            var strRaw:String = str
            var str = str.lowercaseString
            println("p91 str: \(str)")
            println("p92 strRaw: \(strRaw)")
            
            var startDate:String = ""
            var day:String = ""
            var time = "No Time Found"
            
            defaults.setObject(strRaw, forKey: "strRaw")
            
            
            //TODO ADD if we see LIST then parse on comma maybe...
            
            let charset = NSCharacterSet(charactersInString: ",")

// ____ IF for comma in string ____________________________________
           
            if str.lowercaseString.rangeOfCharacterFromSet(charset, options: nil, range: nil) != nil {
                println("p122 Comma's in String yes")
                
                wordArr = str.componentsSeparatedByString(",")      //** use for COMMA seperated list, or phrases
                
                actionType = "Phrase List"         // set type for proper processing
                
                let notes = wordArr              //origonal string
                mainType = "Phrase List"
                
                // New list today go to the store,
                
                var firstString:String = wordArr[0]
                
               // let subStringNew = (firstString as NSString).containsString("new list") // see "new" then process
                
               // if(subStringNew){
                //    firstString = firstString.stringByReplacingOccurrencesOfString("new list", withString: "", options: .allZeros, range: nil)
               // }
                
                firstString = firstString.stringByReplacingOccurrencesOfString("new", withString: "", options: .allZeros, range: nil)
                
                firstString = firstString.stringByReplacingOccurrencesOfString("list", withString: "", options: .allZeros, range: nil)
                
                println("p100 wordArr: \(wordArr)")
                println("p150 firstString: \(firstString)")
                
                var reminderTitle = firstString
                
            //    if #available(iOS 9.0, *) {
            //        reminderTitle.localizedCapitalizedString
            //   }
                
                reminderTitle = reminderTitle.capitalizedString
                println("p172 reminderTitle: \(reminderTitle)")

                wordArrTrimmed = wordArr.filter() { $0 != wordArr[0] }   // remove first array item
                println("p165 wordArrTrimmed: \(wordArrTrimmed)")
             
                defaults.setObject(actionType, forKey: "actionType")    //sets actionType for processing
                defaults.setObject(mainType, forKey: "mainType")
                defaults.setObject(reminderTitle, forKey: "title")      //sets reminderTitle
                defaults.setObject(reminderTitle, forKey: "calendarName")   //sets title to calendarName for ParseDB
                
                defaults.setObject(wordArrTrimmed, forKey: "wordArrTrimmed")            //sets reminderItems

                return (startDT, endDT, output, outputNote, day, calendarName, actionType)
                
// ____ end IF comma in string ____________________________________
                
            } else {
                
                wordArr = str.componentsSeparatedByString(" ")      //** use for SPACE seperated list, or phrases
            

            //let wordArr = str.componentsSeparatedByString(",")      //** use for COMMA seperated list, or phrases
            
            wordArrTrimmed = wordArr
            
            let wordArrRaw = strRaw.componentsSeparatedByString(" ")    //Raw Array for nicer output
            println("p100 wordArr: \(wordArr)")
            println("p101 wordArrRaw: \(wordArrRaw)")
            
            
            var arrayLength = wordArr.count  // is Array Length
            
            println("p87 wordArrTrimmed: \(wordArrTrimmed)")
            
            println("107: \(wordArr.count) is array length")
            
            func printTimestamp() -> String {
                let timestamp = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .LongStyle, timeStyle: .ShortStyle)
                //let timestamp = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .LongStyle, timeStyle: .NoStyle)
                println("p45 tmestamp: \(timestamp)")
                let now = timestamp
                return now
            }
            
            printTimestamp()        // Prints "Sep 9, 2014, 4:30 AM"
            //today = timestamp
            println("141 now: \(now)")
            
            var d = NSDate()
            
            let dateStyler = NSDateFormatter()
            dateStyler.dateFormat = "MM-dd-yyyy"
            
            let myDate = dateStyler.dateFromString("04-05-2014")!
            //let todayDate = dateStyler.dateFromString(today)!
            
            let myWeekday = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitWeekday, fromDate: myDate).weekday
            
            let calendar = NSCalendar.currentCalendar()
            let date2 = NSDate()
            
            var components = NSDateComponents()
            components.weekOfYear = 1
            components.hour = 0
            
            println("194: 1 week and 0 hours from now: \(calendar.dateByAddingComponents(components, toDate: date2, options: nil))")
            
            
// ____ For Loop to loop through every word in the Sting now an array _________________
            
            for (i, element) in enumerate(wordArr) {
                
                word = wordArr[i] //as! String
                
                println("___")
                println("vvvvvvvv current WORD vvvvvvvv: \(word)")
                
                println("p132 wordArrTrimmed: \(wordArrTrimmed)")
                
                
// ____ "new" word ____________________________________
                
                let subStringNewList = (word as NSString).containsString("new") // see "new" ore "remind" then process
                
                if(subStringNewList && (wordArr[i] == wordArr[0])){ //added last so only here if matches is first word in string!
                    
                    if (i < arrayLength-1) {
                        nextWord = wordArr[i+1]
                    } else {
                        nextWord = ""
                    }
                    
                    if (i < arrayLength-2) {
                        nextWord2 = wordArr[i+2]
                    } else {
                        nextWord2 = ""
                    }

                    
                    if ( (nextWord != "") && nextWord == "list" ) {
                        
                            wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i+1] }   // remove "list" nextword
                        
                            wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }   // remove "new" word
                        
                            wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i+2] }   // remove nextWord2 the list name.
            
                            println("p200 nextWord: \(nextWord)")
                        
                            println("p202 wordArrTrimmed: \(wordArrTrimmed)")

                            actionType = "New List"         // set type for proper processing
                        
                            let notes = strRaw              //origonal string
                            mainType = "New List"           // type to display
                            
                            var joiner = " "
                            output = joiner.join(wordArrTrimmed)
                        
                            listName = "New List"
                            
                            let title = output
                            println("p213 title: \(title)")
                        
                            println("p203: actionType \(actionType)")
                            println("p204: mainType \(mainType)")
                            
                            defaults.setObject(actionType, forKey: "actionType")        //sets actionType for processing
                            defaults.setObject(mainType, forKey: "mainType")            //sets mainType
                        
                            nextWord2.capitalizedString
                            nextWord2.replaceRange(nextWord2.startIndex...nextWord2.startIndex, with: String(nextWord2[nextWord2.startIndex]).capitalizedString)
                        
                            let reminderList = nextWord2
                        
                            defaults.setObject(reminderList, forKey: "reminderList")            //sets reminderList
                    
                            defaults.setObject(reminderList, forKey: "calendarName")            //sets title to calendarName for ParseDB

                        
                            defaults.setObject(wordArrTrimmed, forKey: "wordArrTrimmed")            //sets reminderItems

            
                           // EventManager.sharedInstance.creatNewReminderList(nextWord2, items: wordArrTrimmed)
                        
                           // EventManager.sharedInstance.creatNewReminderList(nextWord, items: ["Butter","Milk","Cheese"])
                        
                        break
                    }
  
                }

// ____ "list" first word ____________________________________
                
                let subStringListFirstWord = (word as NSString).containsString("list") // see "raw"  then process
                
                if(subStringListFirstWord && (wordArr[i] == wordArr[0])){ //added last so only here if matches is first word in string!
                    
                    if (i < arrayLength-1) {
                        nextWord = wordArr[i+1]
                    } else {
                        nextWord = ""
                    }
                    
                    if ( nextWord != "" ) {
                     
                        wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }   // remove "list" word
                        
                        println("p200 nextWord: \(nextWord)")
                        
                        println("p202 wordArrTrimmed: \(wordArrTrimmed)")
                        
                        actionType = "List"         // set type for proper processing
                        
                        let notes = strRaw              //origonal string
                        mainType = "List"           // type to display
                        
                        var joiner = " "
                        output = joiner.join(wordArrTrimmed)
                        
                        let title = output
                        println("p213 title: \(title)")
                        
                        println("p203: actionType \(actionType)")
                        println("p204: mainType \(mainType)")
                        
                        defaults.setObject(actionType, forKey: "actionType")        //sets actionType for processing
                        defaults.setObject(mainType, forKey: "mainType")            //sets mainType
                        
                        let reminderList = "Untitled List"
                        
                       // defaults.setObject(reminderTitle, forKey: "title")            //sets reminderTitle
                        defaults.setObject(reminderList, forKey: "reminderList")            //sets reminderList
                        
                        defaults.setObject(reminderList, forKey: "calendarName")            //sets title to calendarName for ParseDB
                        
                        defaults.setObject(wordArrTrimmed, forKey: "wordArrTrimmed")            //sets reminderTitle
                        
                        // EventManager.sharedInstance.creatNewReminderList(nextWord2, items: wordArrTrimmed)
                        
                        // EventManager.sharedInstance.creatNewReminderList(nextWord, items: ["Butter","Milk","Cheese"])
                        
                        break
                    }
                    
                }
                
                
                
                
// ____ "reminder" or "remind" word ____________________________________
                
                
                let subStringReminder = (word as NSString).containsString("reminder") || (word as NSString).containsString("remind")  // see "reminder" ore "remind" then process
                
                if(subStringReminder && (wordArr[i] == wordArr[0])){ //added last so only here if matches is first word in string!
                    
                    // why did I have this in ??? removed 072315 wordArrTrimmed = wordArrRaw
                    
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }   // remove "reminder" word
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != "Reminder" }   // remove "reminder" word
                    
                    
                    println("p141 we here? wordArrTrimmed: \(wordArrTrimmed)")
                    
                    actionType = "Reminder"         // set type for proper processing
                    
                    let notes = strRaw              //origonal string
                    mainType = "Reminder"           // type to display
                    
                    var joiner = " "
                    output = joiner.join(wordArrTrimmed)
                    
                    let title = output
                    println("p151 title: \(title)")
                    
                    
                    //TODO  tried to set the bales to "" for the detail screen  no luck
                    
                    let eventAlert = "none set yet"
                    
                    startDT = NSDate(dateString:"2014-12-12")
                    
                    //TODO Mike Anil get from settings user set default reminder list!
                    listName = "Default"                            //save reminder to default Reminder List
                    
                    println("p424 actionType: \(actionType)")
                    println("p424: mainType: \(mainType)")
                    println("p424: startDT: \(startDT)")
                    println("p424: eventAlert: \(eventAlert)")
                    println("p424: calendarName: \(calendarName)")
                    println("p424: output: \(output)")
                    println("p424: listName: \(listName)")
                    
                    defaults.setObject(startDT, forKey: "startDT")
                    defaults.setObject(calendarName, forKey: "calendarName")    //sets calendarName
                    defaults.setObject(eventAlert, forKey: "eventAlert")
                    defaults.setObject(actionType, forKey: "actionType")        //sets actionType for processing
                    defaults.setObject(mainType, forKey: "mainType")            //sets mainType
                    defaults.setObject(output, forKey: "output")                //sets output
                    defaults.setObject(listName, forKey: "reminderList")        //sets reminderList
        
                }
                
// ____ "text", "message", "im" word ____________________________________
                
                
                let subStringText = (word as NSString).containsString("text") || (word as NSString).containsString("message") || (word as NSString).containsString("im")   // see "text", "message", "im" then process
                
                //wordArrTrimmed = wordArrRaw
                
                if(subStringText && (wordArr[i] == wordArr[0])){    //added last so only here if matches is first word in string!
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }   // remove "text" word
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != "Text" }   // remove "text" word
                    
                    
                    println("p232 we here? wordArrTrimmed: \(wordArrTrimmed)")
                    
                    if (i < arrayLength-1) {
                        nextWord = wordArr[i+1]
                    } else {
                        nextWord = ""
                    }
                    
                    if ( nextWord != "" ) {
                        
                        
                        let matched = listMatches("[a-z]{3,10}", inString: nextWord)   // alpha characters length 3 to 10
                        
                        println("p103 matched: \(matched)")
                        
                        if (matched.count > 0) {
                            
                            wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i+1] }   // remove "name" word
                            
                            var toPhone:String = ""
                            
                            println("p209 nextWord: \(nextWord)")
                            
                    // TODO Anil get this from Settings users created favorite names, phone, and email
                            
                            switch (nextWord) {
                            case "mike":                toPhone  = "608-242-7700"; break
                            case "stephanie", "steph":  toPhone  = "608-692-6132"; break
                            case "john", "jonathan":    toPhone  = "608-220-8543"; break
                            case "mom":                 toPhone  = "608-693-8347"; break
                            case "andrew":              toPhone  = "262-412-8745"; break
                                
                            default:
                                toPhone = ""
                                break;
                            }
                            
                            println("p224 toPhone: \(toPhone)")
                            
                            let defaults = NSUserDefaults.standardUserDefaults()
                            defaults.setObject(toPhone, forKey: "toPhone")
                            
                        }
                        
                    }
                    
                    
                    
                    
                    let notes = strRaw              //origonal string
                    mainType = "Text"
                    actionType = "Text"             //sets actionType for processing
                    
                    var joiner = " "
                    output = joiner.join(wordArrTrimmed)
                    let title = output
                    println("p151 title: \(title)")
                    
                    //TODO  tried to set the bales to "" for the detail screen  no luck
                    
                    let eventAlert = "none set yet"
                    actionType = "Text"         // set type for proper processing
                    
                    let defaults = NSUserDefaults.standardUserDefaults()
                    
                    defaults.setObject(eventAlert, forKey: "eventAlert")
                    defaults.setObject(actionType, forKey: "actionType")        //sets actionType
                    defaults.setObject(mainType, forKey: "mainType")            //sets actionType
                    
                    
                    //ReminderCode().createReminder(title, notes: notes)
                    //TODO above line, this done in  Reminder button but change that, add code,  to the process button
                    
                    
                    //TODO Handle Reminder or Calendar Event more efficiently????
                    
                    break;       //added 083115 my Mike to break out of the loop
                    
                }
                
// ____ "call", "phone", "ring" or "buzz" word ____________________________________
                
                
                let subStringCall = (word as NSString).containsString("call") || (word as NSString).containsString("phone") || (word as NSString).containsString("ring") || (word as NSString).containsString("buzz")     // see "call", "phone", "ring" or "buzz" then process
                
                //wordArrTrimmed = wordArrRaw
                
                println("p334 we here? wordArr[0], wordArr[i] : \(wordArr[0]), \(wordArr[i])")
                
                if(subStringCall && (actionType != "Reminder") && (wordArr[i] == wordArr[0]) ){ //added last so only here if matches is first word in string!
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }   // remove [i] word
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != "Call" }   // remove "Call" word
                    
                    
                    println("p317 we here? wordArrTrimmed: \(wordArrTrimmed)")
                    
                    if (i < arrayLength-1) {
                        nextWord = wordArr[i+1]
                    } else {
                        nextWord = ""
                    }
                    
                    if ( nextWord != "" ) {
                        
                        
                        let matched = listMatches("[a-z]{3,10}", inString: nextWord)   // alpha characters length 3 to 10
                        
                        println("p103 matched: \(matched)")
                        
                        if (matched.count > 0) {
                            
                            wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i+1] }   // remove [i+!] word
                            
                            var toPhone:String = ""
                            
                            println("p209 nextWord: \(nextWord)")
                            
                // TODO Anil get this from Settings users created favorite names, phone, and email
            
                            switch (nextWord) {
                            case "mike":                toPhone  = "608-242-7700"; break;
                            case "stephanie", "steph":  toPhone  = "608-692-6132"; break;
                            case "john", "jonathan":    toPhone  = "608-220-8543"; break;
                            case "mom":                 toPhone  = "608-693-8347"; break;
                            case "andrew":              toPhone  = "262-412-8745"; break;
                                
                            default:
                                toPhone = ""
                                break;
                            }
                            
                            println("p224 toPhone: \(toPhone)")
                            
                            let defaults = NSUserDefaults.standardUserDefaults()
                            defaults.setObject(toPhone, forKey: "toPhone")
                            
                        }
                        
                    }
                    
                    
                    
                    
                    let notes = strRaw              //origonal string
                    mainType = "Call"
                    actionType = "Call"             //sets actionType for processing
                    
                    var joiner = " "
                    output = joiner.join(wordArrTrimmed)
                    let title = output
                    println("p151 title: \(title)")
                    
                    //TODO  tried to set the bales to "" for the detail screen  no luck
                    
                    actionType = "Call"         // set type for proper processing
                    let eventAlert = "none set yet"
                    
                    let defaults = NSUserDefaults.standardUserDefaults()
                    
                    defaults.setObject(eventAlert, forKey: "eventAlert")
                    defaults.setObject(actionType, forKey: "actionType")        //sets actionType
                    defaults.setObject(mainType, forKey: "mainType")            //sets actionType
                    
                    
                    //ReminderCode().createReminder(title, notes: notes)
                    //TODO above line, this done in  Reminder button but change that, add code,  to the process button
                    
                    
                    //TODO Handle Reminder or Calendar Event more efficiently????
                    
                    break;      //added 083115 my Mike to break out of the loop

                    
                }
                
// ____ "mail" or "email" word ____________________________________
                
                let subStringMail = (word as NSString).containsString("mail")  || (word as NSString).containsString("email")   // see "mail" or "email" then process
                
                if(subStringMail && (wordArr[i] == wordArr[0])){    //added last so only here if matches is first word in string!
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }   // remove "mail" word
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != "Mail" }   // remove "mail" word
                    
                    
                    println("p286 in mail parse we here? wordArrTrimmed: \(wordArrTrimmed)")
                    
                    if (i < arrayLength-1) {
                        nextWord = wordArr[i+1]
                    } else {
                        nextWord = ""
                    }
                    
                    if ( nextWord != "" ) {

                        let matched = listMatches("[a-z]{3,10}", inString: nextWord)   // alpha characters length 3 to 10
                        
                        println("p299 matched: \(matched)")
                        
                        if (matched.count > 0) {
                            
                            wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i+1] }   // remove "name" word
                            
                            var toPhone:String = ""
                            
                            println("p209 nextWord: \(nextWord)")
                            
                // TODO Anil get this from Settings users created favorite names, phone, and email

                            switch (nextWord) {
                            case "mike":                toPhone  = "mike@derr.ws"; break;
                            case "stephanie", "steph":  toPhone  = "steph@derr.ws"; break;
                            case "john", "jonathan":    toPhone  = "jonathanmwild@gmail.com"; break;
                            case "mom":                 toPhone  = "germangirl1988@gmail.com"; break;
                            case "andrew":              toPhone  = "aw@rouse.biz"; break;
                                
                            default:
                                toPhone = ""
                                break;
                            }
                            
                            println("p322 toPhone: \(toPhone)")
                            
                            let defaults = NSUserDefaults.standardUserDefaults()
                            defaults.setObject(toPhone, forKey: "toPhone")
                            
                        }
                        
                    }
                    
              
                    let notes = strRaw              //origonal string
                    mainType = "Mail"
                    actionType = "Mail"             //sets actionType for processing
                    
                    var joiner = " "
                    output = joiner.join(wordArrTrimmed)
                    let title = output
                    println("p341 title: \(title)")
                    
                    //TODO  tried to set the bales to "" for the detail screen  no luck
                    
                    actionType = "Mail"         // set type for proper processing
                    let eventAlert = "none set yet"
                    
                    defaults.setObject(eventAlert, forKey: "eventAlert")
                    defaults.setObject(actionType, forKey: "actionType")        //sets actionType
                    defaults.setObject(mainType, forKey: "mainType")            //sets actionType
                    
                    
                    break;       //added 083115 my Mike to break out of the loop
                }
                
                
// ____ "invite"  word ____________________________________
                
                //TODO NOT ALLOWED TO INVITE Programtically Not sure Apple allows to programmically invite people???
                
                
                let subStringInvite = (word as NSString).containsString("invite")   // see "mail" or "email" then process
                
                if(subStringInvite ){
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }   // remove "mail" word
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != "Invite" }   // remove "mail" word
                    
                    
                    println("p501 in invite parse we here? wordArrTrimmed: \(wordArrTrimmed)")
                    
                    if (i < arrayLength-1) {
                        nextWord = wordArr[i+1]
                    } else {
                        nextWord = ""
                    }
                    
                    if ( nextWord != "" ) {
                        
                        
                        let matched = listMatches("[a-z]{3,10}", inString: nextWord)   // alpha characters length 3 to 10
                        
                        println("p514 matched: \(matched)")
                        
                        if (matched.count > 0) {
                            
                            wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i+1] }   // remove "name" word
                            
                            var toPhone:String = ""
                            
                            println("p522 nextWord: \(nextWord)")
                        
                    // TODO Anil, can't invote progrmatically??? get this from Settings users created favorite names, phone, and email
                            
                            switch (nextWord) {
                            case "mike":                toPhone  = "mike@derr.ws"; break;
                            case "stephanie", "steph":  toPhone  = "steph@derr.ws"; break;
                            case "john", "jonathan":    toPhone  = "jonathanmwild@gmail.com"; break;
                            case "mom":                 toPhone  = "germangirl1988@gmail.com"; break;
                            case "andrew":              toPhone  = "aw@rouse.biz"; break;
                                
                            default:
                                toPhone = ""
                                break;
                            }
                            
                            println("p322 toPhone: \(toPhone)")
                            
                            let defaults = NSUserDefaults.standardUserDefaults()
                            defaults.setObject(toPhone, forKey: "toPhone")
                            
                        }
                        
                    }
                    
                    
                    
                    
                    let notes = strRaw              //origonal string
                    mainType = "Mail"
                    actionType = "Mail"             //sets actionType for processing
                    
                    var joiner = " "
                    output = joiner.join(wordArrTrimmed)
                    let title = output
                    println("p341 title: \(title)")
                    
                    //TODO  tried to set the bales to "" for the detail screen  no luck
                    
                    actionType = "Mail"         // set type for proper processing
                    let eventAlert = "none set yet"
                    
                    let defaults = NSUserDefaults.standardUserDefaults()
                    
                    defaults.setObject(eventAlert, forKey: "eventAlert")
                    defaults.setObject(actionType, forKey: "actionType")        //sets actionType
                    defaults.setObject(mainType, forKey: "mainType")            //sets actionType
                    
                    
                    //ReminderCode().createReminder(title, notes: notes)
                    //TODO above line, this done in  Reminder button but change that, add code,  to the process button
                    
                    
                    //TODO Handle Reminder or Calendar Event more efficiently????
                    
                }
                
                
                
                
                // ____ "list" word ____________________________________
                // 1. single words = Raw list
                // 2. Comma delimited list of phrases!
                
                
                
// ____ "am" word ____________________________________
                
                let subStringAM = (word as NSString).containsString("am")   // see AM then process time at word[i-1]
                
                //println("p119 am time found at item \(i)")
                //println("p120 count(word): \(count(word))")
                //println("p121 timeString: \(timeString)")
                //println("p122 subStringAM: \(subStringAM)")
                
                if(subStringAM && (count(word) <= 5) ){
                    println("p126 am time found at item: \(i)")
                    time = "\(wordArr[i-1]) \(wordArr[i])"
                    
                    let timeNumber = wordArr[i-1]
                    
                    let subStringColon = (timeNumber as NSString).containsString(":")
                    
                    if(subStringColon && (count(timeNumber) >= 4) && (count(timeNumber) <= 5) ){
                        println("378: timeNumber has colon in string")
                        timeString = "\(wordArr[i-1]) AM"
                    } else if ((count(timeNumber) >= 3) && (count(timeNumber) <= 5) ) {
                        
                            // add colon
                            
                            println("p622 (wordArr[i-1]): \(wordArr[i-1])")

                            let mutableStr = NSMutableString(string: wordArr[i-1])
                        
                        //TODO change to index or position 2nd from right end
                        if ( count(timeNumber) == 3 ) {
                            mutableStr.insertString(":", atIndex: 1)
                        } else if ( count(timeNumber) == 4 ) {
                            mutableStr.insertString(":", atIndex: 2)
                        }
                        
                            timeString = mutableStr as String
                            
                            println("p629 timeString: \(timeString)")
                        
                            timeString = "\(timeString) AM"
                            println("p633 timeString: \(timeString)")

                     
                    } else if ((count(timeNumber) >= 1) && (count(timeNumber) <= 2)) {    // number is 1 or 2 digits
                        
                        timeString = "\(wordArr[i-1]):00 AM"
                    }
                    
                    time = "\(wordArr[i-1]) AM"
                    
                    // timeString = wordArr[i-1]
                    
                    println("## p149 timeString: \(timeString)")
                    println("-- p150 \(wordArr)")
                    
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i-1] }
                    println("---- p154 \(wordArrTrimmed)")
                    
                    if (startDate == "") {                              //add today for Reminder if a time only
                        var dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "M-dd-yyyy"
                        
                        startDate = dateFormatter.stringFromDate(NSDate())      // no day found so assume today
                        println("p475 startDate: \(startDate)")
                    }
                    
                } else if time == "" {
                    time = "No Time Found"
                }
                
// ____ "pm" word ____________________________________
                
                let subStringPM = (word as NSString).containsString("pm")   // see PM then process time at word[i-1]
                
                if(subStringPM && (count(word) == 2)){
                    println("217: pm time found at item \(i)")
                    // time = "\(wordArr[i-1]) \(wordArr[i])"
                    let timeNumber = wordArr[i-1]
                    
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != "PM" }   // remove "PM" word
                    
                    
                    let subStringColon = (timeNumber as NSString).containsString(":")
                    
                    if(subStringColon && (count(timeNumber) >= 4) && (count(timeNumber) <= 5) ){
                        println("p684: timeNumber has colon in string")
                        timeString = "\(wordArr[i-1]) PM"
                    } else if ((count(timeNumber) >= 3) && (count(timeNumber) <= 5) ) {
                        
                        // add colon
                        
                        println("p690 (wordArr[i-1]): \(wordArr[i-1])")
                        
                        let mutableStr = NSMutableString(string: wordArr[i-1])
                        
                        //TODO change to index or position 2nd from right end
                        if ( count(timeNumber) == 3 ) {
                            mutableStr.insertString(":", atIndex: 1)
                        } else if ( count(timeNumber) == 4 ) {
                            mutableStr.insertString(":", atIndex: 2)
                        }
                        
                        timeString = mutableStr as String
                        
                        println("p703 timeString: \(timeString)")
                        
                        timeString = "\(timeString) PM"
                        println("p706 timeString: \(timeString)")
                        
                        
                    } else if ((count(timeNumber) >= 1) && (count(timeNumber) <= 2)) {    // number is 1 or 2 digits
                        
                        timeString = "\(wordArr[i-1]):00 PM"
                    }
                    
                    time = "\(wordArr[i-1]) PM"
                    
                    // timeString = wordArr[i-1]
                    
                    println("#### 227 timeString: \(timeString)")
                    
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i-1] }
                    println("p200 wordArrTrimmed: \(wordArrTrimmed)")
                    
                    if (startDate == "") {                              //add today for Reminder if a time only
                        var dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "M-dd-yyyy"
                        
                        startDate = dateFormatter.stringFromDate(NSDate())      // no day found so assume today
                        println("p475 startDate: \(startDate)")
                    }
                    
                    
                } else if time == "" {
                    time = "No Time Found"
                }
                
                
// ____ ":" is a time word ____________________________________
                
                let subStringTimeColon = (word as NSString).containsString(":")     // see : then process time at word
                println("#### p182 subStringTimeColen: \(subStringTimeColon)")
                println("#### p183 time: \(time)")
                
                if(subStringTimeColon && (count(word) >= 4) && (count(word) <= 5) && (timeString == "") ){
                    
                    //  if(subStringTimeColon && (count(word) >= 4) && (count(word) <= 5) ) {
                    println("#### p190: : time found at item \(i)")
                    // time = "\(wordArr[i-1]) \(wordArr[i])"
                    let timeNumber = wordArr[i]
                    
                    // TODO add logic and code to guess am or pm logically, I assume PM here so far
                    
                    if(subStringTimeColon){
                        println("253: timeNumber has colon in string")
                        timeString = "\(wordArr[i]) PM"
                    }
                    
                    println("#### 258 timeString: \(timeString)")
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }
                    println("p230 wordArrTrimmed: \(wordArrTrimmed)")
                    
                    if (startDate == "") {                              //add today for Reminder if a time only
                        var dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "M-dd-yyyy"
                        
                        startDate = dateFormatter.stringFromDate(NSDate())      // no day found so assume today
                        println("p475 startDate: \(startDate)")
                    }
                    
                } else if time == "" {
                    time = "No Time Found"
                }
                
// ____ "o'clock" ____________________________________
                
                let subStringOclock = (word as NSString).containsString("o'clock") // see o'clock then process time at word
                println(subStringOclock)
                if(subStringOclock && (time == "No Time Found")){
                    println("217: o'clock time found at item \(i)")
                    time = "\(wordArr[i-1]) \(wordArr[i])"
                    
                    timeString = "\(wordArr[i-1]):00 PM"
                    
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i-1] }
                    println("p247 wordArrTrimmed: \(wordArrTrimmed)")
                    
                    if (startDate == "") {                              //add today for Reminder if a time only
                        var dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "M-dd-yyyy"
                        
                        startDate = dateFormatter.stringFromDate(NSDate())      // no day found so assume today
                        println("p475 startDate: \(startDate)")
                    }
                    
                } else if time == "" {
                    time = "No Time Found"
                }
                
// ____ Time as 3-4 digits ____________________________________
                
                // Handle if time word as number only like 1045 or 330
                var numOfCharacters = count(word)
                
                if (numOfCharacters >= 3) && (numOfCharacters <= 4) && (timeString == "") {     // Handle if time word as number only like 1045 or 330
                    let matched = listMatches("\\d{3,4}", inString: word)
                    
                    if (matched.count > 0) {
                        let numberFound = matched[0]
                        println("pl275 numberFound: \(numberFound)")
                        
                        var charAtIndex = word[advance(word.startIndex, 0)]
                        
                        let myArrayFromString = Array(word)
                        var stringLength = count(word)
                        let stringIndex = myArrayFromString[stringLength-3]
                        
                        let mutableWord = NSMutableString(string: word)
                        mutableWord.insertString(":", atIndex: mutableWord.length - 2)
                        
                        let newTime = (mutableWord as String)
                        println("pl288 newTime: \(newTime)")
                        
                        // TODO ADD code to determine if 1045 word user intended AM or PM  try to guess right. need to add time checking somehow!  assuming PM for now
                        
                        timeString = "\(newTime) PM"
                        println("pl293: timeString \(timeString)")
                        
                        wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }
                        println("p283 wordArrTrimmed: \(wordArrTrimmed)")
                        
                        if (startDate == "") {                              //add today for Reminder if a time only
                            var dateFormatter = NSDateFormatter()
                            dateFormatter.dateFormat = "M-dd-yyyy"
                            
                            startDate = dateFormatter.stringFromDate(NSDate())      // no day found so assume today
                            println("p475 startDate: \(startDate)")
                        }
                        
                    } else {
                        time = "No Time Found"
                    }
                    
                } else {
                    time = "No Time Found"
                }
                
    // ____ "day" word ____________________________________
                
                let subStringDay = (word as NSString).containsString("day")     // note: could be today also!
                if(subStringDay){
                    println("253: day found at item \(i)")
                    
                    day = wordArr[i].capitalizedString
                    println(day)
                    
                    var priorWord:String = ""
                    var priorWord2:String = ""
                    
                    if (i > 0) {
                        priorWord = wordArr[i-1]
                    }
                    if (i > 1) {
                        priorWord2 = wordArr[i-2]
                    }
                    
                    
                    switch wordArr[i] as String {
                        
                    case "today":
                        
                        let formatter  = NSDateFormatter()
                        let todayDate = NSDate()
                        let myCalendar = NSCalendar.currentCalendar()
                        let myComponents = myCalendar.components(.CalendarUnitWeekday, fromDate: todayDate)
                        let todayDay = myComponents.weekday
                        
                        println("pl335 todayDay: \(todayDay)")
                        
                        startDate = calcDays(todayDay, priorWord: priorWord, priorWord2: priorWord2)
                        day = "Today"
                        wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }
                        break;
                        
                    case "sunday":
                        startDate = calcDays(1, priorWord: priorWord, priorWord2: priorWord2)
                        day = "Sunday"
                        wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }
                        break;
                    case "monday":
                        startDate = calcDays(2, priorWord: priorWord, priorWord2: priorWord2)
                        day = "Monday"
                        wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }
                        break;
                    case "tuesday":
                        startDate = calcDays(3, priorWord: priorWord, priorWord2: priorWord2)
                        day = "Tuesday"
                        wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }
                        break;
                    case "wednesday":
                        startDate = calcDays(4, priorWord: priorWord, priorWord2: priorWord2)
                        day = "Wednesday"
                        wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }
                        break;
                    case "thursday":
                        startDate = calcDays(5, priorWord: priorWord, priorWord2: priorWord2)
                        day = "Thursday"
                        wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }
                        break;
                    case "friday":
                        startDate = calcDays(6, priorWord: priorWord, priorWord2: priorWord2)
                        day = "Friday"
                        wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }
                        break;
                    case "saturday":
                        startDate = calcDays(7, priorWord: priorWord, priorWord2: priorWord2)
                        day = "Saturday"
                        wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }
                        break;
                    default:
                        println("334 day is something else")
                        
                        break;
                    }
                    
                    println("p370 wordArrTrimmed: \(wordArrTrimmed)")
                    
                } else if day == "" {
                    day = "No Day Found"
                    var dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "M-dd-yyyy"
                    
                    if (actionType != "Reminder") {
                        startDate = dateFormatter.stringFromDate(NSDate())      // no day found so assume today
                        println("p638 startDate: \(startDate)")
                        
                    }
                    
                    day = "Today"
                }
                
    // ____ Months Words ____________________________________
                
                if (i < arrayLength-1) {
                    nextWord = wordArr[i+1]
                } else {
                    nextWord = ""
                }
                if (i < arrayLength-2) {
                    nextWord2 = wordArr[i+2]
                } else {
                    nextWord2 = ""
                }
                
                if (i > 0) {
                    priorWord = wordArr[i-1]
                } else {
                    priorWord = ""
                }
                if (i > 1) {
                    priorWord2 = wordArr[i-2]
                } else {
                    priorWord2 = ""
                }
                
                var months = ["january", "jan", "february", "feb", "march", "mar", "april", "apr", "may", "june", "jun", "july", "jul", "august", "aug", "september", "sept", "october", "oct", "november", "nov", "december", "dec"]
                
                
                if contains(months, wordArr[i]) {
                    
                    switch wordArr[i] {
                    case "january", "jan": startDate = processMonth(1, nextWord: nextWord, nextWord2: nextWord2, priorWord: priorWord, priorWord2: priorWord2)
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }
                    break;
                    case "february", "feb": startDate = processMonth(2, nextWord: nextWord, nextWord2: nextWord2, priorWord: priorWord, priorWord2: priorWord2)
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }
                    break;
                    case "march", "mar": startDate = processMonth(3, nextWord: nextWord, nextWord2: nextWord2, priorWord: priorWord, priorWord2: priorWord2)
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }
                    break;
                    case "april", "apr": startDate = processMonth(4, nextWord: nextWord, nextWord2: nextWord2, priorWord: priorWord, priorWord2: priorWord2)
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }
                    break;
                    case "may": startDate = processMonth(5, nextWord: nextWord, nextWord2: nextWord2, priorWord: priorWord, priorWord2: priorWord2)
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }
                    break;
                    case "june", "jun": startDate = processMonth(6, nextWord: nextWord, nextWord2: nextWord2, priorWord: priorWord, priorWord2: priorWord2)
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }
                    break;
                    case "july", "jul": startDate = processMonth(7, nextWord: nextWord, nextWord2: nextWord2, priorWord: priorWord, priorWord2: priorWord2)
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }
                    break;
                    case "august", "aug": startDate = processMonth(8, nextWord: nextWord, nextWord2: nextWord2, priorWord: priorWord, priorWord2: priorWord2)
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }
                    break;
                    case "september", "sept": startDate = processMonth(9, nextWord: nextWord, nextWord2: nextWord2, priorWord: priorWord, priorWord2: priorWord2)
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }
                    break;
                    case "october", "oct": startDate = processMonth(10, nextWord: nextWord, nextWord2: nextWord2, priorWord: priorWord, priorWord2: priorWord2)
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }
                    break;
                    case "november", "nov": startDate = processMonth(11, nextWord: nextWord, nextWord2: nextWord2, priorWord: priorWord, priorWord2: priorWord2)
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }
                    break;
                    case "december", "dec": startDate = processMonth(12, nextWord: nextWord, nextWord2: nextWord2, priorWord: priorWord, priorWord2: priorWord2)
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }
                    break;
                        
                        
                    default:
                        println("p133 month is something else")
                        break;
                    }   // end Switch
                    
                } else {
                    println("p139 No Month Processed")
                }
                
                println("#### 345: startDate: \(startDate)")
                
        // ____ Phone as numbers 7-10 digits ____________________________________
                
                // process Phone number
                let subStringPhone = (word as NSString).containsString("-")
                
                if(subStringPhone) && (count(wordArr[i])>=8) && (actionType != "Reminder") {
                    
                    println("p431 phone found at item: \(i)")
                    phone = wordArr[i].capitalizedString
                    println("p433 phone: \(phone)")
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }
                    println("p470 wordArrTrimmed: \(wordArrTrimmed)")
                    
                    let defaults = NSUserDefaults.standardUserDefaults()
                    defaults.setObject(phone, forKey: "toPhone")                // to use for texting to
                    
                }
                
                
        // ____ Phone as numbers 7-10 digits ____________________________________
                
                // Handle if number word as number only like 60823427700  make it phone
                numOfCharacters = count(word)
                
                if (numOfCharacters >= 7) && (numOfCharacters <= 10) && (phone == "") && (actionType != "Reminder") {
                    let matched = listMatches("\\d{7,10}", inString: word)
                    
                    if (matched.count > 0) {
                        let numberFound = matched[0]
                        println("p449 numberFound: \(numberFound)")
                        
                        var charAtIndex = word[advance(word.startIndex, 0)]
                        
                        let myArrayFromString = Array(word)
                        var stringLength = count(word)
                        let stringIndex = myArrayFromString[stringLength-3]
                        
                        let mutableWord = NSMutableString(string: word)
                        mutableWord.insertString("-", atIndex: mutableWord.length - 4)
                        
                        if (mutableWord.length == 11) {
                            mutableWord.insertString("-", atIndex: mutableWord.length - 8)
                        }
                        
                        phone = (mutableWord as String)
                        println("p461 phone: \(phone)")
                        
                        wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }
                        println("p505 wordArrTrimmed: \(wordArrTrimmed)")
                        
                        let defaults = NSUserDefaults.standardUserDefaults()
                        defaults.setObject(phone, forKey: "toPhone")                // to use for texting to
                        
                        
                    } else {
                        phone = ""
                    }
                    
                }
                
        
                var currentWord: AnyObject = wordArr[i]             //TODO why I do this?  word is the same current word at [i]
                
        // ____ "calendar" word ____________________________________
                
                let subStringCalendar = (word as NSString).containsString("calendar") // see calendar then process
                if (subStringCalendar) {
                    println("p943: calendar found at item \(i)")
                    println("p944: calendarName \(calendarName)")
                    
                    // TODO pull this from EKEvntkit get users lsit of calendar's
                    
                    
                    //var arrayCalendars = ["work", "mike", "mom", "music", "steph"]
                    
                    var arrayCalendars = NSUserDefaults.standardUserDefaults().objectForKey("calendarArray") as! [String] //array of the items
                    
                    if (i < arrayLength-1) {
                        nextWord = wordArr[i+1]
                    } else {
                        nextWord = ""
                    }
                    
                    if (nextWord != "") {                           //  check to see if there is word after "calendar"
                        
                        if contains(arrayCalendars, wordArr[i+1]) {
                            calendarToUse = wordArr[i+1]
                            wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i+1] }
                        }   else if contains(arrayCalendars, wordArr[i-1]) {
                            calendarToUse = wordArr[i-1]
                            wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i-1] }
                        }
                        
                    } else {
                        errorMsg = "No Calendar Found"
                    }
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }
                    if (calendarName == ""){
                        calendarName = calendarToUse
                    }
                    
                    println("p973: calendarName \(calendarName)")
                    //let defaults = NSUserDefaults.standardUserDefaults()
                    defaults.setObject(calendarName, forKey: "calendar")
                }
                
                //TODO Pull from prefs
                
                
                
                
                // no word "calendar" found in string so set to thsi canendar for now.
                // TODO take from prefs users default calendar
                println("p817: calendarName \(calendarName)")
                
                println("p559 wordArrTrimmed: \(wordArrTrimmed)")
                
                //let defaults = NSUserDefaults.standardUserDefaults()
                //set above in IF statement. defaults.setObject(calendarName, forKey: "calendar")
                
        // ____ "list" word ____________________________________
                
                let subStringList = (word as NSString).containsString("list") // see calendar then process
                if (subStringList) {
                    println("p1357 list found at item: \(i)")
                    println("p1358 listName: \(listName)")
                    
                    var reminderArray = NSUserDefaults.standardUserDefaults().objectForKey("reminderArray") as! [String] //array of the items
                    
                    println("p1389 reminderArray: \(reminderArray)")
                    
                    let reminderArrayLowerCased = reminderArray.map { return $0.lowercaseString}    //lowercase ever word in array -from Anil 083115 thank you Bro :)

                    if (i < arrayLength-1) {
                        nextWord = wordArr[i+1]
                    } else {
                        nextWord = ""
                    }
                    println("p1378 nextWord: \(nextWord)")
                 

                    let startIndex = i+1    //start at word after "list"
                    listName = ""
                    for word in wordArr[startIndex..<wordArr.count] {   // make list title from words after List to end
                        println("p1428: \(word)")
                        listName = listName + " \(word)"
                        println("p1430: \(listName)")
                    }
                    
                    if listName != "" {
                        listName = dropFirst(listName) //remove first space I added above in loop.
                
                        listName = listName.capitalizedString   //capitalzie first letter of each word for Calendar match
                    }
                    
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }
                    
                    println("p1435 wordArrTrimmed: \(wordArrTrimmed)")

                    let end = (i-1)
                    println("p1390 i: \(i)")
                    println("p1390 end: \(end)")

                    
                    let slice = wordArrTrimmed[0..<end]
                    
                    println("p1440 slice: \(slice)")
                    
                    wordArrTrimmed = Array(slice)
                    
                    if (listName == ""){
                        mainType = "New OneItem List"
                        actionType = "New OneItem List"             //sets actionType for processing
                        listName = "New List"
                        
                        defaults.setObject(actionType, forKey: "actionType")    //sets actionType
                        defaults.setObject(listName, forKey: "reminderList")    //sets reminderList
                        defaults.setObject(listName, forKey: "calendarName")    //sets List to calendarName for ParseDB
                        defaults.setObject(wordArrTrimmed, forKey: "wordArrTrimmed")    //sets List to calendarName for ParseDB
                    }
                    
                    println("p1394 listName: \(listName)")
                    defaults.setObject(listName, forKey: "reminderList")    //sets actionType
                    
                    break;

                }
                
                //TODO Pull from prefs
                
                
                
                
                // no word "calendar" found in string so set to thi canelndar for now.
                // TODO take from prefs users default calendar
                println("p1406 listName: \(listName)")
                
                println("p1439 wordArrTrimmed: \(wordArrTrimmed)")
                
                //let defaults = NSUserDefaults.standardUserDefaults()
                //set above in IF statement. defaults.setObject(calendarName, forKey: "calendar")
         
                
                
        // ____ "duration" word ____________________________________
                
                let subStringDuration = (word as NSString).containsString("duration") || (word as NSString).containsString("length")   // see duration or lenght then process
                
                if (subStringDuration) {
                    println("p523: duration found at item \(i)")
                    
                    
                    
                    //TODO is there a better way to check words? text if word in array???
                    
                    if (i < arrayLength-1) {        // check to see is there is something after word "duration"
                        nextWord = wordArr[i+1]
                        println("p524: duration is: \(wordArr[i+1])")
                    } else {
                        nextWord = ""
                    }
                    if (i < arrayLength-2) {
                        nextWord2 = wordArr[i+2]
                        println("p537: duration type: \(wordArr[i+2])")
                    } else {
                        nextWord2 = ""
                    }
                    
                    
                    
                    if (nextWord != "") && (contains(numberWordArray,nextWord) ) {
                        
                        wordArrTrimmed = wordArrTrimmed.filter() { $0 != self.nextWord }
                        
                        println("p576 word: \(word)")
                        
                        // userDuration = NumberWord.five.rawValue        // => 1...  // WORKS
                        
                        // TODO TOFIX 'DictateCode.NumberWord.Type' does not have a member named 'word'
                        
                        //userDuration = NumberWord.word.rawValue        // => 1...   //Does not work!!!
                        
                        var returnValue:Int = 0
                        
                        switch (nextWord){
                        case "one": returnValue     = 1;   break;
                        case "two": returnValue     = 2;   break;
                        case "three": returnValue   = 3;   break;
                        case "four": returnValue    = 4;   break;
                        case "five": returnValue    = 5;   break;
                        case "six": returnValue     = 6;   break;
                        case "seven": returnValue   = 7;   break;
                        case "eight": returnValue   = 8;   break;
                        case "nine": returnValue    = 9;   break;
                        case "ten": returnValue     = 10;   break;
                            
                        default:   println("p590 no duration word matched")
                        break;
                        }
                        
                        userDuration = returnValue
                        
                        println("p1057 userDuration: \(userDuration)")
                        
                        // TODO make this a General func as we call in in IF below also and also for alert
                        if (nextWord2 != "") {
                            
                            switch nextWord2 {
                            case "minutes", "minute": userDuration = userDuration * 1               //leave as minutes need *1 ??? TODO
                            wordArrTrimmed = wordArrTrimmed.filter() { $0 != self.nextWord2 }
                            break;
                            case "hours", "hour": userDuration = userDuration * 60                  //convert to hours
                            wordArrTrimmed = wordArrTrimmed.filter() { $0 != self.nextWord2 }
                            break;
                            case "days", "day": userDuration = userDuration * 60 * 24               //convert to days
                            wordArrTrimmed = wordArrTrimmed.filter() { $0 != self.nextWord2 }
                            break;
                            case "weeks", "week": userDuration = userDuration * 60 * 24 * 7         //convert to weeks
                            wordArrTrimmed = wordArrTrimmed.filter() { $0 != self.nextWord2 }
                            break;
                            default:
                                println("p561 nextWord is something else")
                                break;
                            }   // end Switch
                            
                        }
                        
                        println("p1082 userDuration: \(userDuration)")
                        eventDuration = Double(userDuration)
                        wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }
                        
                    }
                    
                    if (nextWord != "") {
                        
                        var durationNumberString = listMatches("\\d{1,3}", inString: nextWord)     //allow a 1, 2 or 3 digit string
                        
                        if (durationNumberString != []) {                   // added if no digit found, ie word is "one", "two" "three", etc...
                            
                            let numberString = durationNumberString[0]      //if number and not nextWord assume minutes!
                            
                            userDuration = numberString.toInt()!
                            
                            if (nextWord2 != "") {
                                
                                switch nextWord2 {
                                case "minutes", "minute": userDuration = userDuration * 1                //leave as minutes need *1 ??? TODO
                                wordArrTrimmed = wordArrTrimmed.filter() { $0 != self.nextWord2 }
                                break;
                                case "hours", "hour": userDuration = userDuration * 60                 //convert to hours
                                wordArrTrimmed = wordArrTrimmed.filter() { $0 != self.nextWord2 }
                                break;
                                case "days", "day": userDuration = userDuration * 60 * 24             //convert to days
                                wordArrTrimmed = wordArrTrimmed.filter() { $0 != self.nextWord2 }
                                break;
                                case "weeks", "week": userDuration = userDuration * 60 * 24 * 7         //convert to weeks
                                wordArrTrimmed = wordArrTrimmed.filter() { $0 != self.nextWord2 }
                                break;
                                default:
                                    println("p561 nextWord is something else")
                                    break;
                                }   // end Switch
                                
                            }
                            
                            println("p547 userDuration \(userDuration)")
                            
                            eventDuration = Double(userDuration)
                            wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }
                        }   // end (durationNumberString != [])
                    }   //end nextWord != ""
                    
                } else {
                    errorMsg = "No Duration Found"
                }
                
                println("p692 wordArrTrimmed: \(wordArrTrimmed)")
                
                
        // ____ "Alarm"/"Alert" word ____________________________________
                //TODO add Alert code...
                
                let subStringAlert = (word as NSString).containsString("alert") || (word as NSString).containsString("alarm")   // see duration or lenght then process
                
                var numberString = ""
                var userAlert:Int = 0
                
                
                if (subStringAlert) {
                    println("p603: alert or alarm found at item \(i)")
                    
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i]}         // trim "alert"
                    
                    
                    //TODO is there a better way to check words? text if word in array???
                    
                    if (i < arrayLength-1) {            // check to see is there is something after "duration"
                        nextWord = wordArr[i+1]
                        println("p609 alert next word is: \(wordArr[i+1])")
                    } else {
                        nextWord = ""
                    }
                    if (i < arrayLength-2) {
                        nextWord2 = wordArr[i+2]
                        println("p537 alert type: \(wordArr[i+2])")
                    } else {
                        nextWord2 = ""
                    }
                    
                    
                    if (nextWord != "") && (contains(numberWordArray,nextWord) ) {
                        
                        wordArrTrimmed = wordArrTrimmed.filter() { $0 != self.nextWord }
                        
                        println("p725 word: \(word)")
                        println("p726 nextWord: \(nextWord)")
                        println("p727 nextWord2: \(nextWord2)")
                        
                        var returnValue:Int = 0
                        
                        switch (nextWord){
                        case "one": returnValue     = 1;   break;
                        case "two": returnValue     = 2;   break;
                        case "three": returnValue   = 3;   break;
                        case "four": returnValue    = 4;   break;
                        case "five": returnValue    = 5;   break;
                        case "six": returnValue     = 6;   break;
                        case "seven": returnValue   = 7;   break;
                        case "eight": returnValue   = 8;   break;
                        case "nine": returnValue    = 9;   break;
                        case "ten": returnValue     = 10;   break;
                            
                        default:   println("p590 no duration word matched")
                        break;
                        }
                        
                        userAlert = returnValue
                        
                        println("p749 userAlert: \(userAlert)")
                        
                        // TODO repeated same code as below... but or now....
                        
                        if (userAlert != 0) {                      // added if no digit found, ie word is "one", "two" "three", etc...
                            
                            
                            if (nextWord2 != "") {
                                
                                switch nextWord2 {
                                case "minutes", "minute": userAlert * 1                              //in minuteslease as minutes number lol
                                wordArrTrimmed = wordArrTrimmed.filter() { $0 != self.nextWord2 }
                                break;
                                case "hours", "hour": userAlert = userAlert * 60                 //convert to hours
                                wordArrTrimmed = wordArrTrimmed.filter() { $0 != self.nextWord2 }
                                break;
                                case "days", "day": userAlert = userAlert * 60 * 24             //convert to days
                                wordArrTrimmed = wordArrTrimmed.filter() { $0 != self.nextWord2 }
                                break;
                                case "weeks", "week": userAlert = userAlert * 60 * 24 * 7         //convert to weeks
                                wordArrTrimmed = wordArrTrimmed.filter() { $0 != self.nextWord2 }
                                break;
                                default:
                                    println("p635 nextWord is something else")
                                    break;
                                }   // end Switch
                                
                            }
                            
                            println("p779 userAlert: \(userAlert)")
                            
                            let userAlertMinutes: Double = Double(userAlert)
                            
                            println("p655 userAlertMinutes: \(userAlertMinutes)")
                            
                            let eventAlert:Double = userAlertMinutes                        // thsi name for NSUserDefaults
                            
                            self.eventAlert = userAlertMinutes
                            
                            println("p661 self.eventAlert: \(self.eventAlert)")
                            
                            wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }
                            
                        }
                        
                        
                        
                        
                        
                        
                    }
                    
                    
                    if (nextWord != "") {
                        
                        var alertNumberString = listMatches("\\d{1,3}", inString: nextWord)     //allow a 1, 2 or 3 digit string
                        
                        println("p631 alertNumberString: \(alertNumberString)")
                        
                        if (alertNumberString != []) {                      // added if no digit found, ie word is "one", "two" "three", etc...
                            
                            
                            wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i+1]}         // trim the number
                            
                            numberString = alertNumberString[0]         // if number and not nextWord assume minutes!
                            
                            var userAlert:Int = numberString.toInt()!
                            
                            if (nextWord2 != "") {
                                
                                switch nextWord2 {
                                case "minutes", "minute": userAlert * 1                              //in minuteslease as minutes number lol
                                wordArrTrimmed = wordArrTrimmed.filter() { $0 != self.nextWord2 }
                                break;
                                case "hours", "hour": userAlert = userAlert * 60                 //convert to hours
                                wordArrTrimmed = wordArrTrimmed.filter() { $0 != self.nextWord2 }
                                break;
                                case "days", "day": userDuration = userDuration * 60 * 24             //convert to days
                                wordArrTrimmed = wordArrTrimmed.filter() { $0 != self.nextWord2 }
                                break;
                                case "weeks", "week": userDuration = userDuration * 60 * 24 * 7         //convert to weeks
                                wordArrTrimmed = wordArrTrimmed.filter() { $0 != self.nextWord2 }
                                break;
                                    
                                default:
                                    println("p635 nextWord is something else")
                                    break;
                                }   // end Switch
                                
                            }
                            
                            println("p644 userAlert: \(userAlert)")
                            
                            let userAlertMinutes: Double = Double(userAlert)
                            
                            println("p655 userAlertMinutes: \(userAlertMinutes)")
                            
                            let eventAlert:Double = userAlertMinutes                        // thsi name for NSUserDefaults
                            
                            self.eventAlert = userAlertMinutes
                            
                            println("p661 self.eventAlert: \(self.eventAlert)")
                            
                            wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }
                            
                        }   // end alertNumberString true
                    }   //end nextWord != ""
                    
                    println("p866 wordArrTrimmed: \(wordArrTrimmed)")
                    
                } else {
                    errorMsg = "No Alert Found"
                }
        
                
        // ____ "Repeat" word ____________________________________
                
                
                let subStringRepeat = (word as NSString).containsString("repeat") || (word as NSString).containsString("reoccurring")   // see duration or lenght then process
                
                numberString = ""
                var userRepeat:Int = 0
                
                
                if (subStringRepeat) {
                    
                    
                    println("p886 repeat or reoccurring: \(i)")
                    
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i]}         // trim "repeat"
                    
                    
                    //TODO is there a better way to check words? text if word in array???
                    
                    if (i < arrayLength-1) {            // check to see is there is something after "duration"
                        nextWord = wordArr[i+1]
                        println("p895 repeat next word is: \(wordArr[i+1])")
                    } else {
                        nextWord = ""
                    }
                    if (i < arrayLength-2) {
                        nextWord2 = wordArr[i+2]
                        println("p901 repeat type: \(wordArr[i+2])")
                    } else {
                        nextWord2 = ""
                    }
                    
                    let frequencyArray = ["daily", "weekly", "yearly", "monthly"]   // added trying monthly 090415 Mike
                    
                    if (nextWord != "") && ( contains(frequencyArray,nextWord) ) {    // check if word is in array
                        
                        wordArrTrimmed = wordArrTrimmed.filter() { $0 != self.nextWord }
                        
                        println("p911 word: \(word)")
                        println("p912 nextWord: \(nextWord)")
                        println("p913 nextWord2: \(nextWord2)")
                        
                        var returnValue:Int = 0
                        
                        switch (nextWord){  // 1 = daily, 2 = weekly, 3 = yearly   I made this to pass then change later in event method
                        case "daily": returnValue   = 1;   break;
                        case "weekly": returnValue  = 2;   break;
                        case "yearly": returnValue  = 3;   break;
                        case "monthly": returnValue  = 4;   break;
                            
                        default:   println("p923 no repeat word matched")
                        break;
                        }
                        
                        var repeatInterval:Int = 1        //TODO for now 1 mean every week etc...
                        
                        println("p931 returnValue: \(returnValue)")
                        eventRepeatInterval = returnValue   // 1 = daily, 2 = weekly, 3 = yearly, 4 = monthly
                    }
                    
                } else {
                    errorMsg = "No Repeat Found"
                }
     
                
                
        //---- Switch Rotine for Type's ----
                
                switch wordArr[i] as String {
                    
                case "appointment":
                    mainType = "Appointment"                                //1 = appointment
                    println("p293: mainType: \(mainType)")
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }
                    break;
                    
                case "at":
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }
                    break;
                    
                case "todo":
                    println("found todo")
                    mainType = "todo"
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }
                    break;
         /*
                case "list", "list,":
                    println("found list")
                    mainType = "List"
                    output = mainType+": "+(wordArr[i] as String)
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }
                    break;
         */
                case "contact":
                    println("found contact")
                    mainType = "contact"
                    break;
                    
                case "tomorrow":
                    println("311 set date to tomorrow")
                    day = "Tomorrow"
                    
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "M-dd-yyyy"                 // superset of OP's format
                    
                    let components = NSDateComponents()
                    components.weekOfYear = 0
                    components.day = 1
                    components.hour = 0
                    components.minute = 0
                    
                    var newDate = NSCalendar.currentCalendar().dateByAddingComponents(components,toDate: today,options: nil)
                    var dateTomorrow = dateFormatter.stringFromDate(newDate!)
                    
                    println("320 date: \(dateTomorrow)")
                    
                    startDate = dateTomorrow
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }
                    break;
                    
                    
                case "efficiency", "inefficiency":
                    println("apt type is efficiency")
                    aptType = "efficiency"
                    break;
                    
                case "bedroom":
                    println("apt type is x bedroom \(i)")
                    aptType = "\(wordArr[i-1]) \(wordArr[i])"
                    println(aptType)
                    break;
                    
                case "new":
                    println("new")
                    mainType = "***New"
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }
                    break;
                    
                case "add":
                    println("add")
                    mainType = "add ***"
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }
                    break;
                    
                default:
                    println("Type is something else")
                    //resultType.text = "Type is something else"
                    //cleardata()
                    
                    var dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "M-dd-yyyy"
                    //startDate = dateFormatter.stringFromDate(NSDate())      // if now date found assume today
                    
                    //mainType = "Other"
                    break;
                    
                }   // end Switch
                
                println("p1900 wordArrTrimmed: \(wordArrTrimmed)")
                
            }  // end for loop
            
            // #### end for loop for words in array ############################################################
            
            println("p1906: calendarName \(calendarName)")
            
            //TODO maybe this not needed now? 7/15/15 Mike check
            
            if (calendarName == "") {
                // took out test 7/4/15 8 am set calandar name elsewhere took out to see Reminder set in reminder code above
                
                //TODO get freom prefs eventually TODO MIKE  TODO Anil
                
                calendarName    = defaults.stringForKey("prefsDefaultCalendarName") ?? "Work"
                // calendarName = "dictate events"
                
                println("p1481: calendarName \(calendarName)")
                
            }
            
            
            
            
            
            // Set End Time for now 10 minutes get from prefs?
            
            // #### Date Time code to get time correct ###############################################
            
            today = NSDate()                        // equals today as NSDate 5-18-2015
            println("496 today: \(today)")          //412 today: 2015-05-18 19:23:26 +0000
            
            if (timeString == "") {
                timeString = "00:00 PM"
            }
            
            var fullDT:String = startDate + " " + timeString       // combine strings startDate and timesTring into one
            
            println("p1106 fullDT: \(fullDT)")
            
            var formatter3 = NSDateFormatter()
            formatter3.dateFormat = "M-dd-yyyy h:mm a"
            
            // CRASHES if fullDT not proper format:  fullDT: 6-06-2015 see:00 AM
            
            if(fullDT != " 00:00 PM") {
                
                println("p1633 MAIN we here? fullDT: \(fullDT)")
                
                startDT = formatter3.dateFromString(fullDT) ?? today
            }
            
            var endDT:NSDate = startDT.dateByAddingTimeInterval(eventDuration * 60.0)
            
            var fullDTEnd = formatter3.stringFromDate(endDT)
            
            println("p1127 startDT: \(startDT)")
            println("p1128 endDT: \(endDT)")
            
            // #### Date Time code to get time correct ###############################################
            
            println("### 614: date: \(date)")
            
            //output = mainType+" for "+aptType+" at "+time+" "+day+" "+phone
            //output = strRaw
            //output = outputNote
            date = day+", "+date
            
            outputRaw = strRaw
            
            println("p1012 wordArrTrimmed: \(wordArrTrimmed)")
            
            var joiner = " "
            output = joiner.join(wordArrTrimmed)
            
            
            println("p603 output: \(output)")
            /*
            resultType.text = mainType
            resultProcessed.text = output
            resultRaw.text = strRaw
            resultDate.text = day
            resultPhone.text = phone
            resultStartDate.text = fullDT
            resultEndDate.text = fullDTEnd
            resultTitle.text = output
            resultCalendar.text = "work"
            */
            outputNote = strRaw
            
            //println("p920 phone: \(phone)")
            println("p1554 outputNote: \(outputNote)")
            println("p1556 actionType: \(actionType)")
            
            if (actionType == "") {
                actionType = "Event"
                println("p1561 actionType: \(actionType)")
                mainType = "Event"
            }
                
            //Save vales to NSUserDefaults...
            
            println("p1566 actionType: \(actionType)")
            
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(startDT, forKey: "startDT")
            
            println("p1270 MAIN startDT: \(startDT)")
            
            defaults.setObject(mainType, forKey: "mainType")
            defaults.setObject(actionType, forKey: "actionType")
            
            defaults.setObject(phone, forKey: "phone")
            
            defaults.setObject(endDT, forKey: "endDT")
            defaults.setObject(output, forKey: "output")
            defaults.setObject(outputNote, forKey: "outputNote")
            
            defaults.setObject(day, forKey: "day")
            defaults.setObject(calendarName, forKey: "calendarName")
            
            defaults.setObject(eventDuration, forKey: "eventDuration")
            
            defaults.setObject(eventAlert, forKey: "eventAlert")
            
            // TODO  not used yet we see!
            let eventRepeat = eventRepeatInterval
            
            println("p1291 eventRepeat: \(eventRepeat)")
            
            defaults.setObject(eventRepeat, forKey: "eventRepeat")  //sets repeat interval for Events
            
            println("p1401 calendarName: \(calendarName)")
            
            println("p1599 actionType: \(actionType)")
            
            // Not for extension saveToDatabase()    // save data to database call function
            
            return (startDT, endDT, output, outputNote, day, calendarName, actionType)
           
            }  // end else space deliminated string
            
   
            
       // }   // end else
        
        
        
        }       //end func str != 0
        
        if (str == "") {                                                       // if str != ""
            var messageOut:String = "Nothing to Translate, try again"
            //cleardata()
            
            if (startDT != NSDate(dateString:"2014-12-12") ) {
                return (startDT, endDT, output, outputNote, day, calendarName, actionType)
            } else {
                return (NSDate(dateString:"2014-12-12"), NSDate(dateString:"2014-12-12"), output, outputNote, day, calendarName, actionType)
                
            }
        }
        
        return (NSDate(dateString:"2014-12-12"), NSDate(dateString:"2014-12-12"), output, outputNote, day, calendarName, actionType)
        
    } // end func parse
    
    
    
    
//-----------------------------------------------
    
    
    
    func calcDays(eventDay:Int, priorWord:String, priorWord2:String) -> String {         // gets 1-7 for day of week Sun-Sat as event day
        
        //var priorWord = priorWord
        
        println("pl529 eventDay: \(eventDay)")
        println("pl532 priorWord: \(priorWord)")
        println("pl530 priorWord2: \(priorWord2)")
        
        var daysToAdd:Int = 0
        
        let formatter  = NSDateFormatter()
        let todayDate = NSDate()
        let myCalendar = NSCalendar.currentCalendar()
        let myComponents = myCalendar.components(.CalendarUnitWeekday, fromDate: todayDate)
        let todayDay = myComponents.weekday
        
        println("pl538 todayDay: \(todayDay)")
        
        if (todayDay < eventDay) {
            daysToAdd = eventDay - todayDay     //event Thur, today Tue so add 2 days to today
            
        } else if (todayDay > eventDay) {
            let differenceDays = todayDay - eventDay
            
            switch differenceDays {
            case 1: daysToAdd = 6;  break;
            case 2: daysToAdd = 5;  break;
            case 3: daysToAdd = 4;  break;
            case 4: daysToAdd = 3;  break;
            case 5: daysToAdd = 2;  break;
            case 6: daysToAdd = 1;  break;
            default:
                println("691 differenceDays is something else")
            }               // end switch
        }                   // end if
        
        println("702 daysToAdd: \(daysToAdd)")
        if (todayDay == eventDay){
            daysToAdd = 0
            
            if (priorWord == "next") {
                daysToAdd = daysToAdd + 7
                wordArrTrimmed = wordArrTrimmed.filter() { $0 != priorWord }
                println("---- p706 \(wordArrTrimmed)")
            }
            
            if ((priorWord == "from") && (priorWord2 == "week") ) {
                daysToAdd = daysToAdd + 14
                wordArrTrimmed = wordArrTrimmed.filter() { $0 != priorWord }
                wordArrTrimmed = wordArrTrimmed.filter() { $0 != priorWord2 }
                
            }
            
        }
        
        if ((priorWord == "from") && (priorWord2 == "week") ) {
            daysToAdd = daysToAdd + 7
            wordArrTrimmed = wordArrTrimmed.filter() { $0 != priorWord }
            wordArrTrimmed = wordArrTrimmed.filter() { $0 != priorWord2 }
        }
        
        if (priorWord == "next") {
            wordArrTrimmed = wordArrTrimmed.filter() { $0 != priorWord }
        }
        
        
        
        var calendar = NSCalendar.currentCalendar()
        var today = NSDate()
        
        let components = NSDateComponents()
        components.weekOfYear = 0
        components.day = daysToAdd
        components.hour = 0
        components.minute = 0
        
        let newDate = calendar.dateByAddingComponents(components, toDate: today, options: nil)
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "M-dd-yyyy"
        let startDate = dateFormatter.stringFromDate(newDate!)
        println("712 startDate: \(startDate)")
        
        return startDate
    }                       // end func CalcDays
    
    
    func processMonth(wordMonthNumber:Int, nextWord:String, nextWord2:String, priorWord:String, priorWord2:String) -> String {
        
        var matched = [String]()
        var eventDay:String = ""
        var eventMonth:String = ""
        var eventYear:String = ""
        var startDate:String = ""
        
        eventMonth = String(wordMonthNumber)    // get string from Int
        
        
        var numOfCharacters:Int = count(nextWord)       // counts the number of characters in nextWord
        if ( numOfCharacters >= 1 && numOfCharacters <= 2 ) {
            let matched = listMatches("\\d{1,2}", inString: nextWord)
        } else {
            let matched = []
        }
        
        let matched2 = listMatches("\\d{4}", inString: nextWord2)
        
        var todayDate = NSDate()
        var formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy"
        
        let myCalendar = NSCalendar.currentCalendar()
        var myComponents = myCalendar.components(.CalendarUnitYear, fromDate: todayDate)
        var todayYear = myComponents.year
        
        myComponents = myCalendar.components(.CalendarUnitMonth, fromDate: todayDate)
        formatter.dateFormat = "m"
        let todayMonth = myComponents.month
        
        if ( matched != [] ) {
            eventDay = matched[0]
            wordArrTrimmed = wordArrTrimmed.filter() { $0 != eventDay }
        }
        
        
        if  ( (wordMonthNumber - todayMonth) < 0 ) {
            todayYear = todayYear+1
        }
        
        if (numOfCharacters >= 1) && (numOfCharacters <= 3) && (matched.count > 0) && (matched2.count == 0) {
            var dateMonthDayYear:String = "\(eventMonth)-\(eventDay)-\(eventYear)"
            startDate = dateMonthDayYear
        }
        
        println("p623 nextWord: \(nextWord)")
        
        if (nextWord != "") {
            var numOfCharacters = count(nextWord)
            let matchedYear = listMatches("\\d{4}", inString: nextWord)
            
            println("p634 nextword: \(nextWord) \(matchedYear) \(numOfCharacters)")
            
            if ( (numOfCharacters == 4) && (matchedYear.count == 1)) {
                eventYear = nextWord
                wordArrTrimmed = wordArrTrimmed.filter() { $0 != nextWord }
            }
            
            let matchedDay = listMatches("\\d{1,2}", inString: nextWord)
            
            if ( (numOfCharacters >= 1 && numOfCharacters <= 3 && matchedDay.count == 1 )) {
                eventDay = matchedDay[0]
                wordArrTrimmed = wordArrTrimmed.filter() { $0 != eventDay }
                println("p642 eventDay: \(eventDay)")
            }
            
            
        }
        
        if (nextWord2 != "") {
            var numOfCharacters = count(nextWord2)
            let matched = listMatches("\\d{4}", inString: nextWord2)
            
            if ( (numOfCharacters == 4) && (matched.count == 1) && (matched2.count > 0)) {
                //var dateYear:String = nextWord2
                //var dateMonthDayYear:String = "\(wordMonthNumber)-\(numberFound)-\(dateYear)"
                //startDate = dateMonthDayYear
                eventYear = nextWord2
                wordArrTrimmed = wordArrTrimmed.filter() { $0 != nextWord2 }
            }
        }
        
        println("p653 eventYear: \(eventYear)")
        println("p654 priorWord2: \(priorWord2)")
        
        let priorDayFoundMatched = listMatches("\\d{1,2}", inString: priorWord)
        let priorDay2FoundMatched = listMatches("\\d{1,2}", inString: priorWord2)
        
        println("p655 priorDayFoundMatched: \(priorDayFoundMatched)")
        
        if (priorDayFoundMatched != [] ) {
            eventDay = priorDayFoundMatched[0]
            println("p663 eventDay: \(eventDay)")
            wordArrTrimmed = wordArrTrimmed.filter() { $0 != eventDay }
            
        }
        
        if (priorDay2FoundMatched != [] ) {
            eventDay = priorDay2FoundMatched[0]
            wordArrTrimmed = wordArrTrimmed.filter() { $0 != eventDay }
        }
        /*
        if ( (priorDay2FoundMatched.count > 0) ) {
        var dateMonthDayYear:String = "\(wordMonthNumber)-\(numberFound)-\(todayYear)"
        startDate = dateMonthDayYear
        }
        */
        if (eventYear == "") {
            eventYear = String(todayYear)       //convert Int to string
        }
        
        var dateMonthDayYear:String = "\(eventMonth)-\(eventDay)-\(eventYear)"
        startDate = dateMonthDayYear
        
        println("p673 startDate: \(startDate)")
        
        return startDate
    }   // end func processMonth
    
    
    func listMatches(pattern: String, inString string: String) -> [String] {                // found on stackhub
        let regex = NSRegularExpression(pattern: pattern, options: .allZeros, error: nil)
        let range = NSMakeRange(0, count(string))
        let matches = regex?.matchesInString(string, options: .allZeros, range: range) as! [NSTextCheckingResult]
        
        return matches.map {
            let range = $0.range
            return (string as NSString).substringWithRange(range)
        }
    }
   
    //#### end my functions #################################
    
}   // class dictate code


extension NSDate
{
    convenience
    init(dateString:String) {
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        let d = dateStringFormatter.dateFromString(dateString)
        self.init(timeInterval:0, sinceDate:d!)
    }
}