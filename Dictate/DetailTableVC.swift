//
//  DetailTableVC.swift
//  Dictate
//
//  Created by Mike Derr on 1/31/16.
//  Copyright © 2016 ThatSoft.com. All rights reserved.
//

import UIKit
import EventKit
import AVFoundation
import EventKitUI

class DetailTableVC: UIViewController {
    
    @IBOutlet weak var tableV: UITableView!
   // @IBOutlet weak var label: UILabel!
   // @IBOutlet weak var data: UILabel!
    
    @IBOutlet weak var tableViewOutlet: UITableView!
   
    @IBOutlet weak var buttonCreateOutlet: UIButton!
    @IBOutlet weak var resultMessage: UITextView!
    
     @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
        
    var eventRepeat = ""
    var actionType = ""
    var strRaw = ""
    var alertString = ""
    var output = ""
    var messageString = ""
 
    var results = ["temp", "temp", "temp", "temp", "temp", "temp", "temp", "temp", "temp", "temp", "temp"]
    var labels = ["Input", "Type", "Day","Time", "Cell#", "Start", "End", "Title", "Cal.", "Alert", "Repeat"]

    var labelInput = "Input"
    var labelType = "Type"
    var labelDay = "Day"
    var labelTime = "Time"
    var labelCell = "Cell#"
    var labelStart = "Start"
    var labelEnd = "End"
    var labelTitle = "Title"
    var labelCal = "Cal."
    var labelAlert = "Alert"
    var labelRepeat = "Repeat"
    
    let defaults = NSUserDefaults(suiteName: "group.com.thatsoft.dictateApp")!
    var audioPlayer = AVAudioPlayer()
    
    var wordArrTrimmed  = NSUserDefaults(suiteName: "group.com.thatsoft.dictateApp")!.objectForKey("wordArrTrimmed") as? [String] ?? [] //array of the items
    
    let lightPink = UIColor(red: 255, green: 204, blue: 255)
    let swiftColor = UIColor(red: 255, green: 165, blue: 0)
    let moccasin = UIColor(red: 255, green: 228, blue: 181)     //light biege color, for Word List
    let apricot = UIColor(red: 251, green: 206, blue: 177)     //light biege color, for Phrase List
    
    var deleteRowCountArray: [Int] = []
    var numberRowsToDelete = 0
    var rowsToShow = 0
    var titleFrameHeight = 0
    var additionalRows = 0


//#### my functions #################################
    
    
    func switchScreen(scene: String) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier(scene)
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func displayAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    
    func createReminder() {
        
        //Don't need to parse again? commented out 7/4/15 8 am
        //let (startDT, endDT, output, outputNote, day, calendarName) = DictateCode().parse(str)
        
        let title:String = output
        let notes:String = outputNote
        
        //try getting alues in the func ReminderCode().createReminder(title, notes: notes, startDT: startDT)
        
        ReminderCode().createReminder()
    }
    
    
    func playSound(sound: NSURL){
        var error:NSError?
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL: sound)
        } catch var error1 as NSError {
            error = error1
        }
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    
    func handleSwipes(sender:UISwipeGestureRecognizer) {
        if (sender.direction == .Left) {
            self.tabBarController?.selectedIndex = 2
        }
        if (sender.direction == .Right) {
            self.tabBarController?.selectedIndex = 0
        }
    }
    
    // below: http://stackoverflow.com/questions/27369777/self-sizing-cell-in-swift-how-do-i-make-constraints-programmatically
    
    func dynamicHeight(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
        
    }
    
    
    
    
    
    
    
