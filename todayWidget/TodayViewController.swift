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
    
    fileprivate var data: Array<NSDictionary> = Array()
    var attractionNames = [String]()
    
    var output:String           = ""
    var allEvents: Array<EKEvent> = []
    var allEventsToday: Array<EKEvent> = []
    var noEventsString:String   = "Dictate™ 😀 No More Events Today"

    let dateFormatter           = DateFormatter()
    var today:Date            = Date()      //current time
    var now:Date              = Date()
    var timeUntil:String        = ""
    
    var numberOfRows:Int        = 0
    var rowsToDelete:Int        = 0
    
    var deleteRowCountArray: [Int] = []
    var numberRowsToDelete      = 0
    var rowsToShow              = 0
    
    var setRowHeight:CGFloat    = 0
    var endTimeDash             = ""
    
    var defaultLeftInset: CGFloat = 30
    var marginIndicator = UIView()
    
    var timer = Timer()
    let myRowHeightConstant     = 62    //was 62
    let myFooterHeightConstant  = 80 //was 45 80 60
    
    let startDateToday = Calendar.current.startOfDay(for: Date())   //= 12:01 am today
    
    let calendar = Calendar.current
    
    let tomorrow :Date = (Calendar.current as NSCalendar).date(byAdding: NSCalendar.Unit.day, value: 1, to: Date(), options: [])!
    
    let endDateToday = Calendar.current.startOfDay(for: (Calendar.current as NSCalendar).date(byAdding: NSCalendar.Unit.day, value: 1, to: Date(), options: [])!)  //is midnight today
    
    var startDate: Date = Date()
    var endDate: Date = Date()
    
    var eventsLeft:Int = 0
    var eventsDayTotal:Int = 0
    
    
    
    @IBOutlet var labelNoEvents: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var buttonLabelTime: UIButton!
    @IBOutlet weak var buttonTomorrow: UIButton!
    @IBOutlet weak var labelTomorrowDay: UILabel!
    @IBOutlet weak var buttonTodayAll: UIButton!
    @IBOutlet weak var labelCount: UILabel!
    
    @IBAction func buttonActionTime(_ sender: AnyObject) {
        let myAppUrl = URL(string: "Dictate://?MainScreen")!
        extensionContext?.open(myAppUrl, completionHandler: { (success) in
            if (!success) {
                // let the user know it failed
            }
        })
    }
    
    @IBAction func buttonActionIcon(_ sender: AnyObject) {
        let myAppUrl = URL(string: "Dictate://?record")!
        extensionContext?.open(myAppUrl, completionHandler: { (success) in
            if (!success) {
                // let the user know it failed
            }
        })
    }
    
    
    
    @IBAction func buttonTomorrow(_ sender: AnyObject) {
        print("p91 button Clicked")
        print("p91 buttonTomorrow.currentTitle: \(buttonTomorrow.currentTitle)")

        labelTomorrowDay.isHidden = false
        
        if buttonTomorrow.currentTitle == "Tomorrow" {
            
            print("p99 button = Tomorrow")
            
            let tomorrowStartDate :Date = (Calendar.current as NSCalendar).date(byAdding: NSCalendar.Unit.day, value: 1, to: startDateToday, options: [])!
            
            let tomorrowEndDate :Date = (Calendar.current as NSCalendar).date(byAdding: NSCalendar.Unit.day, value: 1, to: endDateToday, options: [])!
            
            print("p97 startDateToday: \(startDateToday)")
            print("p97 tomorrowStartDate: \(tomorrowStartDate)")
            print("p97 endDateToday: \(endDateToday)")
            print("p97 tomorrowEndDate: \(tomorrowEndDate)")
            
            fetchEvents(tomorrowStartDate, endDate: tomorrowEndDate)
            
            buttonTomorrow.setTitle("Today", for: UIControlState())
            buttonTodayAll.setTitle("Today All", for: UIControlState())

            tableView.reloadData()
           
            if rowsToShow != 0 {
                self.preferredContentSize.height = CGFloat((rowsToShow * myRowHeightConstant) + myFooterHeightConstant) // was + 50
            } else {
                self.preferredContentSize.height = CGFloat(myRowHeightConstant + 8 + myFooterHeightConstant)
            }
           
            dateFormatter.dateFormat = "EEEE"    //EEEE = full day name  EEE is 3 letter abbreviation
            
            let eventDay = dateFormatter.string(from: tomorrowStartDate)

            labelTomorrowDay.text = eventDay
            
            if allEvents.count == 0 || rowsToShow == 0  {        //no events for day
                self.preferredContentSize.height = CGFloat(150) //was 125
                self.labelNoEvents.text = "Dictate™ 😀 No Events Tomorrow"
              //  self.labelNoEvents.text = noEventsString
                self.labelNoEvents.isHidden = false
            } else {
                self.labelNoEvents.isHidden = true
            }
            
            eventsLeft = rowsToShow
            eventsDayTotal = allEvents.count
            self.labelCount.text = "\(eventsDayTotal)\n events"
            

        } else {
            fetchEvents(Date(), endDate: endDateToday)  //show today events
            
            tableView.reloadData()
            
            if rowsToShow != 0 {
                self.preferredContentSize.height = CGFloat((rowsToShow * myRowHeightConstant) + myFooterHeightConstant)
            } else {
                self.preferredContentSize.height = CGFloat(myRowHeightConstant + 8 + myFooterHeightConstant)
            }
            
            buttonTomorrow.setTitle("Tomorrow", for: UIControlState())
            labelTomorrowDay.isHidden = true
            
            if allEvents.count == 0 || rowsToShow == 0  {        //no events for day
                self.preferredContentSize.height = CGFloat(125)
               // self.labelNoEvents.text = "Dictate™ 😀 No Events Today"
                
                if allEventsToday.count == 0 {
                    self.labelNoEvents.text = "Dictate™ 😀 No Events Today"
                } else {
                    self.labelNoEvents.text = "Dictate™ 😀 No more Events Today"
                }
                
               self.labelNoEvents.isHidden = false
            } else {
                self.labelNoEvents.isHidden = true
            }
            
            eventsLeft = rowsToShow
            eventsDayTotal = allEventsToday.count
            self.labelCount.text = "\(eventsLeft) of \(eventsDayTotal)\n events"
        }
        
        

        
        
        
    }
    
    
    
    @IBAction func buttonTodayAll(_ sender: AnyObject) {
        print("p148 button Clicked")
        
        labelTomorrowDay.text = ""
        
        if buttonTodayAll.currentTitle == "Today All" {
            print("p154 buttonTodayAll.currentTitle: \(buttonTodayAll.currentTitle)")
            
            let startDate = Calendar.current.startOfDay(for: today)   //= 12:01 am today
            
            let endDate = Calendar.current.startOfDay(for: tomorrow)  //is midnight today
            
            fetchEvents(startDate, endDate: endDate)
            
            tableView.reloadData()
        /*
            if rowsToShow != 0 {
                self.preferredContentSize.height = CGFloat((rowsToShow * myRowHeightConstant) + myFooterHeightConstant)
            } else {
                self.preferredContentSize.height = CGFloat(myRowHeightConstant + 8 + myFooterHeightConstant)
            }
 */
            print("p196 allEventsToday.count: \(allEventsToday.count)")
            print("p196 myRowHeightConstant: \(myRowHeightConstant)")
            print("p196 myFooterHeightConstantt: \(myFooterHeightConstant)")
            
            self.preferredContentSize.height = CGFloat((allEventsToday.count * myRowHeightConstant) + myFooterHeightConstant)
            
            print("p202 preferredContentSize.height: \(self.preferredContentSize.height)")
            print("p202 rowsToShow: \(rowsToShow)")
            print("p202 allEvents.count: \(allEvents.count)")

            buttonTodayAll.setTitle("Today", for: UIControlState())
            buttonTomorrow.setTitle("Tomorrow", for: UIControlState())
            
            if allEvents.count == 0 || rowsToShow == 0  {        //no events for day
                self.preferredContentSize.height = CGFloat(125)
                self.labelNoEvents.text = noEventsString
                self.labelNoEvents.isHidden = false
            } else {
                self.labelNoEvents.isHidden = true
            }
            
            if allEvents.count == 0 || rowsToShow == 0  {        //no events for day
                self.preferredContentSize.height = CGFloat(125)
                
                if allEventsToday.count == 0 {
                    self.labelNoEvents.text = "Dictate™ 😀 No Events Today"
                } else {
                    self.labelNoEvents.text = "Dictate™ 😀 No More Events Today"
                }
      
                self.labelNoEvents.isHidden = false
            } else {
                self.labelNoEvents.isHidden = true
            }
            
            eventsLeft = rowsToShow
            eventsDayTotal = allEventsToday.count
            self.labelCount.text = "\(eventsDayTotal)\n events"
            
        } else {
            fetchEvents(Date(), endDate: endDateToday)  //show today events
            
            tableView.reloadData()
            
            if rowsToShow != 0 {
                self.preferredContentSize.height = CGFloat((rowsToShow * myRowHeightConstant) + myFooterHeightConstant)
            } else {
                self.preferredContentSize.height = CGFloat(myRowHeightConstant + 8 + myFooterHeightConstant)
            }
            
            buttonTodayAll.setTitle("Today All", for: UIControlState())
            labelTomorrowDay.isHidden = true
            
            if allEvents.count == 0 || rowsToShow == 0  {        //no events for day
                self.preferredContentSize.height = CGFloat(125)

                    if allEventsToday.count == 0 {
                        self.labelNoEvents.text = "Dictate™ 😀 No Events Today"
                    } else {
                        self.labelNoEvents.text = "Dictate™ 😀 No More Events Today"
                    }

                self.labelNoEvents.isHidden = false
            } else {
                self.labelNoEvents.isHidden = true
            }
            
            eventsLeft = rowsToShow
            eventsDayTotal = allEventsToday.count
            self.labelCount.text = "\(eventsLeft) of \(eventsDayTotal)\n events"
        }
        
    }
    
    
    func fetchEvents(_ startDate: Date, endDate: Date){
        
        //let startDate = NSCalendar.currentCalendar().startOfDayForDate(today)   //= 12:01 am today
        
        //let calendar = NSCalendar.currentCalendar()
        
       // let tomorrow :NSDate = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: 1, toDate: NSDate(), options: [])!
        
       // let endDate = NSCalendar.currentCalendar().startOfDayForDate(tomorrow)  //is midnight today
        
        print("p39 startDate: \(startDate)")
        print("p40 endDate: \(endDate)")
        EventManager.sharedInstance.fetchEventsFrom(startDate, endDate: endDate, completion: { (events) -> Void in
            self.allEvents = events
            
            if (startDate.timeIntervalSince1970 == self.startDateToday.timeIntervalSince1970) && (endDate.timeIntervalSince1970 == self.endDateToday.timeIntervalSince1970) {       //if called function with dates of all day start and end dates...
                
                print("p239  we here")
                
                self.allEventsToday = events
                print("p242 self.allEventsToday.count: \(self.allEventsToday.count)")
            }
            
        })
        
        //sort events array on startDate
        allEvents.sort(by: {$0.startDate.timeIntervalSince1970 < $1.startDate.timeIntervalSince1970})
        
        print("p130 allEvents.count: \(allEvents.count)")
    }
    
    func minuteUpdates (){
        currentTime ()
        updateTable()
    }
    
    func currentTime () {
        dateFormatter.dateFormat = "h:mm a"
        let timeA = dateFormatter.string(from: Date())
        let timeNow = timeA.replacingOccurrences(of: ":00", with: "")
        buttonLabelTime.setTitle(timeNow, for: UIControlState())
    }
    
    func updateTable () {
        tableView.reloadData()
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
       // table.tableFooterView = UIView(frame: CGRectZero)
        
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        
        currentTime()
        
        //mikeash:  the current time, calculate how many seconds until the top of the next minute, schedule your time for that many seconds
        let datecomponenets = (calendar as NSCalendar).components(NSCalendar.Unit.second, from: Date())
        let secondsToTop:Double =  Double(60 - datecomponenets.second!)    //current seconds in minute 12:00:20 shows 20
        print("p308 secondsToTop: \(secondsToTop)")
        
    
        //http://stackoverflow.com/questions/24034544/dispatch-after-gcd-in-swift/24318861#24318861
        //swift3
      /*  let deadlineTime = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            print("test")
        }
      */
   
        delay(secondsToTop) {
             self.timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(TodayViewController.minuteUpdates), userInfo: nil, repeats: true)
        }
        
       // timer = NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: Selector("minuteUpdates"), userInfo: nil, repeats: true)


        fetchEvents(startDateToday, endDate: endDateToday)  //need all day to get no events text set perfectly.  DO to make all day array for label
        
        fetchEvents(Date(), endDate: endDateToday)

        let numberOfRows = allEvents.count
        
        tableView.reloadData()
        
        print("p310 allEvents.count: \(allEvents.count)")
        print("p310 allEventsToday.count: \(allEventsToday.count)")
        print("p310 numberOfRows: \(numberOfRows)")
        print("p310 rowsToDelete: \(rowsToDelete)")
        print("p310 rowsToShow: \(rowsToShow)")
        
        if rowsToShow != 0 {
            self.preferredContentSize.height = CGFloat((rowsToShow * myRowHeightConstant) + myFooterHeightConstant)
        } else {
            self.preferredContentSize.height = CGFloat(myRowHeightConstant + 8 + myFooterHeightConstant)
        }
        
        tableView.allowsSelectionDuringEditing = false
                
        if allEvents.count == 0 || rowsToShow == 0 {        //no events for day
            
            if buttonTomorrow.currentTitle == "Today" {
                self.labelNoEvents.text = "Dictate™ 😀 No More Events Tomorrow"
            } else {
                
                if allEventsToday.count == 0 {
                     self.labelNoEvents.text = "Dictate™ 😀 No Events Today"
                } else {
                    self.labelNoEvents.text = "Dictate™ 😀 No More Events Today"
                }
            }
            
            self.labelNoEvents.textColor = UIColor.white.withAlphaComponent(0.7)
            self.labelNoEvents.isHidden = false
        } else {
            self.labelNoEvents.isHidden = true
        }
        
        eventsLeft = rowsToShow
        eventsDayTotal = allEventsToday.count
        
        self.labelCount.text = "\(eventsLeft) of \(eventsDayTotal)\n events"
        
    }
  /*
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        timer = NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: Selector("currentTime"), userInfo: nil, repeats: true)
    }
  */

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        marginIndicator.frame = CGRect(x: defaultLeftInset, y: 0, width: 0, height: view.frame.size.height)

        //tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 0.5
        paragraphStyle.alignment = NSTextAlignment.center
        
        eventsLeft = rowsToShow
        eventsDayTotal = allEventsToday.count
        
       //self.labelCount.text = "\(eventsLeft) of \(eventsDayTotal)\n events"
        
        let myString = "\(eventsLeft) of \(eventsDayTotal)\n events"

        
        let attrString = NSMutableAttributedString(string: myString)
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        
        self.labelCount.attributedText = attrString
        
      //  var tableViewCell = NSTableCellView()
       // tableViewCell.textField.attributedStringValue = attrString
        
        
        
        
        currentTime()
        
        let datecomponenets = (calendar as NSCalendar).components(NSCalendar.Unit.second, from: Date())
        let secondsToTop:Double =  Double(60 - datecomponenets.second!)    //current seconds in minute 12:00:20 shows 20
        print("p308 secondsToTop: \(secondsToTop)")
        
        delay(secondsToTop) {
            self.timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(TodayViewController.minuteUpdates), userInfo: nil, repeats: true)
        }
        
      // var timer = NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: Selector("currentTime"), userInfo: nil, repeats: true)
        
        fetchEvents(Date(), endDate: endDateToday)
        //fetchEvents(startDateToday, endDate: endDateToday)  //need all day to get no events text set perfectly.
        
     //   var timer2 = NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: Selector("updateTable"), userInfo: nil, repeats: true)
        
        print("p202 rowsToShow: \(rowsToShow)")
        
        
        
        tableView.reloadData()
        
        if rowsToShow != 0 {
            self.preferredContentSize.height = CGFloat((rowsToShow * myRowHeightConstant) + myFooterHeightConstant)
        } else {
            self.preferredContentSize.height = CGFloat(myRowHeightConstant + 20 + myFooterHeightConstant) // was 8
        }

       // let item = allEvents[0]  
        
        if allEvents.count == 0 || rowsToShow == 0  {        //no events for day
            
            
            
            if buttonTomorrow.currentTitle == "Today" {
                self.labelNoEvents.text = "Dictate™ 😀 No More Events Tomorrow"
            } else {
                
                if allEventsToday.count == 0 {
                    self.labelNoEvents.text = "Dictate™ 😀 No Events Today"
                } else {
                    self.labelNoEvents.text = "Dictate™ 😀 No More Events Today"
                }
            }
/*
            
            if allEventsToday.count > 0 {
                self.labelNoEvents.text = "Dictate™ 😀 No More Events Today"
            } else {
                self.labelNoEvents.text = "Dictate™ 😀 No Events Today"
            }
            
            if buttonTomorrow.currentTitle == "Today" {
                self.labelNoEvents.text = "Dictate™ 😀 No Events Tomorrow"
            } else {
                self.labelNoEvents.text = noEventsString
            }
        */
            self.labelNoEvents.textColor = UIColor.white.withAlphaComponent(0.7)
            self.labelNoEvents.isHidden = false
        } else {
            self.labelNoEvents.isHidden = true
        }
        
        completionHandler(NCUpdateResult.newData)
    }
    
