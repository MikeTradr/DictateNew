//
//  NotificationController.swift
//  DictateWatch Extension
//
//  Created by Mike Derr on 5/4/16.
//  Copyright © 2016 ThatSoft.com. All rights reserved.
//
// some from here...
//http://www.brianjcoleman.com/tutorial-building-a-apple-watch-notification/
//

import WatchKit
import Foundation



class NotificationController: WKUserNotificationInterfaceController {
    
    var timeUntil:String        = ""
    let dateFormatter = NSDateFormatter()
    
    
    @IBOutlet var labelEventTitle: WKInterfaceLabel!    
    @IBOutlet var labelEventLocation: WKInterfaceLabel!
    @IBOutlet var labelStartTime: WKInterfaceLabel!
    @IBOutlet var labelEndTime: WKInterfaceLabel!
    @IBOutlet var labelTimeUntil: WKInterfaceLabel!
    
    
    override init() {
        // Initialize variables here.
        super.init()
        
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

    
    override func didReceiveLocalNotification(localNotification: UILocalNotification, withCompletion completionHandler: ((WKUserNotificationInterfaceType) -> Void)) {
        // This method is called when a local notification needs to be presented.
        // Implement it if you use a dynamic notification interface.
        // Populate your dynamic notification interface as quickly as possible.
        //
        // After populating your dynamic notification interface call the completion block.
        
        
        dateFormatter.dateFormat = "h:mm a"
        
        let startTimeA = dateFormatter.stringFromDate(localNotification.fireDate!)
        var startTime = startTimeA.stringByReplacingOccurrencesOfString(":00", withString: "")
        print("w58 startime \(startTime)")
        
        let startTimeItem = localNotification.fireDate!
        let timeUntilStart = startTimeItem.timeIntervalSinceDate(NSDate())
        
        
        
        
        
        dateFormatter.dateFormat = "h:mm"
        
        self.labelEventTitle?.setText(localNotification.alertTitle)
        self.labelStartTime?.setText(startTime)
        self.labelEndTime?.setText(localNotification.category)  //TODO stored endDate String here for now see EventSaveManager
        
        timeUntil = TimeManger.sharedInstance.timeInterval(localNotification.fireDate!)
        print("w74 timeUntil: \(timeUntil)")
        
        //let neonRed = UIColor(red: 255, green: 51, blue: 0, alpha: 1)
        let brightYellow = UIColor(red: 255, green: 255, blue: 0, alpha: 1)
        
        //let swiftColor = UIColor(red: 1, green: 165/255, blue: 0, alpha: 1)
        self.labelTimeUntil.setTextColor(brightYellow)
        //row.labelTimeUntil.setTextColor(UIColor.yellowColor())
        
        // works
        let headlineFont =
            UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        
        let fontAttribute = [NSFontAttributeName: headlineFont]
        
        let attributedString = NSAttributedString(string: "Now  ",
                                                  attributes: fontAttribute)
        
        self.labelTimeUntil.setAttributedText(attributedString)
 
       // self.labelTimeUntil?.setText(timeUntil)


        
        
        completionHandler(.Custom)
    }
    
    
    
    override func didReceiveRemoteNotification(remoteNotification: [NSObject : AnyObject], withCompletion completionHandler: ((WKUserNotificationInterfaceType) -> Void)) {
        // This method is called when a remote notification needs to be presented.
        // Implement it if you use a dynamic notification interface.
        // Populate your dynamic notification interface as quickly as possible.
        //
        // After populating your dynamic notification interface call the completion block.
        completionHandler(.Custom)
    }
    
}
