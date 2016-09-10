//
//  DetailTableVC.swift
//  Dictate
//
//  Created by Mike Derr on 1/31/16.
//  Copyright © 2016 ThatSoft.com. All rights reserved.
//
//  Changes:
//  -----------------------------------
//  043016 Mike: added Location code...

import UIKit
import EventKit
import AVFoundation
import EventKitUI

class DetailTableVC: UIViewController, DetailsTableViewCellDateSelectionDelegate {
    
    var selectedIndexPath : NSIndexPath?
    var repeatRow: Int!
    
    @IBOutlet weak var tableV: UITableView!
    
    @IBOutlet weak var buttonCreateOutlet: UIButton!
    @IBOutlet weak var resultMessage: UITextView!
    
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
        
   // @IBOutlet weak var labelTrailingConstraint: NSLayoutConstraint!
    
    var eventRepeat = ""
    var actionType = ""
    var strRaw = ""
    var alertString = ""
    var output = ""
    var messageString = ""
    var locationString = ""
 
    var results = ["temp", "temp", "temp", "temp", "temp", "temp", "temp", "temp", "temp", "temp", "temp", "temp"]
    var labels = ["Input", "Type", "Day", "Time", "Cell#", "Start", "End", "Title", "Cal.", "Alert", "Repeat", "Location"]

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
    var labelLocation = "Locat."
    
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
    
    var titleRowHeight: CGFloat = 0.0
    
    var startDT = NSDate()
    var datePickerHeight: CGFloat = 0.0


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
        
