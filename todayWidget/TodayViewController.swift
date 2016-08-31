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
    
    let brightYellow = UIColor(red: 255, green: 255, blue: 0, alpha: 1)

    
    @IBOutlet var table: UITableView!
    
  //  @IBOutlet var tableView: UITableView!
    
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
        
        attractionNames = ["Buckingham Palace",
                           "The Eiffel Tower",
                           "The Grand Canyon",
                           "Windsor Castle",
                           "Empire State Building"]

        
        fetchEvents()
        
        self.preferredContentSize.height = 170
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
        
        completionHandler(NCUpdateResult.NewData)
    }
/*
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> (UIEdgeInsets) {
        return UIEdgeInsetsZero
    }
 */


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
        
        var identifier = "tableViewCellIdentifier"
        
        let cell = table.dequeueReusableCellWithIdentifier( identifier, forIndexPath: indexPath) as! TodayTableViewCell
    
      //  let row = indexPath.row
        
        print("p133 allEvents.count: \(allEvents.count)")
        
       // let item = allEvents[row]

       //table.setNumberOfRows(allEvents.count, withRowType: "tableRow")
        
        for (index, title) in allEvents.enumerate() {
            
            print("---------------------------------------------------")
            print("w175 index, title: \(index), \(title)")
            print("w176 index: \(index)")
            print("w177 table: \(table)")
          //  print("w178 table.rowControllerAtIndex(index): \(table.rowControllerAtIndex(index))")
            
                print("w183 WE HERE????")
                
                let item = allEvents[index]
                
                dateFormatter.dateFormat = "h:mm a"
                
                let startTimeA = dateFormatter.stringFromDate(item.startDate)
                var startTime = startTimeA.stringByReplacingOccurrencesOfString(":00", withString: "")
                NSLog("%@ w137", startTime)
                
                dateFormatter.dateFormat = "h:mm"
                
                let endTimeA = dateFormatter.stringFromDate(item.endDate)
                let endTime = endTimeA.stringByReplacingOccurrencesOfString(":00", withString: "")
                
                var endTimeDash = "- \(endTime)"
                
                timeUntil = TimeManger.sharedInstance.timeInterval(item.startDate)
                
         //       if item.allDay {     // if allDay bool is true
         //           row.groupTime.setHidden(true)
          //      }
                
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
                    cell.labelTimeUntil.textColor = brightYellow
                    //row.labelTimeUntil.setTextColor(UIColor.yellowColor())
                    
                    // works
                    let headlineFont =
                        UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
                    
                    let fontAttribute = [NSFontAttributeName: headlineFont]
                    
                    let attributedString = NSAttributedString(string: "Now  ",
                                                              attributes: fontAttribute)
                    
                    cell.labelTimeUntil.attributedText = attributedString
                    
                    
                } else {
                 
                    cell.labelTimeUntil.textColor = brightYellow
                    cell.labelTimeUntil.text = timeUntil
                }
                
                //TODO Mike TODO Anil All day event spanning multiple days does not show up on multiple days
                
                print("w185 timeUntil: \(timeUntil)")
                
                cell.labelOutput.text = item.title
                //row.labelEventLocation.setText(item.location)
                cell.labelStartTime.text = startTime
                cell.labelEndTime.text = endTimeDash
            
                //row.labelTimeUntil.setText("\(timeUntil)  ")
                
                cell.labelOutput.textColor = (UIColor(CGColor: item.calendar.CGColor))
                // row.labelStartTime.setTextColor(UIColor(CGColor: item.calendar.CGColor))
                // row.labelEndTime.setTextColor(UIColor(CGColor: item.calendar.CGColor))
                
                cell.labelStartTime.textColor = (UIColor.whiteColor().colorWithAlphaComponent(1.0))
                cell.labelEndTime.textColor = (UIColor.whiteColor().colorWithAlphaComponent(0.65))
                
            
                cell.verticalBarView.backgroundColor = UIColor(CGColor: item.calendar.CGColor)
            
            
                let location = item.location
            
            if location != "" {
                
                let string = location
               // let myAttribute = [ NSForegroundColorAttributeName: UIColor.blueColor() ]
                
                let myAttribute = [ NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue ]

                let myAttrString = NSAttributedString(string: string!, attributes: myAttribute)
                
        
                
                cell.labelSecondLine.attributedText = myAttrString
                
        
            }   else {
                cell.labelSecondLine.text = item.calendar.title
            }
            
            cell.labelSecondLine.textColor = UIColor(CGColor: item.calendar.CGColor)

            
            
            
            
            
                
              //  cell.verticalBarView.setBackgroundColor = (UIColor(CGColor: item.calendar.CGColor))
                
              //  cell.verticalBarView.setTintColor = (UIColor(CGColor: item.calendar.CGColor))
                
                // row.imageVertBar.image = [row.imageVertBar imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                
               // row.groupEvent.setBackgroundColor(UIColor(CGColor: item.calendar.CGColor).colorWithAlphaComponent(0.375))
         
            
          //  cell.labelOutput.text = item.title
           // cell.labelStartTime.text = item.title
            
            return cell
            
        }

        
       // cell.labelOutput.text = item.title
       // cell.labelStartTime.text = item.title

       // cell.textLabel?.text = item["title"] as? String
        //cell.textLabel?.textColor = UIColor.whiteColor()
        return cell
    }
    
    
    
    
}
