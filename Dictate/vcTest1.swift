//
//  vcTest1.swift
//  WatchInput
//
//  Created by Mike Derr on 6/14/15.
//  Copyright (c) 2015 ThatSoft.com. All rights reserved.
//

import UIKit
import EventKit
import Parse
import AVFoundation

class vcTest1: UIViewController {
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var audioPlayer = AVAudioPlayer()
    


    
    // Create a MessageComposer
    let messageComposer = MessageComposer()

 //   @IBOutlet weak var resultStartDate: UITextField!
    
 //   @IBOutlet weak var resultEndDate: UITextField!
    

 //   let defaults = NSUserDefaults.standardUserDefaults()
 //   resultStartDate = defaults.stringForKey("startDT")

    @IBOutlet weak var resultType: UITextField!
    @IBOutlet weak var resultDay: UITextField!
    @IBOutlet weak var resultTime: UITextField!
    @IBOutlet weak var resultPhone: UITextField!
    @IBOutlet weak var resultStartDate: UITextField!
    @IBOutlet weak var resultEndDate: UITextField!
    @IBOutlet weak var resultTitle: UITextField!
    @IBOutlet weak var resultCalendar: UITextField!
    
    @IBOutlet weak var resultAlert: UITextField!
    @IBOutlet weak var resultRepeat: UITextField!

    @IBOutlet weak var resultMessage: UITextView!
    @IBOutlet weak var resultError: UITextView!
    
    //@IBOutlet weak var resultRaw: UITextView!
    
    // to fix bomb  7-2-15 @IBOutlet var resultDur: UITextField!
    
    let eventStore = EKEventStore()
    
    @IBOutlet weak var buttonCreateOutlet: UIButton!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    let mainType:String     = NSUserDefaults.standardUserDefaults().stringForKey("mainType") ?? "Event"
    var actionType:String   = NSUserDefaults.standardUserDefaults().stringForKey("actionType") ?? "Event"
    
    
//#### my functions #################################

    
    func switchScreen(scene: String) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier(scene) as! UIViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func displayAlert(title: String, message: String) {
        
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
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
        audioPlayer = AVAudioPlayer(contentsOfURL: sound, error: &error)
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
    

//#### End my functions #################################

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Added left adn Right Swipe gestures. TODO Can add this to the General.swift Class? and call it?
        var leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        var rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        leftSwipe.direction = .Left
        rightSwipe.direction = .Right
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)

