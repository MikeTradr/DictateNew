//
//  DictateViewController.swift
//  Dictate
//
//  Created by Mike Derr on 5/6/15.
//  Copyright (c) 2015 ThatSoft.com. All rights reserved.
//

import UIKit
import EventKit
import MessageUI
import Parse
import AVFoundation
import AudioToolbox         //needed for Nuance? or no?
import SystemConfiguration   //needed for Nuance? or no?

//var enteredText = String()

let str1:String = "new appointment tomorrow 2 AM sandra for efficiency for fall 242-1234"

let str2:String = "appointment tuesday 11 am ben for 2 bedroom for fall 4147651234"

// ---- these from siri translation----

let str3:String = "New appointment 11 AM today show apartment with Sandi"

let str9:String = "New appointment at 2 PM with Sandi next Wednesday"

let str4:String = "Appointment at 1:30 PM to see efficiency with Tony 608-255-9876"

let str5:String = "Appointment this Friday 2 pm to see a two bedroom for John 608-255-0885 for a two bedroom for two people for the fall"

let str6:String = "Appointment for an efficiency with Mary next Monday at 2:30 414-308-1234"

let str7:String = "New appointment next Tuesday, April 14 to see inefficiency for Brenda 608-123-4567"

let str8:String = "new List, Shave and shower, call invisible fence, rental deposits, leave for Adra Dan, play tennis, program an app"      // Comma sperated phrases list test from siri

let str14:String = "appointment Test xCode today 2:10 pm work calendar 608-242-7722"

let str15:String = "appointment today 2:10 am Show Apartment to John 6082427744 at 1132 Johnson street duration five minutes calendar work alert 5 minutes"      // Comma sperated phrases list test from siri

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

let str27:String = "new list groceries cheese milk carrots lettace eggs"    // new list

let str28:String = "new todo, call mom, meeting at 10 AM, play tennis, pick up kids" //phrase list. "todo" is title

let str29:String = "Reminder Wash the car tonight"

let str30:String = "Reminder go to the bank list today"    // test to see if added to list "today"

let str31:String = "todo today, call mom, meeting at 10 AM, play tennis, pick up kids" // comma deliminated list, first phrase or word before comma is title
let str32:String = "list shower work workout dinner sleep"  //raw list one word speed list, title = "untitled list"

let str33:String = "Reminder go to the store list to do tomorrow"    // test to see if new list "to do downtown" is created

let str34:String = "Reminder go play tennis list test"    // test to see if new list "to do downtown" is created

let str35a:String = "Reminder go to the store list new unmatched title"    // test to see if new list "to do downtown" is created

let str35:String = "Reminder go to the store list new list title"    // test to see if new list "to do downtown" is created

let str36:String = "Reminder Mike Call Mom Today repeat daily for 3 days" //TODO MAKE THIS WORK MIKE

let str37:String = "Appointment today 3:00 pm repeat monthly calendar Mike Call Mom"

let str38:String = "Reminder mow the grass today 1 pm list today"

let str39:String = "4:55 test to calendar calendar Mike duration 90 minutes alert one hour"

let str40:String = "11 am test after restore"

let str41:String = "reminder buy milk"

let str42:String = "Tomorrow 6 PM duration 4 hours Dress Rehersal alert 30 minutes"

let str43:String = "Tomorrow 9 PM at Essen Haus Josh Becker Band calendar Mike duration 4 hours "

let str44:String = "Mail bro list work"

let str45:String = "Mail mike events"

let str46:String = "Mail mike list default"

let str47:String = "Today all day Program Dictate calendar Mike"

let str48:String = "Reminder wash the car"

let str49:String = "tomorrow all day study for exam calendar Mike"

let str50:String = "Monday all day study for exam"

let str51:String = "6 am test alert 44 minutes"

let str52:String = "reminder shovel snow"

let str53:String = "call mike"

let str54:String = "8 am go see the doctor"

let str55:String = "8 am go see the doctor go to the gym go to the bank go to the office"

let str56:String = "list this that other thing"