        if #available(iOS 9.0, *) {
            ReminderManagerSave().createReminder()  //fixed check FIXWC
        } else {
            // Fallback on earlier versions
        }
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
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
    
        return UIModalPresentationStyle.None
    }
    
    func resetToDefaults(){
        labels = ["Input", "Type", "Day","Time", "Cell#", "Start", "End", "Title", "Cal.", "Alert", "Repeat", "Locat."]
        labelInput      = "Input"
        labelType       = "Type"
        labelDay        = "Day"
        labelTime       = "Time"
        labelCell       = "Cell#"
        labelStart      = "Start"
        labelEnd        = "End"
        labelTitle      = "Title"
        labelCal        = "Cal."
        labelAlert      = "Alert"
        labelRepeat     = "Repeat"
        labelLocation   = "Locat."
        
        datePickerHeight = 0.0
        
        flagAutoRecord = false
        defaults.setObject(flagAutoRecord, forKey: "flagAutoRecord")        //sets flagAutoRecord for processing
        
    }
    
    
    func toggleDatepicker() {
        
        datePickerHidden = !datePickerHidden
        
        tableV.beginUpdates()
        tableV.endUpdates()
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showCalPicker"
        {
            if let destinationVC = segue.destinationViewController as? CalendarPickerViewController{
               // destinationVC.numberToDisplay = counter
            }
        }
   /*
        if segue.identifier == "showCalPicker" {
           // CalendarPickerViewController.selectedCalendar = usersCalendar
            
            print("p153 we here?")

            let controller = segue.destinationViewController as! CalendarPickerViewController
           // let usersCalendar:String = defaults.stringForKey("calendarName")!
          //  print("p152 usersCalendar: \(usersCalendar)")
            
          //  controller.selectedCalendar = usersCalendar
           // self.performSegueWithIdentifier("showCalPicker", sender: self)
            
            performSegueWithIdentifier("showCalPicker", sender: self)

        }
     */
        
        //Anil added
        if segue.identifier == "PickReminder"{
            //usually we the value in the next controller from here
            // in our case its not really required, since we are setting it in user defaults, will be globaly available
            //As a better approach iam doing here to show you
            
            let selectedCalendarIdentifier = defaults.objectForKey("defaultReminderList") as? String
            
            let reminderPickerController = segue.destinationViewController as! ReminderPickerTableViewController
            reminderPickerController.selectedReminder = selectedCalendarIdentifier
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
        //return 11         // 11 fields (rows) total!
        return results.count
    }
    
    
//===== heightForRowAtIndexPath ================================================

    var datePickerHidden = false
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        //print("p154 results[indexPath.row]: \(results[indexPath.row])")
        
//        if indexPath == selectedIndexPath {
//            return DetailsTableViewCell.expandedHeight
//        } else {
//            return DetailsTableViewCell.defaultHeight
//        }
    
        //ANIL HELP HERE???
        
   /*
        if datePickerHidden && indexPath.section == 0 && indexPath.row == 1 {
            return 0
        }
        else {
            //return tableView(tableView, heightForRowAtIndexPath: indexPath)
            return 35
        }
   */
        
        
        
        var height:CGFloat = 35

        if (results[indexPath.row] == "" || results[indexPath.row] == "0" || labels[indexPath.row] == "") {
           // print("p148 we here hide rows: \(indexPath.row)")
            
            deleteRowCountArray.append(indexPath.row)
            //print("p152 deleteRowCountArray: \(deleteRowCountArray)")
            
            let uniqueRowArray = Array(Set(deleteRowCountArray))    //removes duplicates
            
            numberRowsToDelete = uniqueRowArray.count
            //print("p158 numberRowsToDelete: \(numberRowsToDelete)")
            
            rowsToShow = results.count - numberRowsToDelete    //11 is maximun fields same as results.count
      
            return 0
        
        } else if (labels[indexPath.row] == "Title" || labels[indexPath.row] == "Items") {
            
            print("p175 row: \(labels[indexPath.row]): \(results[indexPath.row])")
            // http://stackoverflow.com/questions/27369777/self-sizing-cell-in-swift-how-do-i-make-constraints-programmatically
  
            //Instead of 180, we actually need to have the width of the result textView
            var  height = dynamicHeight(results[indexPath.row], font: UIFont.boldSystemFontOfSize(22), width: 150)  //was 180
            
            print("p275 height: \(height)")
            
            if height < 35 {
                height = 35     //row height can't be less then 35, for 1 line to show.
                print("p185 height: \(height)")
            }
            
            if height > 90 {    //set max row height to allow like 3 rows, then scale font to fill this height! :) neat!
                height = 90
            }
            
            titleRowHeight = height; print("p192 height: \(height)")
            
            let rowsToAdd = height/36; print("p200 rowsToAdd: \(rowsToAdd)")

            additionalRows = Int(rowsToAdd)     // var for additional rows to add to table height
            print("p204 additionalRows: \(additionalRows)")

            tableViewHeightConstraint.constant = CGFloat((rowsToShow * 35) + (additionalRows * 30)) //20 ) //anil added, mike changed
            
            print("p204 additionalRows: \(additionalRows)")
            
            view.updateConstraintsIfNeeded()
            
            print("p205 tableViewHeightConstraint.constant: \(tableViewHeightConstraint.constant)")
                        
            print("p211 height: \(height)")
            
            return height
        }   //else if "Title"
        
        print("p270 indexPath: \(indexPath)")
        print("p271 selectedIndexPath: \(selectedIndexPath)")
        
        //add height for Date Picker
        if (labels[indexPath.row] == "Start") || (labels[indexPath.row] == "End") {
            if selectedIndexPath == indexPath  {
                    print("p230 here? indexPath: \(indexPath)")
                    height = 250
                } else {
                    height = 35
                }
        }
        /*
        //add height for Calendar and List picker
        if (labels[indexPath.row] == "Cal.") || (labels[indexPath.row] == "List") {
            if selectedIndexPath == indexPath  {
                print("p230 here? indexPath: \(indexPath)")
                height = 250
            } else {
                height = 35
            }
        }
        */
        return height
    }   // end func heightForRowAtIndexPath

//===== endheightForRowAtIndexPath ================================================
    
//===== cellForRowAtIndexPath ================================================
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var identifier = "BasicCell"
        
        if labels[indexPath.row] == "Start" || labels[indexPath.row] == "End"{
            identifier = "DateCell"     //used for datePicker Anil added 022316
        }
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier( identifier, forIndexPath: indexPath) as! DetailsTableViewCell
        cell.delegate = self
        cell.selectionStyle = .None
        