// TABLE funcs...
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        //return 11
        // 11 fields (rows) total!
        return results.count
    }


    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
       // print("p149 deleteRowCountArray: \(deleteRowCountArray)")
        //print("p153 results: \(results)")
        //print("p154 results[indexPath.row]: \(results[indexPath.row])")

        if (results[indexPath.row] == "" || results[indexPath.row] == "0")  {
           // print("p148 we here hide rows: \(indexPath.row)")
            
            deleteRowCountArray.append(indexPath.row)
            
            //print("p152 deleteRowCountArray: \(deleteRowCountArray)")
            
            let uniqueRowArray = Array(Set(deleteRowCountArray))    //removes duplicates
            
            //print("p162 uniqueRowArray: \(uniqueRowArray)")
            //print("p173 uniqueRowArray.count: \(uniqueRowArray.count)")
            
            numberRowsToDelete = uniqueRowArray.count
            
            //print("p158 numberRowsToDelete: \(numberRowsToDelete)")
            
            rowsToShow = 11 - numberRowsToDelete    //11 is maximun fields same as results.count
      
            return 0
        
        } else if (labels[indexPath.row] == "Title") {
            
            print("p170 we here: \(results[indexPath.row])")
            // http://stackoverflow.com/questions/27369777/self-sizing-cell-in-swift-how-do-i-make-constraints-programmatically
            
            
        //    dynamicHeight(results[indexPath.row], UIFont.systemFontSize(), 262)
            
           // titleFrameHeight = 70
            
            additionalRows = 1      // varr for additional rows to add to table height
        
        
            return 70

    

        }
        
        return 35
    }   // end func heightForRowAtIndexPath
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier( "BasicCell", forIndexPath: indexPath) as! DetailsTableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.Default //TODO tried to set sleection color to yellow
        cell.label.text = labels[indexPath.row]
        
        cell.resultsTextField.text = results[indexPath.row]
        cell.resultsTextField.layer.cornerRadius = 7
      //  cell.resultsTextField.textColor = UIColor.blueColor()
       // cell.resultsTextField.textAlignment = .Center
       // cell.resultsTextField. = .Center


        
        
        
        if labels[indexPath.row] == "Input" || labels[indexPath.row] == "Start" || labels[indexPath.row] == "End" || labels[indexPath.row] == "Title" || labels[indexPath.row] == "Cal." || labels[indexPath.row] == "Alert" || labels[indexPath.row] == "List"  {
            
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            
            //cell.accessoryView = PZDisclosureIndicator(color: UIColor.yellowColor())
            
        } else {
            cell.accessoryType = .None
        }
        
        if labels[indexPath.row] == "Title" {
            
          /*
         //   let contentSize = cell.resultsTextField.sizeThatFits(cell.resultsTextField.bounds.size)
            
            var frame = cell.resultsTextField.frame
            frame.size.height = contentSize.height
            
            print("p208 frame.size.height: \(frame.size.height)!")
            print("p208 frame \(frame)!")

            cell.resultsTextField.frame = frame
            
       */
        /*
            let contentSize = cell.resultsTextField.sizeThatFits(cell.resultsTextField.bounds.size)
            var frame = cell.resultsTextField.frame
            frame.size.height = contentSize.height
            cell.resultsTextField.frame = frame
            
            let aspectRatioTextViewConstraint = NSLayoutConstraint(item: cell.resultsTextField, attribute: .Height, relatedBy: .Equal, toItem: cell.resultsTextField, attribute: .Width, multiplier: cell.resultsTextField.bounds.height/cell.resultsTextField.bounds.width, constant: 1)
            cell.resultsTextField.addConstraint(aspectRatioTextViewConstraint)
       */   
            
            print("p257 we here? \(labels[indexPath.row])")

            
            var frameRect:CGRect  = cell.resultsTextField.frame;
            frameRect.size.height = 60 // <-- Specify the height you want here.
            cell.resultsTextField.frame = frameRect
            
            
            
            
        }

    
        
        if results[indexPath.row] == "Event" {
            print("p144 we here: \(indexPath.row)!")
            cell.resultsTextField.backgroundColor = swiftColor
        }
        
        switch (results[indexPath.row]){
        case "Event":
            cell.resultsTextField.backgroundColor = swiftColor
             break;
        case "Reminder":
            cell.resultsTextField.backgroundColor = UIColor.yellowColor()
            break;
        case "New List", "List":
            cell.resultsTextField.backgroundColor = moccasin
            break;
        case "New OneItem List":
            cell.resultsTextField.backgroundColor = moccasin
            break;
        case "Phrase List":
            cell.resultsTextField.backgroundColor = apricot
            break;

        default:
            cell.resultsTextField.backgroundColor = UIColor.whiteColor()
            break;
        }
    
        //    resultType.backgroundColor = UIColor.yellowColor()
      
        return cell
    }   // end func cellForRowAtIndexPath
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("p68 You selected cell #\(indexPath.row)!")
        
        var selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        
        let saffron = UIColor(red: 244, green: 208, blue: 63)  // 244, 208, 63
        selectedCell.contentView.backgroundColor = saffron
        
        if labels[indexPath.row] == "Input" {               //selected Input row...
            self.tabBarController?.selectedIndex = 2        //go to main dictate microphone screen
            
        } else if labels[indexPath.row] == "Title" {               //selected Input row...

       
            var alert = UIAlertController(title: "Enter your new Title", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Continue", style: .Default, handler: { (action) -> Void in
                
                self.output = alert.textFields![0].text!
                self.defaults.setObject(self.output, forKey: "output")                //sets output

                print("p251 alert.textFields![0].text!: \(alert.textFields![0].text!)")
                print("p251 self.output: \(self.output)")
               // let outputNew = self.defaults.stringForKey("output")                   //Title
               // print("p271 outputNew: \(outputNew)")
                
                self.loadResultsArray()
                
                self.tableViewOutlet.reloadData()
                
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
                //selectedCell.contentView.backgroundColor = UIColor.blackColor()
                self.tableViewOutlet.reloadData()   //TODO Anil Mike best way to remove the highlighted row?
            }))


            
            alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
                textField.placeholder = "Enter text:"
                textField.secureTextEntry = false
                
                print("p230 textField.text: \(textField.text)")
                
                self.output = textField.text!
                
         

    
            })
  
            self.presentViewController(alert, animated: true, completion: nil)
           
            
        } else if (labels[indexPath.row] == "Start" || labels[indexPath.row] == "End") {
            //load EKEventEditViewController
            // create Event ViewController
          
            
            let evc = EKEventEditViewController()
            evc.eventStore = EKEventStore()
       //     evc.editViewDelegate = self
            evc.modalPresentationStyle = .Popover
            self.presentViewController(evc, animated: true, completion: nil)
            
//no idea here...
            func eventEditViewController(controller: EKEventEditViewController,
                didCompleteWithAction action: EKEventEditViewAction) {
                    print("did complete: \(action.rawValue), \(controller.event)")
                    self.dismissViewControllerAnimated(true, completion: nil)
            }
     
        }   //end Start and Date edit VC.
        
   }   // end func didSelectRowAtIndexPath
    