let str57:String = "list this that other thing adjective"

let str58:String = "8 am meeting"

let str59:String = "Reminder meeting 10 am alert 1 hour"




















//BOMBS test n fix Mike TODO MIKE, from Siri

let str100:String = "Thursday 12 PM meet lunch with Rob calendar Mike duration one hour alert one hour"
 

/*    ADD TEST THESE make them work...TODO Mike

“meeting with Bob every Wednesday at 2:00 PM”

add to dictate str   “meeting with Bob every Wednesday at noon”  //handle word noon as 12:00 pm

“meeting with Bob every month at 2:00 PM Wednesday”

“meeting with Bob every year at 2:00 PM July 3"

*/

// ---- change strings here for testing, shows on the dictated field---
var str:String = str59
//var str:String = ""

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

var eventDuration:Int       = 10

//TODO add this as a preference

var now = ""

// ---- end set Global Varbiables ----


class DictateViewController: UIViewController, UITextFieldDelegate, MFMailComposeViewControllerDelegate, SpeechKitDelegate, SKRecognizerDelegate, SKVocalizerDelegate {
    
    var voiceSearch: SKRecognizer?
    
    var earconStart: SKEarcon = SKEarcon.earconWithName("earcon_listening.wav") as! SKEarcon
    var earconStop: SKEarcon = SKEarcon.earconWithName("earcon_done_listening.wav") as! SKEarcon
    var earconCancel: SKEarcon = SKEarcon.earconWithName("earcon_cancel.wav") as! SKEarcon
    
    var isSpeaking: Bool = false

    let defaults = NSUserDefaults(suiteName: "group.com.thatsoft.dictateApp")!
    
     var audioPlayer = AVAudioPlayer()
    
    // Create a MessageComposer
    let messageComposer = MessageComposer()
    
//    defaults.setObject(eventDuration, forKey: "eventDuration")
    
  //  @IBOutlet weak var enteredText: UITextView!     //this is under the micophone graphic
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
    
    @IBOutlet weak var vuMeter: UIView! //yellwo meter Bro for voice level!
   
    @IBOutlet weak var labelRecording: UILabel!
    
    @IBOutlet weak var labelReadIt: UIButton!

    
    var startDT:NSDate = NSDate(dateString:"2014-12-12")
    var endDT:NSDate = NSDate(dateString:"2014-12-12")
    
    var output:String       = ""
    var outputNote:String   = ""
    var day:String          = ""
    var calendarName:String = ""
    
    var database = EKEventStore()
    var napid: String!
    
    var width: Float = 0
    
    var transactionState:String = ""
    var actionType = ""


    
    
    
    //---- Event Guy functions ----------------------------------------
    
    
    // got from https://github.com/mattneub/Programming-iOS-Book-Examples/blob/master/bk2ch19p725calendar/ch32p986calendar/ViewController.swift
    
    // TODO need to call this func yet I think... had good dialog.
    
    func determineStatus() -> Bool {
        let type = EKEntityType.Event
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
        let calendars = self.database.calendarsForEntityType(EKEntityType.Event) 
        for cal in calendars { // (should be using identifier)
            if cal.title == name {
                return cal
            }
        }
        print ("failed to find calendar")
        return nil
    }
    
    func switchScreenOld() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("eventDetails") 
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func switchScreenTester() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("eventTester") 
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func switchScreen(scene: String) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier(scene) 
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    
    
    
    
    
//---- my General functions ----------------------------------------
    
    func cleardata() {
        print("ViewController 262 we here cleardata: \(date)")
        
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
       // enteredText.resignFirstResponder()
        enteredText2.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    
    func handleSwipes(sender:UISwipeGestureRecognizer) {
        if (sender.direction == .Left) {
            self.tabBarController?.selectedIndex = 3
        }
        if (sender.direction == .Right) {
            var alertSound3: NSURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("122-whoosh03", ofType: "mp3")!)
            //General.playSound(alertSound3!)
            playSound(alertSound3)
            self.tabBarController?.selectedIndex = 1
        }
    }
    