//        cell.selectionStyle = UITableViewCellSelectionStyle.Default //TODO tried to set selection color to yellow
        cell.label.text = labels[indexPath.row]
        cell.resultsLabel.text = results[indexPath.row]
        cell.resultsLabel.layer.cornerRadius = 7
        cell.resultsLabel.font = UIFont.boldSystemFontOfSize(CGFloat(22))

        print("p250 ========================================")
        print("p250 row: \(labels[indexPath.row]): \(results[indexPath.row]) ")
        print("p250 ========================================")
        
        if labels[indexPath.row] == "Input" || labels[indexPath.row] == "Start" || labels[indexPath.row] == "End" || labels[indexPath.row] == "Title" || labels[indexPath.row] == "Cal." || labels[indexPath.row] == "Alert" || labels[indexPath.row] == "List"  || labels[indexPath.row] == "Repeat" || labels[indexPath.row] == "Alarm" || labels[indexPath.row] == "Locat."  {
            cell.disclosureLabel.hidden = false
            cell.userInteractionEnabled = true     //allow cell to be highlighted!
        } else {
            cell.disclosureLabel.hidden = true
            cell.userInteractionEnabled = false     //does not allow cell to be highlighted!
        }
        
        if labels[indexPath.row] == "Input" || labels[indexPath.row] == "Title" || labels[indexPath.row] == "Items" {
        
            print("p300 titleRowHeight: \(titleRowHeight)")

            if labels[indexPath.row] == "Title" || labels[indexPath.row] == "Items" {
                cell.resultsLabel.frame.size.height = titleRowHeight
                
                if cell.resultsLabel.frame.size.height > 90 {   //try to have max rows at 3
                    cell.resultsLabel.frame.size.height = 90
                }
            }
         
            print("p301 ========================================")
            print("p301 row: \(labels[indexPath.row]): \(results[indexPath.row]) ")
            print("p301 ========================================")
            print("p301 cell.resultsLabel.font: \(cell.resultsLabel.font)")
            print("p305 cell.resultsLabel.frame.size.height: \(cell.resultsLabel.frame.size.height)")
            
            //from: http://derekneely.com/2011/04/size-to-fit-text-in-uitextview-iphone/
            //setup text resizing check here
            
            var height = dynamicHeight(results[indexPath.row], font: UIFont.boldSystemFontOfSize(22), width: 180)
            
            print("p337 height: \(height)")
            
            if ( height > cell.resultsLabel.frame.size.height) {
                print("p312 we in If?: \(labels[indexPath.row])")
                
                var fontIncrement = 0.1
                while (height > cell.resultsLabel.frame.size.height) {
                    cell.resultsLabel.font = UIFont.boldSystemFontOfSize(CGFloat(21-fontIncrement))
                    height = dynamicHeight(results[indexPath.row], font: UIFont.boldSystemFontOfSize(CGFloat(21-fontIncrement)), width: 180)
                    fontIncrement += 1
                }
            }
            print("p322 cell.resultsLabel.font? \(cell.resultsLabel.font)")
        }
        
       
  
        
        
        
        if labels[indexPath.row] == "Start" {   //set default date for picker!
            toggleDatepicker()

            cell.datePicker.date = defaults.objectForKey("startDT")! as! NSDate
        } else if labels[indexPath.row] == "End" {
            toggleDatepicker()

            cell.datePicker.date = defaults.objectForKey("endDT")! as! NSDate
        }
        
        if labels[indexPath.row] == "Cal." {    //set default calendar for picker!
        }
        
        if labels[indexPath.row] == "List" {    //set
        }
        
        switch (results[indexPath.row]){
        case "Event":
            cell.resultsLabel.backgroundColor = swiftColor
             break;
        case "Reminder":
            cell.resultsLabel.backgroundColor = UIColor.yellowColor()
            break;
        case "New List", "List":
            cell.resultsLabel.backgroundColor = moccasin
            break;
        case "New OneItem List":
            cell.resultsLabel.backgroundColor = moccasin
            break;
        case "Phrase List":
            cell.resultsLabel.backgroundColor = apricot
            break;
        default:
            cell.resultsLabel.backgroundColor = UIColor.whiteColor()
            break;
        }
    
        print("p364 end cell: \(labels[indexPath.row]) ------------------------")
        print("--------------------------------------------")

     
        return cell
    }   // end func cellForRowAtIndexPath
    