// End TABLE funcs...
    
    func loadResultsArray() {
        
        var strRaw      = defaults.stringForKey("strRaw")                   //Input
        var actionType  = defaults.stringForKey("actionType")!              //Type
        var day         = defaults.stringForKey("day")                      //Day
        let phone       = defaults.stringForKey("phone")                    //Cell#
        let startDT     = defaults.objectForKey("startDT")! as! NSDate      //Start
        let endDT       = defaults.objectForKey("endDT")! as! NSDate        //End
        var output      = defaults.stringForKey("output")                   //Title
        var calendarName = defaults.stringForKey("calendarName")            //Cal.
        let alert       = defaults.objectForKey("eventAlert") as! Int ?? 10 //Alert
        let eventRepeat = defaults.stringForKey("eventRepeat")              //Repeat
        
        var alertString = ""
        
        if (alert == 0){
            alertString = ""
        } else {
            alertString = "\(String(alert)) minutes"
        }
 
        results = ["\"\(strRaw!)\"", actionType, day!, time, phone!, fullDT, fullDTEnd, output!, calendarName!, alertString, eventRepeat!]
        print("p303 results: \(results)")
    }
    
    
//#### End my functions #################################
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
        var alertSound3: NSURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("se_tap", ofType: "m4a")!)
        //General.playSound(alertSound3!)
        
        playSound(alertSound3)
        
        // Do any additional setup after loading the view.
        var strRaw      = defaults.stringForKey("strRaw")                   //Input
        var actionType  = defaults.stringForKey("actionType")!              //Type
        var day         = defaults.stringForKey("day")                      //Day
        let phone       = defaults.stringForKey("phone")                    //Cell#
        let startDT     = defaults.objectForKey("startDT")! as! NSDate      //Start
        let endDT       = defaults.objectForKey("endDT")! as! NSDate        //End
        var output      = defaults.stringForKey("output")                   //Title
        var calendarName = defaults.stringForKey("calendarName")            //Cal.
        let alert       = defaults.objectForKey("eventAlert") as! Int ?? 10 //Alert
        let eventRepeat = defaults.stringForKey("eventRepeat")              //Repeat
        
        var formatter3 = NSDateFormatter()
        formatter3.dateFormat = "M-dd-yyyy h:mm a"
        fullDT = formatter3.stringFromDate(startDT)
        fullDTEnd = formatter3.stringFromDate(endDT)
        
        var alertString = ""
        
        if (alert == 0){
            alertString = ""
        } else {
            alertString = "\(String(alert)) minutes"
        }
        
        deleteRowCountArray = []
        print("p345 deleteRowCountArray: \(deleteRowCountArray)")
        
        print("p111Main ===================================")
        print("p111Main results: \(results)")
        
        let outputNote  = defaults.stringForKey("outputNote")
        let duration    = defaults.objectForKey("eventDuration") as! Int ?? 10
        
        var wordArrTrimmed  = defaults.objectForKey("wordArrTrimmed") as! [String] //array of the items
        
        //TODO Mike Anil commented to fix nil error
        // var reminderArray = defaults.objectForKey("reminderArray") as! [String] //array of the items
        
        var reminderTitle   = defaults.stringForKey("reminderTitle")
        var reminderArray:[String] = []
        var reminderList   = defaults.stringForKey("reminderList")
        var reminderAlarm  = defaults.objectForKey("reminderAlarm")! as! NSDate
    
        let allDayFlag  = defaults.objectForKey("allDayFlag") as! Bool
        let defaultCalendarID  = defaults.stringForKey("defaultCalendarID")
        let defaultReminderID = defaults.stringForKey("defaultReminderID")
        let processNow = defaults.objectForKey("ProcessNow") as! Bool
        
        
        print("p111Main ===================================")
        print("p111Main day: \(day)")
        print("p111Main phone: \(phone)")
        print("p111Main startDT: \(startDT)")
        print("p111Main endDT: \(endDT)")
        print("p111Main output: \(output)")
        print("p111Main outputNote: \(outputNote)")
        print("p111Main duration: \(duration)")
        print("p111Main calandarName: \(calendarName)")
        print("p111Main alert: \(alert)")
        print("p111Main eventRepeat: \(eventRepeat)")
        print("p111Main strRaw: \(strRaw)")
        
        print("p111Main mainType: \(mainType)")
        print("p111Main actionType: \(actionType)")
        
        print("p111Main reminderTitle: \(reminderTitle)")
        print("p111Main wordArrTrimmed: \(wordArrTrimmed)")
        print("p111Main reminderList: \(reminderList)")
        print("p111Main reminderArray: \(reminderArray)")
        print("p111Main reminderAlarm: \(reminderAlarm)")
        
        print("p111Main allDayFlag: \(allDayFlag)")
        print("p111Main timeString: \(timeString)")
        
        print("p111Main defaultCalendarID: \(defaultCalendarID)")       //defaultCalendarID
        print("p111Main defaultReminderID: \(defaultReminderID)")       //defaultReminderID
        print("p111Main processNow: \(processNow)")                     //processNow Bool
        
        print("p111Main end =================================")
        
        if allDayFlag {                             //if flag = true
            formatter3.dateFormat = "M-dd-yyyy"
            fullDT = formatter3.stringFromDate(startDT)
            day     = "\(fullDT), All-Day"
        }
        

        switch (actionType){
        case "Reminder":
            print("p315 actionType: \(actionType)")
            let reminderTitle  = defaults.stringForKey("reminderTitle") ?? ""

            
            buttonCreateOutlet.setTitle("Create Reminder", forState: UIControlState.Normal)
            buttonCreateOutlet.backgroundColor = UIColor.yellowColor()
     
            if ( fullDT == "12-12-2014 12:00 AM" ) {        // added 072315 no need to show if no date used
                fullDT = ""
                fullDTEnd = ""
            }
           
            output = reminderTitle
            calendarName = reminderList!
            
            labelCal   = "List"    // default Cal.
            
            print("p337 output: \(output)")
            print("p337 calendarName: \(calendarName)")

            if fullDT != "12-12-2014 12:00 AM" {        // means a blank date
                labelAlert = "Alarm"               // default Alert
                alertString = fullDT
            }
    
            break;
            
        case "Event":
            buttonCreateOutlet.setTitle("Create Event", forState: UIControlState.Normal)
            buttonCreateOutlet.backgroundColor = swiftColor
            break;
            
        case "New List", "List":
            
            let reminderTitle  = defaults.stringForKey("reminderList") ?? ""
            
            buttonCreateOutlet.backgroundColor = moccasin
            buttonCreateOutlet.setTitle("Create New List", forState: UIControlState.Normal)

            output = ""
            fullDT = ""
            fullDTEnd = ""
            alertString = ""
            calendarName = ""
            
            let stringOutput = wordArrTrimmed.joinWithSeparator(", ")
            
            // ____ Data Used _____________________________________
            labelDay       = "Title"   // default Day
            labelTime      = "Items"   // default Time
     
            day      = reminderTitle
            time     = stringOutput
    
            break;
            
        case "New OneItem List":
            
            let reminderTitle:String    = defaults.stringForKey("reminderList")! //Sets Reminder Title
            
            buttonCreateOutlet.backgroundColor = moccasin
            buttonCreateOutlet.setTitle("Create New List", forState: UIControlState.Normal)
            
            output = ""
            fullDT = ""
            fullDTEnd = ""
            alertString = ""
            calendarName = ""
            
            let stringOutput = wordArrTrimmed.joinWithSeparator(", ")
            
            // ____ Data Used _____________________________________
            labelDay       = "Title"   // default Day
            labelTime      = "Items"   // default Time
            
            day      = reminderTitle
            time     = stringOutput
            
            actionType = "New One Item List"   // default Title.
   
            break;
            
            
            
        case "Phrase List":
            let reminderTitle:String    = defaults.stringForKey("reminderList")! //Sets Reminder Title
            
            buttonCreateOutlet.backgroundColor = apricot
            buttonCreateOutlet.setTitle("Create Phrase List", forState: UIControlState.Normal)
            output = reminderTitle
            
            let stringOutput = wordArrTrimmed.joinWithSeparator(", ")
            day = stringOutput
            
            labelDay       = "Title"   // default Day
            labelTime      = "Items"   // default Time
            
            alertString = ""

            break;
            
        default:
            buttonCreateOutlet.setTitle("Create Event", forState: UIControlState.Normal)
            buttonCreateOutlet.backgroundColor = swiftColor
            
            break;
        }
        
        print("p604 processNow: \(processNow)")
        if (processNow == true) {
            buttonCreate(self)   //go to this class
        }
        
        print("p555 labelCal: \(labelCal)")
        print("p555 labelTitle: \(labelTitle)")

        print("p555 labelInput: \(labelInput)")
        print("p555 labelType: \(labelType)")
  
        labels = [labelInput, labelType, labelDay, labelTime, labelCell, labelStart, labelEnd, labelTitle, labelCal, labelAlert, labelRepeat]
        
        results = ["\"\(strRaw!)\"", actionType, day!, time, phone!, fullDT, fullDTEnd, output!, calendarName!, alertString, eventRepeat!]
        
        print("p555 labels: \(labels)")
        print("p555 results: \(results)")
    /*
        print("p541 numberRowsToDelete: \(numberRowsToDelete)")

        let rowsToShow = 11 - numberRowsToDelete    //11 is maximun fields same as results.count
        
        print("p542 rowsToShow: \(rowsToShow)")
    
     */
        //rowsToShow = rowsToShow + 3
        
        tableViewHeightConstraint.constant = CGFloat((rowsToShow * 35) + (additionalRows * 35) )   //anil added
        tableViewOutlet.reloadData()
        
        print("**** p546 tableViewHeightConstraint.constant: \(tableViewHeightConstraint.constant)")
        
  //      tableResultFrameHeightConstraint.constant = CGFloat(titleFrameHeight)
  //      print("p176  tableResultFrameHeightConstraint.constant: \( tableResultFrameHeightConstraint.constant)")
        

    }   //end viewWill Appear
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        tableV.tableFooterView = UIView(frame:CGRectZero)    //removes blank lines
        
        self.tableViewOutlet.reloadData()


      //  tableV.estimatedRowHeight = 150
      //  tableV.rowHeight = UITableViewAutomaticDimension
        
        //Added left and Right Swipe gestures. TODO Can add this to the General.swift Class? and call it?
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        leftSwipe.direction = .Left
        rightSwipe.direction = .Right
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func buttonCreate(sender: AnyObject) {
        
        var alertSound1 = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("217-buttonclick03", ofType: "mp3")!)
        //  General.playSound(alertSound3!)
        playSound(alertSound1)
        
        var actionType:String    = defaults.stringForKey("actionType")!
        print("p237 vcTest1, actionType: \(actionType)")
        
        switch (actionType){
            
// ____ Reminder Case buttonCreate____________________________________
        case "Reminder":
            print("p242 in Reminder Switch")
            
            let title:String = output
            
            var calendarName = ""
            var reminderCreatedFlag = false
            
            var reminderArray       = defaults.objectForKey("reminderArray") as! [String] //array of the items
            var reminderList:String     = defaults.stringForKey("reminderList")!
            
            print("p518 reminderArray: \(reminderArray)")
            print("p519 reminderList: \(reminderList)")
            
            if reminderList == "default" {
                calendarName = reminderList
                
                output      = defaults.stringForKey("output")!
                var outputArray:[String] = Array(arrayLiteral: output)  //make output into Array for func call below
                
                print("p550 calendarName: \(calendarName)")
                print("p551 outputArray: \(outputArray)")
                
                ReminderManager.sharedInstance.addReminder(calendarName, items: outputArray)
            }
            
            
            for list in reminderArray {
                
                //var list = list.capitalizedString
                print("p524 reminderList: \(reminderList)")
                print("p525 list________: \(list)")
                
                var lengthList = list.characters.count
                var lengthReminderList = reminderList.characters.count
                //println("p537 lengthList________: \(lengthList)")
                //println("p537 lengthReminderList: \(lengthReminderList)")
                
                if (reminderList == list) {
                    print("p528 we in condition reminderList: \(reminderList)")
                    calendarName = reminderList
                    
                    print("p478 calendarName: \(calendarName)")
                    
                    output      = defaults.stringForKey("output")!
                    var outputArray:[String] = Array(arrayLiteral: output)  //make output into Array for func call below
                    
                    print("p550 calendarName: \(calendarName)")
                    print("p551 outputArray: \(outputArray)")
                    
                    ReminderManager.sharedInstance.addReminder(calendarName, items: outputArray)
                    
                    self.messageString = "☑️ Reminder created on your: \"\(calendarName.capitalizedString)\" list"
                    
                    reminderCreatedFlag = true
                    break;
                }
            }
            
            if !reminderCreatedFlag {   // If is false
                print("p571  we here reminderCreatedFlag: \(reminderCreatedFlag)")
                
                calendarName = reminderList
                
                output      = defaults.stringForKey("output")!
                var outputArray:[String] = Array(arrayLiteral: output)
                
                ReminderManager.sharedInstance.createNewReminderList(calendarName, items: outputArray)
                
                self.messageString = "☑️Reminder created on your New: \"\(calendarName.capitalizedString)\" list!"
            }
            
            break;
            
// ____ Event Case ____________________________________
        case "Event":
            print("p255 in Event Switch")
            
            EventManager().createEvent()
            calendarName = defaults.stringForKey("calendarName")!            //Cal.
            self.messageString = "📅 Event created on your: \"\(calendarName.capitalizedString)\" calendar!"
            break;
            
// ____ New List, List Case ____________________________________
        case "New List", "List" :
            print("p530 in list Switch")
            
            ReminderManager.sharedInstance.createNewReminderList(calendarName, items: wordArrTrimmed)
            var reminderList = defaults.stringForKey("reminderList")
            self.messageString = "📝 New List: \(reminderList!), created!"
            break;
            
// ____ New OneItem List ____________________________________
        case  "New OneItem List" :
            print("p543 in New OneItem List Switch")
            
            var calendarName    = defaults.stringForKey("reminderList") //Sets Reminder Title
            
            output      = defaults.stringForKey("output")!
            var outputArray:[String] = Array(arrayLiteral: output)
            
            ReminderManager.sharedInstance.createNewReminderList(calendarName!, items: outputArray)
            self.messageString = "📝 New List: \"\(calendarName!)\", created!"
            break;
            
// ____ Phrase List ____________________________________
        case "Phrase List":
            print("p638 in phraseList Switch")
            
            var calendarName    = defaults.stringForKey("calendarName") //Sets Reminder Title
            var wordArrTrimmed  = defaults.objectForKey("wordArrTrimmed") as! [String] //array of the items
            
            ReminderManager.sharedInstance.createNewReminderList(calendarName!, items: wordArrTrimmed)
            self.messageString = "📝 New Phrase List: \"\(calendarName!)\", created!"
            break;
            
        case "Note":
            print("p152 in note Switch")
            break;
            
        default:
            print("p155 in default switch so assume Event")
            
            EventManager().createEvent()
            self.messageString = "📅 Event created on your: \"\(calendarName.capitalizedString)\" calendar!"
            break;
        }
        