/*
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> (UIEdgeInsets) {
        return UIEdgeInsetsZero
    }
 */
    
    func widgetMarginInsets(forProposedMarginInsets defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        var defaultMarginInsets = defaultMarginInsets
        //let defaultLeftInset = defaultMarginInsets.left
        
        defaultMarginInsets.left = 20
        return defaultMarginInsets
    }


    // MARK: - TableView Data Source
    
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if allEvents.count >= 10 {
            return 10
        } else  {
            return allEvents.count
        }
    }

//===== cellForRowAtIndexPath ================================================
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "tableViewCellIdentifier"
        let cell = tableView.dequeueReusableCell( withIdentifier: identifier, for: indexPath) as! TodayTableViewCell
        
        cell.layoutMargins = UIEdgeInsets.zero
        
        //var item = allEventsToday[indexPath.row]
        let item = allEvents[(indexPath as NSIndexPath).row]

     /*
        if buttonTodayAll.currentTitle == "Today" {
            item = allEventsToday[indexPath.row]
            
        } else {
        
            item = allEvents[indexPath.row]
        }
 */
  /*
        if buttonTodayAll.currentTitle  == "Today All" {
        
            if item.endDate.timeIntervalSince1970 <= NSDate().timeIntervalSince1970 {
                cell.hidden = true
            }
            
        } else {
            cell.hidden = false
        }
        
        if buttonTomorrow.currentTitle  == "Today" {
            cell.hidden = false
        }
        
     */
        
        dateFormatter.dateFormat = "h:mm a"
        
        let startTimeA = dateFormatter.string(from: item.startDate)
        var startTime = startTimeA.replacingOccurrences(of: ":00", with: "")
        
        dateFormatter.dateFormat = "h:mm"
        
        let endTimeA = dateFormatter.string(from: item.endDate)
        let endTime = endTimeA.replacingOccurrences(of: ":00", with: "")
        
        endTimeDash = "- \(endTime)"

        let todayNoon: Date = (Calendar.current as NSCalendar).date(bySettingHour: 12, minute: 0, second: 0, of: Date(), options: NSCalendar.Options())!
        
        // for swift3
        /*
         let newDate: Date = NSCalendar.currentCalendar().date(bySettingHour: 0, minute: 0, second: 0, of: NSDate())!
         */
        
        if (item.startDate.timeIntervalSince1970 < todayNoon.timeIntervalSince1970) && (item.endDate.timeIntervalSince1970 > todayNoon.timeIntervalSince1970) {     //for same event start time am and end time in pm
            
            dateFormatter.dateFormat = "h:mm a"
            
            let endTimeA = dateFormatter.string(from: item.endDate)
            let endTime = endTimeA.replacingOccurrences(of: ":00", with: "")
            
            endTimeDash = "- \(endTime)"
        }
                
        if item.startDate == item.endDate {     //for same start & end time event
            endTimeDash = ""
        }
        
        let todayStart = Calendar.current.startOfDay(for: today)   //= 12:01 am today
            
        if item.startDate.timeIntervalSince1970 <= todayStart.timeIntervalSince1970 {
            dateFormatter.dateFormat = "EEEE"    //EEEE = full day name  EEE is 3 letter abbreviation
            let eventDay = dateFormatter.string(from: item.startDate)
            startTime = eventDay
            
            dateFormatter.dateFormat = "h:mm a"
            let endTimeA = dateFormatter.string(from: item.endDate)
            let endTime = endTimeA.replacingOccurrences(of: ":00", with: "")
            endTimeDash = "- \(endTime)"
        }
        
        if buttonTomorrow.currentTitle == "Today" {
            
            print("p434 rowsToShow: \(rowsToShow)")
            
            dateFormatter.dateFormat = "h:mm"
            
            let endTimeA = dateFormatter.string(from: item.endDate)
            let endTime = endTimeA.replacingOccurrences(of: ":00", with: "")
            
            endTimeDash = "- \(endTime)"
            
            if item.startDate.timeIntervalSince1970 <= todayStart.timeIntervalSince1970 {
                dateFormatter.dateFormat = "EEEE"    //EEEE = full day name  EEE is 3 letter abbreviation
                let eventDay = dateFormatter.string(from: item.startDate)
                startTime = eventDay
                
                dateFormatter.dateFormat = "h:mm a"
                let endTimeA = dateFormatter.string(from: item.endDate)
                let endTime = endTimeA.replacingOccurrences(of: ":00", with: "")
                endTimeDash = "- \(endTime)"
            }
        }
        
        let todayEnd = Calendar.current.startOfDay(for: tomorrow)  //is midnight today
        
        if (item.endDate.timeIntervalSince1970 > todayEnd.timeIntervalSince1970) && (buttonTomorrow.currentTitle == "Tomorrow") {
            dateFormatter.dateFormat = "EEE"    //EEEE = full day name  EEE is 3 letter abbreviation
            let eventDay = dateFormatter.string(from: item.endDate)
            let endTime = eventDay
            endTimeDash = "- \(endTime)"
        }
        
        timeUntil = TimeManger.sharedInstance.timeInterval(item.startDate)
        
        if item.isAllDay {     // if allDay bool is true
            startTime = "all-day"
            endTimeDash = ""
            timeUntil = "all-Day"
        }

        let startTimeItem = item.startDate
        let timeUntilStart = startTimeItem.timeIntervalSince(Date())
    
        let endTimeItem = item.endDate
        let timeUntilEnd = endTimeItem.timeIntervalSince(Date())
        
        print("p600 timeUntilStart: \(timeUntilStart)")
        print("p600 timeUntilEnd: \(timeUntilEnd)")

        
        
    
        if ((timeUntilStart <= 0) && (timeUntilEnd >= 0)) {     //Time is Now
            // works
            let headlineFont =
                UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
            let fontAttribute = [NSFontAttributeName: headlineFont]
            let attributedString = NSAttributedString(string: "Now" + " 😀",
                                                      attributes: fontAttribute)
            cell.labelTimeUntil.attributedText = attributedString
            cell.labelTimeUntil.textColor = UIColor.yellow
            
            if item.isAllDay {     // if allDay bool is true
                print("p205 we here item.allDay: \(item.isAllDay)")
                cell.labelTimeUntil.text = ""
            }
            print("p608 we here? cell.constraintTimeUntilTop.constant: \(cell.constraintTimeUntilTop.constant)")
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
        cell.labelOutput.textColor      = UIColor.white
        cell.labelStartTime.textColor   = UIColor.white.withAlphaComponent(1.0)
        cell.labelEndTime.textColor     = UIColor.white.withAlphaComponent(0.5)
        cell.verticalBarView.backgroundColor = UIColor(cgColor: item.calendar.cgColor)
    
        let location = item.location
        
        if location != "" {     //Show location if there, esle show calendar name :)
            cell.labelSecondLine.font = UIFont.italicSystemFont(ofSize: cell.labelSecondLine.font.pointSize)
            cell.labelSecondLine.text = location
            cell.labelSecondLine.textColor = UIColor.white.withAlphaComponent(0.5)
        } else {
            cell.labelSecondLine.text = item.calendar.title
            cell.labelSecondLine.textColor = UIColor(cgColor: item.calendar.cgColor)
        }
        
        
        if buttonTodayAll.currentTitle == "Today" {
            if (item.endDate.timeIntervalSince1970 < Date().timeIntervalSince1970){
                cell.labelTimeUntil.text            = ""
                cell.labelOutput.textColor          = UIColor.white.withAlphaComponent(0.5)
                endTimeDash                         = ""
                cell.verticalBarView.backgroundColor = UIColor(cgColor: item.calendar.cgColor).withAlphaComponent(0.5)
                cell.labelStartTime.textColor       = UIColor.white.withAlphaComponent(0.65)
                cell.labelEndTime.textColor         = UIColor.white.withAlphaComponent(0.5)
                cell.labelSecondLine.textColor      = UIColor.white.withAlphaComponent(0.5)
                self.labelNoEvents.isHidden = true
            }
        }

        return cell
    }                   // end func cellForRowAtIndexPath
    