//===== end cellForRowAtIndexPath ================================================
    
//===== didSelectRowAtIndexPath ================================================
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("p68 You selected cell #\(indexPath.row)!")
    
    //expand cell code...
        let previousIndexPath = selectedIndexPath
        if indexPath == selectedIndexPath {
            selectedIndexPath = nil
        } else {
            selectedIndexPath = indexPath
        }
        
//        var indexPaths : Array<NSIndexPath> = []
//        if let previous = previousIndexPath {
//            indexPaths += [previous]
//        }
//        if let current = selectedIndexPath {
//            indexPaths += [current]
//        }
//        if indexPaths.count > 0 {
//            tableView.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Automatic)
//        }
        
     // to here.
   
        tableView.beginUpdates()
        tableView.endUpdates()
        var selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        
       // let saffron = UIColor(red: 244, green: 208, blue: 63)  // 244, 208, 63
       // selectedCell.contentView.backgroundColor = saffron
        
        
        if labels[indexPath.row] == "Type" || labels[indexPath.row] == "Day" {
            // selectedCell.selectionStyle = UITableViewCellSelectionStyle.None
            
        }
        
        switch (labels[indexPath.row]){
            case "Input":                                       //selected Input row...
                self.tabBarController?.selectedIndex = 2        //go to main dictate microphone screen
                break;
                
            case "Title":
                var alert = UIAlertController(title: "Enter your new Title", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Continue", style: .Default, handler: { (action) -> Void in
                    
                    self.output = alert.textFields![0].text!
                    self.defaults.setObject(self.output, forKey: "output")                //sets output

                    print("p251 alert.textFields![0].text!: \(alert.textFields![0].text!)")
                    print("p251 self.output: \(self.output)")
                    
                    self.loadResultsArray()
                    self.tableV.reloadData()                    
                }))
            
                alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
                    self.tableV.reloadData()   //TODO Anil Mike best way to remove the highlighted row?
                }))
     
                alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
                    textField.placeholder = "Enter text:"
                    textField.secureTextEntry = false
                    
                    print("p230 textField.text: \(textField.text)")
                    self.output = textField.text!
                })
  
                self.presentViewController(alert, animated: true, completion: nil)
                break;
            
            case "Start":
                break;
            
            case "End":
                break;
            
            case "Cal.":
                print("p486 in didselect Cal. segue next")
                self.performSegueWithIdentifier("showCalPicker", sender: indexPath);
                break;
            
            case "List":    //todo Add reminder Picker Mike //Reminder
                break;
            

            case "Alert":
                
                var alert = UIAlertController(title: "Enter new Alert (in minutes)", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Continue", style: .Default, handler: { (action) -> Void in
                    
                    self.output = alert.textFields![0].text!
                    print("p442 self.output: \(self.output)")
                    
                    if let newAlertInterger = Int(self.output) {    //make sure it is only number entered
                        self.defaults.setObject(newAlertInterger, forKey:"eventAlert")    //sets eventAlert
                    }
                    
                    print("p446 alert.textFields![0].text!: \(alert.textFields![0].text!)")
                    print("p447 self.output: \(self.output)")
                    
                    self.loadResultsArray()
                    self.tableV.reloadData()
                    
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
                    self.tableV.reloadData()
                }))
                
                alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
                    textField.placeholder = "Enter minutes:"
                    textField.secureTextEntry = false
                    
                    print("p230 textField.text: \(textField.text)")
                    self.output = textField.text!
                })
                
                self.presentViewController(alert, animated: true, completion: nil)
                break;
            
            case "Repeat":
             
                var alert = UIAlertView()
                alert.delegate = self   //set the delegate of alertView
                
                //1 = daily, 2 = weekly, 3 = monthly, 4 = yearly, 99 = none
                
                alert.message = "Select new Repeatability"
                alert.addButtonWithTitle("None")
                alert.addButtonWithTitle("Every Day")
                alert.addButtonWithTitle("Every Week")
                alert.addButtonWithTitle("Every Month")
                alert.addButtonWithTitle("Every Year")
                alert.title = "Change Repeat to:"
                alert.show()
            
                repeatRow = indexPath.row
                
                // */
                print("p548 results[indexPath.row]: \(results[indexPath.row])")
      
            break;
            
            case "Locat.":
                var alert = UIAlertController(title: "Enter your new Location", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Continue", style: .Default, handler: { (action) -> Void in
                    
                    self.locationString = alert.textFields![0].text!
                    self.defaults.setObject(self.locationString, forKey: "eventLocation")                //sets eventLocation
                    
                    print("p251 alert.textFields![0].text!: \(alert.textFields![0].text!)")
                    print("p251 self.locationString: \(self.locationString)")
                    
                    self.loadResultsArray()
                    self.tableV.reloadData()
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
                    self.tableV.reloadData()   //TODO Anil Mike best way to remove the highlighted row?
                }))
                
                alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
                    textField.placeholder = "Enter Location:"
                    textField.secureTextEntry = false
                    
                    print("p230 textField.text: \(textField.text)")
                    self.locationString = textField.text!
                })
                
                self.presentViewController(alert, animated: true, completion: nil)
                break;

            
            
            default:   print("p471 end switch")
            break;
  
            
        }   //end switch
        
        
   }   // end func didSelectRowAtIndexPath

    func alertView(alertView: UIAlertView!, clickedButtonAtIndex buttonIndex: Int){
        print("p488 buttonIndex: \(buttonIndex)")
        
        var eventRepeatInterval = 0

        switch buttonIndex{
        case 0:
            results[repeatRow] = "None"
            eventRepeatInterval = 99
        case 1:
            results[repeatRow] = "Every Day"
            eventRepeatInterval = 1
        case 2:
            results[repeatRow] = "Every Week"
            eventRepeatInterval = 2
        case 3:
            results[repeatRow] = "Every Month"
            eventRepeatInterval = 3
        case 4:
            results[repeatRow] = "Every Year"
            eventRepeatInterval = 4
        default:
            break
        }
        
        //save for processing in event Manager if user hits create button
       // defaults.setObject(results[repeatRow], forKey: "eventRepeat")  //sets repeat interval for Events  // Anil did
        
        defaults.setObject(eventRepeatInterval, forKey: "eventRepeat")  //sets repeat interval for Events
        
        print("p577 results: \(results)")
       // results.removeAtIndex(repeatRow)
        print("p578 results: \(results)")

       // results.insert(results[repeatRow], atIndex: indexPath)
        
       // self.loadResultsArray()
        self.tableV.reloadData()

    }
    
