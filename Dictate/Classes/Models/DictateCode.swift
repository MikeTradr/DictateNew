//
//  DictateCode.swift
//  Dictate
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
    var reminderAlarm:NSDate    = NSDate(dateString:"2014-12-12")
    
    var outputNote:String       = ""
    var output:String           = ""
    var day:String              = ""
    
    var priorWord:String        = ""
    var priorWord2:String       = ""
    var nextWord:String         = ""
    var nextWord2:String        = ""
    var nextWord3:String        = ""

    var numberFound:String      = ""
    var startDate:String        = ""
    var currentMonthNumber:Int  = 0
    var wordMonthNumber:Int     = 0
    
    var errorMsg:String         = ""
    var calendarToUse:String    = ""
    var calendarName:String     = ""
    var listName:String         = ""
    var listToUse:String        = ""
    var allDayFlag:Bool         = false
    
    //added these for pDictate print commands near end line 2000...
    var duration:Int            = 0
    var alert:Int               = 0
    var reminderTitle:String    = ""
    var reminderList:String     = ""
    var reminderArray:[String]  = []
    var defaultCalendarID:String = ""
    var defaultReminderID:String = ""
    var processNow:Bool         = false
    var eventLocation           = ""

    //var startDate:String        = ""
    
    var database                = EKEventStore()
    var napid:String!
    
    var wordArrTrimmed:[String] = []
    
    var userAlertMinutes:Double = 0
    var userAlert:Int = 0
    //var eventAlert:Double       = 0
    var eventRepeatInterval:Int = 0
    
    var numberWordArray:[String] = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten"]
    
    enum NumberWord:Int { case one=1, two=2, three=3, four=4, five=5, six=6, seven=7, eight=8, nine=9, ten=10 }
    
    var userDuration:Int = 0
    
    var actionType:String   = ""        //event, reminder, singleWordList, commaList, rawList, note?, text, email
    var mainType:String   = ""
    
    let defaults = NSUserDefaults(suiteName: "group.com.thatsoft.dictateApp")!

   
// new for new start...
    
   // var eventDuration:Int = 0
    
    // defaults.setObject(eventDuration, forKey: "eventDuration")

    //CRASHES watchOS@, need to solve! and below. and ALL UserDefaults
  //  var eventDuration    = NSUserDefaults(suiteName: "group.com.thatsoft.dictateApp")!.objectForKey("defaultEventDuration") as! Int
    
    var eventDuration: Int = 10 //TODO FIX hardcoded for now, fix to new defaults watchSO2
    
    // TODO above crashes if not run phone app first??? 121215
    
   // var eventAlert    = NSUserDefaults(suiteName: "group.com.thatsoft.dictateApp")!.objectForKey("defaultEventAlert") as! Int
    
    var eventAlert: Int = 30    //TODO FIX hardcoded for now, fix to new defaults watchSO2
    
    var now = ""
    var word = ""
    var timeString = ""
    var phone = ""
    var today = NSDate()
    var date = ""
    var aptType = ""
    var outputRaw = ""
    var myLocationString = ""
    
    //#### my functions #################################
    
    func stripListWords(wordArr:[String]) -> ([String]) {
        
        for (i, element) in wordArr.enumerate() {
            
            word = wordArr[i] //as! String
        }
        
        return wordArr
    }


    
    func parse (str: String) -> (NSDate, NSDate, String, String, String, String, String) {
        //returning startDT, endDT, output, outputNote, day, calendarName, eventDuration, actionType
        
        var wordArr:[String]        = []
        
        actionType = ""     // set to blank so can process...
        mainType = ""
        calendarName = ""   // set to blank so can process...
        listName = ""
        eventLocation = ""
        
        
        
        //eventDuration = 10  // TODO get from defaults screen
        //eventDuration = 0  // TODO get from defaults screen
        
       // var eventDuration:Double     = 10

        
        defaults.setObject(actionType, forKey: "actionType")        //sets actionType for processing
        defaults.setObject(mainType, forKey: "mainType")            //sets mainType
       // defaults.setObject(eventDuration, forKey: "eventDuration")
        defaults.setObject(wordArrTrimmed, forKey: "wordArrTrimmed")
        defaults.setObject(eventLocation, forKey: "eventLocation")

        
        print("p116 eventDuration from NSDefaults: \(eventDuration)")              // see what NSDefaults has!
        print("p87 calendarName: \(calendarName)")              // see what NSDefaults has!
        
        
        
        if (str != "") {
            
            var strRaw:String = str
            var str = str.lowercaseString
            print("p91 str: \(str)")
            print("p92 strRaw: \(strRaw)")
            
            var startDate:String = ""
            var day:String = ""
            var time = "No Time Found"
            
            var userAlertMinutes:Double = 0
            
            defaults.setObject(strRaw, forKey: "strRaw")    // save raw origonal string
            
            
            //TODO ADD if we see LIST then parse on comma maybe...
            
            let charset = NSCharacterSet(charactersInString: ",")

// ____ IF for comma in string ____________________________________
           
            if str.lowercaseString.rangeOfCharacterFromSet(charset, options: [], range: nil) != nil {
                print("p122 Comma's in String yes")
                
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
                
                firstString = firstString.stringByReplacingOccurrencesOfString("new", withString: "", options: [], range: nil)
                
                firstString = firstString.stringByReplacingOccurrencesOfString("list", withString: "", options: [], range: nil)
                
                print("p100 wordArr: \(wordArr)")
                print("p150 firstString: \(firstString)")
                
                var reminderTitle = firstString
                
            //    if #available(iOS 9.0, *) {
            //        reminderTitle.localizedCapitalizedString
            //   }
                
                reminderTitle = reminderTitle.capitalizedString
                print("p172 reminderTitle: \(reminderTitle)")

                wordArrTrimmed = wordArr.filter() { $0 != wordArr[0] }   // remove first array item
                print("p165 wordArrTrimmed: \(wordArrTrimmed)")
             
                defaults.setObject(actionType, forKey: "actionType")    //sets actionType for processing
                defaults.setObject(mainType, forKey: "mainType")
                //defaults.setObject(reminderTitle, forKey: "title")      //sets reminderTitle
                defaults.setObject(reminderTitle, forKey: "reminderList")      //sets reminderTitle
                
                defaults.setObject(reminderTitle, forKey: "calendarName")   //sets title to calendarName for ParseDB
                
                defaults.setObject(wordArrTrimmed, forKey: "wordArrTrimmed")            //sets reminderItems

                return (startDT, endDT, output, outputNote, day, calendarName, actionType)
                
// ____ end IF comma in string ____________________________________
                
            } else {
                
                wordArr = str.componentsSeparatedByString(" ")      //** use for SPACE seperated list, or phrases
            

            //let wordArr = str.componentsSeparatedByString(",")      //** use for COMMA seperated list, or phrases
            
            wordArrTrimmed = wordArr
            
            let wordArrRaw = strRaw.componentsSeparatedByString(" ")    //Raw Array for nicer output
            print("p100 wordArr: \(wordArr)")
            print("p101 wordArrRaw: \(wordArrRaw)")
            
            
            var arrayLength = wordArr.count  // is Array Length
            
            print("p105 wordArrTrimmed: \(wordArrTrimmed)")
            
            print("p107: \(wordArr.count) is array length")
            
            func printTimestamp() -> String {
                let timestamp = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .LongStyle, timeStyle: .ShortStyle)
                //let timestamp = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .LongStyle, timeStyle: .NoStyle)
                print("p227 tmestamp: \(timestamp)")
                let now = timestamp
                return now
            }
            
            printTimestamp()        // Prints "Sep 9, 2014, 4:30 AM"
            //today = timestamp
            print("p141 now: \(now)")
            
            var d = NSDate()
            
            let dateStyler = NSDateFormatter()
            dateStyler.dateFormat = "MM-dd-yyyy"
            
            let myDate = dateStyler.dateFromString("04-05-2014")!
            //let todayDate = dateStyler.dateFromString(today)!
            
            let myWeekday = NSCalendar.currentCalendar().components(NSCalendarUnit.Weekday, fromDate: myDate).weekday
            
            let calendar = NSCalendar.currentCalendar()
            let date2 = NSDate()
            
            let components = NSDateComponents()
            components.weekOfYear = 1
            components.hour = 0
            
            print("p194: 1 week and 0 hours from now: \(calendar.dateByAddingComponents(components, toDate: date2, options: []))")
            
            
// ____ For Loop to loop through every word in the Sting now an array _________________
            
            for (i, element) in wordArr.enumerate() {
                
                let defaults = NSUserDefaults(suiteName: "group.com.thatsoft.dictateApp")!

                word = wordArr[i] //as! String
                
                print("===============================================")
                print("\(word)    current WORD:    \(word)")
                print("===============================================")

                print("p132 wordArrTrimmed: \(wordArrTrimmed)")
                
                
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
            
                            print("p200 nextWord: \(nextWord)")
                            print("p202 wordArrTrimmed: \(wordArrTrimmed)")

                            actionType = "New List"         // set type for proper processing
                        
                            let notes = strRaw              //origonal string
                            mainType = "New List"           // type to display
                            
                            let joiner = " "
                            output = wordArrTrimmed.joinWithSeparator(joiner)
                        
                            listName = "New List"
                            
                            let title = output
                            print("p202 title: \(title)")
                            print("p203: actionType \(actionType)")
                            print("p204: mainType \(mainType)")

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
                        
                        print("p200 nextWord: \(nextWord)")
                        print("p202 wordArrTrimmed: \(wordArrTrimmed)")
                        
                        actionType = "List"         // set type for proper processing
                        
                        let notes = strRaw          //origonal string
                        mainType = "List"           // type to display
                        
                        let joiner = " "
                        output = wordArrTrimmed.joinWithSeparator(joiner)
                        
                        let title = output
                        print("p213 title: \(title)")
                        print("p203: actionType \(actionType)")
                        print("p204: mainType \(mainType)")
                        
                        defaults.setObject(actionType, forKey: "actionType")        //sets actionType for processing
                        defaults.setObject(mainType, forKey: "mainType")            //sets mainType
                        
                        let reminderList = "Untitled List"
                        let reminderTitle = output

                        defaults.setObject(reminderTitle, forKey: "reminderTitle")            //sets reminderTitle
                        defaults.setObject(reminderList, forKey: "reminderList")            //sets reminderList
                        defaults.setObject(reminderList, forKey: "calendarName")            //sets title to calendarName for ParseDB
                        defaults.setObject(wordArrTrimmed, forKey: "wordArrTrimmed")
                        
                        // EventManager.sharedInstance.creatNewReminderList(nextWord2, items: wordArrTrimmed)
                        // EventManager.sharedInstance.creatNewReminderList(nextWord, items: ["Butter","Milk","Cheese"])
                        
                        break
                    }
                }
                
        // ____ "list" word (new might be first word, then 3rd word is title) ____________________________________
                
                let subStringList = (word as NSString).containsString("list") // see calendar then process
                if (subStringList) {
                    print("p1357 list found at item: \(i)")
                    print("p1358 listName: \(listName)")
                    let tempArray = defaults.objectForKey("reminderArray")
                    print("p1475 defaults.objectForKey(reminderArray): \(tempArray)")
                    
                    let reminderStringArray = defaults.objectForKey("reminderArray") as! [String] //array of the items
                    
                    print("p1389 reminderStringArray: \(reminderStringArray)")
                    
                    let reminderArrayLowerCased = reminderStringArray.map { return $0.lowercaseString}    //lowercase ever word in array -from Anil 083115 thank you Bro :)
                    
                    if (i < arrayLength-1) {
                        nextWord = wordArr[i+1]
                    } else {
                        nextWord = ""
                    }
                    print("p1378 nextWord: \(nextWord)")
                    
                    let startIndex = i+1    //start at word after "list"
                    listName = ""
                    for word in wordArr[startIndex..<wordArr.count] {   // make list title from words after List to end
                        print("p1428: \(word)")
                        listName = listName + " \(word)"
                        print("p1430: \(listName)")
                    }
                    
                    if listName != "" {
                        listName = String(listName.characters.dropFirst()) //remove first space I added above in loop.
                        
                        listName = listName.capitalizedString   //capitalzie first letter of each word for Calendar match
                    }
                    
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }
                    
                    print("p138 wordArrTrimmed: \(wordArrTrimmed)")
                    print("p1388 wordArrTrimmed.count: \(wordArrTrimmed.count)")
                    
                    var end = (i-1)
                    print("p1390 i: \(i)")
                    print("p1390 end: \(end)")
                    
                    if end >= wordArrTrimmed.count {
                        end = wordArrTrimmed.count
                    }
                    
                    let slice = wordArrTrimmed[0..<end]
                    
                    print("p1440 slice: \(slice)")
                    
                    wordArrTrimmed = Array(slice)
                    
                    if (listName == ""){
                        print("p1482 we in new one item list???: \(listName)")
                        
                        mainType = "New OneItem List"
                        actionType = "New OneItem List"             //sets actionType for processing
                        listName = "New List"
                        
                        defaults.setObject(actionType, forKey: "actionType")    //sets actionType
                        defaults.setObject(listName, forKey: "reminderList")    //sets reminderList
                        defaults.setObject(listName, forKey: "calendarName")    //sets List to calendarName for ParseDB
                        defaults.setObject(wordArrTrimmed, forKey: "wordArrTrimmed")    //sets List to calendarName for ParseDB
                    }
                    
                    print("p1394 listName: \(listName)")
                    defaults.setObject(listName, forKey: "reminderList")    //sets actionType
                    
                    break;
                    
                }
                
