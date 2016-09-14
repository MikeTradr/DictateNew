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
    
    let defaults = UserDefaults(suiteName: "group.com.thatsoft.dictateApp")!
    
    let reminderList = ReminderManager.sharedInstance.getCalendars(EKEntityType.reminder)
    
    var numberOfNewItems:Int    = 0
    var startDate:Date!
    var endDate:Date!
    var today:Date!
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
    
    var allReminders:[EKReminder] = []


    
   // var reminderArray = defaults.objectForKey("reminderArray") as! [String] //array of the items
   // var reminderArray: Array<EKCalendar> = NSUserDefaults.standardUserDefaults().objectForKey("reminderArray") //array of the items
    // var reminderArray: Array<EKCalendar> = ReminderManager.createReminderArray
    
    
   override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    
        let view = cell.viewWithTag(1)
        let reminder = reminderList[(indexPath as NSIndexPath).row]
        view!.backgroundColor = UIColor(cgColor: reminder.cgColor)
    
    
        // Check if deafults is there, then set default item to be checked
        if defaults.string(forKey: "defaultReminderID") != "" {
            if let defaultReminderID  = defaults.string(forKey: "defaultReminderID") {
                
                print("p133 defaultReminderID: \(defaultReminderID)")
                print("p134 reminder.calendarIdentifier: \(reminder.calendarIdentifier)")
                
                if reminder.calendarIdentifier == defaultReminderID {               // add checkmark for default reminder
                    print("p135 WE HERE")
                    cell.accessoryType = UITableViewCellAccessoryType.checkmark
                } else {
                    cell.accessoryType = UITableViewCellAccessoryType.none
                }
            }
        }
    
  
    
    }

    override func viewWillAppear(_ animated: Bool) {
        let reminderList = ReminderManager.sharedInstance.getCalendars(EKEntityType.reminder)

            print("p49 reminderList: \(reminderList)")
            print("p50 reminderList.count: \(reminderList.count)")
            
        }
        


    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
        if let defaultReminderList = selectedReminder {
            
//            selectedReminderIndex = find(reminderList.title, defaultReminderList)!
        }
        
        tableView.tableFooterView = UIView()    //hides blank cells

        
        
    }

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
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return reminderList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCell", for: indexPath) as! SettingsReminderListTableViewCell
        
        cell.selectionStyle = .none
        
        let reminder = reminderList[(indexPath as NSIndexPath).row]
        cell.labelTitle.text = reminder.title
        
        ReminderManager.sharedInstance.fetchCalendarReminders(reminder) { (reminders) -> Void in
            self.allReminders = reminders as [EKReminder]
            let numberOfItems = self.allReminders.count
            cell.labelNumberItems.text = "\(numberOfItems) items"
            cell.labelTitle.textColor = UIColor(cgColor: reminder.cgColor)
            cell.labelNumberItems.textColor = UIColor(cgColor: reminder.cgColor)
        }
        
        //Anil added
        if reminder.calendarIdentifier == self.selectedReminder{
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        }else{
            cell.accessoryType = UITableViewCellAccessoryType.none
        }

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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        //other row is selected  - need to deselect it
        if let index = selectedReminderIndex {
            let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0))
            cell?.accessoryType = .none
        }
        
        selectedReminderIndex = (indexPath as NSIndexPath).row
        let selectedReminder = reminderList[(indexPath as NSIndexPath).row]

        print("p200 selectedReminder: \(selectedReminder)")
        print("p201 selectedReminder.title: \(selectedReminder.title)")
        print("p202 selectedReminder.calendarIdentifier: \(selectedReminder.calendarIdentifier)")
        
        defaults.set(selectedReminder.calendarIdentifier, forKey: "defaultReminderID") //sets Default Selected Reminder CalendarIdentifier
        
        if #available(iOS 9.0, *) {
            ConnectivityPhoneManager.sharedInstance.sendKey("defaultReminderID")
        } else {
            // Fallback on earlier versions
        }
        
        //update the checkmark for the current row
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        
     /*
        if !shouldShowSpecialItems{
            let selectedCalendar = self.calendarList[indexPath.row];
            //        contains( self.selectedCalendars, )
            let cell = self.tableView.cellForRowAtIndexPath(indexPath)
            cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
*/
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SaveSelectedReminder" {
            if let cell = sender as? UITableViewCell {
                let indexPath = tableView.indexPath(for: cell)
                selectedReminderIndex = (indexPath as NSIndexPath?)?.row
                if let index = selectedReminderIndex {
                    let reminder = reminderList[(indexPath! as NSIndexPath).row]
                    selectedReminder = reminder.title
                }
            }
        }
        
        if segue.identifier == "PickReminder" {
//            if let reminderPickerTableViewController = segue.destinationViewController as? ReminderPickerTableViewController.selectedReminder = defaultReminderList
        }
    }


}