//===== end didSelectRowAtIndexPath ================================================
    
    //MARK: DetailsTableViewCellDateSelectionDelegate
    
    //TODO: Update startDT and endDT in results array
    func didSelectDate(date:NSDate, inCell cell:DetailsTableViewCell){

        if labels[selectedIndexPath!.row] == "Start"{
            // Start date selected
            let newStartDate = date
            print("p568 newStartDate: \(newStartDate)")
            defaults.setObject(newStartDate, forKey: "startDT")
         
        } else {      //End date selection
            let newEndDate = date
            print("p570 newEndDate: \(newEndDate)")
            let newStartDate = defaults.objectForKey("startDT")! as! NSDate
            var newDuration: Double = 0.0
            
            let durationInt = NSCalendar.currentCalendar().components(.Minute, fromDate: newStartDate, toDate: newEndDate, options: []).minute

            newDuration = Double(durationInt)
            defaults.setObject(newDuration, forKey: "eventDuration")
        }
    
        let dateFormatter =  NSDateFormatter()
        dateFormatter.dateFormat = "M-dd-yyyy h:mm a"
        let dateString = dateFormatter.stringFromDate(date)

        results.removeAtIndex(selectedIndexPath!.row)
        results.insert(dateString, atIndex: selectedIndexPath!.row)
    }

    
    /*
    //no idea here...
    func eventEditViewController(controller: EKEventEditViewController,
        didCompleteWithAction action: EKEventEditViewAction) {
            print("did complete: \(action.rawValue), \(controller.event)")
            self.dismissViewControllerAnimated(true, completion: nil)
    }
   */ 
