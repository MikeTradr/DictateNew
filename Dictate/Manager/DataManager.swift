//
//  DataManager.swift
//  Dictate
//
//  Created by Mike Derr on 9/18/15.
//  Copyright (c) 2015 ThatSoft.com. All rights reserved.
//

import UIKit
import EventKit

class DataManager: NSObject {
    class var sharedInstance : DataManager {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : DataManager? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = DataManager()
        }
        return Static.instance!
    }
    
//_____ Variables for new users start____________________________
    
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
    
    var userDuration:Int        = 0
    
    var actionType:String       = ""        //event, reminder, singleWordList, commaList, rawList, note?, text, email
    var mainType:String   = ""

    // new for new start...
    //var eventDuration:Double     = 10   //TODO get this from settings
    var now         = ""
    var word        = ""
    var timeString  = ""
    var phone       = ""
    var today       = NSDate()
    var date        = ""
    var aptType     = ""
    var outputRaw   = ""
    
    var defaultReminderListID: String   = ""
    var defaultEventListID: String      = ""
    var defaultEventDuration: Int       = 10
    var defaultEventAlert: Int          = 30
    
    var reminderList:String             = ""
    var reminderArray:[String]          = []
    var reminderTitle: String           = ""
    

    let defaults = NSUserDefaults(suiteName: "group.com.thatsoft.dictateApp")!
    
//_____ end Variables for new users start____________________________

    
    func createDefaults() {
        NSLog("%@ p94 func createDefaults", self)
        print("p95 startDT: \(startDT)")
    
        defaults.setObject(actionType, forKey: "actionType")
        defaults.setObject(mainType, forKey: "mainType")
        
        defaults.setObject(eventDuration, forKey: "defaultEventDuration")   //added defualt 112715
        defaults.setObject(defaultEventAlert, forKey: "defaultEventAlert")  //added defualt 112715

        defaults.setObject(wordArrTrimmed, forKey: "wordArrTrimmed")
        defaults.setObject(calendarName, forKey: "calendarName")
        defaults.setObject(startDT, forKey: "startDT")
        defaults.setObject(endDT, forKey: "endDT")
        defaults.setObject(output, forKey: "output")

        defaults.setObject(defaultReminderListID, forKey: "defaultReminderListID")
        defaults.setObject(defaultEventListID, forKey: "defaultEventListID")
        defaults.setObject(defaultEventAlert, forKey: "eventAlert")
        
        defaults.setObject(reminderList, forKey: "reminderList")
        defaults.setObject(reminderAlarm, forKey: "reminderAlarm")
        defaults.setObject(reminderArray, forKey: "reminderArray")
        defaults.setObject(reminderTitle, forKey: "reminderTitle")
        

        let test   = defaults.objectForKey("reminderArray") as! [String]
        print("119 test: \(test)")


        
        print("#####################################################")
        //println("111 Main Representation: \(NSUserDefaults.standardUserDefaults().dictionaryRepresentation())")
        print("111 Main keys.array: \(NSUserDefaults.standardUserDefaults().dictionaryRepresentation().keys)")
        print("-----------------------------------------------------")
        print("112: \(NSUserDefaults.standardUserDefaults().dictionaryRepresentation())")
        print("-----------------------------------------------------")
        print("113 Main values.array: \(NSUserDefaults.standardUserDefaults().dictionaryRepresentation().values)")
        print("#####################################################")

        //TODO Mike TODO Anil can't we print to log the items saved in NSUserDefaults???
    
    }

}
