//
//  TodayViewController.swift
//  todayWidget
//
//  Created by Mike Derr on 8/31/16.
//  Copyright © 2016 ThatSoft.com. All rights reserved.
//
//  https://github.com/maximbilan/iOS-Today-Extension-Simple-Tutorial
//
//  passing to app via url from here...
//  http://iosdevelopertips.com/cocoa/launching-your-own-application-via-a-custom-url-scheme.html
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
    
    var deleteRowCountArray: [Int] = []
    var numberRowsToDelete = 0
    var rowsToShow = 0
    
    var setRowHeight:CGFloat = 0
    var endTimeDash = ""
    
    var defaultLeftInset: CGFloat = 30
    var marginIndicator = UIView()
    
    var timer = NSTimer()
    let myRowHeightConstant = 62    //was 62
    let myFooterHeightConstant = 70 //was 45 80 60
    
    let startDateToday = NSCalendar.currentCalendar().startOfDayForDate(NSDate())   //= 12:01 am today
    
    let calendar = NSCalendar.currentCalendar()
    
    let tomorrow :NSDate = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: 1, toDate: NSDate(), options: [])!
    
    let endDateToday = NSCalendar.currentCalendar().startOfDayForDate(NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: 1, toDate: NSDate(), options: [])!)  //is midnight today
    
    var startDate: NSDate = NSDate()
    var endDate: NSDate = NSDate()
    
    
   // let calendar = NSCalendar.currentCalendar()
    
    
    @IBOutlet var labelNoEvents: UILabel!
    
    @IBOutlet var tableView: UITableView!

    @IBOutlet weak var buttonLabelTime: UIButton!
    
    @IBOutlet weak var buttonTomorrow: UIButton!
    
    @IBOutlet weak var labelTomorrowDay: UILabel!
    @IBOutlet weak var buttonTodayAll: UIButton!
    
    
    @IBAction func buttonActionTime(sender: AnyObject) {
        let myAppUrl = NSURL(string: "Dictate://?MainScreen")!
        extensionContext?.openURL(myAppUrl, completionHandler: { (success) in
            if (!success) {
                // let the user know it failed
            }
        })
    }
    
    @IBAction func buttonActionIcon(sender: AnyObject) {
        let myAppUrl = NSURL(string: "Dictate://?record")!
        extensionContext?.openURL(myAppUrl, completionHandler: { (success) in
            if (!success) {
                // let the user know it failed
            }
        })
    }
    
    
    
    @IBAction func buttonTomorrow(sender: AnyObject) {
        print("p91 button Clicked")
        print("p91 buttonTomorrow.currentTitle: \(buttonTomorrow.currentTitle)")

        
        labelTomorrowDay.hidden = false
        
        if buttonTomorrow.currentTitle == "Tomorrow" {
            
            let tomorrowStartDate :NSDate = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: 1, toDate: startDateToday, options: [])!
            
            let tomorrowEndDate :NSDate = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: 1, toDate: endDateToday, options: [])!
            
            print("p97 startDateToday: \(startDateToday)")
            print("p97 tomorrowStartDate: \(tomorrowStartDate)")
            print("p97 endDateToday: \(endDateToday)")
            print("p97 tomorrowEndDate: \(tomorrowEndDate)")
            
            fetchEvents(tomorrowStartDate, endDate: tomorrowEndDate)
            
            buttonTomorrow.setTitle("Today", forState: UIControlState.Normal)
            
            tableView.reloadData()
           
            if rowsToShow != 0 {
                self.preferredContentSize.height = CGFloat((rowsToShow * myRowHeightConstant) + myFooterHeightConstant + 50)
            } else {
                self.preferredContentSize.height = CGFloat(myRowHeightConstant + 8 + myFooterHeightConstant)
            }
           
            
            dateFormatter.dateFormat = "EEEE"    //EEEE = full day name  EEE is 3 letter abbreviation
            
            let eventDay = dateFormatter.stringFromDate(tomorrowStartDate)

            labelTomorrowDay.text = eventDay

        } else {
            fetchEvents(NSDate(), endDate: endDateToday)  //show today events
            
            tableView.reloadData()
            
            if rowsToShow != 0 {
                self.preferredContentSize.height = CGFloat((rowsToShow * myRowHeightConstant) + myFooterHeightConstant)
            } else {
                self.preferredContentSize.height = CGFloat(myRowHeightConstant + 8 + myFooterHeightConstant)
            }
            
            buttonTomorrow.setTitle("Tomorrow", forState: UIControlState.Normal)
            labelTomorrowDay.hidden = true
        }
    }
    
    
    
    @IBAction func buttonTodayAll(sender: AnyObject) {
        print("p148 button Clicked")
        
        if buttonTodayAll.currentTitle == "Today All" {
            print("p154 buttonTodayAll.currentTitle: \(buttonTodayAll.currentTitle)")
            
            let startDate = NSCalendar.currentCalendar().startOfDayForDate(today)   //= 12:01 am today
            
            let endDate = NSCalendar.currentCalendar().startOfDayForDate(tomorrow)  //is midnight today
            
            fetchEvents(startDate, endDate: endDate)
            
            tableView.reloadData()
          
            if rowsToShow != 0 {
                self.preferredContentSize.height = CGFloat((rowsToShow * myRowHeightConstant) + myFooterHeightConstant + 220)
            } else {
                self.preferredContentSize.height = CGFloat(myRowHeightConstant + 8 + myFooterHeightConstant)
            }

            buttonTodayAll.setTitle("Today", forState: UIControlState.Normal)

        
            
        } else {
            fetchEvents(NSDate(), endDate: endDateToday)  //show today events
            
            tableView.reloadData()
            
            if rowsToShow != 0 {
                self.preferredContentSize.height = CGFloat((rowsToShow * myRowHeightConstant) + myFooterHeightConstant)
            } else {
                self.preferredContentSize.height = CGFloat(myRowHeightConstant + 8 + myFooterHeightConstant)
            }
            
            buttonTodayAll.setTitle("Today All", forState: UIControlState.Normal)
            labelTomorrowDay.hidden = true
        }
    }
    
    
    func fetchEvents(startDate: NSDate, endDate: NSDate){
        
        //let startDate = NSCalendar.currentCalendar().startOfDayForDate(today)   //= 12:01 am today
        
        //let calendar = NSCalendar.currentCalendar()
        
       // let tomorrow :NSDate = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: 1, toDate: NSDate(), options: [])!
        
       // let endDate = NSCalendar.currentCalendar().startOfDayForDate(tomorrow)  //is midnight today
        
        print("p39 startDate: \(startDate)")
        print("p40 endDate: \(endDate)")
        EventManager.sharedInstance.fetchEventsFrom(startDate, endDate: endDate, completion: { (events) -> Void in
            self.allEvents = events
        })
        
        //sort events array on startDate
        allEvents.sortInPlace({$0.startDate.timeIntervalSince1970 < $1.startDate.timeIntervalSince1970})
        
        print("p130 allEvents.count: \(allEvents.count)")
    }
    
    func currentTime () {
        dateFormatter.dateFormat = "h:mm a"
        let timeA = dateFormatter.stringFromDate(NSDate())
        let timeNow = timeA.stringByReplacingOccurrencesOfString(":00", withString: "")
        buttonLabelTime.setTitle(timeNow, forState: UIControlState.Normal)
    }
    
    func updateTable () {
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
       // table.tableFooterView = UIView(frame: CGRectZero)
        
        tableView.layoutMargins = UIEdgeInsetsZero
        tableView.separatorInset = UIEdgeInsetsZero
        
        currentTime()
        
        timer = NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: Selector("currentTime"), userInfo: nil, repeats: true)
        
         var timer2 = NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: Selector("updateTable"), userInfo: nil, repeats: true)

        //fetchEvents(startDateToday, endDate: endDateToday)
        fetchEvents(NSDate(), endDate: endDateToday)

        
        tableView.reloadData()
        
        if rowsToShow != 0 {
            self.preferredContentSize.height = CGFloat((rowsToShow * myRowHeightConstant) + myFooterHeightConstant)
        } else {
            self.preferredContentSize.height = CGFloat(myRowHeightConstant + 8 + myFooterHeightConstant)
        }

        
        var numberOfRows = allEvents.count
        
        print("p67 rowsToDelete: \(rowsToDelete)")
        print("p77 rowsToShow: \(rowsToShow)")
        print("p79 allEvents.count: \(allEvents.count)")
        
        //self.preferredContentSize.height = 100

        
        //self.preferredContentSize.height = CGFloat(allEvents.count * 50)

        //self.preferredContentSize.height = CGFloat(rowsToShow * 30)
        
        //self.preferredContentSize.height = CGFloat(numberOfRows * 50)
        
       // self.preferredContentSize.height = 200
        
        
      //  tableView.rowHeight = UITableViewAutomaticDimension
       // tableView.estimatedRowHeight = 140
        
        // tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        // tableView.tableFooterView = UIView(frame: CGRectZero)
        
        tableView.reloadData()
        
        tableView.allowsSelectionDuringEditing = false
                
        if allEvents.count == 0 || rowsToShow == 0 {        //no events for day
            self.labelNoEvents.text = "Dictate™ 😀 No More Events Today"
            self.labelNoEvents.textColor = UIColor.whiteColor().colorWithAlphaComponent(0.7)
            self.labelNoEvents.hidden = false
        } else {
            self.labelNoEvents.hidden = true
        }   
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        timer = NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: Selector("currentTime"), userInfo: nil, repeats: true)
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
        
        marginIndicator.frame = CGRectMake(defaultLeftInset, 0, 0, view.frame.size.height)

        //tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        currentTime()
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: Selector("currentTime"), userInfo: nil, repeats: true)
        
        fetchEvents(NSDate(), endDate: endDateToday)
        
        var timer2 = NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: Selector("updateTable"), userInfo: nil, repeats: true)
        
        print("p202 rowsToShow: \(rowsToShow)")
        
        if rowsToShow != 0 {
            self.preferredContentSize.height = CGFloat((rowsToShow * myRowHeightConstant) + myFooterHeightConstant)
        } else {
            self.preferredContentSize.height = CGFloat(myRowHeightConstant + 8 + myFooterHeightConstant)
        }
        tableView.reloadData()

       // let item = allEvents[0]  
        
        if allEvents.count == 0 || rowsToShow == 0  {        //no events for day
            self.preferredContentSize.height = CGFloat(100)

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
        //let defaultLeftInset = defaultMarginInsets.left
        
        defaultMarginInsets.left = 20
        return defaultMarginInsets
    }


    // MARK: - TableView Data Source
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if allEvents.count >= 10 {
            return 10
        } else  {
            return allEvents.count
        }
    }

