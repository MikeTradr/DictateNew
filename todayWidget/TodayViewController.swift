//
//  TodayViewController.swift
//  todayWidget
//
//  Created by Mike Derr on 8/31/16.
//  Copyright © 2016 ThatSoft.com. All rights reserved.
//
/// https://github.com/maximbilan/iOS-Today-Extension-Simple-Tutorial
//

import UIKit
import NotificationCenter
import Foundation
import EventKit

class TodayViewController: UIViewController, NCWidgetProviding {
    
    private var data: Array<NSDictionary> = Array()
    var attractionNames = [String]()
    
    var output:String           = ""
    var allEvents: Array<EKEvent> = []
    let dateFormatter = NSDateFormatter()
    var today:NSDate            = NSDate()      //current time
    var now:NSDate              = NSDate()
    var timeUntil:String        = ""
    
    var numberOfRows:Int        = 0
    var rowsToDelete:Int        = 0
    
    @IBOutlet var labelNoEvents: UILabel!
    @IBOutlet var table: UITableView!
    
    
    func fetchEvents(){
        
        let today =  NSDate()
        let startDate = NSCalendar.currentCalendar().startOfDayForDate(today)
        
        let calendar = NSCalendar.currentCalendar()
        
        let tomorrow :NSDate = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: 1, toDate: NSDate(), options: [])!
        
        let endDate = NSCalendar.currentCalendar().startOfDayForDate(tomorrow)
        
        print("p39 startDate: \(startDate)")
        print("p40 endDate: \(endDate)")
        
        EventManager.sharedInstance.fetchEventsFrom(startDate, endDate: endDate, completion: { (events) -> Void in
            self.allEvents = events
        })
        
        print("p46 allEvents.count: \(allEvents.count)")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        
        fetchEvents()
        
        var numberOfRows = allEvents.count
        
        
        print("p67 rowsToDelete: \(rowsToDelete)")
        
        self.preferredContentSize.height = CGFloat((numberOfRows-rowsToDelete) * 50)
        
        if allEvents.count == 0 {        //no events for day
            self.preferredContentSize.height = 25
            self.labelNoEvents.text = "Dictate™ 😀 No More Events Today"
            self.labelNoEvents.hidden = false
        } else {
            self.labelNoEvents.hidden = true
        }
        
        
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
        
        fetchEvents()
        
       // let item = allEvents[0]  
        
        if allEvents.count == 0 {        //no events for day
            self.preferredContentSize.height = 25
            self.labelNoEvents.text = "Dictate™ 😀 No More Events Today"
            self.labelNoEvents.hidden = false
        } else {
            self.labelNoEvents.hidden = true
        }
        
      //  var numberOfRows = allEvents.count
       // self.preferredContentSize.height = CGFloat((numberOfRows-rowsToDelete) * 50)
        
        completionHandler(NCUpdateResult.NewData)
    }
/*
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> (UIEdgeInsets) {
        return UIEdgeInsetsZero
    }
 */
    
    func widgetMarginInsetsForProposedMarginInsets(var defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        
       // var defaultLeftInset: CGFloat = 0
       // defaultLeftInset = defaultMarginInsets.left
        
        defaultMarginInsets.left = 45
        return defaultMarginInsets
    }


    // MARK: - TableView Data Source
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allEvents.count
    }

    
    func tableView(table: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier = "tableViewCellIdentifier"
        
        let cell = table.dequeueReusableCellWithIdentifier( identifier, forIndexPath: indexPath) as! TodayTableViewCell
    
      //  let row = indexPath.row
        
        print("p133 allEvents.count: \(allEvents.count)")
        
       let item = allEvents[indexPath.row]

       //table.setNumberOfRows(allEvents.count, withRowType: "tableRow")
        
       // for (index, title) in allEvents.enumerate() {
            
        print("---------------------------------------------------")
        print("w175 index, title: \(index), \(title)")
        print("w176 index: \(index)")
        print("w177 table: \(table)")
      //  print("w178 table.rowControllerAtIndex(index): \(table.rowControllerAtIndex(index))")
        
        print("w183 WE HERE????")
        
       // let item = allEvents[index]
        
       // date1.timeIntervalSince1970 < date2.timeIntervalSince1970
        
        if item.endDate.timeIntervalSince1970 <= NSDate().timeIntervalSince1970 {
            cell.hidden = true
          //  cell.rowHeight = 0
            
            return cell
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
        
        if item.allDay {     // if allDay bool is true
            startTime = "all-day"
            endTimeDash = ""
            timeUntil = "all-Day"
        }

        if item.startDate == item.endDate {
             endTimeDash = ""
        }


        let startTimeItem = item.startDate
        let timeUntilStart = startTimeItem.timeIntervalSinceDate(NSDate())
    
        let endTimeItem = item.endDate
        let timeUntilEnd = endTimeItem.timeIntervalSinceDate(NSDate())
    
        if ((timeUntilStart <= 0) && (timeUntilEnd >= 0)) {

            // works
            let headlineFont =
                UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
            let fontAttribute = [NSFontAttributeName: headlineFont]
            
            let attributedString = NSAttributedString(string: "Now" + " 😀",
                                                      attributes: fontAttribute)
            
            cell.labelTimeUntil.attributedText = attributedString
            cell.labelTimeUntil.textColor = UIColor.yellowColor()
            
            
            if item.allDay {     // if allDay bool is true
                print("p205 we here item.allDay: \(item.allDay)")
                cell.labelTimeUntil.text = ""
            }

            
        } else {
            cell.labelTimeUntil.text = timeUntil
        }
        
        //TODO Mike TODO Anil All day event spanning multiple days does not show up on multiple days
        
        print("p227 timeUntil: \(timeUntil)")
        
        cell.labelOutput.text = item.title
        cell.labelStartTime.text = startTime
        cell.labelEndTime.text = endTimeDash
    
        //cell.labelOutput.textColor = UIColor(CGColor: item.calendar.CGColor)
        cell.labelOutput.textColor = UIColor.whiteColor()
        
        cell.labelStartTime.textColor = UIColor.whiteColor().colorWithAlphaComponent(1.0)
        cell.labelEndTime.textColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
    
        cell.verticalBarView.backgroundColor = UIColor(CGColor: item.calendar.CGColor)
    
        let location = item.location
        
        if location != "" {
            
            cell.labelSecondLine.font = UIFont.italicSystemFontOfSize(cell.labelSecondLine.font.pointSize)
            cell.labelSecondLine.text = location
            cell.labelSecondLine.textColor = UIColor.whiteColor().colorWithAlphaComponent(0.65)
    
        } else {
            cell.labelSecondLine.text = item.calendar.title
            cell.labelSecondLine.textColor = UIColor(CGColor: item.calendar.CGColor)
        }
        
       // return cell
            
       // }                   // for (index, title)

        return cell
    }                       // func tableView
    
    
    func tableView(table: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        let item = allEvents[indexPath.row]
        
        if item.endDate.timeIntervalSince1970 <= NSDate().timeIntervalSince1970 {

            //self.preferredContentSize.height = self.preferredContentSize.height - 50
            
            rowsToDelete = rowsToDelete + 1

            return 0.0

        } else {

        return 50.0;//Choose your custom row height
        }
    }
 
}
