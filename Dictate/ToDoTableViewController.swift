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

class ToDoTableViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource { //UIPickerViewDataSource {
    
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
    
    @IBOutlet weak var pickerLists: UIPickerView!
    
    // TODO  get calendars from users, and make into array hard coded at prsent 7-17-15
    let pickerData = ["Reminders", "522", "Anil List", "Steph", "All", "Bands", "Birthdays", "Reacurring", "x1"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var viewController = self
        setStartDateAndEndDate()
        
        //Added left adn Right Swipe gestures. TODO Can add this to the General.swift Class? and call it?
        var leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        var rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        leftSwipe.direction = .Left
        rightSwipe.direction = .Right
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
        
        //TODO hard coded to row 3, set to the default user Calendar item!
        self.pickerLists.selectRow(4, inComponent: 0, animated: true)
      
        
    }
    

    
    override func viewWillAppear(animated: Bool) {
        EventManager.sharedInstance.fetchReminders({ (reminders) -> Void in
            self.reminders = reminders
            self.tableView.reloadData()
    
            
            
            println("p49 self.reminders: \(self.reminders)")
            println("p50 self.reminders.count: \(self.reminders.count)")
            
            
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
        
        pickerLists.delegate = self
    //    pickerLists.dataSource = self
        
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
        
        
        
        // let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell
        
        // Configure the cell...
        
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
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
  //  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

    
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
       // myLabel.text = pickerData[row]
    }
    
    // TODO Set a better non serif font! system font!!!!
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = pickerData[row]
        var myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Geneva", size: 12.0)!,NSForegroundColorAttributeName:UIColor.blueColor()])
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
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Helvetica", size: 15.0)!,NSForegroundColorAttributeName:UIColor.blackColor()])
        pickerLabel!.attributedText = myTitle
        
        return pickerLabel
        
    }
    
    // TODO check sizes for smaller phones! and font size etc... make look great!
    
    //size the components of the UIPickerView
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 17.0
    }
    
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 100
    }
    
    func pickerView(pickerView: UIPickerView, heightForComponet component: Int) -> CGFloat {
        return 54
    }
    
    
}
