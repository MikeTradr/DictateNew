//
//  ToDoTableViewController.swift
//  WatchInput
//
//  Created by Mike Derr on 6/22/15.
//  Copyright (c) 2015 ThatSoft.com. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI

class ToDoTableViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var viewController = self
        setStartDateAndEndDate()
      
        
        println("p175: reminders: \(self.reminders)")
        println("p176: reminders.count: \(self.reminders.count)")
        
    }
    
    override func viewWillAppear(animated: Bool) {
        EventManager.sharedInstance.fetchReminders({ (reminders) -> Void in
            self.reminders = reminders
        })
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
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
}