// ____ "reminder" or "remind" word ____________________________________
                
                let subStringReminder = (word as NSString).containsString("reminder") || (word as NSString).containsString("remind")  // see "reminder" ore "remind" then process
                
                if(subStringReminder && (wordArr[i] == wordArr[0])){ //added last so only here if matches is first word in string!
                    
                    print("p397: in Reminder word: \(word)")
                    
                    if defaults.objectForKey("reminderArray") != nil {
                        var reminderArray = defaults.objectForKey("reminderArray") as! [String] //array of the items
                    }
                    
                    // why did I have this in ??? removed 072315 wordArrTrimmed = wordArrRaw
                    
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }   // remove "reminder" word
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != "Reminder" }   // remove "reminder" word
                    
                    print("p141 we here? wordArrTrimmed: \(wordArrTrimmed)")
                    
                    actionType = "Reminder"         // set type for proper processing
                    
                    let notes = strRaw              //origonal string
                    mainType = "Reminder"           // type to display
                    
                    let joiner = " "
                    output = wordArrTrimmed.joinWithSeparator(joiner)
                    
                    let title = output
                    print("p151 title: \(title)")
                    
                    //TODO  tried to set the bales to "" for the detail screen  no luck
                    
                    let eventAlert = "none set yet"
                    
                    startDT = NSDate(dateString:"2014-12-12")
                    
                    //TODO Mike Anil get from settings user set default reminder list!
                    
                    //listName = defaults.stringForKey("reminderList")!
              
                    if defaults.stringForKey("defaultReminderID") != "" {
                        if let defaultReminderID  = defaults.stringForKey("defaultReminderID") {
                            print("p425 defaultReminderID: \(defaultReminderID)")
                            if let reminder:EKCalendar = ReminderManager.sharedInstance.getCalendar(defaultReminderID) {
                                print("p427 reminder: \(reminder)")
                                listName = reminder.title
                            }
                        }
                    }
               
                    var reminderList = listName
                   // listName = "Default"                            //save reminder to default Reminder List
                    
                    print("p424 actionType: \(actionType)")
                    print("p424: mainType: \(mainType)")
                    print("p424: startDT: \(startDT)")
                    print("p424: eventAlert: \(eventAlert)")
                    print("p424: calendarName: \(calendarName)")
                    print("p424: output: \(output)")
                    print("p441: listName: \(listName)")
                    
                    defaults.setObject(startDT, forKey: "startDT")
                    defaults.setObject(calendarName, forKey: "calendarName")    //sets calendarName
                    defaults.setObject(eventAlert, forKey: "eventAlert")
                    defaults.setObject(actionType, forKey: "actionType")        //sets actionType for processing
                    defaults.setObject(mainType, forKey: "mainType")            //sets mainType
                    defaults.setObject(output, forKey: "output")                //sets output
                    defaults.setObject(reminderList, forKey: "reminderList")    //sets reminderList
                    
                    defaults.setObject(output, forKey: "reminderTitle")         //sets reminderTitle

                    defaults.setObject(reminderList, forKey: "calendarName")    //sets title to calendarName for ParseDB
                    defaults.setObject(wordArrTrimmed, forKey: "wordArrTrimmed")
                }
                