//===== cellForRowAtIndexPath ================================================
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier = "tableViewCellIdentifier"
        let cell = tableView.dequeueReusableCellWithIdentifier( identifier, forIndexPath: indexPath) as! TodayTableViewCell
        
        cell.layoutMargins = UIEdgeInsetsZero
        
       let item = allEvents[indexPath.row]
        
        if buttonTodayAll == "Today All" {
        
            if item.endDate.timeIntervalSince1970 <= NSDate().timeIntervalSince1970 {
                cell.hidden = true
              //  cell.rowHeight = 0
               // return cell
            }
            
        } else {
            cell.hidden = false
            //  cell.rowHeight = 0
            //return cell
            
        }
        
        dateFormatter.dateFormat = "h:mm a"
        
        let startTimeA = dateFormatter.stringFromDate(item.startDate)
        var startTime = startTimeA.stringByReplacingOccurrencesOfString(":00", withString: "")
        
        dateFormatter.dateFormat = "h:mm"
        
        let endTimeA = dateFormatter.stringFromDate(item.endDate)
        let endTime = endTimeA.stringByReplacingOccurrencesOfString(":00", withString: "")
        
        endTimeDash = "- \(endTime)"

        let todayNoon: NSDate = NSCalendar.currentCalendar().dateBySettingHour(12, minute: 0, second: 0, ofDate: NSDate(), options: NSCalendarOptions())!
        
        // for swift3
        /*
         let newDate: Date = NSCalendar.currentCalendar().date(bySettingHour: 0, minute: 0, second: 0, of: NSDate())!
         */
        
        if (item.startDate.timeIntervalSince1970 < todayNoon.timeIntervalSince1970) && (item.endDate.timeIntervalSince1970 > todayNoon.timeIntervalSince1970) {     //for same event start time am and end time in pm
            
            dateFormatter.dateFormat = "h:mm a"
            
            let endTimeA = dateFormatter.stringFromDate(item.endDate)
            let endTime = endTimeA.stringByReplacingOccurrencesOfString(":00", withString: "")
            
            endTimeDash = "- \(endTime)"
        }
        
        
        if item.startDate == item.endDate {     //for same start & end time event
            endTimeDash = ""
        }
        
        let todayStart = NSCalendar.currentCalendar().startOfDayForDate(today)   //= 12:01 am today
            
        if item.startDate.timeIntervalSince1970 <= todayStart.timeIntervalSince1970 {
            dateFormatter.dateFormat = "EEEE"    //EEEE = full day name  EEE is 3 letter abbreviation
            let eventDay = dateFormatter.stringFromDate(item.startDate)
            startTime = eventDay
            
            dateFormatter.dateFormat = "h:mm a"
            let endTimeA = dateFormatter.stringFromDate(item.endDate)
            let endTime = endTimeA.stringByReplacingOccurrencesOfString(":00", withString: "")
            endTimeDash = "- \(endTime)"
        }
        
        if buttonTomorrow.currentTitle == "Today" {
            
            print("p434 rowsToShow: \(rowsToShow)")
            
            dateFormatter.dateFormat = "h:mm"
            
            let endTimeA = dateFormatter.stringFromDate(item.endDate)
            let endTime = endTimeA.stringByReplacingOccurrencesOfString(":00", withString: "")
            
            endTimeDash = "- \(endTime)"
            
            if item.startDate.timeIntervalSince1970 <= todayStart.timeIntervalSince1970 {
                dateFormatter.dateFormat = "EEEE"    //EEEE = full day name  EEE is 3 letter abbreviation
                let eventDay = dateFormatter.stringFromDate(item.startDate)
                startTime = eventDay
                
                dateFormatter.dateFormat = "h:mm a"
                let endTimeA = dateFormatter.stringFromDate(item.endDate)
                let endTime = endTimeA.stringByReplacingOccurrencesOfString(":00", withString: "")
                endTimeDash = "- \(endTime)"
            }
        }
        
        let todayEnd = NSCalendar.currentCalendar().startOfDayForDate(tomorrow)  //is midnight today
        
        if (item.endDate.timeIntervalSince1970 > todayEnd.timeIntervalSince1970) && (buttonTomorrow.currentTitle == "Tomorrow") {
            dateFormatter.dateFormat = "EEE"    //EEEE = full day name  EEE is 3 letter abbreviation
            let eventDay = dateFormatter.stringFromDate(item.endDate)
            let endTime = eventDay
            endTimeDash = "- \(endTime)"
        }
        
        timeUntil = TimeManger.sharedInstance.timeInterval(item.startDate)
        
        if item.allDay {     // if allDay bool is true
            startTime = "all-day"
            endTimeDash = ""
            timeUntil = "all-Day"
        }

        let startTimeItem = item.startDate
        let timeUntilStart = startTimeItem.timeIntervalSinceDate(NSDate())
    
        let endTimeItem = item.endDate
        let timeUntilEnd = endTimeItem.timeIntervalSinceDate(NSDate())
    
        if ((timeUntilStart <= 0) && (timeUntilEnd >= 0)) {     //Time is Now
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
            print("p312 we here? cell.constraintTimeUntilTop.constant: \(cell.constraintTimeUntilTop.constant)")
            cell.constraintTimeUntilTop.constant = -4    //move up a bit to accomindate the emoji
            print("p314 we here? cell.constraintTimeUntilTop.constant: \(cell.constraintTimeUntilTop.constant)")
            
            if buttonTomorrow.currentTitle == "Today" {
                cell.labelTimeUntil.text = ""
                
            }
            
        } else {
            cell.labelTimeUntil.text = timeUntil
            cell.constraintTimeUntilTop.constant = 1
        }
        

        print("p227 timeUntil: \(timeUntil)")
        
        cell.labelOutput.text           = item.title
        cell.labelStartTime.text        = startTime
        cell.labelEndTime.text          = endTimeDash
        //cell.labelOutput.textColor    = UIColor(CGColor: item.calendar.CGColor)
        cell.labelOutput.textColor      = UIColor.whiteColor()
        cell.labelStartTime.textColor   = UIColor.whiteColor().colorWithAlphaComponent(1.0)
        cell.labelEndTime.textColor     = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        cell.verticalBarView.backgroundColor = UIColor(CGColor: item.calendar.CGColor)
    
        let location = item.location
        
        if location != "" {     //Show location if there, esle show calendar name :)
            cell.labelSecondLine.font = UIFont.italicSystemFontOfSize(cell.labelSecondLine.font.pointSize)
            cell.labelSecondLine.text = location
            cell.labelSecondLine.textColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        } else {
            cell.labelSecondLine.text = item.calendar.title
            cell.labelSecondLine.textColor = UIColor(CGColor: item.calendar.CGColor)
        }
        
        
        if buttonTodayAll.currentTitle == "Today" {
            
            if (item.endDate.timeIntervalSince1970 < NSDate().timeIntervalSince1970){
                cell.labelTimeUntil.text = ""
                cell.labelOutput.textColor      = UIColor.whiteColor().colorWithAlphaComponent(0.5)
                endTimeDash = ""
                cell.verticalBarView.backgroundColor = UIColor(CGColor: item.calendar.CGColor).colorWithAlphaComponent(0.5)
                cell.labelStartTime.textColor      = UIColor.whiteColor().colorWithAlphaComponent(0.75)
                cell.labelEndTime.textColor      = UIColor.whiteColor().colorWithAlphaComponent(0.5)
                cell.labelSecondLine.textColor      = UIColor.whiteColor().colorWithAlphaComponent(0.5)
            }
        }

        return cell
    }                   // end func cellForRowAtIndexPath
    
