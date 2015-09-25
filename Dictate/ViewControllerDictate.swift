//
//  ViewController.swift
//  Parse v1
//
//  Created by Mike Derr on 5/6/15.
//  Copyright (c) 2015 ThatSoft.com. All rights reserved.
//

import UIKit
import EventKit
import MessageUI
import Parse
import AVFoundation

var enteredText = String()

let str1:String = "new appointment tomorrow 2 AM sandra for efficiency for fall 242-1234"

let str2:String = "appointment tuesday 11 am ben for 2 bedroom for fall 4147651234"

// ---- these from siri translation----

let str3:String = "New appointment 11 AM today show apartment with Sandi"

let str9:String = "New appointment at 2 PM with Sandi next Wednesday"

let str4:String = "Appointment at 1:30 PM to see efficiency with Tony 608-255-9876"

let str5:String = "Appointment this Friday to see a two bedroom for John 608-255-0885 for a two bedroom for two people for the fall"

let str6:String = "Appointment for an efficiency with Mary next Monday at 2:30 414-308-1234"

let str7:String = "New appointment next Tuesday, April 14 to see inefficiency for Brenda 608-123-4567"

let str8:String = "new List, Shave and shower, call invisible fence, rental deposits, leave for Adra Dan, play tennis, program an app"      // Comma sperated phrases list test from siri

let str14:String = "appointment Test xCode today 2:10 pm work calendar 608-242-7722"

let str15:String = "appointment today 2:10 am Show Apartment to John 6082427744 duration five minutes calendar work alert 5 minutes"      // Comma sperated phrases list test from siri

let str16:String = "appointment next Sunday 12 pm Pilot Band Show at SunSet Grill duration four hours calendar Mike alert one day"

let str17:String = "Appointment today 2:00 pm repeat weekly calendar Mike Call Mom"

let str18:String = "Reminder Mike Call Mom Today repeat daily for 3 days"

let str19:String = "Text Mike Call Bob later today 608-123-4557"

let str20:String = "Mail Mom subject comming home for holiday, I will come hone on June 6"

let str21:String = "Text mom Tom Jon let's all meet for a meeting tonight at 8 PM"

let str22:String = "Mail mom Tom Jon let's all meet for a meeting tonight at 8 PM subject let's all meet"

let str23:String = "Stephanie I will be home at 5 PM send text"

let str24:String = "Stephanie I will be home at 5 PM send message"

let str25:String = "Message wife I will be home at 1:15 am"

let str26:String = "Email my wife I am buying us a new truck and will need you to put $2000 into our bank account by 5 PM today. Thank you so much. I love you Tony"

let str27:String = "new list groceries cheese milk carrots lettace eggs"

let str28:String = "new todo call mom, meeting at 10 AM, play tennis, pick up kids"

let str29:String = "Reminder Wash the car tonight"

let str30:String = "Reminder go to the bank list today"    // test to see if added to list "today"

let str31:String = "todo today, call mom, meeting at 10 AM, play tennis, pick up kids" // comma deliminaed list, first phrase or word before comma is title
let str32:String = "list shower work workout dinner sleep"  //raw list one word speed list, ""untitled list"

let str33:String = "Reminder go to the store list to do tomorrow"    // test to see if new list "to do downtown" is created

let str34:String = "Reminder go play tennis list test"    // test to see if new list "to do downtown" is created

let str35a:String = "Reminder go to the store list new unmatched title"    // test to see if new list "to do downtown" is created

let str35:String = "Reminder go to the store list new list title"    // test to see if new list "to do downtown" is created

let str36:String = "Reminder Mike Call Mom Today repeat daily for 3 days" //TODO MAKE THIS WORK MIKE

let str37:String = "Appointment today 3:00 pm repeat monthly calendar Mike Call Mom"

let str38:String = "Reminder mow the grass today 1 pm list today"  // bombs

let str39:String = "4:55 test to calendar calendar Mike duration 90 minutes alert one hour"

let str40:String = "11 am test after restore"

let str41:String = "reminder buy milk"

let str42:String = "Tomorrow 9 PM Band calendar Mike duration 4 hours "

let str43:String = "Tomorrow 9 PM at Essen Haus Josh Becker Band calendar Mike duration 4 hours "

/*    ADD TEST THESE make them work...TODO Mike

“meeting with Bob every Wednesday at 2:00 PM”

add to dictate str   “meeting with Bob every Wednesday at noon”  //handle word noon as 12:00 pm

“meeting with Bob every month at 2:00 PM Wednesday”

“meeting with Bob every year at 2:00 PM July 3"

*/

// ---- change strings here for testing, shows on the dictated field---
//var str:String = str42
var str:String = ""

