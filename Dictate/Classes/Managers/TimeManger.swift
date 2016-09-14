//
//  TimeManger.swift
//  Dictate
//
//  Created by Mike Derr on 3/29/16.
//  Copyright © 2016 ThatSoft.com. All rights reserved.
//
// Anil add to viewcontroller: labelTimeUntil.textColor = UIColor.redColor() for first two case statements please

import UIKit

class TimeManger: NSObject {
    
    private static var __once: () = {
            Static.instance = TimeManger()
        }()
 
    class var sharedInstance : TimeManger {
        struct Static {
            static var onceToken : Int = 0
            static var instance : TimeManger? = nil
        }
        _ = TimeManger.__once
        return Static.instance!
    }
    
    var label = ""
    let now = Date()
    var timeOutput = ""
    var outputInterval = ""
    let dateFormatter = DateFormatter()
    
    //pass date in format: dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    func timeInterval(_ date:Date) -> String {
        
        let dateComponentsFormatter = DateComponentsFormatter()
        dateComponentsFormatter.unitsStyle = DateComponentsFormatter.UnitsStyle.short
        dateComponentsFormatter.allowedUnits = [.hour, .minute]
        
        let hourFormatter = DateComponentsFormatter()
        hourFormatter.unitsStyle = DateComponentsFormatter.UnitsStyle.short
        hourFormatter.allowedUnits = .hour
        
        let timeUntil = date.timeIntervalSince(Date())
        dateComponentsFormatter.string(from: timeUntil)
        
        print("p42 now:  \(now)")
        print("p43 date: \(date)")
        print("p44 timeUntil: \(timeUntil)")
        
        timeOutput = dateComponentsFormatter.string(from: timeUntil)!
        
        // Anil add to viewcontroller: labelTimeUntil.textColor = UIColor.redColor()      for first two case statements please

        switch timeUntil {
        case timeUntil where ((timeUntil >= -120) && (timeUntil <= 0)): //0 until 2 minutes into event, process during to show now in Viewcontroller
            label = "Now"
        case timeUntil where ((timeUntil > 0) && (timeUntil <= 60)): //a minute until event, process during to show now in Viewcontroller
            label = "in 1 minute"
        case timeUntil where ((timeUntil > 60) && (timeUntil <= 3600)):    //display minutes only
            label = "in \(timeOutput)"
        case timeUntil where ((timeUntil > 3600) && (timeUntil <= 10800)):  //display hours & minutes, timeUntil < 3 hours
            label = "in \(timeOutput)"
        case timeUntil where ((timeUntil > 10800) && (timeUntil <= 86400)): //display hours only
            timeOutput = hourFormatter.string(from: timeUntil)!
            label = "in \(timeOutput)"
        case timeUntil where (timeUntil > 86400): //> then a day until, display blank
            label = ""
        default :
            print( "default case")
        }
    
        return label
    }
}
