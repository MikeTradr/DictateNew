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




class DetailTableVC: UIViewController {
    
    @IBOutlet weak var tableV: UITableView!
   // @IBOutlet weak var label: UILabel!
   // @IBOutlet weak var data: UILabel!
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    @IBOutlet weak var buttonCreateOutlet: UIButton!
    @IBOutlet weak var resultMessage: UITextView!
    
    var eventRepeat = ""
    var actionType = ""
    var strRaw = ""
    var alertString = ""
    var output = ""
    var messageString = ""
 
    var results = ["", "", "", "", "", "", "", "", "", "", ""]
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
    
    // var labels = [labelInput, labelType, labelDay, labelTime, labelCell, labelStart, labelEnd, labelTitle, labelCal, labelAlert, labelRepeat]
    
    let defaults = NSUserDefaults(suiteName: "group.com.thatsoft.dictateApp")!
    var audioPlayer = AVAudioPlayer()
    
    var wordArrTrimmed  = NSUserDefaults(suiteName: "group.com.thatsoft.dictateApp")!.objectForKey("wordArrTrimmed") as? [String] ?? [] //array of the items
    
    let lightPink = UIColor(red: 255, green: 204, blue: 255)
    let swiftColor = UIColor(red: 255, green: 165, blue: 0)
    let moccasin = UIColor(red: 255, green: 228, blue: 181)     //light biege color, for Word List
    let apricot = UIColor(red: 251, green: 206, blue: 177)     //light biege color, for Phrase List

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
        return results.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if results[indexPath.row] == "" || results[indexPath.row] == "0"  {
            print("p143 we here hide rows: \(indexPath.row)!")
            return 0
        } else {
            return 25 //space heigh
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier( "BasicCell", forIndexPath: indexPath) as! DetailsTableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.Default //TODO tried to set sleection color to yellow
        cell.label.text = labels[indexPath.row]
        
        cell.resultsTextField.text = results[indexPath.row]
        cell.resultsTextField.layer.cornerRadius = 7
        cell.resultsTextField.textColor = UIColor.blueColor()
        
        if labels[indexPath.row] == "Input" || labels[indexPath.row] == "Start" || labels[indexPath.row] == "End" || labels[indexPath.row] == "Title" || labels[indexPath.row] == "Cal." || labels[indexPath.row] == "Alert"  {
            
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            
            //cell.accessoryView = PZDisclosureIndicator(color: UIColor.yellowColor())
            
        } else {
            cell.accessoryType = .None
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
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("p68 You selected cell #\(indexPath.row)!")
        
        var selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        
        let saffron = UIColor(red: 244, green: 208, blue: 63)  // 244, 208, 63
        selectedCell.contentView.backgroundColor = saffron
        
        if labels[indexPath.row] == "Input" {               //selected Input row...
            self.tabBarController?.selectedIndex = 2        //go to main dictate microphone screen
        } else if labels[indexPath.row] == "Title" {               //selected Input row...

       
            var alert = UIAlertController(title: "Enter your Title", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.Default, handler: nil))
            alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
                textField.placeholder = "Enter text:"
                textField.secureTextEntry = false
                
                print("p230 textField.text: \(textField.text)")
                
                self.output = textField.text!
     
            })
        
           
            
            self.presentViewController(alert, animated: true, completion: nil)
           
            
        }
        
        
        
        
    }

// End TABLE funcs...
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
        
     
   
       // labels = [labelInput, labelType, labelDay, labelTime, labelCell, labelStart, labelEnd, labelTitle, labelCal, labelAlert, labelRepeat]
 
        
        print("p111Main ===================================")
        print("p111Main results: \(results)")

        
        let outputNote  = defaults.stringForKey("outputNote")
        let duration    = defaults.objectForKey("eventDuration") as! Int ?? 10
        
        var wordArrTrimmed  = defaults.objectForKey("wordArrTrimmed") as! [String] //array of the items
        
        //TODO Mike Anil commented to fix nil error
        // var reminderArray = defaults.objectForKey("reminderArray") as! [String] //array of the items
        
        var reminderTitle   = defaults.stringForKey("title")
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
            
            buttonCreateOutlet.setTitle("Create Reminder", forState: UIControlState.Normal)
            buttonCreateOutlet.backgroundColor = UIColor.yellowColor()
     
            if ( fullDT == "12-12-2014 12:00 AM" ) {        // added 072315 no need to show if no date used
                fullDT = ""
                fullDTEnd = ""
            }
           
            output = reminderList!
            calendarName = reminderTitle!
            
            labelCal   = "List"    // default Cal.
            output = ""
            
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
      //      buttonCreate(nil)   //go to this class
            
            
        }
        print("p555 labelCal: \(labelCal)")
        print("p555 labelTitle: \(labelTitle)")

        print("p555 labelInput: \(labelInput)")
        print("p555 labelType: \(labelType)")
  
        labels = [labelInput, labelType, labelDay, labelTime, labelCell, labelStart, labelEnd, labelTitle, labelCal, labelAlert, labelRepeat]
        
        results = ["\"\(strRaw!)\"", actionType, day!, time, phone!, fullDT, fullDTEnd, output!, calendarName!, alertString, eventRepeat!]
        
        print("p555 labels: \(labels)")
        print("p555 results: \(results)")
        
        tableViewOutlet.reloadData()
        
      //  defaults.setObject(results, forKey: "results")      //save items for results table

    }   //end viewWill Appear
    
    


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        tableV.tableFooterView = UIView(frame:CGRectZero)    //removes blank lines
        
       
    
        
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



 /*
        let alertTitle = messageString
        let labelFont2 = UIFont(name: "HelveticaNeue-Bold", size: 22)
        
        let attributedString2 = NSAttributedString(string: alertTitle, attributes: [
            NSFontAttributeName : labelFont2!,
            NSForegroundColorAttributeName : UIColor.blueColor()
            ])
        
        
        
        let textLine2 = "by Dictate™ App 😀"
        let labelFont = UIFont(name: "HelveticaNeue-Bold", size: 16)

        let attributedString = NSAttributedString(string: textLine2, attributes: [
            NSFontAttributeName : labelFont!,
            NSForegroundColorAttributeName : UIColor.blackColor()
            ])
        
        
        let alert = UIAlertController(title: alertTitle, message: self.messageString, preferredStyle: UIAlertControllerStyle.Alert)
        
    
        
        alert.setValue(attributedString2, forKey: "attributedTitle")

        
       // alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))   //adds a button
        
        alert.setValue(attributedString, forKey: "attributedMessage")

        
     //   alert.view.tintColor = UIColor.blueColor()        //sets button font color
    //   alert.view.backgroundColor = UIColor.orangeColor()  //sets dialog background color
*/
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        //General().cleardata()

        General().delay(3.0) {
            // do stuff
            self.resultMessage.text = ""
            
            let processNow = false
            self.defaults.setObject(processNow, forKey: "ProcessNow")
            
            self.presentedViewController!.dismissViewControllerAnimated(true, completion: nil)      //close alert after the set delay of 3 seconds!
            
            self.tabBarController?.selectedIndex = 2
            
        }
        
    }
    
    
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
        
    }
    
    
    
    
    
  
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


