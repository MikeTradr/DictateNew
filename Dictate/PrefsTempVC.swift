//
//  PrefsTempVC.swift
//  Dictate
//
//  Created by Mike Derr on 7/11/15.
//  Copyright (c) 2015 ThatSoft.com. All rights reserved.
//

// picker from:  http://makeapppie.com/tag/uipickerview-in-swift/

import UIKit
import Parse
import AVFoundation

class PrefsTempVC: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let userDefaultDuration:Double = 0.0
  
    var audioPlayer = AVAudioPlayer()
    
    @IBOutlet weak var prefsDefaultCalendar: UITextField!
    
    @IBOutlet weak var prefsDefaultDuration: UITextField!
    
    @IBOutlet weak var myLabel: UILabel!
    
    @IBOutlet weak var pickerCalendars: UIPickerView!
    
    
// TODO  get calendars from users, and make into array hard coded at prsent 7-17-15
    let pickerData = ["User Default Calendar","Mike","Work","Steph","Bands","Birthdays","Reacurring","Dictate Events"]
    
    func playSound(sound: NSURL){
        var error:NSError?
        audioPlayer = AVAudioPlayer(contentsOfURL: sound, error: &error)
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }

    func removeKeyboard() {
        prefsDefaultCalendar.resignFirstResponder()
        prefsDefaultDuration.resignFirstResponder()
    }
    
    func textFieldShouldReturn(prefsDefaultDuration: UITextField) -> Bool {
        prefsDefaultDuration.resignFirstResponder()
        return true;
    }
    
    func switchScreen(scene: String) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier(scene) as! UIViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func handleSwipes(sender:UISwipeGestureRecognizer) {
        if (sender.direction == .Left) {
            self.tabBarController?.selectedIndex = 1
        }
        if (sender.direction == .Right) {
            var alertSound3: NSURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("122-whoosh03", ofType: "mp3")!)!
            //General.playSound(alertSound3!)
            playSound(alertSound3)
            
            self.tabBarController?.selectedIndex = 4
        }
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Added left adn Right Swipe gestures. TODO Can add this to the General.swift Class? and call it?
        var leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        var rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        leftSwipe.direction = .Left
        rightSwipe.direction = .Right
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)

        
        pickerCalendars.delegate = self
        pickerCalendars.dataSource = self

        self.prefsDefaultCalendar.delegate = self
        self.prefsDefaultDuration.delegate = self
        
        let defaults = NSUserDefaults.standardUserDefaults()

        self.prefsDefaultCalendar.text = defaults.stringForKey("prefsDefaultCalendarName")
        
        
        println("p27 prefsDefaultCalendar.text: \(prefsDefaultCalendar.text)")
        println("p30 prefsDefaultDuration.text: \(prefsDefaultDuration.text)")
        
        let userDefaultDuration = (prefsDefaultDuration.text as NSString).doubleValue
        
        defaults.setObject(prefsDefaultCalendar.text, forKey: "calendarName")
        defaults.setObject(userDefaultDuration, forKey: "eventDuration")
        
        let seeEventDuration:Double    = defaults.objectForKey("eventDuration") as! Double
        
        println("p59 seeEventDuration from NSdefaults: \(seeEventDuration)")
        
        
        let calendarName    = defaults.stringForKey("calendarName")
        println("p62 calandarName: \(calendarName)")
        
        self.myLabel.text = defaults.stringForKey("prefsDefaultCalendarName")

    //TODO hard coded to row 3, set to the default user Calendar item!
        self.pickerCalendars.selectRow(2, inComponent: 0, animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        var alertSound3: NSURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("262-buttonclick57", ofType: "mp3")!)!
        //General.playSound(alertSound3!)
        playSound(alertSound3)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func buttonUpdatePrefs(sender: AnyObject) {
        
        
        
        
        let defaults = NSUserDefaults.standardUserDefaults()
       // defaults.setObject(prefsDefaultCalendar.text, forKey: "prefsDefaultCalendarName")
        
        println("p97 myLabel.text: \(myLabel.text)")

        defaults.setObject(myLabel.text, forKey: "prefsDefaultCalendarName")
        
        let testPrefsCal = defaults.stringForKey("prefsDefaultCalendarName")
        
        println("p103 testPrefsCal: \(testPrefsCal)")
        
        println("p105 userDefaultDuration: \(userDefaultDuration)")

        
        
        defaults.setObject(userDefaultDuration, forKey: "eventDuration")
        
        let seeEventDuration:Double    = defaults.objectForKey("eventDuration") as! Double
        
        println("p91 seeEventDuration from NSdefaults: \(seeEventDuration)")
        
        
        let calendarName    = defaults.stringForKey("calendarName")
        
        let seeCalendar:String = defaults.stringForKey("calendarName") ?? "Steph"
        
        defaults.setObject(seeCalendar, forKey: "calendar")

        
        println("p95 seeCalendar: \(seeCalendar)")
        
        
        println("p108Main Representation: \(NSUserDefaults.standardUserDefaults().dictionaryRepresentation())")

        
        
        //self.switchScreen("tabBarController")
        
        tabBarController?.selectedIndex = 2

        
    }
    
    
    @IBAction func buttonLogout(sender: AnyObject) {
        
        //TODO Mike add Parse databse logout code.
        
    //    PFUser.logOut()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("Login") as! UIViewController
        self.presentViewController(vc, animated: true, completion: nil)
        
        //self.performSegueWithIdentifier("login", sender: self)
    
           // self.loginSetup()
            
        }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - Delegates and datasources
    //MARK: Data Sources
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    //MARK: Delegates
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        myLabel.text = pickerData[row]
    }
    
 // TODO Set a better non serif font! system font!!!!
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = pickerData[row]
        var myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Geneva", size: 15.0)!,NSForegroundColorAttributeName:UIColor.blueColor()])
        return myTitle
    }
    
    
// TODO set background color to match color of users Calendars please!!!!!
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
        var pickerLabel = view as! UILabel!
        if view == nil {  //if no label there yet
            pickerLabel = UILabel()
            
            //color  and center the label's background
            let hue = CGFloat(row)/CGFloat(pickerData.count)
            pickerLabel.backgroundColor = UIColor(hue: hue, saturation: 1.0, brightness:1.0, alpha: 1.0)
            pickerLabel.textAlignment = .Center
            
        }
        let titleData = pickerData[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 26.0)!,NSForegroundColorAttributeName:UIColor.blackColor()])
        pickerLabel!.attributedText = myTitle
        
        return pickerLabel
        
    }
    
 // TODO check sizes for smaller phones! and font size etc... make look great!
    
    //size the components of the UIPickerView
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 36.0
    }
    
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 300
    }
    
    
    
    
    
    
}


extension PrefsTempVC : UITextFieldDelegate {
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
}