//===== end cellForRowAtIndexPath ================================================
    
//===== heightForRowAtIndexPath ================================================
 
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat
    {
        let item = allEvents[(indexPath as NSIndexPath).row]
        
        print("p267 we here? \(item.title)")
   
        if buttonTodayAll.currentTitle == "Today All" {

            if item.endDate.timeIntervalSince1970 <= Date().timeIntervalSince1970 {
                
                print("p239 we here? have row to hide/delete")
                
                deleteRowCountArray.append((indexPath as NSIndexPath).row)
                
                let uniqueRowArray = Array(Set(deleteRowCountArray))    //removes duplicates
                
                numberRowsToDelete = uniqueRowArray.count
                print("p244 numberRowsToDelete: \(numberRowsToDelete)")
                
                rowsToShow = allEvents.count - numberRowsToDelete
                print("p247 rowsToShow: \(rowsToShow)")
               
                setRowHeight = 0
            } else {
                //return 50     //Choose your custom row height
                print("p588 we here? \(item.title)")
                
                setRowHeight = 55
                
                rowsToShow = allEvents.count
                numberRowsToDelete = 0
            }
            
        } else {
            
            setRowHeight = 55
        }
    
        rowsToShow = allEvents.count - numberRowsToDelete
        print("p708 rowsToShow: \(rowsToShow)")
        
        if allEvents.count == 0 {  // TODO Mike Anil does not work!
            //set row height for the No Events today Label
            print("p303 we here? allEvents.count: \(allEvents.count)")
            setRowHeight = 50
        }
        
        setRowHeight = 55
        print("p309 setRowHeight: \(setRowHeight)")
        
        print("p721 buttonTodayAll.currentTitle: \(buttonTodayAll.currentTitle)")

        if buttonTodayAll.currentTitle == "Today All" {
            print("p724 we in here?")
            //rowsToShow = allEventsToday.count
            rowsToShow = allEvents.count
            print("p725 rowsToShow: \(rowsToShow)")

        }
        
        
        
        
        return setRowHeight
    }
 

//===== endheightForRowAtIndexPath ================================================
    
//===== didSelectRowAtIndexPath ================================================
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        print("p328 You selected row/event # \((indexPath as NSIndexPath).row)")
        
       // var selectedCell:UITableViewCell = table.cellForRowAtIndexPath(indexPath)!
        
        let item = allEvents[(indexPath as NSIndexPath).row]
        let eventID = item.eventIdentifier
        print("p334 eventID \(eventID)")

        
        // from here:
        // http://iosdevelopertips.com/cocoa/launching-your-own-application-via-a-custom-url-scheme.html
       // let myAppUrl = NSURL(string: "Dictate://some-context")!
        let myAppUrl = URL(string: "Dictate://?eventID=\(eventID)")!
        
       // var myAppUrl = NSURL(string: "Dictate://some-context")!

        
       // myapp://name=BrunoMars&gender=Male&age=26&occupation=Singer
        
        extensionContext?.open(myAppUrl, completionHandler: { (success) in
            if (!success) {
                // let the user know it failed
            }
        })
        
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 0)) //was 40
        //headerView.backgroundColor = UIColor.yellowColor()
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 0)) //was 40
       // footerView.backgroundColor = UIColor.yellowColor()
        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
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
