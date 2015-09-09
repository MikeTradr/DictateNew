//
//  ReminderPickerTableViewController.swift
//  Dictate
//
//  Created by Mike Derr on 9/8/15.
//  Copyright (c) 2015 ThatSoft.com. All rights reserved.
//

import UIKit
import EventKit

class ReminderPickerTableViewController: UITableViewController {
    
    let reminderList = ReminderManager.sharedInstance.getCalendars(EKEntityTypeReminder)
    
    var numberOfNewItems:Int    = 0
    var startDate:NSDate!
    var endDate:NSDate!
    var today:NSDate!
    var reminders:[EKReminder] = []
    var eventStore : EKEventStore = EKEventStore()
    
 //   var calendarList = Array<EKCalendar>()
 //   var allowsMultipleSelection = true
 //   var selectedCalendars:Array<EKCalendar>?
 //   var shouldShowSpecialItems = false
 //   var specialItems = ["All","Default"];
    
 //   var reminderArray = Array<EKCalendar>()
    
 //   var games:[String]!
    
    var selectedReminder:String? = nil
    var selectedReminderIndex:Int? = nil
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var verticalBarView: UIView!
    
    
   // var reminderArray = defaults.objectForKey("reminderArray") as! [String] //array of the items
    
   // var reminderArray: Array<EKCalendar> = NSUserDefaults.standardUserDefaults().objectForKey("reminderArray") //array of the items

    // var reminderArray: Array<EKCalendar> = ReminderManager.createReminderArray

    override func viewWillAppear(animated: Bool) {
      let reminderList = ReminderManager.sharedInstance.getCalendars(EKEntityTypeReminder)

            println("p49 reminderList: \(reminderList)")
            println("p50 reminderList.count: \(reminderList.count)")
            
        }
        


    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        if let defaultReminderList = selectedReminder {
        
            
//            selectedReminderIndex = find(reminderList.title, defaultReminderList)!
        }
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
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return reminderList.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       // let cell = tableView.dequeueReusableCellWithIdentifier("ReminderCell", forIndexPath: indexPath) as! UITableViewCell
        
        
        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("ReminderCell") as! UITableViewCell
        cell.selectionStyle = .None
        let reminder = reminderList[indexPath.row]
        cell.textLabel?.text = reminder.title
      //  cell.calendarName.text = reminder.calendar.title
        cell.textLabel?.textColor = UIColor(CGColor: reminder.CGColor)
        
        //Anil added
        if reminder.calendarIdentifier == self.selectedReminder{
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }else{
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        //TODO why can't I color vertical bar?
       // cell.verticalBarView.backgroundColor = UIColor(CGColor: reminder.calendar.CGColor)
        
      

        // Configure the cell...
     //   let calendar = self.calendarList[indexPath.row]
    //    cell.textLabel?.text = calendar.title
   //     cell.textLabel?.textColor =  UIColor(CGColor: calendar.CGColor)
     //   cell.textLabel?.text = reminders[indexPath.row]
      //  cell.textLabel?.textColor =  UIColor(CGColor: calendar.CGColor)

        //Anil removed
        return cell
    }
    

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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        //other row is selected  - need to deselect it
        if let index = selectedReminderIndex {
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0))
            cell?.accessoryType = .None
        }
        
        selectedReminderIndex = indexPath.row
        let selectedReminder = reminderList[indexPath.row]

        println("p192 selectedReminder: \(selectedReminder)")
        println("p193 selectedReminder.title: \(selectedReminder.title)")

        //Anil added
        defaults.setObject(selectedReminder.calendarIdentifier, forKey: "defaultReminderList")            //sets title to calendarName for ParseDB

        
        
        //update the checkmark for the current row
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = .Checkmark
        
     /*
        if !shouldShowSpecialItems{
            let selectedCalendar = self.calendarList[indexPath.row];
            //        contains( self.selectedCalendars, )
            let cell = self.tableView.cellForRowAtIndexPath(indexPath)
            cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
*/
        }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SaveSelectedReminder" {
            if let cell = sender as? UITableViewCell {
                let indexPath = tableView.indexPathForCell(cell)
                selectedReminderIndex = indexPath?.row
                if let index = selectedReminderIndex {
                    let reminder = reminderList[indexPath!.row]
                    selectedReminder = reminder.title
                }
            }
        }
        
        if segue.identifier == "PickReminder" {
//            if let reminderPickerTableViewController = segue.destinationViewController as? ReminderPickerTableViewController.selectedReminder = defaultReminderList
        }
    }


}