//===== end cellForRowAtIndexPath ================================================
    
//===== heightForRowAtIndexPath ================================================
 
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        let item = allEvents[indexPath.row]
        
        print("p267 we here? \(item.title)")
        
        if buttonTodayAll == "Today All" {

            if item.endDate.timeIntervalSince1970 <= NSDate().timeIntervalSince1970 {
                
                print("p239 we here? have row to hide/delete")
                
                deleteRowCountArray.append(indexPath.row)
                
                let uniqueRowArray = Array(Set(deleteRowCountArray))    //removes duplicates
                
                numberRowsToDelete = uniqueRowArray.count
                print("p244 numberRowsToDelete: \(numberRowsToDelete)")
                
                rowsToShow = allEvents.count - numberRowsToDelete
                print("p247 rowsToShow: \(rowsToShow)")
               
                setRowHeight = 0
            } else {
                //return 50     //Choose your custom row height
                print("p588 we here? \(item.title)")
                
                rowsToShow = allEvents.count
                numberRowsToDelete = 0
            }
            
        } else {
            
            setRowHeight = 55
        }
        
        rowsToShow = allEvents.count - numberRowsToDelete
        print("p312 rowsToShow: \(rowsToShow)")
        
        if allEvents.count == 0 {  // TODO Mike Anil does not work!
            //set row height for the No Events today Label
            print("p303 we here? allEvents.count: \(allEvents.count)")
            setRowHeight = 50
        }
        print("p309 setRowHeight: \(setRowHeight)")
        
        return setRowHeight
    }
 