//var strRaw:String = str

// ---- set Global Varbiables ----
var time:String         = ""
var mainType:String     = ""
var aptType:String      = ""
var phone:String        = ""
var day:String          = ""
var date:String         = ""
var fullDT:String       = ""
var fullDTEnd:String    = ""
var todayDay:String     = ""
var timestamp:String    = ""
var word:String         = ""
var timeString:String   = ""
var endTime:NSDate      = NSDate()

var today:NSDate        = NSDate()

var wordArr             = []

var output:String       = ""
var outputRaw:String    = ""
var outputNote:String   = ""
var calendarName:String = ""

var messageOut:String   = ""

var resultProcessed:String  = ""
//var resultRaw:String        = ""
var resultStartDate:String  = ""
var resultEndDate:String    = ""
var resultTitle:String      = ""
var resultCalendar:String   = ""

var eventDuration:Double    = 10

//TODO add this as a preference

var now = ""

// ---- end set Global Varbiables ----


class ViewControllerDictate: UIViewController, UITextFieldDelegate, MFMailComposeViewControllerDelegate {
    
    let defaults = NSUserDefaults(suiteName: "group.com.thatsoft.dictateApp")!
    
     var audioPlayer = AVAudioPlayer()
    
    // Create a MessageComposer
    let messageComposer = MessageComposer()
    
//    defaults.setObject(eventDuration, forKey: "eventDuration")
    
    @IBOutlet weak var enteredText: UITextView!     //this is under the micophone graphic
    // @IBOutlet weak var resultProcessed: UITextView!
    //@IBOutlet weak var resultRaw: UITextView!
    
    
    @IBOutlet weak var enteredText2: UITextView!        //larger grey text field.
    
    //@IBOutlet weak var enteredText: UITextField!
    @IBOutlet weak var resultType: UITextField!
    
    @IBOutlet weak var resultMessage: UITextView!
    @IBOutlet weak var resultMessageTopRight: UITextView!
    
    @IBOutlet weak var error: UITextView!
    
    @IBOutlet weak var resultDate: UITextField!
    @IBOutlet weak var resultTime: UITextField!
    @IBOutlet weak var resultPhone: UITextField!
    @IBOutlet weak var resultStartDate: UITextField!
    @IBOutlet weak var resultEndDate: UITextField!
    @IBOutlet weak var resultTitle: UITextField!
    @IBOutlet weak var resultCalendar: UITextField!    
    
    @IBOutlet weak var resultError: UITextView!

    
    var startDT:NSDate = NSDate(dateString:"2014-12-12")
    var endDT:NSDate = NSDate(dateString:"2014-12-12")
    
    var output:String       = ""
    var outputNote:String   = ""
    var day:String          = ""
    var calendarName:String = ""
    
    var database = EKEventStore()
    var napid : String!
    
    
    
    //---- Event Guy functions ----------------------------------------
    
    
    // got from https://github.com/mattneub/Programming-iOS-Book-Examples/blob/master/bk2ch19p725calendar/ch32p986calendar/ViewController.swift
    
    // TODO need to call this func yet I think... had good dialog.
    
    func determineStatus() -> Bool {
        let type = EKEntityTypeEvent
        let stat = EKEventStore.authorizationStatusForEntityType(type)
        switch stat {
        case .Authorized:
            return true
        case .NotDetermined:
            self.database.requestAccessToEntityType(type, completion:{_,_ in})
            return false
        case .Restricted:
            return false
        case .Denied:
            // new iOS 8 feature: sane way of getting the user directly to the relevant prefs
            // I think the crash-in-background issue is now gone
            let alert = UIAlertController(title: "Need Authorization", message: "Wouldn't you like to authorize this app to use your Calendar?", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "No", style: .Cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {
                _ in
                let url = NSURL(string:UIApplicationOpenSettingsURLString)!
                UIApplication.sharedApplication().openURL(url)
            }))
            self.presentViewController(alert, animated:true, completion:nil)
            return false
        }
    }
    
    
    
    
    func calendarWithName( name:String ) -> EKCalendar? {
        let calendars = self.database.calendarsForEntityType(EKEntityTypeEvent) as! [EKCalendar]
        for cal in calendars { // (should be using identifier)
            if cal.title == name {
                return cal
            }
        }
        println ("failed to find calendar")
        return nil
    }
    
    func switchScreenOld() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("eventDetails") as! UIViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func switchScreenTester() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("eventTester") as! UIViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func switchScreen(scene: String) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier(scene) as! UIViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    
    
    
    
    