// ____ End Switch Statement ____________________________________
        
        var strRaw      = defaults.stringForKey("strRaw")
        output          = defaults.stringForKey("output")!
        calendarName    = defaults.stringForKey("calendarName")!
        
        
        print("p485 strRaw: \(strRaw)")
        print("p485 output: \(output)")
        print("p485 outputNote: \(outputNote)")
        print("p485 fullDT: \(fullDT)")
        print("p485 fullDTEnd: \(fullDTEnd)")
        print("p485 calendarName: \(calendarName)")
        print("p485 actionType: \(actionType)")
        
        if (fullDT == "12-12-2014 12:00 AM") {      // set to "" for database
            fullDT = ""
            fullDTEnd = ""
        }
        
        General().saveToParse()         //save to database
        
        defaults.setObject(eventDuration, forKey: "eventDuration")
                
       // actionType = ""
       // defaults.setObject(actionType, forKey: "actionType")
        
        print("p977 actionType: \(actionType)")
        
// ____ Alert Dialog ____________________________________
        
        let alertTitle = messageString
        let labelFont = UIFont(name: "HelveticaNeue-Bold", size: 22)
        let attributedString = NSAttributedString(string: alertTitle, attributes: [
            NSFontAttributeName: labelFont!,
            NSForegroundColorAttributeName: UIColor.blueColor() //TODO Mike ANIL why is Font color NOT beeing set???
            ])

        let textLine2 = "by Dictate™ App 😀"
        let labelFont2 = UIFont(name: "HelveticaNeue-Bold", size: 16)
        let attributedString2 = NSAttributedString(string: textLine2, attributes: [
            NSFontAttributeName: labelFont2!,
            NSForegroundColorAttributeName: UIColor.blackColor() //TODO Mike ANIL why is Font color NOT beeing set???
            ])
 
        let alert = UIAlertController(title: alertTitle, message: textLine2, preferredStyle: UIAlertControllerStyle.Alert)
        alert.setValue(attributedString, forKey: "attributedTitle")
        alert.setValue(attributedString2, forKey: "attributedMessage")
  
        self.presentViewController(alert, animated: true, completion: nil)
        