//===== endheightForRowAtIndexPath ================================================
    
//===== didSelectRowAtIndexPath ================================================
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("p328 You selected row/event # \(indexPath.row)")
        
       // var selectedCell:UITableViewCell = table.cellForRowAtIndexPath(indexPath)!
        
        let item = allEvents[indexPath.row]
        let eventID = item.eventIdentifier
        print("p334 eventID \(eventID)")

        
        // from here:
        // http://iosdevelopertips.com/cocoa/launching-your-own-application-via-a-custom-url-scheme.html
       // let myAppUrl = NSURL(string: "Dictate://some-context")!
        let myAppUrl = NSURL(string: "Dictate://?eventID=\(eventID)")!
        
       // var myAppUrl = NSURL(string: "Dictate://some-context")!

        
       // myapp://name=BrunoMars&gender=Male&age=26&occupation=Singer
        
        extensionContext?.openURL(myAppUrl, completionHandler: { (success) in
            if (!success) {
                // let the user know it failed
            }
        })
        
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 0)) //was 40
        //headerView.backgroundColor = UIColor.yellowColor()
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }

    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 0)) //was 40
       // footerView.backgroundColor = UIColor.yellowColor()
        
        return footerView
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        var footerHeight:CGFloat = 10.0

        if allEvents.count == 0 || rowsToShow == 0 {        //no events for day
           footerHeight = 50.0
            
            self.preferredContentSize.height = CGFloat(100)
        }
        
       // tableView.tableFooterView?.hidden = true
         return footerHeight //was 40
    }
    
    
    
 /*
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let item = items?[indexPath.row] {
            if let context = extensionContext {
                context.openURL(item.link, completionHandler: nil)
            }
        }
    }
*/
 /*
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return expandButton
    }
    
    // MARK: expand
    
    func updateExpandButtonTitle() {
        expandButton.setTitle(expanded ? "Show less" : "Show more", forState: .Normal)
    }
    
    func toggleExpand() {
        expanded = !expanded
        updateExpandButtonTitle()
        updatePreferredContentSize()
        tableView.reloadData()
    }
*/

 
}