    func autoProcess() {
        // ____ Auto Process ____________________________________
        let processNow = defaults.objectForKey("ProcessNow") as! Bool
        print("p379 processNow: \(processNow)")
        if (processNow == true) {
            print("p381 we here: \(processNow)")

            DetailTableVC()   //go to this class
        
       // enteredText2.text = ""      // set to blank for return
        }
    }

    
//---- From Nuance funcs ----------------------------------------------------------
//---- Speach to Text --------------
    
    func setVUMeterWidth (var width: CGFloat) {
        if width < 0 {
            width = 0
        }
        var frame: CGRect = vuMeter.frame
        frame.size.width = width + 5        //5 is initial bar width
        vuMeter.frame = frame
    }
    
    func updateVUMeter() {
        let width: CGFloat = ( 90 + CGFloat(voiceSearch!.audioLevel) * 5 / 2 ) * 4
       // let width: CGFloat = (90 + voiceSearch!.audioLevel) * 5 / 2
        self.setVUMeterWidth(width)
        self.performSelector("updateVUMeter", withObject: nil, afterDelay: 0.05)
    }
    
    func recognizerDidBeginRecording(recognizer: SKRecognizer) {
        NSLog("p402 recognizerDidBeginRecording Recording started.")
        var transactionState = "TS_RECORDING"
        
        labelRecording.text = "Recording..."
       // recordButton.setTitle("Recording...", forState: UIControlStateNormal)
        self.performSelector("updateVUMeter", withObject: nil, afterDelay: 0.05)
    }
    