// ____ End Alert Dialog ____________________________________
        
        //General().cleardata()

        General().delay(3.0) {
            // do stuff
            self.resultMessage.text = ""
            
            let processNow = false
            self.defaults.setObject(processNow, forKey: "ProcessNow")
            
            self.presentedViewController!.dismissViewControllerAnimated(true, completion: nil)      //close alert after the set delay of 3 seconds!
            
            self.tabBarController?.selectedIndex = 2
            
        }
    }   //end ButtonCreate
    
    
    @IBAction func buttonCancel(sender: AnyObject) {
        print("p898 in buttonCancel")
        
        var alertSound124 = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("124-DeleteWhoosh", ofType: "mp3")!)
        //  General.playSound(alertSound3!)
        
        playSound(alertSound124)
        
        General().cleardata()
 /*
        resultType.text = ""
        //  resultProcessed.text = outputNote
        //  resultRaw.text = strRaw
        resultDay.text = day
        resultTime.text = timeString
        resultPhone.text = phone
        resultStartDate.text = fullDT
        resultEndDate.text = fullDTEnd
        resultTitle.text = output
        resultCalendar.text = calendarName
 */
        self.tabBarController?.selectedIndex = 2
        
    }   //end buttonCancel
    
    
    
    
    
  
    /*
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    
    return "Section \(section)"
    }
    */
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

}