// End TABLE funcs...
//==================================================================================
    
    func loadResultsArray() {
        
        let strRaw      = defaults.stringForKey("strRaw")                   //Input
        let actionType  = defaults.stringForKey("actionType")!              //Type
        let day         = defaults.stringForKey("day")                      //Day
        let phone       = defaults.stringForKey("phone")                    //Cell#
        let startDT     = defaults.objectForKey("startDT")! as! NSDate      //Start
        let endDT       = defaults.objectForKey("endDT")! as! NSDate        //End
        let output      = defaults.stringForKey("output")                   //Title
        var calendarName = defaults.stringForKey("calendarName")            //Cal.
        let alert       = defaults.objectForKey("eventAlert") as! Int ?? 10 //Alert
        let eventRepeat = defaults.stringForKey("eventRepeat")              //Repeat
        let eventLocation = defaults.stringForKey("eventLocation") ?? ""    //Location

        
        var alertString = ""
        
        if (alert == 0){
            alertString = ""
        } else {
            alertString = "\(String(alert)) minutes"
        }
 
        results = ["\"\(strRaw!)\"", actionType, day!, time, phone!, fullDT, fullDTEnd, output!, calendarName!, alertString, eventRepeat!, eventLocation]
        print("p705 results: \(results)")
    }
    
    
