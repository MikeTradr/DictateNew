//
//  ToDoTableViewController.swift
//  Dictate
//
//  Created by Mike Derr on 6/22/15.
//  Copyright (c) 2015 ThatSoft.com. All rights reserved.
//
// did Anil do this code?
// 122415 mods by Mike, see comments... added the activityController code...


import UIKit
import EventKit
import EventKitUI
import AVFoundation

class ToDoTableViewController: UITableViewController,BFPaperCheckboxDelegate {

    var audioPlayer = AVAudioPlayer()
    
    var numberOfNewItems:Int    = 0
    var startDate:Date!
    var endDate:Date!
    var today:Date!
    var reminders:[EKReminder] = []
    var eventStore : EKEventStore = EKEventStore()
    lazy var dateFormatter:DateFormatter = {
        let _dateFormatter = DateFormatter()
        _dateFormatter.dateFormat = "dd-MM-yyyy"
        return _dateFormatter
        }()
    
    var selectionController:CalendarSelectionViewController!
    var showCompleted = false
    
    var listName:String = ""        //added by Mike 122415 for activityVC
    var listCount:String = ""       //added by Mike 122415 for activityVC
    var body:String = ""            //added by Mike 122415 for activityVC

    
    @IBOutlet var ToDoTableView: UITableView!
    
    @IBOutlet weak var reminderListButton: UIButton!
    @IBOutlet weak var listItemsNumberLabel: UILabel!
    
    @IBOutlet weak var showHideButton: UIButton!
    
    // TODO Anil get calendars from users, Add to array: All, Default, Last, +Array and make into array hard coded at prsent 7-17-15
    
    @IBAction func buttonReminderListSelector(_ sender: AnyObject) {
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewControllerWithIdentifier("ShowReminders") 
//        self.presentViewController(vc, animated: true, completion: nil)
        
        if (self.selectionController == nil){
            self.selectionController = self.storyboard!.instantiateViewController(withIdentifier: "CalendarSelectionViewController") as! CalendarSelectionViewController
        }
        let calendars = ReminderManager.sharedInstance.eventStore.calendars(for: EKEntityType.reminder)
        self.selectionController.calendarList = calendars;
//        self.selectionController.selectedCalendars = [self.reminder.calendar]
        self.selectionController.allowsMultipleSelection = false
        self.selectionController.shouldShowAll = true
        self.navigationController?.pushViewController(self.selectionController, animated: true)
        
    }
    
    
    