//---- my General functions ----------------------------------------
    
    func cleardata() {
        println("ViewController 262 we here cleardata: \(date)")
        
        date = ""
        phone = ""
        fullDT = ""
        fullDTEnd = ""
      //  output = ""
        
        
        resultType.text = ""
        resultDate.text = ""
        resultTime.text = ""
        resultPhone.text = ""
        resultStartDate.text = ""
        resultEndDate.text = ""
        resultTitle.text = ""
        resultCalendar.text = ""
        
        enteredText2.text = ""
    }
    
    func removeKeyboard() {
        enteredText.resignFirstResponder()
        enteredText2.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldDidBeginEditing(enteredText: UITextField){
        
        //Put a break point here and test
    
    }
    
    func handleSwipes(sender:UISwipeGestureRecognizer) {
        if (sender.direction == .Left) {
            self.tabBarController?.selectedIndex = 3
        }
        if (sender.direction == .Right) {
            var alertSound3: NSURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("122-whoosh03", ofType: "mp3")!)!
            //General.playSound(alertSound3!)
            playSound(alertSound3)
            self.tabBarController?.selectedIndex = 1
        }
    }
    
    
    
//---- end my Gerneral functions -------------------------------------
    
//---- Override functions --------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NSLog("%@ p326 DictateVC viewDidLoad", self)
        
        println("p328 we here? viewDidLoad viewController")
        
        //Added left adn Right Swipe gestures. TODO Can add this to the General.swift Class? and call it?
        var leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        var rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        leftSwipe.direction = .Left
        rightSwipe.direction = .Right
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
        
        let testObject = PFObject(className: "TestObject")
        testObject["foo"] = "does send?"
        testObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            println("Object has been saved.")
        }
        
        //...
        
        self.tabBarController?.selectedIndex = 2
                
        //enteredText.delegate = self

        
        // 1
        let eventStore = EKEventStore()
        
        // 2
        switch EKEventStore.authorizationStatusForEntityType(EKEntityTypeEvent) {
        case .Authorized:
            println("p176 Access Authorized")
            //insertEvent(eventStore)
        case .Denied:
            println("Access denied")
        case .NotDetermined:
            // 3
            eventStore.requestAccessToEntityType(EKEntityTypeEvent, completion:
                {[weak self] (granted: Bool, error: NSError!) -> Void in
                    if granted {
                        //self!.insertEvent(eventStore)
                        println("p186 Access Authorized")
                    } else {
                        println("Access denied")
                    }
                })
        default:
            println("Case Default")
        }