//#### End my functions #################################
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
        // self.tableViewOutlet.reloadData()

        //tableV.reloadData()
        
        let alertSound3: NSURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("se_tap", ofType: "m4a")!)
        //General.playSound(alertSound3!)
        
        playSound(alertSound3)
        
        // Do any additional setup after loading the view.
        let strRaw      = defaults.stringForKey("strRaw")                   //Input
        var actionType  = defaults.stringForKey("actionType")!              //Type
        var day         = defaults.stringForKey("day")                      //Day
        let phone       = defaults.stringForKey("phone")                    //Cell#
        let startDT     = defaults.objectForKey("startDT")! as! NSDate      //Start
        let endDT       = defaults.objectForKey("endDT")! as! NSDate        //End
        var output      = defaults.stringForKey("output")                   //Title
        var calendarName = defaults.stringForKey("calendarName")            //Cal.
        let alert       = defaults.objectForKey("eventAlert") as? Int ?? 10 //Alert
        var eventRepeat = defaults.stringForKey("eventRepeat") ?? ""            //Repeat
        let eventLocation = defaults.stringForKey("eventLocation") ?? ""    //Location

        
        let formatter3 = NSDateFormatter()
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
  
        let outputNote  = defaults.stringForKey("outputNote")
        let duration    = defaults.objectForKey("eventDuration") as! Int ?? 10
        
        let wordArrTrimmed  = defaults.objectForKey("wordArrTrimmed") as! [String] //array of the items
        
        //TODO Mike Anil commented to fix nil error
        // var reminderArray = defaults.objectForKey("reminderArray") as! [String] //array of the items
        
        let reminderTitle   = defaults.stringForKey("reminderTitle")
        let reminderArray:[String] = []
        let reminderList   = defaults.stringForKey("reminderList")
        let reminderAlarm  = defaults.objectForKey("reminderAlarm")! as! NSDate
    
        let allDayFlag  = defaults.objectForKey("allDayFlag") as! Bool
        let defaultCalendarID  = defaults.stringForKey("defaultCalendarID")
        let defaultReminderID = defaults.stringForKey("defaultReminderID")
        let processNow = defaults.objectForKey("ProcessNow") as! Bool
        
        print("p111Main ===================================")
        print("p111Main results: \(results)")
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
        print("p111Main eventLocation: \(eventLocation)")
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
        
        switch (eventRepeat) {  // 1 = daily, 2 = weekly, 3 = monthly, 4 = yearly, 99 = none I made this to pass then change later in event method
            //lol changed from the numner to the word!
            case "1": eventRepeat   = "Every Day";   break;
            case "2": eventRepeat   = "Every Week";   break;
            case "3": eventRepeat   = "Every Month";   break;
            case "4": eventRepeat   = "Every Year";   break;
                
            default:   print("p760 no repeat word matched")
            break;
        }
        
        

        switch (actionType){
        case "Reminder":
            print("p315 actionType: \(actionType)")
            let reminderTitle  = defaults.stringForKey("reminderTitle") ?? ""

            buttonCreateOutlet.setTitle("   Create Reminder", forState: UIControlState.Normal)
            buttonCreateOutlet.backgroundColor = UIColor.yellowColor()
     
            if ( fullDT == "12-12-2014 12:00 AM" ) {        // added 072315 no need to show if no date used
                fullDT = ""
                fullDTEnd = ""
            }
            
            if ( fullDTEnd == "12-12-2014 12:00 AM" ) {        // added 030416 no need to show EndDate for alarm case
                fullDTEnd = ""
            }
            
           
            output = reminderTitle
            calendarName = reminderList!
            
            labelCal   = "List"    // default Cal.
            
            print("p337 output: \(output)")
            print("p337 calendarName: \(calendarName)")

            if fullDT != "12-12-2014 12:00 AM" {       // means a Remminder Alarm
                //labelAlert = "Alarm"                  // default Alert
                labelAlert = ""                         // default Alert
                labelStart = "Alarm"
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
            buttonCreateOutlet.setTitle("   Create \r New List", forState: UIControlState.Normal)

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
            buttonCreateOutlet.setTitle("  Create \r New List", forState: UIControlState.Normal)
            
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
            buttonCreateOutlet.setTitle("      Create \r Phrase List", forState: UIControlState.Normal)
            output = reminderTitle
            
            let stringOutput = wordArrTrimmed.joinWithSeparator(", ")
            day = stringOutput
            
            labelDay       = "Title"   // default Day
            labelTitle     = "Items"   // default Time
            
            output     = stringOutput
            day        = reminderTitle
            
            alertString = ""
            fullDT = ""
            fullDTEnd = ""
            calendarName = ""

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
  
        labels = [labelInput, labelType, labelDay, labelTime, labelCell, labelStart, labelEnd, labelTitle, labelCal, labelAlert, labelRepeat, labelLocation]
        
        results = ["\"\(strRaw!)\"", actionType, day!, time, phone!, fullDT, fullDTEnd, output!, calendarName!, alertString, eventRepeat, eventLocation]
        
        print("p555 labels: \(labels)")
        print("p555 results: \(results)")
        
        tableViewHeightConstraint.constant = CGFloat((rowsToShow * 35) + (additionalRows * 35) )   //anil added
        tableV.reloadData()
        
        print("**** p546 tableViewHeightConstraint.constant: \(tableViewHeightConstraint.constant)")
        tableV.layoutIfNeeded()
        
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
        
        self.tableV.reloadData()
        
        //Added left and Right Swipe gestures. TODO Can add this to the General.swift Class? and call it?
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(DetailTableVC.handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(DetailTableVC.handleSwipes(_:)))
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
        
        let alertSound1 = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("217-buttonclick03", ofType: "mp3")!)
        //  General.playSound(alertSound3!)
        playSound(alertSound1)
        
        let actionType:String    = defaults.stringForKey("actionType")!
        print("p237 vcTest1, actionType: \(actionType)")
        
        switch (actionType){
            
// ____ Reminder Case buttonCreate____________________________________
        case "Reminder":
            print("p242 in Reminder Switch")
            
            titleRowHeight = 27.5
            
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
                
                if #available(iOS 9.0, *) {
                    ReminderManagerSave.sharedInstance.addReminder(calendarName, items: outputArray)
                } else {
                    // Fallback on earlier versions
                }    //fixed check FIXWC
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
                    
                    if #available(iOS 9.0, *) {
                        ReminderManagerSave.sharedInstance.addReminder(calendarName, items: outputArray)    //fixed check FIXWC
                    } else {
                        // Fallback on earlier versions
                    }
                    
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
                
                if #available(iOS 9.0, *) {
                    ReminderManagerSave.sharedInstance.createNewReminderList(calendarName, items: outputArray)
                } else {
                    // Fallback on earlier versions
                }  //fixed check FIXWC
                
                self.messageString = "☑️Reminder created on your New: \"\(calendarName.capitalizedString)\" list!"
            }
            
            break;
            