// ____ "text", "message", "im" word ____________________________________
                
                
                let subStringText = (word as NSString).containsString("text") || (word as NSString).containsString("message") || (word as NSString).containsString("im")   // see "text", "message", "im" then process
                
                //wordArrTrimmed = wordArrRaw
                
                if(subStringText && (wordArr[i] == wordArr[0])){    //added last so only here if matches is first word in string!
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }   // remove "text" word
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != "Text" }   // remove "text" word
                    
                    print("p232 we here? wordArrTrimmed: \(wordArrTrimmed)")
                    
                    if (i < arrayLength-1) {
                        nextWord = wordArr[i+1]
                    } else {
                        nextWord = ""
                    }
                    
                    if ( nextWord != "" ) {
                        let matched = listMatches("[a-z]{3,10}", inString: nextWord)   // alpha characters length 3 to 10
                        
                        print("p103 matched: \(matched)")
                        
                        if (matched.count > 0) {
                            wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i+1] }   // remove "name" word
                            
                            var toPhone:String = ""
                            
                            print("p209 nextWord: \(nextWord)")
                            
                    // TODO Anil get this from Settings users created favorite names, phone, and email
                            
                            switch (nextWord) {
                            case "mike":                toPhone  = "608-242-7700"; break
                            case "stephanie", "steph":  toPhone  = "608-692-6132"; break
                            case "john", "jonathan":    toPhone  = "608-220-8543"; break
                            case "mom":                 toPhone  = "608-963-8347"; break
                            case "andrew":              toPhone  = "262-412-8745"; break
                                
                            default:
                                toPhone = ""
                                break;
                            }
                            
                            print("p224 toPhone: \(toPhone)")
                            
                            defaults.setObject(toPhone, forKey: "toPhone")
                        }
                    }
                    
                    let notes = strRaw              //origonal string
                    mainType = "Text"
                    actionType = "Text"             //sets actionType for processing
                    
                    let joiner = " "
                    output = wordArrTrimmed.joinWithSeparator(joiner)
                    let title = output
                    print("p151 title: \(title)")
                    
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
                
                print("p334 we here? wordArr[0], wordArr[i] : \(wordArr[0]), \(wordArr[i])")
                
                if(subStringCall && (actionType != "Reminder") && (wordArr[i] == wordArr[0]) ){ //added last so only here if matches is first word in string!
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }   // remove [i] word
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != "Call" }   // remove "Call" word
                    
                    
                    print("p317 we here? wordArrTrimmed: \(wordArrTrimmed)")
                    
                    if (i < arrayLength-1) {
                        nextWord = wordArr[i+1]
                    } else {
                        nextWord = ""
                    }
                    
                    if ( nextWord != "" ) {
                        let matched = listMatches("[a-z]{3,10}", inString: nextWord)   // alpha characters length 3 to 10
                        
                        print("p103 matched: \(matched)")
                        
                        if (matched.count > 0) {
                            
                            wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i+1] }   // remove [i+!] word
                            
                            var toPhone:String = ""
                            
                            print("p209 nextWord: \(nextWord)")
                            
                // TODO Anil get this from Settings users created favorite names, phone, and email
            
                            switch (nextWord) {
                            case "mike":                toPhone  = "608-242-7700"; break;
                            case "stephanie", "steph":  toPhone  = "608-692-6132"; break;
                            case "john", "jonathan":    toPhone  = "608-220-8543"; break;
                            case "mom":                 toPhone  = "608-963-8347"; break;
                            case "andrew":              toPhone  = "262-412-8745"; break;
                                
                            default:
                                toPhone = ""
                                break;
                            }
                            
                            print("p224 toPhone: \(toPhone)")
                            
                            defaults.setObject(toPhone, forKey: "toPhone")
                        }
                    }
                 
                    
                    let notes = strRaw              //origonal string
                    mainType = "Call"
                    actionType = "Call"             //sets actionType for processing
                    
                    let joiner = " "
                    output = wordArrTrimmed.joinWithSeparator(joiner)
                    let title = output
                    print("p151 title: \(title)")
                    
                   // defaults.setObject(eventAlert, forKey: "eventAlert")
                    defaults.setObject(actionType, forKey: "actionType")        //sets actionType
                    defaults.setObject(mainType, forKey: "mainType")            //sets actionType
                    
                    //ReminderCode().createReminder(title, notes: notes)
                    //TODO above line, this done in  Reminder button but change that, add code,  to the process button
                    
                    //TODO Handle Reminder or Calendar Event more efficiently????
                    
                  //  break;      //added 083115 my Mike to break out of the loop
                    
                }
                
// ____ "mail" or "email" word ____________________________________
                
                let subStringMail = (word as NSString).containsString("mail")  || (word as NSString).containsString("email")   // see "mail" or "email" then process
                
                if(subStringMail && (wordArr[i] == wordArr[0])){    //added last so only here if matches is first word in string!
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }   // remove "mail" word
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != "Mail" }   // remove "mail" word
                    
                    print("p286 in mail parse we here? wordArrTrimmed: \(wordArrTrimmed)")
                    
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
                    
                    if (i < arrayLength-3) {
                        nextWord3 = wordArr[i+3]
                    } else {
                        nextWord3 = ""
                    }
                    
                    if ( nextWord != "") {
                        let matched = listMatches("[a-z]{3,10}", inString: nextWord)   // alpha characters length 3 to 10
                        
                        print("p299 matched: \(matched)")
                        
                        if (matched.count > 0) {
                            wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i+1] }   // remove "name" word
                            
                            var toPhone:String = ""
                            
                            print("p209 nextWord: \(nextWord)")
                            
                // TODO Anil get this from Settings users created favorite names, phone, and email

                            switch (nextWord) {
                            case "mike":                toPhone  = "mike@derr.ws"; break;
                            case "stephanie", "steph":  toPhone  = "steph@derr.ws"; break;
                            case "john", "jonathan":    toPhone  = "jonathanmwild@gmail.com"; break;
                            case "mom":                 toPhone  = "germangirl1988@gmail.com"; break;
                            case "andrew":              toPhone  = "aw@rouse.biz"; break;
                            case "anil":                toPhone  = "anil@thatsoft.com"; break;
                            case "bro":                 toPhone  = "anil@thatsoft.com"; break;
                         
                            default:
                                toPhone = ""
                                break;
                            }
                            
                            print("p322 toPhone: \(toPhone)")
                            
                            defaults.setObject(toPhone, forKey: "toPhone")
                            
                        }
                        
                        let notes = strRaw              //origonal string
                        mainType = "Mail"
                        actionType = "Mail"             //sets actionType for processing
                        
                        let joiner = " "
                        output = wordArrTrimmed.joinWithSeparator(joiner)
                        let title = output
                        print("p341 title: \(title)")
                        
                        //TODO  tried to set the bales to "" for the detail screen  no luck
                        
                        actionType = "Mail"         // set type for proper processing
                       // let eventAlert = "none set yet"
                        
                      //  defaults.setObject(eventAlert, forKey: "eventAlert")
                        defaults.setObject(actionType, forKey: "actionType")        //sets actionType
                        defaults.setObject(mainType, forKey: "mainType")            //sets actionType
                        
                    }
                    
                // ----- mail Reminder items for said list --------------------------
     
                    if ( (nextWord2 == "list") || (nextWord2 == "reminders") || (nextWord2 == "reminder")) {
                        print("p695 in List nextWord2: \(nextWord2)")
                    
                        wordArrTrimmed = wordArrTrimmed.filter() { $0 != nextWord2}   // remove "list" word
                        
                        actionType = "Mail List"         // set type for proper processing
                        defaults.setObject(actionType, forKey: "actionType")        //sets actionType

                        if ( nextWord3 != "" ) {
                            //TODO Mike add Reminder Title List array lookup
                            
                            let reminderList = nextWord3
                            defaults.setObject(reminderList, forKey: "reminderList")

                        } else {
                            //TODO Mike add code to send users default set list. so no need to save the list name "mail mike list)  DONE 11-18-2015
                            var reminderList = ""
                            
                            if defaults.stringForKey("defaultReminderID") != "" {
                                if let defaultReminderID  = defaults.stringForKey("defaultReminderID") {
                                    print("p709 defaultReminderID: \(defaultReminderID)")
                                    if let reminder:EKCalendar = ReminderManager.sharedInstance.eventStore.calendarWithIdentifier("defaultReminderID") {
                                        print("p711 reminder: \(reminder)")
                                         reminderList = reminder.title
                                    }
                                }
                            }
                            
                            //let reminderList = "userDefault"    //set to this then email users set defualt list
                            defaults.setObject(reminderList, forKey: "reminderList")
                        }
                    }
                    
               // ----- mail Todays Events --------------------------
                    if ( (nextWord2 == "today") || (nextWord2 == "events") || (nextWord2 == "calendar")) {
                        print("p752 in List nextWord2: \(nextWord2)")
                        
                        wordArrTrimmed = wordArrTrimmed.filter() { $0 != nextWord2}   // remove "today" word
                        
                        actionType = "Mail Events"         // set type for proper processing
                        defaults.setObject(actionType, forKey: "actionType")        //sets actionType
                        
                        //set to one day so far. could add a # days events to mail TODO v2
              
                    }
                    
                
                    //break;       //added 083115 my Mike to break out of the loop
                }
                
                
// ____ "invite"  word ____________________________________
                
                //TODO NOT ALLOWED TO INVITE Programtically Not sure Apple allows to programmically invite people???
                