        // moved all to viewWillAppear...
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
        var alertSound3: NSURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("se_tap", ofType: "m4a")!)!
        //General.playSound(alertSound3!)
        
        playSound(alertSound3)

        // Do any additional setup after loading the view.
        
        println("****p83 VIEWDIDLOAD processed?????: \(self.actionType)")
        
        println("p85Main self.actionType: \(self.actionType)")
        
        let day         = defaults.stringForKey("day")
        let phone       = defaults.stringForKey("phone")
        
        let startDT     = defaults.objectForKey("startDT")! as! NSDate
        let endDT       = defaults.objectForKey("endDT")! as! NSDate
        var output      = defaults.stringForKey("output")
        let outputNote  = defaults.stringForKey("outputNote")
        let duration    = defaults.stringForKey("eventDuration")
        
        var calendarName    = defaults.stringForKey("calendarName")
        
        let alert       = defaults.objectForKey("eventAlert") as! Double
        let repeat      = defaults.stringForKey("eventRepeat")
        
        let strRaw      = defaults.stringForKey("strRaw")
        
        let actionType:String  = defaults.stringForKey("actionType")!
        
        println("p111Main day: \(day)")
        println("p111Main phone: \(phone)")
        println("p111Main startDT: \(startDT)")
        println("p111Main endDT: \(endDT)")
        println("p111Main output: \(output)")
        println("p111Main outputNote: \(outputNote)")
        println("p111Main duration: \(duration)")
        println("p111Main calandarName: \(calendarName)")
        println("p111Main alert: \(alert)")
        println("p111Main repeat: \(repeat)")
        println("p111Main strRaw: \(strRaw)")
        
        println("p111Main mainType: \(mainType)")
        println("p111Main actionType: \(actionType)")
        
        println("p119Main Representation: \(NSUserDefaults.standardUserDefaults().dictionaryRepresentation())")
        
        // println("p121Main keys.array: \(NSUserDefaults.standardUserDefaults().dictionaryRepresentation().keys.array)")
        
        // println("p123Main values.array: \(NSUserDefaults.standardUserDefaults().dictionaryRepresentation().values.array)")
        
        var formatter3 = NSDateFormatter()
        formatter3.dateFormat = "M-dd-yyyy h:mm a"
        fullDT = formatter3.stringFromDate(startDT)
        fullDTEnd = formatter3.stringFromDate(endDT)
        
        resultMessage.text = strRaw
        resultType.text = actionType
        // resultRaw.text = outputNote
        resultDay.text = day
        resultTime.text = timeString
        resultPhone.text = phone
        resultStartDate.text = fullDT
        resultEndDate.text = fullDTEnd
        resultTitle.text = output
        // TODO Anil next line bombs not sure why! I did like others simple label lol
        
        //resultDur.text = "test"    // BOMBS HHY????
        
        println("p137 actionType: \(actionType)")
        println("p138 resultType.text: \(resultType.text)")
        
        resultCalendar.text = calendarName
        
        let alertAsInt = Int(alert)               // to format 10.0  to 10  for minutes result
        
        //TODO could add an "userAlertString to NSUSerDefaults to display here better, "2 hours", "1 day", etc...
        // or a better way besides using NSUserDefualts? Data processed in DictateCode.swift... and passed vs NSUSerDefaults at present.
        
        if (alert == 0.0){
            resultAlert.text = ""
        } else {
            resultAlert.text = "\(String(alertAsInt)) minutes"
        }
        
        if (repeat == "0") {
            resultRepeat.text = ""
        } else {
            resultRepeat.text = repeat
        }
        
        if (timeString == "00:00 PM") {
            resultTime.text = ""
        } else {
            resultTime.text = timeString
        }
        
        
        
        //With the extension
        let newSwiftColor = UIColor(red: 255, green: 165, blue: 0)
        let lightPink = UIColor(red: 255, green: 204, blue: 255)
        let swiftColor = UIColor(red: 255, green: 165, blue: 0)
        
        
        
        
        switch (actionType){
        case "Reminder":
            resultType.backgroundColor = UIColor.yellowColor()
            buttonCreateOutlet.setTitle("Create Reminder", forState: UIControlState.Normal)
            buttonCreateOutlet.backgroundColor = UIColor.yellowColor()
            if ( resultStartDate.text == "12-12-2014 12:00 AM" ) {        // added 072315 no need to show if no date used
                resultStartDate.text = ""
            }
            resultCalendar.text = ""
            resultEndDate.text = ""
            
            break;
        case "Event":
            resultType.backgroundColor = swiftColor
            buttonCreateOutlet.setTitle("Create Event", forState: UIControlState.Normal)
            buttonCreateOutlet.backgroundColor = swiftColor
            break;
            
        case "List":        resultType.backgroundColor = UIColor.redColor(); break;
        case "CommaList":   resultType.backgroundColor = UIColor.cyanColor(); break;
            /*
            case "Text":
            resultType.backgroundColor = UIColor.cyanColor()
            buttonCreateOutlet.setTitle("Send Text", forState: UIControlState.Normal)
            buttonCreateOutlet.backgroundColor = UIColor.cyanColor()
            
            break;
            */
        default:
            resultType.backgroundColor = swiftColor
            buttonCreateOutlet.setTitle("Create Event", forState: UIControlState.Normal)
            buttonCreateOutlet.backgroundColor = swiftColor
            
            break;
        }
     
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
  
    
    @IBAction func buttonCreate(sender: AnyObject) {
        
        var alertSound1 = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("217-buttonclick03", ofType: "mp3")!)
      //  General.playSound(alertSound3!)
        
      playSound(alertSound1!)

        
        // CHECK Do I have to call this again??? else 12/12/2014 event
        //Don't need to parse again? commented out 7/4/15 8 am

        //let (startDT, endDT, output, outputNote, day, calendarName) = DictateCode().parse(str)
        
        //println("### pl240 startDT: \(startDT)")
        
       // let defaults = NSUserDefaults.standardUserDefaults()
       var actionType:String    = defaults.stringForKey("actionType")!
        
        println("p237 vcTest1, actionType: \(actionType)")
        
        //actionType = "Reminder"
        
        switch (actionType){
        case "Reminder":
            println("p242 in Reminder Switch")
            //createReminder()                      // worked with nothing in func call??? why?
            
            let title:String = output
            //let notes:String = outputNote
            
            //ReminderCode().createReminder(title, notes: notes, startDT: startDT)
            ReminderCode().createReminder()

            resultMessage.text = "Reminder created on your \(calendarName.capitalizedString) list"
            break;
            
        case "Event":
            println("p255 in Event Switch")
            
// TODO MIKE  remove this parsing again! pass with NSUser Data in method
         //   let (startDT, endDT, output, outputNote, day, calendarName, actionType) = DictateCode().parse(str)
            
 
            //DictateCode().insertEvent(eventStore, startDT: startDT, endDT: endDT, output: output, outputNote: outputNote, calendarName: calendarName )
            
            EventCode().createEvent()

            resultMessage.text = "Event created on your \(calendarName.capitalizedString) calendar!"
            break;
            
        case "List":
            println("p150 in list Switch")
            break;
        case "CommaList":
            println("p151 in commaList Switch")
            break;
        case "Note":
            println("p152 in note Switch")
            break;
            
        default:
            println("p155 in default switch so assume Event")
            
            //TODO MIke add back fixed call...
            //DictateCode().insertEvent(eventStore, startDT: startDT, endDT: endDT, output: output, outputNote: outputNote, calendarName: calendarName )
            EventCode().createEvent()
            
            resultMessage.text = "Event created on your \(calendarName.capitalizedString) calendar!"
            break;
        }
        
        var strRaw      = defaults.stringForKey("strRaw")
        output      = defaults.stringForKey("output")!
        calendarName    = defaults.stringForKey("calendarName")!

        
        println("p485 strRaw: \(strRaw)")
        println("p485 output: \(output)")
        println("p485 outputNote: \(outputNote)")
        println("p485 fullDT: \(fullDT)")
        println("p485 fullDTEnd: \(fullDTEnd)")
        println("p485 calendarName: \(calendarName)")
        println("p485 actionType: \(actionType)")
        
        if (fullDT == "12-12-2014 12:00 AM") {      // set to "" for database
            fullDT = ""
            fullDTEnd = ""
        }
        
        let rawDataObject = PFObject(className: "UserData")
        rawDataObject["rawString"] = strRaw
        rawDataObject["output"] = output
        rawDataObject["fullDT"] = fullDT
        rawDataObject["fullDTEnd"] = fullDTEnd
        rawDataObject["actionType"] = actionType
        rawDataObject["calendarName"] = calendarName
        