    func recognizerDidFinishRecording(recognizer: SKRecognizer) {
        NSLog("p408 recognizerDidFinishRecording Recording finished.")
        NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: "updateVUMeter", object: nil)
        self.setVUMeterWidth(0)
        transactionState = "TS_PROCESSING"
        labelRecording.text = "Processing..."
    }
    
    func recognizer(recognizer: SKRecognizer!, didFinishWithResults results: SKRecognition!) {
    
        NSLog("p419 didFinishWithResults Got results.")
        NSLog("Session id [%@].", SpeechKit.sessionID())
        var numOfResults: Int = results.results.count
        transactionState = "TS_IDLE"
        labelRecording.text = ""
        
        enteredText2.text = results.firstResult()
        print("p421 enteredText2: \(enteredText2)")
        print("p422 enteredText2.text: \(enteredText2.text)")

//code for super auto create no button at all.
        
        var wordArrTemp = enteredText2.text.componentsSeparatedByString(" ")      //** use for SPACE seperated list, or phrases
        
        print("p427 wordArrTemp: \(wordArrTemp)")

        var lastElement:String = wordArrTemp.last!                          //last element in array
        lastElement = lastElement.lowercaseString
        
        if (lastElement == "go" || lastElement == "done" || lastElement == "create") {
            let str = enteredText2.text
            
            print("p432 we here???? lastElement: \(lastElement)")

            let (startDT, endDT, output, outputNote, day, calendarName, actionType) = DictateCode().parse(str)
            
            print("p449 we here????: \(lastElement)")
            
            General().delay(3.0) {
                // do stuff
                self.tabBarController?.selectedIndex = 1
                self.enteredText2.text = ""      // set to blank for return
            
            }

            //self.tabBarController?.selectedIndex = 1
            
        }
        
        var firstElement:String = wordArrTemp.first!                          //first element in array
        firstElement = firstElement.lowercaseString
        
        
        switch (firstElement) {
            case "call", "phone":
                self.actionType = "Call"
                let (startDT, endDT, output, outputNote, day, calendarName, actionType) = DictateCode().parse(str)
                General().delay(1.5) {  // delay to show text in dialog
                    self.buttonProcess(self)
                }
            break;
            
            case "text", "message":
                self.actionType = "Text"
                let (startDT, endDT, output, outputNote, day, calendarName, actionType) = DictateCode().parse(str)
                General().delay(1.5) {  // delay to show text in dialog
                    self.buttonProcess(self)
                }
            break;
            
            case "mail", "email":
                self.actionType = "Mail"
                let (startDT, endDT, output, outputNote, day, calendarName, actionType) = DictateCode().parse(str)
                General().delay(1.5) {  // delay to show text in dialog
                    self.buttonProcess(self)
                }
            break;
      

        default:
            print("p491 Switch firstElement")
            
        }   //end Switch
        
    
        if enteredText2.text == "" {
            labelReadIt.hidden = true   //hide read label at beginning as nothing to read
        } else {
            labelReadIt.hidden = false
        }

        voiceSearch = nil
    }

    func recognizer(recognizer: SKRecognizer!, didFinishWithError error: NSError!, suggestion: String!) {
        
        NSLog("p424 didFinishWithError Got error.")
       // NSLog("Session id [%@].", SpeechKit.sessionID())              //this crasehd app 012316 so commented out
        transactionState = "TS_IDLE"
        //recordButton.setTitle("Record", forState: UIControlStateNormal)
        
        if error != nil {
           let alert = UIAlertController(title: "Error", message: error.debugDescription, preferredStyle: UIAlertControllerStyle.Alert)
            //TODO Mike uncomment below for release, and comment above.
           // let alert = UIAlertController(title: "Error", message: "Problem to connecting to speech server. Try again", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
      //  voiceSearch.release()
        voiceSearch = nil
    }
    
//---- Read Text --------------
    
    func vocalizer(vocalizer: SKVocalizer, willBeginSpeakingString text: String) {
        isSpeaking = true
        labelReadIt.setTitle("Stop", forState: UIControlState.Normal)
       // if text {
       //     textReadSoFar.text = textReadSoFar.text.stringByAppendingString(text).stringByAppendingString("\n")
       // }
    }

  
    func vocalizer(vocalizer: SKVocalizer, willSpeakTextAtCharacter index: UInt, ofString text: String) {
        NSLog("Session id [%@].", SpeechKit.sessionID())
        //textReadSoFar.text = text.substringToIndex(index)
    }

    func vocalizer(vocalizer: SKVocalizer!, didFinishSpeakingString text: String!, withError error: NSError!) {
        NSLog("p453 didFinishSpeakingString")
        NSLog("Session id [%@].", SpeechKit.sessionID())
        isSpeaking = false
        labelReadIt.setTitle("speak your result", forState: UIControlState.Normal)
        //speakButton.setTitle("Read It", forState: UIControlStateNormal)
        
        if error != nil {
           // let alert = UIAlertController(title: "Error", message: error.debugDescription, preferredStyle: UIAlertControllerStyle.Alert)
            print("p465 error.debugDescription: \(error.debugDescription)")

        
            let alert = UIAlertController(title: "Error", message: "Problem to connecting to speech server. Try again", preferredStyle: UIAlertControllerStyle.Alert)

            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    
    
//---- END From Nuance funcs ----------------------------------------------------------
    

//---- end my Gerneral functions -------------------------------------
    
//---- Override functions --------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NSLog("%@ p326 DictateVC viewDidLoad", self)
        
        print("p328 we here? viewDidLoad viewController")
        
        //Setup SpeechKit
        SpeechKit.setupWithID("NMDPTRIAL_miketradr_gmail_com20151020235701", host: "sandbox.nmdp.nuancemobility.net", port: 443, useSSL: false, delegate: self)
        
        //TODO Anil TODO Mike UInt to Int Error here.
        SpeechKit.setEarcon(earconStart, forType: UInt(SKStartRecordingEarconType))
        SpeechKit.setEarcon(earconStop, forType: UInt(SKStopRecordingEarconType))
        SpeechKit.setEarcon(earconCancel, forType: UInt(SKCancelRecordingEarconType))
        
        if enteredText2.text == "" {
            labelReadIt.hidden = true   //hide read label at beginning as nothing to read
        } else {
             labelReadIt.hidden = false
        }
        
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
            print("Object has been saved.")
        }
        
        //...
        
        self.tabBarController?.selectedIndex = 2
                
        //enteredText.delegate = self

        
        // 1
        let eventStore = EKEventStore()
        
        // 2
        switch EKEventStore.authorizationStatusForEntityType(EKEntityType.Event) {
        case .Authorized:
            print("p176 Access Authorized")
            //insertEvent(eventStore)
        case .Denied:
            print("Access denied")
        case .NotDetermined:
            // 3
            eventStore.requestAccessToEntityType(EKEntityType.Event, completion: { (granted, error) -> Void in
                    if granted {
                        //self!.insertEvent(eventStore)
                        print("p186 Access Authorized")
                    } else {
                        print("Access denied")
                    }
                })
        default:
            print("Case Default")
        }


//#### for testing comment out besides for simulator in xCode
        
        print("p375 str: \(str)")

        enteredText2.text = str        // comment out besides for simulator in xCode
        resultMessage.text = str
       

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.determineStatus()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "determineStatus", name: UIApplicationWillEnterForegroundNotification, object: nil)
        
        var alertSound218 = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("218-buttonclick54", ofType: "mp3")!)
        //  General.playSound(alertSound3!)
        
        playSound(alertSound218)
        
        if enteredText2.text == "" {
            labelReadIt.hidden = true   //hide read label at beginning as nothing to read
        } else {
            labelReadIt.hidden = false
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//---- End Override functions ----------------------------------------

    func playSound(sound: NSURL){
        var error:NSError?
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL: sound)
            
        } catch  {
           
        }
   /*     } catch var error1 as NSError {
            error = error1
        }
*/
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }

//---- Nuance funcs -----------
 /*   func recognizerDidBeginRecording(recognizer: SKRecognizer!)
    {
        //The recording has started
    }
 
    func recognizerDidFinishRecording(recognizer: SKRecognizer!)
    {
        //The recording has stopped
    }
 
    func recognizer(recognizer: SKRecognizer!, didFinishWithResults results: SKRecognition!)
    {
        //The voice recognition process has understood something
        
//        var enteredText2 = SKRecognition()
    }

    func recognizer(recognizer: SKRecognizer!, didFinishWithError error: NSError!, suggestion: String!)
    {
        //an error has occurred
        print("p549 a SKRecognizer error has occurred")
    }
 */
    
    //#### functions end ##############################
    
    
    @IBAction func buttonMic(sender: AnyObject) {
        
        //TODO Bro, Anil, ADD call to Nuance voice here please. Thx Bro...
        // put results into var enteredText2 to show on screen!
        print("p484 mic button pressed")
        
        removeKeyboard()

        self.voiceSearch = SKRecognizer(type: SKSearchRecognizerType, detection: UInt(SKLongEndOfSpeechDetection), language:"eng-USA", delegate: self)

        print("p599 after SKRecognizer")
    }
    
    @IBAction func buttonReadIt(sender: AnyObject) {
        print("p604 button Read It pressed")
        
        removeKeyboard()
        
        let vocalizer = SKVocalizer(language: "en_US", delegate: self)
        
        if isSpeaking {
            vocalizer.cancel()
            isSpeaking = false
        } else {
            isSpeaking = true
            vocalizer.speakString(enteredText2.text)
            //textReadSoFar.text = ""
        }

        print("p617 after Read It Button")
    }
    
    
    
    @IBAction func buttonProcess(sender: AnyObject) {
        
        let alertSound1 = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("se_tap", ofType: "m4a")!)
        //  General.playSound(alertSound3!)
        playSound(alertSound1)

        //cleardata()
 /*
     //   let strRaw = enteredText.text
      //  print("827 strRaw: \(strRaw)")
        
     //   resultMessage.text = strRaw
*/
        if ( enteredText2.text != "" ) {
            str = enteredText2.text
            labelReadIt.hidden = false
        } else {
            labelReadIt.hidden = true   //hide read label at beginning as nothing to read
        }

        print("### 684 str: \(str)")
        
        // CALL main parsing of string...  Only call this here once! Check TODO Mike...
        
        let (startDT, endDT, output, outputNote, day, calendarName, actionType) = DictateCode().parse(str)
        
        removeKeyboard()

        // Added get actionType from func above 7/6/15
        //actionType    = defaults.stringForKey("actionType")!
        
        print("p419 DictateScene, actionType: \(actionType)")
        
        autoProcess()   //call autoProcess function
        
 /*
// ____ Auto Process ____________________________________
        let processNow = defaults.objectForKey("ProcessNow") as! Bool
        print("p712 processNow: \(processNow)")
        if (processNow == true) {
            vcTest1()   //go to this class
        
            enteredText2.text = ""      // set to blank for return
        }
*/
        
