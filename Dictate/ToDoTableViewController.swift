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

class ToDoTableViewController: UITableViewController,BFPaperCheckboxDelegate {
    

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
    
    var selectionController:CalendarSelectionViewController!
    var showCompleted = false
    @IBOutlet var ToDoTableView: UITableView!
    
    @IBOutlet weak var reminderListButton: UIButton!
    @IBOutlet weak var listItemsNumberLabel: UILabel!
    
    @IBOutlet weak var showHideButton: UIButton!
    
    // TODO Anil get calendars from users, Add to array: All, Default, Last, +Array and make into array hard coded at prsent 7-17-15
    
    @IBAction func buttonReminderListSelector(sender: AnyObject) {
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewControllerWithIdentifier("ShowReminders") 
//        self.presentViewController(vc, animated: true, completion: nil)
        
        if (self.selectionController == nil){
            self.selectionController = self.storyboard!.instantiateViewControllerWithIdentifier("CalendarSelectionViewController") as! CalendarSelectionViewController
        }
        let calendars = ReminderManager.sharedInstance.eventStore.calendarsForEntityType(EKEntityType.Reminder)
        self.selectionController.calendarList = calendars;
//        self.selectionController.selectedCalendars = [self.reminder.calendar]
        self.selectionController.allowsMultipleSelection = false
        self.selectionController.shouldShowAll = true
        self.navigationController?.pushViewController(self.selectionController, animated: true)
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var viewController = self
        setStartDateAndEndDate()
        
        //Added left and Right Swipe gestures. TODO Can add this to the General.swift Class? and call it?
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        leftSwipe.direction = .Left
        rightSwipe.direction = .Right
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
        
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        
        showHideButton.setTitle("Show Completed", forState: .Normal)
        showHideButton.selected = true
        showCompleted = false
        
        fetchReminders()
        //Play sound
        var alertSound3: NSURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("button-14", ofType: "mp3")!)
        //General.playSound(alertSound3!)
//        playSound(alertSound3)
    }
    
    func fetchReminders(){
        if let _selectionController = selectionController where selectionController.selectedCalendars.count > 0{
            self.fetchRemindersFromCalendars(_selectionController.selectedCalendars, showComplted: showCompleted)
            
        }else{
            //Fatch all reminders
            self.fetchRemindersFromCalendars(showComplted:showCompleted)
        }
    }
    
    func fetchRemindersFromCalendars(calendars:[EKCalendar]? = nil, showComplted:Bool=false){
        
        ReminderManager.sharedInstance.fetchRemindersFromCalendars(calendars,includeCompleted:showComplted ) { (reminders) -> Void in
            self.reminders = reminders
            
            print("p76 self.reminders: \(self.reminders)")
            print("p77 self.reminders.count: \(self.reminders.count)")
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
                self.setTabBarBadge()
                if let _selectionController = self.selectionController where self.selectionController.selectedCalendars.count > 0{
                    self.reminderListButton.setTitle("List: \(_selectionController.selectedCalendars[0].title) >", forState: .Normal)
                    
                }else{
                    self.reminderListButton.setTitle("List: All >", forState: .Normal)
                }
                
                self.listItemsNumberLabel.text = "\(self.reminders.count) items"
            })
        }
    }
    
    func setTabBarBadge(){
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
            print("p60 we here? self.numberOfNewItems: \(self.numberOfNewItems)")
            self.tabBarItem.badgeValue = String(self.reminders.count)
        }
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
        
        let cell:ToDoTableCell = tableView.dequeueReusableCellWithIdentifier("ReminderCell") as! ToDoTableCell
        cell.selectionStyle = .None
        let reminder = reminders[indexPath.row]
        cell.reminder = reminder
        cell.titleLabel.text = reminder.title
        cell.calendarName.text = reminder.calendar.title
        cell.calendarName.textColor = UIColor(CGColor: reminder.calendar.CGColor)
        cell.verticalBarView.backgroundColor = UIColor(CGColor: reminder.calendar.CGColor)
        cell.checkBox.tag = indexPath.row
        cell.checkBox.delegate = self
        if reminder.completed{
           cell.checkBox.checkAnimated(false)
        }
        
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
    
    func paperCheckboxChangedState(checkbox: BFPaperCheckbox!) {
        let row = checkbox.tag
        let reminder = self.reminders[row]
        reminder.completed = !reminder.completed
        try? ReminderManager.sharedInstance.eventStore.saveReminder(reminder, commit: true)
//        fetchRemindersFromCalendars(nil, showComplted: <#T##Bool#>)
    }

    
    func indexPathForView(view: UIView) -> NSIndexPath? {
        let viewOrigin = view.bounds.origin
        
        let viewLocation = tableView.convertPoint(viewOrigin, fromView: view)
        
        return tableView.indexPathForRowAtPoint(viewLocation)
    }
    
    @IBAction func showHideCompletedReminders(sender: UIButton) {
        
        if sender.selected{
            sender.selected = false
            sender.setTitle("Hide Completed", forState: .Normal)
            showCompleted = true
            fetchReminders()

        }else{
            sender.selected = true
            sender.setTitle("Show Completed", forState: .Normal)
            showCompleted = false
            fetchReminders()

        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ReminderEditSegue"{
            let indexPath = self.tableView.indexPathForSelectedRow!
            let selectedReminder =  reminders[indexPath.row];
            let navController = segue.destinationViewController as! UINavigationController
            let destController = navController.topViewController as! ReminderEditorViewController
            destController.reminder = selectedReminder
            
        }
    }
}