/*
                let subStringInvite = (word as NSString).containsString("invite")   // see "mail" or "email" then process
                
                if(subStringInvite ){
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }   // remove "mail" word
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != "Invite" }   // remove "mail" word
                    
                    
                    print("p501 in invite parse we here? wordArrTrimmed: \(wordArrTrimmed)")
                    
                    if (i < arrayLength-1) {
                        nextWord = wordArr[i+1]
                    } else {
                        nextWord = ""
                    }
                    
                    if ( nextWord != "" ) {
                        
                        
                        let matched = listMatches("[a-z]{3,10}", inString: nextWord)   // alpha characters length 3 to 10
                        
                        print("p514 matched: \(matched)")
                        
                        if (matched.count > 0) {
                            
                            wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i+1] }   // remove "name" word
                            
                            var toPhone:String = ""
                            
                            print("p522 nextWord: \(nextWord)")
                        
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
                            
                            print("p322 toPhone: \(toPhone)")
                            
                            defaults.setObject(toPhone, forKey: "toPhone")
                            
                        }
                        
                    }
                    
                    
                    
                    
                    let notes = strRaw              //origonal string
                    mainType = "Mail"
                    actionType = "Mail"             //sets actionType for processing
                    
                    let joiner = " "
                    output = wordArrTrimmed.joinWithSeparator(joiner)
                    let title = output
                    print("p341 title: \(title)")
                    
                    //TODO  tried to set the bales to "" for the detail screen  no luck
                    
                    actionType = "Mail"         // set type for proper processing
                    let eventAlert = "none set yet"
                    
                    defaults.setObject(eventAlert, forKey: "eventAlert")
                    defaults.setObject(actionType, forKey: "actionType")        //sets actionType
                    defaults.setObject(mainType, forKey: "mainType")            //sets actionType
                    
                    
                    //ReminderCode().createReminder(title, notes: notes)
                    //TODO above line, this done in  Reminder button but change that, add code,  to the process button
                    
                    
                    //TODO Handle Reminder or Calendar Event more efficiently????
                    
                }
                
*/
                
                
                // ____ "list" word ____________________________________
                // 1. single words = Raw list
                // 2. Comma delimited list of phrases!
                
                
                
// ____ "am" word ____________________________________
                
                let subStringAM = (word as NSString).containsString("am")   // see AM then process time at word[i-1]
                
                //println("p119 am time found at item \(i)")
                //println("p120 count(word): \(count(word))")
                //println("p121 timeString: \(timeString)")
                //println("p122 subStringAM: \(subStringAM)")
                
                //if(subStringAM && (word.characters.count <= 5) ){
                if(subStringAM && (word.characters.count <= 2) ){
                    print("p126 am time found at item: \(i)")
                    time = "\(wordArr[i-1]) \(wordArr[i])"
                    
                    let timeNumber = wordArr[i-1]
                    
                    let subStringColon = (timeNumber as NSString).containsString(":")
                    
                    if(subStringColon && (timeNumber.characters.count >= 4) && (timeNumber.characters.count <= 5) ){
                        print("378: timeNumber has colon in string")
                        timeString = "\(wordArr[i-1]) AM"
                    } else if ((timeNumber.characters.count >= 3) && (timeNumber.characters.count <= 5) ) {
                        
                            // add colon
                            
                            print("p622 (wordArr[i-1]): \(wordArr[i-1])")

                            let mutableStr = NSMutableString(string: wordArr[i-1])
                        
                        //TODO change to index or position 2nd from right end
                        if ( timeNumber.characters.count == 3 ) {
                            mutableStr.insertString(":", atIndex: 1)
                        } else if ( timeNumber.characters.count == 4 ) {
                            mutableStr.insertString(":", atIndex: 2)
                        }
                        
                            timeString = mutableStr as String
                            
                            print("p629 timeString: \(timeString)")
                        
                            timeString = "\(timeString) AM"
                            print("p633 timeString: \(timeString)")

                     
                    } else if ((timeNumber.characters.count >= 1) && (timeNumber.characters.count <= 2)) {    // number is 1 or 2 digits
                        timeString = "\(wordArr[i-1]):00 AM"
                    }
                    
                    time = "\(wordArr[i-1]) AM"
                    
                    // timeString = wordArr[i-1]
                    
                    print("## p149 timeString: \(timeString)")
                    print("-- p150 \(wordArr)")
                    
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i-1] }
                    print("---- p154 \(wordArrTrimmed)")
                    
                    if (startDate == "") {                              //add today for Reminder if a time only
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "M-dd-yyyy"
                        startDate = dateFormatter.stringFromDate(NSDate())      // no day found so assume today
                        print("p899 startDate: \(startDate)")
                    }
                    
                } else if time == "" {
                    time = "No Time Found"
                }
                
// ____ "pm" word ____________________________________
                
                let subStringPM = (word as NSString).containsString("pm")   // see PM then process time at word[i-1]
                
                if(subStringPM && (word.characters.count == 2)){
                    print("p217: pm time found at item \(i)")
                    // time = "\(wordArr[i-1]) \(wordArr[i])"
                    let timeNumber = wordArr[i-1]
                    
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != "PM" }   // remove "PM" word
                    
                    let subStringColon = (timeNumber as NSString).containsString(":")
                    
                    if(subStringColon && (timeNumber.characters.count >= 4) && (timeNumber.characters.count <= 5) ){
                        print("p684: timeNumber has colon in string")
                        timeString = "\(wordArr[i-1]) PM"
                    } else if ((timeNumber.characters.count >= 3) && (timeNumber.characters.count <= 5) ) {
                        
                        // add colon
                        
                        print("p690 (wordArr[i-1]): \(wordArr[i-1])")
                        
                        let mutableStr = NSMutableString(string: wordArr[i-1])
                        
                        //TODO change to index or position 2nd from right end
                        if ( timeNumber.characters.count == 3 ) {
                            mutableStr.insertString(":", atIndex: 1)
                        } else if ( timeNumber.characters.count == 4 ) {
                            mutableStr.insertString(":", atIndex: 2)
                        }
                        
                        timeString = mutableStr as String
                        
                        print("p703 timeString: \(timeString)")
                        
                        timeString = "\(timeString) PM"
                        print("p706 timeString: \(timeString)")
                        
                    } else if ((timeNumber.characters.count >= 1) && (timeNumber.characters.count <= 2)) {    // number is 1 or 2 digits
                        timeString = "\(wordArr[i-1]):00 PM"
                    }
                    
                    time = "\(wordArr[i-1]) PM"
                    
                    // timeString = wordArr[i-1]
                    
                    print("#### 227 timeString: \(timeString)")
                    
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i-1] }
                    print("p200 wordArrTrimmed: \(wordArrTrimmed)")
                    
                    if (startDate == "") {                              //add today for Reminder if a time only
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "M-dd-yyyy"
                        startDate = dateFormatter.stringFromDate(NSDate())      // no day found so assume today
                        print("p475 startDate: \(startDate)")
                    }
                    
                } else if time == "" {
                    time = "No Time Found"
                }
                
// ____ ":" is a time word ____________________________________
                
                let subStringTimeColon = (word as NSString).containsString(":")     // see : then process time at word
                print("#### p182 subStringTimeColen: \(subStringTimeColon)")
                print("#### p183 time: \(time)")
                
                if(subStringTimeColon && (word.characters.count >= 4) && (word.characters.count <= 5) && (timeString == "") ){                    
                    //  if(subStringTimeColon && (count(word) >= 4) && (count(word) <= 5) ) {
                    print("#### p190: : time found at item \(i)")
                    // time = "\(wordArr[i-1]) \(wordArr[i])"
                    let timeNumber = wordArr[i]
                    
                    // TODO add logic and code to guess am or pm logically, I assume PM here so far
                    
                    if(subStringTimeColon){
                        print("253: timeNumber has colon in string")
                        timeString = "\(wordArr[i]) PM"
                    }
                    
                    print("#### 258 timeString: \(timeString)")
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }
                    print("p230 wordArrTrimmed: \(wordArrTrimmed)")
                    
                    if (startDate == "") {                              //add today for Reminder if a time only
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "M-dd-yyyy"
                        startDate = dateFormatter.stringFromDate(NSDate())      // no day found so assume today
                        print("p475 startDate: \(startDate)")
                    }
                    
                } else if time == "" {
                    time = "No Time Found"
                }
                
