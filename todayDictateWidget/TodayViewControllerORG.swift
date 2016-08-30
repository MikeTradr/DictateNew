//
//  TodayViewController.swift
//  todayDictateWidget
//
//  Created by Mike Derr on 8/29/16.
//  Copyright © 2016 ThatSoft.com. All rights reserved.
//
// some ideas from here:
//https://grokswift.com/notification-center-widget/
//

import UIKit
import NotificationCenter
import Foundation
import EventKit

class TodayViewController: UIViewController, NCWidgetProviding {
    
    var output:String           = ""
    var allEvents: Array<EKEvent> = []
    let dateFormatter = NSDateFormatter()
    var today:NSDate            = NSDate()      //current time
    var now:NSDate              = NSDate()
    var timeUntil:String        = ""




    @IBOutlet var labelStartTime: UILabel!
    
    @IBOutlet var labelWidgetTitle: UILabel!
    @IBOutlet var labelTimeUntil: UILabel!
    
    
    func fetchEvents(){
        
        //  let dateHelper = JTDateHelper()
        let startDate =  NSDate()
        
        // let cal = NSCalendar(calendarIdentifier: NSGregorianCalendar)
        // let next10Days = cal!.dateByAddingUnit(NSCalendarUnit.Day, value: 10, toDate: today, options: .Day)
        
        let calendar = NSCalendar.currentCalendar()
        let endDate: NSDate = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: 1, toDate: startDate, options: [])!
        
        // value above was 10 Mke 061316
        
        // let endDate = dateHelper.addToDate(startDate, days: 10)
        
        print("w46 startDate: \(startDate)")
        print("w46 endDate: \(endDate)")
        
        //FIXME:4
        EventManager.sharedInstance.fetchEventsFrom(startDate, endDate: endDate, completion: { (events) -> Void in
            self.allEvents = events
            //self.loadTableData()
        })

        print("p49 allEvents.count: \(allEvents.count)")

        
       // print("w56 self.allEvents: \(self.allEvents)")
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        
        fetchEvents()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        
        let item = allEvents[1]
        
        labelWidgetTitle?.text = "Still not sure"
        
        print("p40 we here output: \(output)")
     
        if labelWidgetTitle != nil
        {
            let defaults = NSUserDefaults(suiteName: "group.com.thatsoft.dictateApp")
            print("p43 defaults: \(defaults)")

            if let output:String = defaults?.objectForKey("output") as? String
            {
                print("p48 output: \(output)")

                labelWidgetTitle?.text = item.title
            }
            
            dateFormatter.dateFormat = "h:mm a"
            
            let startTimeA = dateFormatter.stringFromDate(item.startDate)
            var startTime = startTimeA.stringByReplacingOccurrencesOfString(":00", withString: "")
            NSLog("%@ w137", startTime)
            
            dateFormatter.dateFormat = "h:mm"
            
            let endTimeA = dateFormatter.stringFromDate(item.endDate)
            let endTime = endTimeA.stringByReplacingOccurrencesOfString(":00", withString: "")
            
            var endTimeDash = "- \(endTime)"
            
            timeUntil = TimeManger.sharedInstance.timeInterval(item.startDate)

            
            timeUntil = TimeManger.sharedInstance.timeInterval(item.startDate)
            
            let startTimeItem = item.startDate
            let timeUntilStart = startTimeItem.timeIntervalSinceDate(NSDate())
            //print("w187 timeUntilStart: \(timeUntilStart)")
            
            let endTimeItem = item.endDate
            let timeUntilEnd = endTimeItem.timeIntervalSinceDate(NSDate())
            //print("w192 timeUntilEnd: \(timeUntilEnd)")
            
            if ((timeUntilStart <= 0) && (timeUntilEnd >= 0)) {
                timeUntil = "Now"
                let neonRed = UIColor(red: 255, green: 51, blue: 0, alpha: 1)
                let brightYellow = UIColor(red: 255, green: 255, blue: 0, alpha: 1)
                
                //let swiftColor = UIColor(red: 1, green: 165/255, blue: 0, alpha: 1)
                //labelTimeUntil.textColor(brightYellow)
              // labelTimeUntil.textColor(UIColor.yellowColor())
                
                // works
                let headlineFont =
                    UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
                
                let fontAttribute = [NSFontAttributeName: headlineFont]
                
                let attributedString = NSAttributedString(string: "Now  ",
                                                          attributes: fontAttribute)
                
                labelTimeUntil.attributedText = attributedString
                
                
            } else {
                let brightYellow = UIColor(red: 255, green: 255, blue: 0, alpha: 1)
                labelTimeUntil.textColor = brightYellow
                labelTimeUntil.text = timeUntil
            }

            labelStartTime.text = startTime

            
            
            
            
            //labelTimeUntil.text = startTimeA
            
        }
        
 
        
  /*

        
       // if let label = labelWidgetTitle {
            
            let defaults = NSUserDefaults(suiteName: "group.com.thatsoft.dictateApp")!
         
            print("p66 defaults: \(defaults)")
            
            var output      = defaults.stringForKey("output")                   //Title
            print("p69 output: \(output)")

            labelWidgetTitle.text = "Next Event: " + output!
            
            labelTimeUntil.text = "Now"
           
      //  }

*/
        

        completionHandler(NCUpdateResult.NewData)
    }
    
}