// ____ actionType Text ____________________________________
        
        switch (actionType) {
        case "Text":
            print("p397 in Text Switch")
            resultMessage.text = "Switching to iMessage for your text"
            
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
            
            General().saveToParse()
        break;
        
        case "Call":
            print("p431 in Call Switch")
            resultMessage.text = "Switching to Phone for your call"
    
            let toPhone:String    = defaults.stringForKey("toPhone")!
            
            if let url = NSURL(string: "tel://\(toPhone)") {
                UIApplication.sharedApplication().openURL(url)
            }
            
            //let actionType = ""         // set to "" for next processing
            let mainType = ""
            defaults.setObject(actionType, forKey: "actionType")        //saves actionType
            defaults.setObject(actionType, forKey: "mainType")        //saves actionType
            
            General().saveToParse()
        break;

        case "Mail":
            print("p456 in Mail Switch")
            resultMessage.text = "Switching to Mail for your mail"
            
            let mailComposeViewController = MailComposer().configuredMailComposeViewController()
            if MFMailComposeViewController.canSendMail() {
                self.presentViewController(mailComposeViewController, animated: true, completion: nil)
            } else {
                MailComposer().showSendMailErrorAlert()
            }
            
            print("p485 after MailComposer call")
            
            General().saveToParse()
        break;
            
        case "Mail List":
            print("p588 in Mail List Switch")
            resultMessage.text = "Switching to Mail for your mail"
            
            let mailComposeViewController = MailComposer().mailList()
            if MFMailComposeViewController.canSendMail() {
                self.presentViewController(mailComposeViewController, animated: true, completion: nil)
            } else {
                MailComposer().showSendMailErrorAlert()
            }
            
            print("p485 after MailComposer call")
            
            General().saveToParse()
        break;
            
        case "Mail Events":
            print("p632 in Mail Events Switch")
            resultMessage.text = "Switching to Mail for your mail"
            
            let mailComposeViewController = MailComposer().mailEvents()
            if MFMailComposeViewController.canSendMail() {
                self.presentViewController(mailComposeViewController, animated: true, completion: nil)
            } else {
                MailComposer().showSendMailErrorAlert()
            }
            
            print("p643 after MailComposer call")
            print("p616 actionType: \(actionType)")
            
            General().saveToParse()
        break;
       
        default:
            print("p573 Switch Default")
            
        }   //end Switch
        
        enteredText2.text = ""      // set to blank for return
        resultMessage.text = ""     // set to blank for return
        
       // General().saveToParse()         //call method to save data to parse DB.

        if ( (actionType != "Call") && (actionType != "Text") && (actionType != "Mail") ) {     // call does not need to see details screen
            
            enteredText2.text = ""      // set to blank for return

            General().delay(0.5) {
                // do stuff
                self.tabBarController?.selectedIndex = 1
            }
        }
}   // end func buttonProcess

     
    @IBAction func buttonToday(sender: AnyObject) {
         switchScreen("Today")
    }
    
    
    @IBAction func buttonEdit(sender: AnyObject) {
        EventManager().createEvent()
        switchScreen("Event")
    }
    
    @IBAction func buttonCancel(sender: AnyObject) {
        cleardata()
    }
    
}   // end ViewController


extension DictateViewController  {
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
}