//#### for testing comment out besides for simulator in xCode
        
        println("p375 str: \(str)")

        enteredText2.text = str        // comment out besides for simulator in xCode
        resultMessage.text = str
       

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.determineStatus()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "determineStatus", name: UIApplicationWillEnterForegroundNotification, object: nil)
        
        var alertSound218 = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("218-buttonclick54", ofType: "mp3")!)
        //  General.playSound(alertSound3!)
        
        playSound(alertSound218!)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//---- End Override functions ----------------------------------------
    
    func playSound(sound: NSURL){
        var error:NSError?
        audioPlayer = AVAudioPlayer(contentsOfURL: sound, error: &error)
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    
    
    //#### functions end ##############################
    
    @IBAction func buttonProcess(sender: AnyObject) {
        
        var alertSound1 = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("se_tap", ofType: "m4a")!)
        //  General.playSound(alertSound3!)
        playSound(alertSound1!)

        //cleardata()
        
        let strRaw = enteredText.text
        println("827 strRaw: \(strRaw)")
        
        resultMessage.text = strRaw
        
        if ( enteredText.text != "" ) {
            str = enteredText.text
        } else {
            str = enteredText2.text
        }
        
        println("### 684 str: \(str)")
        
        // CALL main parsing of string...  Only call this here once! Check TODO Mike...
        
        let (startDT, endDT, output, outputNote, day, calendarName, actionType) = DictateCode().parse(str)
        
        removeKeyboard()

        // Added get actionType from func above 7/6/15
        //actionType    = defaults.stringForKey("actionType")!
        
        println("p419 DictateScene, actionType: \(actionType)")
        
// ____ actionType Text ____________________________________
        
        
        switch (actionType) {
        case "Text":
            println("p397 in Text Switch")

            resultMessage.text = "Switching to iMessage for your text"
            
            let rawDataObject = PFObject(className: "UserData")
            rawDataObject["actionType"] = actionType
            rawDataObject["rawString"] = outputNote
            rawDataObject["output"] = output
            rawDataObject["userName"] = PFUser.currentUser()?.username
            
            //TODO get these two fields from code!
            rawDataObject["device"] = "iPhone"               //TODO hardcoded get device from code?
            rawDataObject["userPhoneNumber"] = "608-242-7700"               //TODO hardcoded get device from code?
            
            rawDataObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                println("p433 vcDictate rawDataObject has been saved.")
            }
            
            // Make sure the device can send text messages
            if (messageComposer.canSendText()) {
                // Obtain a configured MFMessageComposeViewController
                let messageComposeVC = messageComposer.configuredMessageComposeViewController()
                
                // Present the configured MFMessageComposeViewController instance
                // Note that the dismissal of the VC will be handled by the messageComposer instance,
                // since it implements the appropriate delegate call-back
                presentViewController(messageComposeVC, animated: true, completion: nil)
                
            } else {
                // Let the user know if his/her device isn't able to send text messages
                let errorAlert = UIAlertView(title: "Cannot Send Text Message", message: "Your device is not able to send text messages.", delegate: self, cancelButtonTitle: "OK")
                errorAlert.show()
            }
            
            enteredText2.text = ""      // set to blank for return
            resultMessage.text = ""     // set to blank for return
            
            //let actionType = ""         // set to "" for next processing
            let mainType = ""
            defaults.setObject(actionType, forKey: "actionType")        //saves actionType
            defaults.setObject(actionType, forKey: "mainType")        //saves actionType
            
        break;
        
        
        case "Call":
            println("p431 in Call Switch")
            
            resultMessage.text = "Switching to Phone for your call"
    
            let toPhone:String    = defaults.stringForKey("toPhone")!
            
            if let url = NSURL(string: "tel://\(toPhone)") {
                UIApplication.sharedApplication().openURL(url)
            }
        
            enteredText2.text = ""      // set to blank for return
            resultMessage.text = ""     // set to blank for return
            
            //let actionType = ""         // set to "" for next processing
            let mainType = ""
            defaults.setObject(actionType, forKey: "actionType")        //saves actionType
            defaults.setObject(actionType, forKey: "mainType")        //saves actionType
            
            let rawDataObject = PFObject(className: "UserData")
             rawDataObject["actionType"] = actionType
            rawDataObject["rawString"] = outputNote
            rawDataObject["userName"] = PFUser.currentUser()?.username
            
            //TODO get these two fields from code!
            rawDataObject["device"] = "iPhone"               //TODO hardcoded get device from code?
            rawDataObject["userPhoneNumber"] = "608-242-7700"               //TODO hardcoded get device from code?
            
            rawDataObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                println("p490 vcDictate rawDataObject has been saved.")
            }
            
        break;


        case "Mail":
            println("p456 in Mail Switch")
            
            resultMessage.text = "Switching to Mail for your mail"
            
            let mailComposeViewController = MailComposer3().configuredMailComposeViewController()
            if MFMailComposeViewController.canSendMail() {
                self.presentViewController(mailComposeViewController, animated: true, completion: nil)
            } else {
                MailComposer3().showSendMailErrorAlert()
            }
            
            println("p485 after MailComposer call")

            enteredText2.text = ""      // set to blank for return
            resultMessage.text = ""     // set to blank for return
            
            //let actionType = ""         // set to "" for next processing
            let mainType = ""
            defaults.setObject(actionType, forKey: "actionType")        //saves actionType
            defaults.setObject(actionType, forKey: "mainType")        //saves actionType

            let rawDataObject = PFObject(className: "UserData")
            rawDataObject["actionType"] = actionType
            rawDataObject["rawString"] = outputNote
            rawDataObject["output"] = output
            rawDataObject["userName"] = PFUser.currentUser()?.username
            
            //TODO get these two fields from code!
            rawDataObject["device"] = "iPhone"               //TODO hardcoded get device from code?
            rawDataObject["userPhoneNumber"] = "608-242-7700"               //TODO hardcoded get device from code?
            
            rawDataObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                println("p523 vcDictate rawDataObject has been saved.")
            }

        break;
            
        default:
            println("p573 Switch Default")
            
        }   //end Switch

        
        if ( (actionType != "Call") && (actionType != "Text") && (actionType != "Mail") ) {     // call does not need to see details screen
            
            enteredText2.text = ""      // set to blank for return

            General().delay(0.5) {
                // do stuff
                 //self.switchScreen("EventDetails")
                
                tabBarController?.selectedIndex = 1
                
            }
        }
}   // end func buttonProcess

     
    @IBAction func buttonToday(sender: AnyObject) {
         switchScreen("Today")
        
    }
    
    
    @IBAction func buttonEdit(sender: AnyObject) {
       EventCode().createEvent()
        
        switchScreen("Event")
        
    }
    
    @IBAction func buttonCancel(sender: AnyObject) {
        
        cleardata()
    }
    
    
}   // end ViewController


extension ViewControllerDictate : UITextFieldDelegate {
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
}