// ____ "o'clock" ____________________________________
                
                let subStringOclock = (word as NSString).containsString("o'clock") // see o'clock then process time at word
                print(subStringOclock)
                if(subStringOclock && (time == "No Time Found")){
                    print("217: o'clock time found at item \(i)")
                    time = "\(wordArr[i-1]) \(wordArr[i])"
                    
                    timeString = "\(wordArr[i-1]):00 PM"
                    
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i-1] }
                    print("p247 wordArrTrimmed: \(wordArrTrimmed)")
                    
                    if (startDate == "") {                              //add today for Reminder if a time only
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "M-dd-yyyy"
                        startDate = dateFormatter.stringFromDate(NSDate())      // no day found so assume today
                        print("p475 startDate: \(startDate)")
                    }
                    
                } else if time == "" {
                    time = "No Time Found"
                }
                
// ____ Time as 3-4 digits ____________________________________
                
                // Handle if time word as number only like 1045 or 330
                var numOfCharacters = word.characters.count
                
                if (numOfCharacters >= 3) && (numOfCharacters <= 4) && (timeString == "") {     // Handle if time word as number only like 1045 or 330
                    let matched = listMatches("\\d{3,4}", inString: word)
                    
                    if (matched.count > 0) {
                        let numberFound = matched[0]
                        print("pl275 numberFound: \(numberFound)")
                        
                        var charAtIndex = word[word.startIndex.advancedBy(0)]
                        
                        let myArrayFromString = Array(word.characters)
                        let stringLength = word.characters.count
                        let stringIndex = myArrayFromString[stringLength-3]
                        
                        let mutableWord = NSMutableString(string: word)
                        mutableWord.insertString(":", atIndex: mutableWord.length - 2)
                        
                        let newTime = (mutableWord as String)
                        print("pl288 newTime: \(newTime)")
                        
                        // TODO ADD code to determine if 1045 word user intended AM or PM  try to guess right. need to add time checking somehow!  assuming PM for now
                        
                        timeString = "\(newTime) PM"
                        print("pl293: timeString \(timeString)")
                        
                        wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }
                        print("p283 wordArrTrimmed: \(wordArrTrimmed)")
                        
                        if (startDate == "") {                              //add today for Reminder if a time only
                            let dateFormatter = NSDateFormatter()
                            dateFormatter.dateFormat = "M-dd-yyyy"
                            startDate = dateFormatter.stringFromDate(NSDate())      // no day found so assume today
                            print("p475 startDate: \(startDate)")
                        }
                        
                    } else {
                        time = "No Time Found"
                    }
                    
                } else {
                    time = "No Time Found"
                }
                
// ____ "all day" word ____________________________________
                
                let all = (word as NSString).containsString("all") // see all then process time at word
                print(all)
                if(all && (time == "No Time Found")){
                    print("p1124 all found at item \(i)")
                    
                    if (i < arrayLength-1) {
                        nextWord = wordArr[i+1]
                    } else {
                        nextWord = ""
                    }
                    
                    if nextWord == "day" {
                        allDayFlag = true
                        time = "all-day"
                        if day == "" {
                            day = "Today"
                        }
       
                        wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }
                        wordArrTrimmed = wordArrTrimmed.filter() { $0 != nextWord }
                    
                        timeString = ""
                    
                    }
                    
                    print("p1140 wordArrTrimmed: \(wordArrTrimmed)")
                    print("p1141 allDayFlag: \(allDayFlag)")
                    
                    if (startDate == "") {                              //add today for Reminder if a time only
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "M-dd-yyyy"
                        startDate = dateFormatter.stringFromDate(NSDate())      // no day found so assume today
                        print("p475 startDate: \(startDate)")
                    }
                    
                } else if time == "" {
                    time = "No Time Found"
                }
                
