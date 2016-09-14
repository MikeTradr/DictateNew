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
    private static var __once: () = {
            Static.instance = DataManager()
        }()
    class var sharedInstance : DataManager {
        struct Static {
            static var onceToken : Int = 0
            static var instance : DataManager? = nil
        }
        _ = DataManager.__once
        return Static.instance!
    }
    
//_____ Variables for new users start____________________________
    
    var startDT:Date          = Date(dateString:"2014-12-12")
    var endDT:Date            = Date(dateString:"2014-12-12")
    var reminderAlarm:Date    = Date(dateString:"2014-12-12")
    
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
    //var eventDuration:Int     = 10   //TODO get this from settings
    var now         = ""
    var word        = ""
    var timeString  = ""
    var phone       = ""
    var today       = Date()
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
    
    var weekView:Bool = true                //set defualt to week view true

    

    let defaults = UserDefaults(suiteName: "group.com.thatsoft.dictateApp")!
    
//_____ end Variables for new users start____________________________

    
    func createDefaults() {
        NSLog("%@ p94 func createDefaults", self)
        print("p95 startDT: \(startDT)")
    
        defaults.set(actionType, forKey: "actionType")
        defaults.set(mainType, forKey: "mainType")
        
        defaults.set(defaultEventDuration, forKey: "defaultEventDuration")   //added defualt 112715
        defaults.set(defaultEventAlert, forKey: "defaultEventAlert")  //added defualt 112715

        defaults.set(wordArrTrimmed, forKey: "wordArrTrimmed")
        defaults.set(calendarName, forKey: "calendarName")
        defaults.set(startDT, forKey: "startDT")
        defaults.set(endDT, forKey: "endDT")
        defaults.set(output, forKey: "output")

        defaults.set(defaultReminderListID, forKey: "defaultReminderListID")
        defaults.set(defaultEventListID, forKey: "defaultEventListID")
        defaults.set(defaultEventAlert, forKey: "eventAlert")
        
        defaults.set(reminderList, forKey: "reminderList")
        defaults.set(reminderAlarm, forKey: "reminderAlarm")
        defaults.set(reminderArray, forKey: "reminderArray")
        defaults.set(reminderTitle, forKey: "reminderTitle")
        
        defaults.set(weekView, forKey: "defaultWeekView")     //calendar display view
        
        let flagAutoRecord = false
        defaults.set(flagAutoRecord, forKey: "flagAutoRecord")        //sets flagAutoRecord for processing

        let test   = defaults.object(forKey: "reminderArray") as! [String]
        print("119 test: \(test)")


        
        print("#####################################################")
        //println("111 Main Representation: \(NSUserDefaults.standardUserDefaults().dictionaryRepresentation())")
        print("111 Main keys.array: \(UserDefaults.standard.dictionaryRepresentation().keys)")
        print("-----------------------------------------------------")
        print("112: \(UserDefaults.standard.dictionaryRepresentation())")
        print("-----------------------------------------------------")
        print("113 Main values.array: \(UserDefaults.standard.dictionaryRepresentation().values)")
        print("#####################################################")

        //TODO Mike TODO Anil can't we print to log the items saved in NSUserDefaults???
    
    }

}