//TODO get these two fields from code!
        rawDataObject["device"] = "iPhone"               //TODO hardcoded get device from code?
        rawDataObject["userPhoneNumber"] = "608-242-7700"               //TODO hardcoded get device from code?
        
    //TODO get this from login Screen, hard coded for now...
        
        println("p349 PFUser.currentUser(): \(PFUser.currentUser())")
        
    //TODO fix PFuser when is nil can be nil???

        if PFUser.currentUser() == nil {
            rawDataObject["userName"] = "Mike Coded"
        } else {
            rawDataObject["userName"] = PFUser.currentUser()?.username
        }
        //rawDataObject["userName"] = "Mike Coded"
        
    // TODO used to have this alone:  rawDataObject["userName"] = PFUser.currentUser()?.username

        
        
        var query = PFQuery(className:"UserData")
    //TODO somehow get and save email to parse database
       // query.whereKey(“username”, equalTo: PFUser.currentUser()?.username)
        
        println("p358 query: \(query)")

        println("p354 PFUser.currentUser()?.email: \(PFUser.currentUser()?.email)")
        
       // rawDataObject["userEmail"] = PFUser.currentUser()?.email

        rawDataObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            println("p362 vcTest1 rawDataObject has been saved.")
        }

        

        General().cleardata()
        resultType.text = ""
     //   resultRaw.text = ""
        resultDay.text = ""
        resultTime.text = timeString
        resultPhone.text = phone
        resultStartDate.text = fullDT
        resultEndDate.text = fullDTEnd
        resultTitle.text = ""
        // error below TODO
       // resultDuration.text = ""
        resultCalendar.text = ""
        resultAlert.text = ""
        resultRepeat.text = ""
        
         defaults.setObject(eventDuration, forKey: "eventDuration")

        //resultMessage.text = "Event created on your \(calendarName.capitalizedString) calendar!"
        
        //resultMessageTopRight.text = "Dicatate has created your event :) "
        
        resultError.text = ""
        
        actionType = ""
        defaults.setObject(actionType, forKey: "actionType")
        
       
        
        General().delay(3.0) {
            // do stuff
            self.resultMessage.text = ""
            self.resultError.text = ""
            //self.switchScreen("tabBarController")
            
            self.tabBarController?.selectedIndex = 2
            
        }
    }

    
    @IBAction func buttonEdit(sender: AnyObject) {
        
       // switchScreen("EditEvent")
        //switchScreen()

    }
    

    @IBAction func buttonCancel(sender: AnyObject) {
        
        println("p383 in buttonCancel")
        
        var alertSound124 = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("124-DeleteWhoosh", ofType: "mp3")!)
        //  General.playSound(alertSound3!)
        
        playSound(alertSound124!)

        General().cleardata()
        
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
        
        self.tabBarController?.selectedIndex = 2
  
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension UIColor
{
    convenience init(red: Int, green: Int, blue: Int)
    {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
}

extension vcTest1 : UITextFieldDelegate {
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
}

