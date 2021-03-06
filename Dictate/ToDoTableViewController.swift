//
//  ToDoTableViewController.swift
//  WatchInput
//
//  Created by Mike Derr on 6/22/15.
//  Copyright (c) 2015 ThatSoft.com. All rights reserved.
//
// did Anil do this code?


import UIKit
import EventKit
import EventKitUI
import AVFoundation

class ToDoTableViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {
    

    var audioPlayer = AVAudioPlayer()
    
    var numberOfNewItems:Int    = 0
    var startDate:NSDate!
    var endDate:NSDate!
    var today:NSDate!
    var reminders:[EKReminder] = []
    var eventStore : EKEventStore = EKEventStore()
    lazy var dateFormatter:NSDateFormatter = {
        let _dateFormatter = NSDateFormatter()
        _dateFormatter.dateFormat = "dd-MM-yyyy"
        return _dateFormatter
        }()
    
    @IBOutlet var ToDoTableView: UITableView!
    
    @IBOutlet weak var buttonReminderListSelector: UIButton!
    @IBOutlet weak var labelNumberListItems: UILabel!
    
    
    // TODO Anil get calendars from users, Add to array: All, Default, Last, +Array and make into array hard coded at prsent 7-17-15
    
    @IBAction func buttonReminderListSelector(sender: AnyObject) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("ShowReminders") as! UIViewController
        self.presentViewController(vc, animated: true, completion: nil)
        
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var viewController = self
        setStartDateAndEndDate()
        
        //Added left and Right Swipe gestures. TODO Can add this to the General.swift Class? and call it?
        var leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        var rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        leftSwipe.direction = .Left
        rightSwipe.direction = .Right
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
        
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        ReminderManager.sharedInstance.fetchReminders({ (reminders) -> Void in
            self.reminders = reminders
            self.tableView.reloadData()
            
            println("p76 self.reminders: \(self.reminders)")
            println("p77 self.reminders.count: \(self.reminders.count)")
            
        })
        
        var tabArray = self.tabBarController?.tabBar.items as NSArray!  //added by Mike 082315 here and viewDidLoad appear?
        var tabItem = tabArray.objectAtIndex(3) as! UITabBarItem              // set 4th tab item
        
        tabItem.badgeValue = String(self.reminders.count)
        
        //does this badge code work?
        
        self.tabBarItem.badgeValue = String(self.reminders.count)
        
        //Set the badge number to display              // added 082215 by Mike
        // TODO add this to the app start up, does not show when app loads.
        self.numberOfNewItems = reminders.count
        if (self.numberOfNewItems == 0) {
            self.tabBarItem.badgeValue = nil;
        } else {
            println("p60 we here? self.numberOfNewItems: \(self.numberOfNewItems)")
            self.tabBarItem.badgeValue = String(self.reminders.count)
        }
        
        
        var alertSound3: NSURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("button-14", ofType: "mp3")!)!
        //General.playSound(alertSound3!)
        playSound(alertSound3)
    }
    
    func setStartDateAndEndDate()
    {
        today = NSDate()
        let dateHelper = JTDateHelper()
        startDate =  dateHelper.addToDate(today, months: -6)
        endDate = dateHelper.addToDate(today, months: 6)
    }
    
    func createReminderDictionary(){
        
    }
    
    func playSound(sound: NSURL){       //Added by Mike 082215
        var error:NSError?
        audioPlayer = AVAudioPlayer(contentsOfURL: sound, error: &error)
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    
    func handleSwipes(sender:UISwipeGestureRecognizer) {
        if (sender.direction == .Left) {
            self.tabBarController?.selectedIndex = 4
        }
        if (sender.direction == .Right) {
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
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminders.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:ToDoTableCell = tableView.dequeueReusableCellWithIdentifier("ReminderCell") as! ToDoTableCell
        cell.selectionStyle = .None
        let reminder = reminders[indexPath.row]
        cell.titleLabel.text = reminder.title
        cell.calendarName.text = reminder.calendar.title
        cell.calendarName.textColor = UIColor(CGColor: reminder.calendar.CGColor)
        cell.verticalBarView.backgroundColor = UIColor(CGColor: reminder.calendar.CGColor)
        
        return cell
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    @IBAction func checkBoxTapped(sender: CheckBox) {
        let indexPath = indexPathForView(sender)!
        
    }
    
    func indexPathForView(view: UIView) -> NSIndexPath? {
        let viewOrigin = view.bounds.origin
        
        let viewLocation = tableView.convertPoint(viewOrigin, fromView: view)
        
        return tableView.indexPathForRowAtPoint(viewLocation)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ReminderEditSegue"{
            let indexPath = self.tableView.indexPathForSelectedRow()!
            let selectedReminder =  reminders[indexPath.row];
            let navController = segue.destinationViewController as! UINavigationController
            let destController = navController.topViewController as! ReminderEditorViewController
            destController.reminder = selectedReminder
            
        }
    }
}
