//
//  CalendarPickerTableViewController.swift
//  Dictate
//
//  Created by Mike Derr on 9/10/15.
//  Copyright (c) 2015 ThatSoft.com. All rights reserved.
//

import UIKit
import EventKit

class CalendarPickerTableViewController: UITableViewController {
    
    let calendarList = ReminderManager.sharedInstance.getCalendars(EKEntityTypeEvent)
    
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
    
    var selectedCalendar:String? = nil
    var selectedCalendarIndex:Int? = nil
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    
   // var reminderArray = defaults.objectForKey("reminderArray") as! [String] //array of the items
    
   // var reminderArray: Array<EKCalendar> = NSUserDefaults.standardUserDefaults().objectForKey("reminderArray") //array of the items

    // var reminderArray: Array<EKCalendar> = ReminderManager.createReminderArray

/*
   override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    
        let view = cell.viewWithTag(1)
        let reminder = reminderList[indexPath.row]
        view!.backgroundColor = UIColor(CGColor: reminder.CGColor)
    
    
    }
*/
    override func viewWillAppear(animated: Bool) {
        let calendarList = ReminderManager.sharedInstance.getCalendars(EKEntityTypeEvent)

            println("p58 calendarList: \(calendarList)")
            println("p59 calendarList.count: \(calendarList.count)")
            
        }
        


    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        if let defaultCalendarList = selectedCalendar {
        
            
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
        return calendarList.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       // let cell = tableView.dequeueReusableCellWithIdentifier("ReminderCell", forIndexPath: indexPath) as! UITableViewCell
        
        
     //   var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("ReminderCell") as! UITableViewCell
        
        // var cell = tableView.dequeueReusableCellWithIdentifier("ReminderCell") as! SettingsReminderListTableViewCell
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CalendarCell", forIndexPath: indexPath) as! SettingsCalendarListTableViewCell
        
        cell.selectionStyle = .None
    
        let calendar = calendarList[indexPath.row]
        
        cell.labelTitle.text = calendar.title
        //TODO Anil help how can we count # items in each Reminder list?
        cell.labelNumberItems.text = "\(calendarList.count) items"
      
        cell.labelTitle.textColor = UIColor(CGColor: calendar.CGColor)
        cell.labelNumberItems.textColor = UIColor(CGColor: calendar.CGColor)
        cell.verticalBarView.backgroundColor = UIColor(CGColor: calendar.CGColor)
        
        //Anil added, Mike changed
        if calendar.calendarIdentifier == self.selectedCalendar{
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }else{
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
    
      

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
        if let index = selectedCalendarIndex {
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0))
            cell?.accessoryType = .None
        }
        
        selectedCalendarIndex = indexPath.row
        let selectedCalendar = calendarList[indexPath.row]

        println("p192 selectedCalendar: \(selectedCalendar)")
        println("p193 selectedCalendar.title: \(selectedCalendar.title)")

        //Anil added
        defaults.setObject(selectedCalendar.calendarIdentifier, forKey: "selectedCalendar")            //sets title to calendarName for ParseDB

        
        
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
        if segue.identifier == "SaveSelectedCalendar" {
            if let cell = sender as? UITableViewCell {
                let indexPath = tableView.indexPathForCell(cell)
                selectedCalendarIndex = indexPath?.row
                if let index = selectedCalendarIndex {
                    let calendar = calendarList[indexPath!.row]
                    selectedCalendar = calendar.title
                }
            }
        }
        
        if segue.identifier == "PickCalendar" {
//            if let reminderPickerTableViewController = segue.destinationViewController as? ReminderPickerTableViewController.selectedReminder = defaultReminderList
        }
    }


}