    @IBAction func shareButtonTapped(_ sender: AnyObject) {   //added by Mike 122415
        
    //TODO Anil, Mike need to give the data, maybe see the mail html format Mike does!
        
      //  let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()
      //  UIGraphicsEndImageContext()
        
      // let someText:String = "List: \(selectionController.selectedCalendars[0].title)"
/*
        if let _selectionController = self.selectionController where self.selectionController.selectedCalendars.count > 0{
            self.reminderListButton.setTitle("List: \(_selectionController.selectedCalendars[0].title) >", forState: .Normal)
            
            let someText:String = "List \(_selectionController.selectedCalendars[0].title) >"
            
            // let's add a String and an NSURL
            let activityViewController = UIActivityViewController(
                activityItems: [someText, someText],
                applicationActivities: nil)
            
            self.presentViewController(activityViewController, animated: true, completion: { () -> Void in
                
            })

        }
*/
        //remindersForTexting()
        
       remindersForMailing()

        
      //  let someText:String = "List: \(listName), \(listCount)"
        
        let mailSubjectText:String = "✉ List: \(listName) (\(listCount))"
        
        
      //  let url = NSURL(string: "http://thumbs.dreamstime.com/x/cocker-spaniel-illustration-20140870.jpg")!
        
        //let image : AnyObject = UIImage(named:"http://thumbs.dreamstime.com/x/cocker-spaniel-illustration-20140870.jpg")!
/*
        let url = NSURL(string: "http://thumbs.dreamstime.com/x/cocker-spaniel-illustration-20140870.jpg")
        let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
        var image = UIImage(data: data!)
*/

        // let's add a String and an NSURL
        let activityViewController = UIActivityViewController(
            //activityItems: [someText, body],
            //activityItems: [body, url, image!],
           // activityItems: [body, image!],


           activityItems: [body],
            
           // activityItems: [body,url],
            applicationActivities: nil)
        
        
        //New Excluded Activities Code
        activityViewController.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
        //
        
        activityViewController.setValue(mailSubjectText, forKey: "Subject") //set subject for mail
        
        activityViewController.completionWithItemsHandler = {(activityType, completed, returnedItems, activityError) -> Void in
            

            
            if !completed {
                print("p 125 cancelled")
                return
            }
            
            if activityType == UIActivityType.message {
                print("p130 text")
                self.remindersForTexting()
                self.body = self.body + "\r\n" + "💬 from Dictate™ App 😀"
            }
            
            if activityType == UIActivityType.mail {
                print("p136 mail")
                self.remindersForMailing()
                self.body = self.body + "\r\n" + "📩 Sent from Dictate™ App 😀" //use this for the mail case...
            }
            
            if activityType == UIActivityType.postToTwitter {
                print("p142 twitter")
                self.body = self.body + "\r\n" + "Tweeted from Dictate™ App 😀"
            }
            
            if activityType == UIActivityType.postToFacebook {
                print("p147 facebook")
                self.body = self.body + "\r\n" + "posted from Dictate™ App 😀"
            }
            
        }

        
        
        self.present(activityViewController, animated: true, completion: nil)
        
        activityViewController.completionWithItemsHandler = {(activityType, completed:Bool, returnedItems:[AnyObject]?, error: NSError?) in
            
            // Return if cancelled
            if !completed {
                print("p125 cancelled")
                return
            }
            
            if activityType == UIActivityType.message {
                print("p130 text")
                self.remindersForTexting()
                self.body = self.body + "\r\n" + "💬 from Dictate™ App 😀"
            }
            
            if activityType == UIActivityType.mail {
                print("p136 mail")
                self.remindersForMailing()
                self.body = self.body + "\r\n" + "📩 Sent from Dictate™ App 😀" //use this for the mail case...
            }
            
            if activityType == UIActivityType.postToTwitter {
                print("p142 twitter")
                self.body = self.body + "\r\n" + "Tweeted from Dictate™ App 😀"
            }
            
            if activityType == UIActivityType.postToFacebook {
                print("p147 facebook")
                self.body = self.body + "\r\n" + "posted from Dictate™ App 😀"
            }
            
            //activity complete
            //some code here
            
            
        }
        
        
   /*
   
        self.presentViewController(activityViewController, animated: true, completion: { () -> Void in
            
          // self.presentViewController(activityViewController.completionHandler, animated: true, completion: { () -> Void in
  
       //     self.presentViewController(activityViewController.completionHandler = {(activityType, completed:Bool) in
                
                activityViewController.excludedActivityTypes =  [
                    UIActivityTypePostToTwitter,
                    UIActivityTypePostToFacebook,
                    UIActivityTypePostToWeibo,
                   // UIActivityTypeMessage,
                   // UIActivityTypeMail,
                    UIActivityTypePrint,
                    UIActivityTypeCopyToPasteboard,
                    UIActivityTypeAssignToContact,
                    UIActivityTypeSaveToCameraRoll,
                    UIActivityTypeAddToReadingList,
                    UIActivityTypePostToFlickr,
                    UIActivityTypePostToVimeo,
                    UIActivityTypePostToTencentWeibo
                ]
            
        
        })
        
        
*/
   
        
    }
    

    
    
    
    


    
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: String) -> AnyObject? {
        if activityType == UIActivityType.message {
            return NSLocalizedString("Like this!", comment: "comment") as AnyObject?
        } else if activityType == UIActivityType.postToTwitter {
            return NSLocalizedString("Retweet this!", comment: "comment") as AnyObject?
        } else {
            return nil
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var viewController = self
        setStartDateAndEndDate()
        
        //Added left and Right Swipe gestures. TODO Can add this to the General.swift Class? and call it?
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(ToDoTableViewController.handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(ToDoTableViewController.handleSwipes(_:)))
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        showHideButton.setTitle("Show Completed", for: UIControlState())
        showHideButton.isSelected = true
        showCompleted = false
        
        fetchReminders()
        //Play sound
        var alertSound3: URL = URL(fileURLWithPath: Bundle.main.path(forResource: "button-14", ofType: "mp3")!)
        //General.playSound(alertSound3!)
//        playSound(alertSound3)
    }
    
    func remindersForTexting(){   //step throught reminders and format for texting activityViewController
        
        var numberOfItems:Int = self.reminders.count
        
        var alarmString = ""
        //  var firstAlarm:EKAlarm
        
        body = "List: \(listName) (\(listCount))" + "\r"
        
        //body = "<html><body>"
        //body = "\(body)<font size=\"6\" color=\"red\"><b>\(reminderListTitle.title)</b></font><br><hr> "
        
        for (index, title) in self.reminders.enumerated() {
            print("---------------------------------------------------")
            print("p191 index, title: \(index), \(title)")
            
            let item = self.reminders[index]
            print("p194 item.title: \(item.title)")
            
            let title = item.title
            //TODO Mike TODO Anil how do we get location from a Reminder? This worked forevent see func below!
            let location = item.location!
            
            let alarms = item.alarms
            let firstAlarm = alarms?[0]
            
            if item.alarms != nil {
                if !alarms!.isEmpty{
                    //you have atleast one alarm in that array
                    let firstAlarm = alarms![0]
                    print("p207 firstAlarm: \(firstAlarm)")
                }
            }
            
            print("p211 location: \(location)")
            
            if location != "" {
                
              //  body = "\(body)<font size=\"5\"><b>❑ \(title)</b></font><br><font color=\"gray\">Location:<br><i>\(location)</i></font><p>"+ "\r"
                
                body = "\(body)❑ \(title), Location: \(location)" + "\r"
            } else if firstAlarm != nil {
                
               // body = "\(body)<font size=\"5\"><b>❑ \(title)</b></font><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;🕑 \(firstAlarm)<p>"+ "\r"
                
                body = "\(body)❑ \(title), 🕑\(firstAlarm)" + "\r"
            } else {
                
               // body = "\(body)<font size=\"5\"><b>❑ \(title)</b></font><br><p>"
                body = "\(body)❑ \(title)" + "\r"
            }
            
        }       // end If loop through items...
        
       // body = body + "<br><hr><br>📩 Sent from Dictate™ App 😀</body></html>"
        body = body + "\r" + "💬 from Dictate™ App 😀"
        print("p306 body: \(body)")
        
    }
    
    func remindersForMailing(){   //step throught reminders and format for mailing activityViewController
        
        var numberOfItems:Int = self.reminders.count
        
        var alarmString = ""
        //  var firstAlarm:EKAlarm
        
        body = "List: \(listName) (\(listCount))" + "\r\n"
        
        //body = "<html><body>"
        //body = "\(body)<font size=\"6\" color=\"red\"><b>\(reminderListTitle.title)</b></font><br><hr> "
        
        for (index, title) in self.reminders.enumerated() {
            print("---------------------------------------------------")
            print("p273 index, title: \(index), \(title)")
            
            let item = self.reminders[index]
            print("p276 item.title: \(item.title)")
            
            let title = item.title
            //TODO Mike TODO Anil how do we get location from a Reminder? This worked forevent see func below!
            let location = item.location!
            
            let alarms = item.alarms
            let firstAlarm = alarms?[0]
            
            if item.alarms != nil {
                if !alarms!.isEmpty{
                    //you have atleast one alarm in that array
                    let firstAlarm = alarms![0]
                    print("p289 firstAlarm: \(firstAlarm)")
                }
            }
            
            print("p293 location: \(location)")
            
            if location != "" {
                
                //  body = "\(body)<font size=\"5\"><b>❑ \(title)</b></font><br><font color=\"gray\">Location:<br><i>\(location)</i></font><p>"+ "\r"
                
                body = "\(body)❑ \(title), Location: \(location)" + "\r\n"
            } else if firstAlarm != nil {
                
                // body = "\(body)<font size=\"5\"><b>❑ \(title)</b></font><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;🕑 \(firstAlarm)<p>"+ "\r"
                
                body = "\(body)❑ \(title), 🕑\(firstAlarm)" + "\r\n"
            } else {
                
                // body = "\(body)<font size=\"5\"><b>❑ \(title)</b></font><br><p>"
                body = "\(body)❑ \(title)" + "\r\n"
            }
            
        }       // end If loop through items...
        
        // body = body + "<br><hr><br>📩 Sent from Dictate™ App 😀</body></html>"
        
        body = body + "\r\n" + "📩 Sent from Dictate™ App 😀" //use this for the mail case...
        // body = body + "\r\n" + "💬 from Dictate™ App 😀"

        print("p368 body: \(body)")
        
        return
        
    }
    
    
    
    func fetchReminders(){
        if let _selectionController = selectionController , selectionController.selectedCalendars.count > 0{
            self.fetchRemindersFromCalendars(_selectionController.selectedCalendars, showComplted: showCompleted)
            
        }else{
            //Fatch all reminders
            self.fetchRemindersFromCalendars(showComplted:showCompleted)
        }
    }
    
    func fetchRemindersFromCalendars(_ calendars:[EKCalendar]? = nil, showComplted:Bool=false){
        
        ReminderManager.sharedInstance.fetchRemindersFromCalendars(calendars,includeCompleted:showComplted ) { (reminders) -> Void in
            self.reminders = reminders
            
            print("p76 self.reminders: \(self.reminders)")
            print("p77 self.reminders.count: \(self.reminders.count)")
            
            DispatchQueue.main.async(execute: { () -> Void in
                self.tableView.reloadData()
                self.setTabBarBadge()
                if let _selectionController = self.selectionController , self.selectionController.selectedCalendars.count > 0{
                    self.reminderListButton.setTitle("List: \(_selectionController.selectedCalendars[0].title) >", for: UIControlState())
                    
                    self.listName = "\(_selectionController.selectedCalendars[0].title)"    //for activityVC
                    
                }else{
                    self.reminderListButton.setTitle("List: All >", for: UIControlState())
                    self.listName = "All Lists" //for activityVC

                }
                
                self.listItemsNumberLabel.text = "\(self.reminders.count) items"
                self.listCount = "\(self.reminders.count) items"            //for activityVC
                
            })
        }
    }
    
    func setTabBarBadge(){
        let tabArray = self.tabBarController?.tabBar.items as NSArray!  //added by Mike 082315 here and viewDidLoad appear?
        let tabItem = tabArray?.object(at: 3) as! UITabBarItem              // set 4th tab item
        
        tabItem.badgeValue = String(self.reminders.count)
        
        //does this badge code work?
        
        self.tabBarItem.badgeValue = String(self.reminders.count)
        
        //Set the badge number to display              // added 082215 by Mike
        // TODO add this to the app start up, does not show when app loads.
        self.numberOfNewItems = reminders.count
        if (self.numberOfNewItems == 0) {
            self.tabBarItem.badgeValue = nil;
        } else {
            print("p60 we here? self.numberOfNewItems: \(self.numberOfNewItems)")
            self.tabBarItem.badgeValue = String(self.reminders.count)
        }
    }
    
    func setStartDateAndEndDate()
    {
        today = Date()
        let dateHelper = JTDateHelper()
        startDate =  dateHelper.add(to: today, months: -6)
        endDate = dateHelper.add(to: today, months: 6)
    }
    
    func createReminderDictionary(){
        
    }
    
    func playSound(_ sound: URL){       //Added by Mike 082215
        var error:NSError?
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: sound)
        } catch var error1 as NSError {
            error = error1
        }
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    
    func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        if (sender.direction == .left) {
            self.tabBarController?.selectedIndex = 4
        }
        if (sender.direction == .right) {
            self.tabBarController?.selectedIndex = 2
        }
    }
    
    
    // TODO trying to add a popover menu for the reminders lists...
    //http://stackoverflow.com/questions/24635744/how-to-present-popover-properly-in-ios-8
    
    // another tutorial on popover.
    //http://gracefullycoded.com/display-a-popover-in-swift/
    
    /*
    func addCategory() {
    
    var popoverContent = self.storyboard?.instantiateViewControllerWithIdentifier("NewCategory") as! UIViewController
    var nav = UINavigationController(rootViewController: popoverContent)
    nav.modalPresentationStyle = UIModalPresentationStyle.Popover
    var popover = nav.popoverPresentationController
    popoverContent.preferredContentSize = CGSizeMake(500,600)
    popover.delegate = self
    popover.sourceView = self.view
    popover.sourceRect = CGRectMake(100,100,0,0)
    
    self.presentViewController(nav, animated: true, completion: nil)
    
    }
    */
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminders.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:ToDoTableCell = tableView.dequeueReusableCell(withIdentifier: "ReminderCell") as! ToDoTableCell
        cell.selectionStyle = .none
        let reminder = reminders[(indexPath as NSIndexPath).row]
        cell.reminder = reminder
        cell.titleLabel.text = reminder.title
        cell.calendarName.text = reminder.calendar.title
        cell.calendarName.textColor = UIColor(cgColor: reminder.calendar.cgColor)
        cell.verticalBarView.backgroundColor = UIColor(cgColor: reminder.calendar.cgColor)
        cell.checkBox.tag = (indexPath as NSIndexPath).row
        cell.checkBox.delegate = self
        if reminder.isCompleted{
           cell.checkBox.check(animated: false)
        }
        
        return cell
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func paperCheckboxChangedState(_ checkbox: BFPaperCheckbox!) {
        let row = checkbox.tag
        let reminder = self.reminders[row]
        reminder.isCompleted = !reminder.isCompleted
        try? ReminderManager.sharedInstance.eventStore.save(reminder, commit: true)
//        fetchRemindersFromCalendars(nil, showComplted: <#T##Bool#>)
    }

    
    func indexPathForView(_ view: UIView) -> IndexPath? {
        let viewOrigin = view.bounds.origin
        
        let viewLocation = tableView.convert(viewOrigin, from: view)
        
        return tableView.indexPathForRow(at: viewLocation)
    }
    
    @IBAction func showHideCompletedReminders(_ sender: UIButton) {
        
        if sender.isSelected{
            sender.isSelected = false
            sender.setTitle("Hide Completed", for: UIControlState())
            showCompleted = true
            fetchReminders()

        }else{
            sender.isSelected = true
            sender.setTitle("Show Completed", for: UIControlState())
            showCompleted = false
            fetchReminders()

        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ReminderEditSegue"{
            let indexPath = self.tableView.indexPathForSelectedRow!
            let selectedReminder =  reminders[(indexPath as NSIndexPath).row];
            let navController = segue.destination as! UINavigationController
            let destController = navController.topViewController as! ReminderEditorViewController
            destController.reminder = selectedReminder
            
        }
    }
}