// ____ Event Case ____________________________________
        case "Event":
            print("p255 in Event Switch")
            
            EventManagerSave().createEvent()    //fixed check FIXWC
            calendarName = defaults.stringForKey("calendarName")!            //Cal.
            self.messageString = "📅 Event created on your: \"\(calendarName.capitalizedString)\" calendar!"
            break;
            
// ____ New List, List Case ____________________________________
        case "New List", "List" :
            print("p530 in list Switch")
            
            if #available(iOS 9.0, *) {
                ReminderManagerSave.sharedInstance.createNewReminderList(calendarName, items: wordArrTrimmed)
            } else {
                // Fallback on earlier versions
            }   //fixed check FIXWC
            var reminderList = defaults.stringForKey("reminderList")
            self.messageString = "📝 New List: \(reminderList!), created!"
            break;
            
// ____ New OneItem List ____________________________________
        case  "New OneItem List" :
            print("p543 in New OneItem List Switch")
            
            var calendarName    = defaults.stringForKey("reminderList") //Sets Reminder Title
            
            output      = defaults.stringForKey("output")!
            var outputArray:[String] = Array(arrayLiteral: output)
            
            if #available(iOS 9.0, *) {
                ReminderManagerSave.sharedInstance.createNewReminderList(calendarName!, items: outputArray)
            } else {
                // Fallback on earlier versions
            } //fixed check FIXWC
            self.messageString = "📝 New List: \"\(calendarName!)\", created!"
            break;
            
// ____ Phrase List ____________________________________
        case "Phrase List":
            print("p638 in phraseList Switch")
            
            var calendarName    = defaults.stringForKey("calendarName") //Sets Reminder Title
            var wordArrTrimmed  = defaults.objectForKey("wordArrTrimmed") as! [String] //array of the items
            
            if #available(iOS 9.0, *) {
                ReminderManagerSave.sharedInstance.createNewReminderList(calendarName!, items: wordArrTrimmed)
            } else {
                // Fallback on earlier versions
            }  //fixed check FIXWC
            self.messageString = "📝 New Phrase List: \"\(calendarName!)\", created!"
            break;
            
        case "Note":
            print("p152 in note Switch")
            break;
            
        default:
            print("p155 in default switch so assume Event")
            
            EventManagerSave().createEvent()    //fixed check FIXWC
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
            
            self.tabBarController?.selectedIndex = 2        //go back to main Dictate start screen
            
        }
        
        resetToDefaults()   //reset labels and all to defaults
        
    }   //end ButtonCreate
    
    
    @IBAction func buttonCancel(sender: AnyObject) {
        print("p898 in buttonCancel")
        
        tableV.reloadData()
        titleRowHeight = 27.5

        let alertSound124 = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("124-DeleteWhoosh", ofType: "mp3")!)
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
        self.tabBarController?.selectedIndex = 2            //go back to main Dictate start screen
        
        resetToDefaults()   //reset labels and all to defaults
        
    }   //end buttonCancel
    
    @IBAction func backFromModal(segue: UIStoryboardSegue) {
        print("p1219 and we are back to DetailTableVC")
        // Switch to the second tab (tabs are numbered 0, 1, 2)
        self.tabBarController?.selectedIndex = 1
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