// ____ "day" word ____________________________________
                
                let subStringDay = (word as NSString).containsString("day")     // note: could be today also!
                if(subStringDay){
                    print("253: day found at item \(i)")
                    
                    if day == "" {
                        day = wordArr[i].capitalizedString
                        print(day)
                    }
                    
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
                        let myComponents = myCalendar.components(.Weekday, fromDate: todayDate)
                        let todayDay = myComponents.weekday
                        
                        print("pl335 todayDay: \(todayDay)")
                        
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
                        print("334 day is something else")
                        
                        break;
                    }
                    
                    print("p370 wordArrTrimmed: \(wordArrTrimmed)")
                    
                } else if day == "" {
                   // day = "No Day Found"
                    day = ""            //020216 changed to "" for detail table processing

                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "M-dd-yyyy"
                    
                    if (actionType != "Reminder") {
                        startDate = dateFormatter.stringFromDate(NSDate())      // no day found so assume today
                        print("p638 startDate: \(startDate)")
                        day = "Today"       // moved into this if so Reminders do not get day set! was below here 2 lines 10/04/15 Mike
                    }
                    
                   
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
                
                let months = ["january", "jan", "february", "feb", "march", "mar", "april", "apr", "may", "june", "jun", "july", "jul", "august", "aug", "september", "sept", "october", "oct", "november", "nov", "december", "dec"]
                
                if months.contains(wordArr[i]) {
                    
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
                        print("p133 month is something else")
                        break;
                    }   // end Switch
                    
                }
                
                print("#### 345: startDate: \(startDate)")
                
        // ____ Phone as numbers 7-10 digits ____________________________________
                
                // process Phone number
                let subStringPhone = (word as NSString).containsString("-")
                
                if(subStringPhone) && (wordArr[i].characters.count>=8) && (actionType != "Reminder") {
                    
                    print("p431 phone found at item: \(i)")
                    phone = wordArr[i].capitalizedString
                    print("p433 phone: \(phone)")
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }
                    print("p470 wordArrTrimmed: \(wordArrTrimmed)")
                    
                    defaults.setObject(phone, forKey: "toPhone")                // to use for texting to
                    
                }
                
                
        // ____ Phone as numbers 7-10 digits ____________________________________
                
                // Handle if number word as number only like 60823427700  make it phone
                numOfCharacters = word.characters.count
                
                if (numOfCharacters >= 7) && (numOfCharacters <= 10) && (phone == "") && (actionType != "Reminder") {
                    let matched = listMatches("\\d{7,10}", inString: word)
                    
                    if (matched.count > 0) {
                        let numberFound = matched[0]
                        print("p449 numberFound: \(numberFound)")
                        
                        var charAtIndex = word[word.startIndex.advancedBy(0)]
                        
                        let myArrayFromString = Array(word.characters)
                        let stringLength = word.characters.count
                        let stringIndex = myArrayFromString[stringLength-3]
                        
                        let mutableWord = NSMutableString(string: word)
                        mutableWord.insertString("-", atIndex: mutableWord.length - 4)
                        
                        if (mutableWord.length == 11) {
                            mutableWord.insertString("-", atIndex: mutableWord.length - 8)
                        }
                        
                        phone = (mutableWord as String)
                        print("p461 phone: \(phone)")
                        
                        wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }
                        print("p505 wordArrTrimmed: \(wordArrTrimmed)")
                        
                        defaults.setObject(phone, forKey: "toPhone")                // to use for texting to
                        
                    } else {
                        phone = ""
                    }
                    
                }
                
        
                var currentWord: AnyObject = wordArr[i]             //TODO why I do this?  word is the same current word at [i]
                
        // ____ "calendar" word ____________________________________
                
                let subStringCalendar = (word as NSString).containsString("calendar") // see calendar then process
                if (subStringCalendar) {
                    print("p943: calendar found at item \(i)")
                    print("p944: calendarName \(calendarName)")

                 //   let calendarArray = defaults.objectForKey("calendarArray") as! [String] //array of the items
                 //   let calendarArray = defaults.objectForKey("calendarArray") as! [String] ?? [] //array of the items // added [] to fix nil watch crash
                    
                    let calendarArray = defaults.objectForKey("calendarArray") as! [String] //array of the items

                    print("p1325 calendarArray: \(calendarArray)")
                    
                    if (i < arrayLength-1) {
                        nextWord = wordArr[i+1]
                    } else {
                        nextWord = ""
                    }
                    
                    print("p1318 nextWord: \(nextWord)")
                    
                     let calendarArrayLowerCased = calendarArray.map { return $0.lowercaseString}    //lowercase ever word in array -from Anil 083115 thank you Bro :)

                    if (nextWord != "") {                           //  check to see if there is word after "calendar"
                        
                        if calendarArrayLowerCased.contains(nextWord) {
                            print("p1321 we here? calendarArrayLowerCased: \(calendarArrayLowerCased)")
                            calendarToUse = nextWord
                            wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i+1] }
                        }   else if calendarArrayLowerCased.contains(wordArr[i-1]) {
                            calendarToUse = wordArr[i-1]
                            wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i-1] }
                        }
                        
                        print("p1325 calendarToUse: \(calendarToUse)")
                        
                    } else {
                        errorMsg = "No Calendar Found"
                    }
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }
                    if (calendarName == ""){
                        calendarName = calendarToUse
                    }
                    
                    print("p1340 calendarName: \(calendarName)")
                    //let defaults = NSUserDefaults.standardUserDefaults()
                    defaults.setObject(calendarName, forKey: "calendar")
                }
                
                //TODO Pull from prefs
 
                // no word "calendar" found in string so set to this canendar for now.
                // TODO take from prefs users default calendar
                print("p817: calendarName \(calendarName)")
                
                print("p559 wordArrTrimmed: \(wordArrTrimmed)")
                
                //let defaults = NSUserDefaults.standardUserDefaults()
                //set above in IF statement. defaults.setObject(calendarName, forKey: "calendar")
                
                
                //TODO Pull from prefs
                
                
                
                
                // no word "calendar" found in string so set to this calendar for now.
                // TODO take from prefs users default calendar
                print("p1406 listName: \(listName)")
                
                print("p1439 wordArrTrimmed: \(wordArrTrimmed)")
                
                //let defaults = NSUserDefaults.standardUserDefaults()
                //set above in IF statement. defaults.setObject(calendarName, forKey: "calendar")
         
                
                
        // ____ "duration" word ____________________________________
                
                let subStringDuration = (word as NSString).containsString("duration") || (word as NSString).containsString("length")   // see duration or lenght then process
                
                if (subStringDuration) {
                    print("p523: duration found at item \(i)")
                    
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }   //remove "duration" word
  
                    //TODO is there a better way to check words? text if word in array???
                    
                    if (i < arrayLength-1) {        // check to see is there is something after word "duration"
                        nextWord = wordArr[i+1]
                        print("p524: duration is: \(wordArr[i+1])")
                    } else {
                        nextWord = ""
                    }
                    if (i < arrayLength-2) {
                        nextWord2 = wordArr[i+2]
                        print("p537: duration type: \(wordArr[i+2])")
                    } else {
                        nextWord2 = ""
                    }
                    
                    
                    
                    if (nextWord != "") && (numberWordArray.contains(nextWord) ) {
                        
                        wordArrTrimmed = wordArrTrimmed.filter() { $0 != self.nextWord }
                        
                        print("p576 word: \(word)")
                        
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
                            
                        default:   print("p590 no duration word matched")
                        break;
                        }
                        
                        userDuration = returnValue
                        
                        print("p1057 userDuration: \(userDuration)")
                        
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
                                print("p561 nextWord is something else")
                                break;
                            }   // end Switch
                            
                        }
                        
                        print("p1082 userDuration: \(userDuration)")
                        //eventDuration = Double(userDuration)
                        eventDuration = userDuration
                        
                        wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }
                        
                    }
                    
                    if (nextWord != "") {
                        
                        var durationNumberString = listMatches("\\d{1,3}", inString: nextWord)     //allow a 1, 2 or 3 digit string
                        
                        if (durationNumberString != []) {                   // added if no digit found, ie word is "one", "two" "three", etc...
                            
                            let numberString = durationNumberString[0]      //if number and not nextWord assume minutes!
                            
                            userDuration = Int(numberString)!
                            
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
                                    print("p561 nextWord is something else")
                                    break;
                                }   // end Switch
                                
                            }
                            
                            print("p547 userDuration \(userDuration)")
                            
                           // eventDuration = Double(userDuration)
                            eventDuration = userDuration

                            wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i+1] }
                        }   // end (durationNumberString != [])
                    }   //end nextWord != ""
                    
                }
                
                print("p692 wordArrTrimmed: \(wordArrTrimmed)")
                
                
        // ____ "Alarm"/"Alert" word ____________________________________
                //TODO add Alert code...
                
                let subStringAlert = (word as NSString).containsString("alert") || (word as NSString).containsString("alarm")   // see duration or lenght then process
                
                var numberString = ""
                //var userAlert:Int = 0
                
                if (subStringAlert) {
                    print("p603: alert or alarm found at item \(i)")
                    
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i]}         // trim "alert"
                    
                    //TODO is there a better way to check words? text if word in array???
                    
                    if (i < arrayLength-1) {            // check to see is there is something after "duration"
                        nextWord = wordArr[i+1]
                        print("p609 alert next word is: \(wordArr[i+1])")
                    } else {
                        nextWord = ""
                    }
                    if (i < arrayLength-2) {
                        nextWord2 = wordArr[i+2]
                        print("p537 alert type: \(wordArr[i+2])")
                    } else {
                        nextWord2 = ""
                    }
                    
                    print("p1671 numberWordArray: \(numberWordArray)")
                    
                    var alertNumberString = listMatches("\\d{1,4}", inString: nextWord)     //allow a 1, 2 or 3 or 4 digit string
                    
                    if ((nextWord != "") && ( (numberWordArray.contains(nextWord) || (alertNumberString.count > 0) ) ) ){

                        wordArrTrimmed = wordArrTrimmed.filter() { $0 != self.nextWord }
                        
                        print("p1680 word: \(word)")
                        print("p726 nextWord: \(nextWord)")
                        print("p727 nextWord2: \(nextWord2)")
                        
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
                            
                        default:   print("p1696 no alert word matched")
                        break;
                        }
                        
                        userAlert = returnValue
                        
                        if (alertNumberString != []) {
                            if (userAlert == 0) {
                                let numberString = alertNumberString[0]      //if number and not nextWord assume minutes
                                userAlert = Int(numberString)!
                            }
                        }
                        
                        print("p749 userAlert: \(userAlert)")
                        
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
                                    print("p635 nextWord is something else")
                                    break;
                                }   // end Switch
                            }   // end if
                            
                            print("p779 userAlert: \(userAlert)")
                            
                            //let userAlertMinutes: Double = Double(userAlert)
                            let userAlertMinutes:Int = userAlert
                            
                            print("p655 userAlertMinutes: \(userAlertMinutes)")
                            
                            let eventAlert:Int = userAlertMinutes    // this name for NSUserDefaults
                            
                            self.eventAlert = userAlertMinutes
                            
                            print("p661 self.eventAlert: \(self.eventAlert)")
                            
                            wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }
                    
                        }   //if userAlert
                   }
                    
                    if (nextWord != "") {
                    
                        var alertNumberString = listMatches("\\d{1,3}", inString: nextWord)     //allow a 1, 2 or 3 digit string
                        
                        print("p631 alertNumberString: \(alertNumberString)")
                        
                        if (alertNumberString != []) {                      // added if no digit found, ie word is "one", "two" "three", etc...
                            
                            wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i+1]}         // trim the number
                            
                            numberString = alertNumberString[0]         // if number and not nextWord assume minutes!
                            
                            var userAlert:Int = Int(numberString)!
                            
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
                                    print("p635 nextWord is something else")
                                    break;
                                }   // end Switch
                                
                            }
                            
                            print("p644 userAlert: \(userAlert)")
                            
                            let userAlertMinutes:Int = userAlert
                            
                            print("p655 userAlertMinutes: \(userAlertMinutes)")
                            
                            let eventAlert:Int = userAlertMinutes   // this name for NSUserDefaults
                            
                            self.eventAlert = userAlertMinutes
                            
                            print("p661 self.eventAlert: \(self.eventAlert)")
                            
                            wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }
                            
                        }   // end alertNumberString true
                    }   //end nextWord != ""
                    
                    print("p866 wordArrTrimmed: \(wordArrTrimmed)")
                    
                }
                
                
        
                
        // ____ "Repeat" word ____________________________________
                
                let subStringRepeat = (word as NSString).containsString("repeat") || (word as NSString).containsString("reoccurring")   // see duration or lenght then process
                
                numberString = ""
                var userRepeat:Int = 0
                
                if (subStringRepeat) {
                    print("p886 repeat or reoccurring: \(i)")
                    
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i]}         // trim "repeat"
                    
                    //TODO is there a better way to check words? text if word in array???
                    
                    if (i < arrayLength-1) {            // check to see is there is something after "duration"
                        nextWord = wordArr[i+1]
                        print("p895 repeat next word is: \(wordArr[i+1])")
                    } else {
                        nextWord = ""
                    }
                    if (i < arrayLength-2) {
                        nextWord2 = wordArr[i+2]
                        print("p901 repeat type: \(wordArr[i+2])")
                    } else {
                        nextWord2 = ""
                    }
                    
                    let frequencyArray = ["daily", "weekly", "yearly", "annually", "monthly"]   // added trying monthly 090415 Mike
                    
                    if (nextWord != "") && ( frequencyArray.contains(nextWord) ) {    // check if word is in array
                        
                        wordArrTrimmed = wordArrTrimmed.filter() { $0 != self.nextWord }
                        
                        print("p911 word: \(word)")
                        print("p912 nextWord: \(nextWord)")
                        print("p913 nextWord2: \(nextWord2)")
                        
                        var returnValue:Int = 0
                        
                        switch (nextWord){  // 1 = daily, 2 = weekly, 3 = yearly   I made this to pass then change later in event method
                            case "daily": returnValue   = 1;   break;
                            case "weekly": returnValue  = 2;   break;
                            case "monthly": returnValue  = 3;   break;
                            case "yearly", "annually": returnValue  = 4;   break;
                                
                            default:   print("p923 no repeat word matched")
                                returnValue  = 99  //= none no repeat
                            break;
                        }
                        
                        //var repeatInterval:Int = 1        //TODO for now 1 mean every week etc...
                        
                        print("p931 returnValue: \(returnValue)")
                        eventRepeatInterval = returnValue   // 1 = daily, 2 = weekly, 3 = monthly, 4 = yearly,  99 = none
                    }
                    
                } else {
                    errorMsg = "No Repeat Found"
                }
                
        // ____ "Location" word ____________________________________
                
                let subStringLocation = (word as NSString).containsString("location")   // see duration or lenght then process
           
                
                if (subStringLocation) {
                    print("p1902 location: \(i)")
                    
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i]}         // trim "repeat"
                    
                    //TODO is there a better way to check words? text if word in array???
                    
                    if (i < arrayLength-1) {            // check to see is there is something after "location"
                        nextWord = wordArr[i+1]
                        print("p1910 repeat next word is: \(wordArr[i+1])")
                    } else {
                        nextWord = ""
                    }
         
                    
                    if (nextWord != "") {
                        
                        wordArrTrimmed = wordArrTrimmed.filter() { $0 != self.nextWord }
                        
                        print("p1920 word: \(word)")
                        print("p1920 nextWord: \(nextWord)")
                        
                        let wordArrLastIndex: Int = wordArr.count-1
                        let wordArrCurrentIndex: Int = i+1
                        
                        let myLocationArr: [String] = ["\(wordArr[wordArrCurrentIndex...wordArrLastIndex])"]
                        
                        let myLocationString = wordArr[wordArrCurrentIndex...wordArrLastIndex].joinWithSeparator(" ").capitalizedString

                        print("p1930 myLocationString: \(myLocationString)")
                        
                        defaults.setObject(myLocationString, forKey: "eventLocation")
                        
                        eventLocation = defaults.stringForKey("eventLocation")!
                        print("p1930 eventLocation: \(eventLocation)")
                    }
                    
                } else {
                    errorMsg = "No Location Found"
                }

                
                
                
        //---- Switch Rotine for Type's ----
                
                switch wordArr[i] as String {
                    
                case "appointment":
                    mainType = "Appointment"                                //1 = appointment
                    print("p293: mainType: \(mainType)")
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }
                    break;
                    
                case "at":
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }
                    break;
                    
                case "todo":
                    print("found todo")
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
                    print("found contact")
                    mainType = "contact"
                    break;
                    
                case "tomorrow":
                 
                    day = "Tomorrow"
                    print("p1965 set day to tomorrow: \(day)")
                    
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "M-dd-yyyy"                 // superset of OP's format
                    
                    let components = NSDateComponents()
                    components.weekOfYear = 0
                    components.day = 1
                    components.hour = 0
                    components.minute = 0
                    
                    let newDate = NSCalendar.currentCalendar().dateByAddingComponents(components,toDate: today,options: [])
                    let dateTomorrow = dateFormatter.stringFromDate(newDate!)
                    
                    print("p1980 date: \(dateTomorrow)")
                    
                    startDate = dateTomorrow
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }
                    break;
                    
                    
                case "efficiency", "inefficiency":
                    print("apt type is efficiency")
                    aptType = "efficiency"
                    break;
                    
                case "bedroom":
                    print("apt type is x bedroom \(i)")
                    aptType = "\(wordArr[i-1]) \(wordArr[i])"
                    print(aptType)
                    break;
                    
                case "new":
                    print("new")
                    mainType = "***New"
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }
                    break;
                    
                case "add":
                    print("add")
                    mainType = "add ***"
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr[i] }
                    break;
                    
                default:
                    print("Type is something else")
                    //resultType.text = "Type is something else"
                    //cleardata()
                    
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "M-dd-yyyy"
                    //startDate = dateFormatter.stringFromDate(NSDate())      // if now date found assume today
                    
                    //mainType = "Other"
                    break;
                    
                }   // end Switch
                
                print("p1900 wordArrTrimmed: \(wordArrTrimmed)")
                
            }  // end for loop
            
            // #### end for loop for words in array ############################################################
            
            print("p1906: calendarName \(calendarName)")
            
            //TODO maybe this not needed now? 7/15/15 Mike check
            
            if (calendarName == "") {
                // took out test 7/4/15 8 am set calandar name elsewhere took out to see Reminder set in reminder code above
                
                //TODO get from prefs eventually TODO MIKE  TODO Anil   DONE CHECK 11-18-2015
                
                // calendarName    = defaults.stringForKey("prefsDefaultCalendarName") ?? "Work"
                // calendarName = "dictate events"
                
                if defaults.stringForKey("defaultCalendarID") != "" {
                    if let defaultCalendarID  = defaults.stringForKey("defaultCalendarID") {
                        
                        //FIXME:2
                        if let calendar:EKCalendar = EventManager.sharedInstance.getCalendar(defaultCalendarID) {
                            calendarName = calendar.title
                        }
                    }
                }

                print("p1997: calendarName \(calendarName)")
                
            }
            
            //POWER USER AUTO create code...
                let lastElement = wordArr.last                          //last element in array
                if (lastElement == "go" || lastElement == "process" || lastElement == "done" || lastElement == "create") {
                    print("p2015 we here? lastElement: \(lastElement)")
                    
                    let processNow:Bool = true
                    defaults.setObject(processNow, forKey: "ProcessNow")
                    wordArrTrimmed = wordArrTrimmed.filter() { $0 != wordArr.last}  // trim last word
                    print("p2020 processNow: \(processNow)")

                } else {
                    let processNow = false
                    let autoCreate:Bool = false
                    defaults.setObject(processNow, forKey: "ProcessNow")
                    print("p2027 processNow: \(processNow)")
                }
       
            
            // Set End Time for now 10 minutes get from prefs?
            
            // #### Date Time code to get time correct ###############################################
            
            today = NSDate()                        // equals today as NSDate 5-18-2015
            print("p2046 today: \(today)")          //412 today: 2015-05-18 19:23:26 +0000
            
            if (timeString == "") {
                timeString = "00:00 PM"
            }
            
            let fullDT:String = startDate + " " + timeString       // combine strings startDate and timesTring into one
            
            print("p2054 fullDT: \(fullDT)")
            
            let formatter3 = NSDateFormatter()
            formatter3.dateFormat = "M-dd-yyyy h:mm a"
            
            // CRASHES if fullDT not proper format:  fullDT: 6-06-2015 see:00 AM
            
            if(fullDT != " 00:00 PM") {
                print("p1633 MAIN we here? fullDT: \(fullDT)")
                startDT = formatter3.dateFromString(fullDT) ?? today
            }
            
            let doubleTimeDuration:Double = Double(eventDuration * 60)  //convert Int to Double for next calc.
            
            var endDT:NSDate = startDT.dateByAddingTimeInterval(doubleTimeDuration)
            
            var fullDTEnd = formatter3.stringFromDate(endDT)
            
            print("p1127 startDT: \(startDT)")
            print("p1128 endDT: \(endDT)")
            
            // #### Date Time code to get time correct ###############################################
            
            print("### 614: date: \(date)")
            
            //output = mainType+" for "+aptType+" at "+time+" "+day+" "+phone
            //output = strRaw
            //output = outputNote
            date = day+", "+date
            
            outputRaw = strRaw
            
            print("p1012 wordArrTrimmed: \(wordArrTrimmed)")
            
            let joiner = " "
            output = wordArrTrimmed.joinWithSeparator(joiner)
        
            
            print("p603 output: \(output)")
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
            print("p1554 outputNote: \(outputNote)")
            print("p1556 actionType: \(actionType)")
            
            if (actionType == "") {     // if no actionType we assume it is Event for calendar event.
                actionType = "Event"
                print("p1561 actionType: \(actionType)")
                mainType = "Event"
            }
                
        // _____add alarm if time detected, and type is Reminder
                
                
            if (actionType == "Reminder" ) && (startDT != NSDate(dateString:"2014-12-12")) {
                reminderAlarm = startDT
                print("p2013 reminderAlarm: \(reminderAlarm)")
                defaults.setObject(reminderAlarm, forKey: "reminderAlarm")  // set for Reminder Alarm
                endDT = NSDate(dateString:"2014-12-12") // basically a blank date
            } else {
                reminderAlarm = NSDate(dateString:"2014-12-12") // basically a blank date
                print("p2018 reminderAlarm: \(reminderAlarm)")
                defaults.setObject(reminderAlarm, forKey: "reminderAlarm")  // set for Reminder Alarm
                //endDT = NSDate(dateString:"2014-12-12") // basically a blank date

                }
                
                
                // AFTER WORLD STRING stepped through... finished processing word string...
                
                print("p2082 userDuration: \(userDuration)")
                
                if userDuration == 0 {          //no duration found so pull duration from defaults.
                    print("p2085 No user Duration found set userDuration: \(userDuration)")
                    if defaults.objectForKey("eventDuration") as? Int != 0 {
                        if let duration:Int  = defaults.objectForKey("defaultEventDuration") as? Int {
                            print("p2137 duration: \(duration)")
                            eventDuration = duration
                        }
                    }
                }
                
                print("p2094 userAlert: \(userAlert)")
                
                if userAlert == 0 {          //no Alert found so pull alert from defaults.
                    print("p2097 No user Alert found set userAlert: \(userAlert)")
                    if defaults.objectForKey("eventAlert") as? Int != 0 {
                        if let alert:Int  = defaults.objectForKey("defaultEventAlert") as? Int {
                            print("p1809 alert: \(alert)")
                            eventAlert = alert
                        }
                    }
                }
                
          
            //Save vales to NSUserDefaults...

            defaults.setObject(actionType, forKey: "actionType")
            defaults.setObject(startDT, forKey: "startDT")
            defaults.setObject(endDT, forKey: "endDT")
            defaults.setObject(allDayFlag, forKey: "allDayFlag")
            defaults.setObject(mainType, forKey: "mainType")
            defaults.setObject(phone, forKey: "phone")
            defaults.setObject(output, forKey: "output")
            defaults.setObject(outputNote, forKey: "outputNote")
            defaults.setObject(day, forKey: "day")
            defaults.setObject(calendarName, forKey: "calendarName")
            defaults.setObject(eventDuration, forKey: "eventDuration")
            defaults.setObject(eventAlert, forKey: "eventAlert")

                
            // TODO  not used yet we see!
            let eventRepeat = eventRepeatInterval
            defaults.setObject(eventRepeat, forKey: "eventRepeat")  //sets repeat interval for Events
                
            defaults.synchronize() // from Rob course
            
            // Not for extension saveToDatabase()    // save data to database call function
                
            print("pDictated ===================================")
            print("pDictated day: \(day)")
            print("pDictated phone: \(phone)")
            print("pDictated startDT: \(startDT)")
            print("pDictated endDT: \(endDT)")
            print("pDictated output: \(output)")
            print("pDictated outputNote: \(outputNote)")
            print("pDictated duration: \(duration)")
            print("pDictated calandarName: \(calendarName)")
            print("pDictated alert: \(alert)")
            print("pDictated eventRepeat: \(eventRepeat)")
            print("pDictated strRaw: \(strRaw)")
            print("pDictated eventLocation: \(eventLocation)")
            
            print("pDictated mainType: \(mainType)")
            print("pDictated actionType: \(actionType)")
            
            print("pDictated reminderTitle: \(reminderTitle)")
            print("pDictated wordArrTrimmed: \(wordArrTrimmed)")
            print("pDictated reminderList: \(reminderList)")
            print("pDictated reminderArray: \(reminderArray)")
            print("pDictated reminderAlarm: \(reminderAlarm)")
            
            print("pDictated allDayFlag: \(allDayFlag)")
            print("pDictated timeString: \(timeString)")
            
            print("pDictated defaultCalendarID: \(defaultCalendarID)")       //defaultCalendarID
            print("pDictated defaultReminderID: \(defaultReminderID)")       //defaultReminderID
            print("pDictated processNow: \(processNow)")                     //processNow Bool
            
            print("pDictated end =================================")
                
                
                
                
                
                
                
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
        
        print("pl529 eventDay: \(eventDay)")
        print("pl532 priorWord: \(priorWord)")
        print("pl530 priorWord2: \(priorWord2)")
        
        var daysToAdd:Int = 0
        
        let formatter  = NSDateFormatter()
        let todayDate = NSDate()
        let myCalendar = NSCalendar.currentCalendar()
        let myComponents = myCalendar.components(.Weekday, fromDate: todayDate)
        let todayDay = myComponents.weekday
        
        print("pl538 todayDay: \(todayDay)")
        
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
                print("691 differenceDays is something else")
            }               // end switch
        }                   // end if
        
        print("702 daysToAdd: \(daysToAdd)")
        if (todayDay == eventDay){
            daysToAdd = 0
            
            if (priorWord == "next") {
                daysToAdd = daysToAdd + 7
                wordArrTrimmed = wordArrTrimmed.filter() { $0 != priorWord }
                print("---- p706 \(wordArrTrimmed)")
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
        
        
        
        let calendar = NSCalendar.currentCalendar()
        let today = NSDate()
        
        let components = NSDateComponents()
        components.weekOfYear = 0
        components.day = daysToAdd
        components.hour = 0
        components.minute = 0
        
        let newDate = calendar.dateByAddingComponents(components, toDate: today, options: [])
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "M-dd-yyyy"
        let startDate = dateFormatter.stringFromDate(newDate!)
        print("712 startDate: \(startDate)")
        
        return startDate
    }                       // end func CalcDays
    
    
    func processMonth(wordMonthNumber:Int, nextWord:String, nextWord2:String, priorWord:String, priorWord2:String) -> String {
        
        var matched = [String]()
        var eventDay:String = ""
        var eventMonth:String = ""
        var eventYear:String = ""
        var startDate:String = ""
        
        eventMonth = String(wordMonthNumber)    // get string from Int
        
        
        let numOfCharacters:Int = nextWord.characters.count       // counts the number of characters in nextWord
        if ( numOfCharacters >= 1 && numOfCharacters <= 2 ) {
            let matched = listMatches("\\d{1,2}", inString: nextWord)
        } else {
            let matched = []
        }
        
        let matched2 = listMatches("\\d{4}", inString: nextWord2)
        
        let todayDate = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy"
        
        let myCalendar = NSCalendar.currentCalendar()
        var myComponents = myCalendar.components(.Year, fromDate: todayDate)
        var todayYear = myComponents.year
        
        myComponents = myCalendar.components(.Month, fromDate: todayDate)
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
            let dateMonthDayYear:String = "\(eventMonth)-\(eventDay)-\(eventYear)"
            startDate = dateMonthDayYear
        }
        
        print("p623 nextWord: \(nextWord)")
        
        if (nextWord != "") {
            let numOfCharacters = nextWord.characters.count
            let matchedYear = listMatches("\\d{4}", inString: nextWord)
            
            print("p634 nextword: \(nextWord) \(matchedYear) \(numOfCharacters)")
            
            if ( (numOfCharacters == 4) && (matchedYear.count == 1)) {
                eventYear = nextWord
                wordArrTrimmed = wordArrTrimmed.filter() { $0 != nextWord }
            }
            
            let matchedDay = listMatches("\\d{1,2}", inString: nextWord)
            
            if ( (numOfCharacters >= 1 && numOfCharacters <= 3 && matchedDay.count == 1 )) {
                eventDay = matchedDay[0]
                wordArrTrimmed = wordArrTrimmed.filter() { $0 != eventDay }
                print("p642 eventDay: \(eventDay)")
            }
            
            
        }
        
        if (nextWord2 != "") {
            let numOfCharacters = nextWord2.characters.count
            let matched = listMatches("\\d{4}", inString: nextWord2)
            
            if ( (numOfCharacters == 4) && (matched.count == 1) && (matched2.count > 0)) {
                //var dateYear:String = nextWord2
                //var dateMonthDayYear:String = "\(wordMonthNumber)-\(numberFound)-\(dateYear)"
                //startDate = dateMonthDayYear
                eventYear = nextWord2
                wordArrTrimmed = wordArrTrimmed.filter() { $0 != nextWord2 }
            }
        }
        
        print("p653 eventYear: \(eventYear)")
        print("p654 priorWord2: \(priorWord2)")
        
        let priorDayFoundMatched = listMatches("\\d{1,2}", inString: priorWord)
        let priorDay2FoundMatched = listMatches("\\d{1,2}", inString: priorWord2)
        
        print("p655 priorDayFoundMatched: \(priorDayFoundMatched)")
        
        if (priorDayFoundMatched != [] ) {
            eventDay = priorDayFoundMatched[0]
            print("p663 eventDay: \(eventDay)")
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
        
        let dateMonthDayYear:String = "\(eventMonth)-\(eventDay)-\(eventYear)"
        startDate = dateMonthDayYear
        
        print("p673 startDate: \(startDate)")
        
        return startDate
    }   // end func processMonth
    
    
    func listMatches(pattern: String, inString string: String) -> [String] {                // found on stackhub
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let range = NSMakeRange(0, string.characters.count)
        let matches = regex?.matchesInString(string, options: [], range: range)
        return matches!.map {
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