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
    
    let calendarList = ReminderManager.sharedInstance.getCalendars(EKEntityType.event)
    
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
    
    var selectedCalendar:String? = nil
    var selectedCalendarIndex:Int? = nil
    
    let defaults = UserDefaults(suiteName: "group.com.thatsoft.dictateApp")!
    
    
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
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let view = cell.viewWithTag(1)
        let calendar = calendarList[(indexPath as NSIndexPath).row]
        view!.backgroundColor = UIColor(cgColor: calendar.cgColor)
      
        if defaults.string(forKey: "defaultCalendarID") != "" {
            if let defaultCalendarID  = defaults.string(forKey: "defaultCalendarID") {
                
                //print("p67 defaultCalendarID: \(defaultCalendarID)")
                //print("p68 calendar: \(calendar.calendarIdentifier)")
                
                if calendar.calendarIdentifier == defaultCalendarID {   // add checkmark for default calendar
                    cell.accessoryType = UITableViewCellAccessoryType.checkmark
                } else {
                    cell.accessoryType = UITableViewCellAccessoryType.none
                }
            }
        }
    }
    
    

    override func viewWillAppear(_ animated: Bool) {
        let calendarList = ReminderManager.sharedInstance.getCalendars(EKEntityType.event)

            //print("p58 calendarList: \(calendarList)")
            //print("p59 calendarList.count: \(calendarList.count)")
            
        }
        


    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        if let defaultCalendarList = selectedCalendar {
        
            
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
        return calendarList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // let cell = tableView.dequeueReusableCellWithIdentifier("ReminderCell", forIndexPath: indexPath) as! UITableViewCell
        
     //   var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("ReminderCell") as! UITableViewCell
        
        // var cell = tableView.dequeueReusableCellWithIdentifier("ReminderCell") as! SettingsReminderListTableViewCell
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarCell", for: indexPath) as! SettingsCalendarListTableViewCell
        
        cell.selectionStyle = .none
    
        let calendar = calendarList[(indexPath as NSIndexPath).row]
        cell.labelTitle.text = calendar.title
        
        let date = Date() //todays date, we get month from here, so we get current month
        let (firstDay, lastDay) = EventManager.sharedInstance.getFirstAndLastDateOfMonth(date)
        
        //print("p154 firstDay: \(firstDay)")
        //print("p155 lastDay: \(lastDay)")
        
        EventManager.sharedInstance.fetchEventsFrom(firstDay, endDate: lastDay, completion: { (events) -> Void in
            
            let filteredArray = events.filter{$0.calendar == calendar}
            //print("p164 filteredArray: \(filteredArray)")
            let numberOfEvents:String = "\(filteredArray.count)"
            cell.labelNumberItems.text = "\(numberOfEvents) items this month"
        })
        
        cell.labelTitle.textColor = UIColor(cgColor: calendar.cgColor)
        cell.labelNumberItems.textColor = UIColor(cgColor: calendar.cgColor)
        cell.verticalBarView.backgroundColor = UIColor(cgColor: calendar.cgColor)

        //Anil added, Mike changed
        if calendar.calendarIdentifier == self.selectedCalendar{
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
            
            let defaultCalendarID: String  = defaults.string(forKey: "defaultCalendarID")!
            
            if self.selectedCalendar != defaultCalendarID {
                
                //TODO Anil how do we uncheck the old default cell row???
                
                 cell.accessoryType = .none
            }
            
            
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.none
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        //other row is selected  - need to deselect it
        if let index = selectedCalendarIndex {
            let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0))
            cell?.accessoryType = .none
        }
        
        selectedCalendarIndex = (indexPath as NSIndexPath).row
        let selectedCalendar = calendarList[(indexPath as NSIndexPath).row]

        print("p202 selectedCalendar: \(selectedCalendar)")
        print("p203 selectedCalendar.title: \(selectedCalendar.title)")
        print("p204 selectedCalendar.calendarIdentifier: \(selectedCalendar.calendarIdentifier)")

        //Anil added
        defaults.set(selectedCalendar.calendarIdentifier, forKey: "defaultCalendarID") //sets Default Selected Calendar CalendarIdentifier
        
        //update the checkmark for the current row
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        self.tableView.reloadData()
        
     /*
        if !shouldShowSpecialItems{
            let selectedCalendar = self.calendarList[indexPath.row];
            //        contains( self.selectedCalendars, )
            let cell = self.tableView.cellForRowAtIndexPath(indexPath)
            cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
*/
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SaveSelectedCalendar" {
            if let cell = sender as? UITableViewCell {
                let indexPath = tableView.indexPath(for: cell)
                selectedCalendarIndex = (indexPath as NSIndexPath?)?.row
                if let index = selectedCalendarIndex {
                    let calendar = calendarList[(indexPath! as NSIndexPath).row]
                    selectedCalendar = calendar.title
                }
            }
        }
        
        if segue.identifier == "PickCalendar" {
//            if let reminderPickerTableViewController = segue.destinationViewController as? ReminderPickerTableViewController.selectedReminder = defaultReminderList
        }
    }


}
