//
//  SettingsEventTableViewController.swift
//  Dictate
//
//  Created by Mike Derr on 8/26/15.
//  Copyright (c) 2015 ThatSoft.com. All rights reserved.
//

import UIKit

class SettingsEventTableViewController: UITableViewController, UITextFieldDelegate{
    
    let defaults = NSUserDefaults(suiteName: "group.com.thatsoft.dictateApp")!
    
    let calendars = ReminderManager.sharedInstance.getCalendars(EKEntityType.Event)  //EKCalendar Array

    @IBOutlet weak var labelCalendarDefault: UILabel!
    @IBOutlet weak var labelDefaultDuration: UITextField!
    @IBOutlet weak var labelDefaultAlert: UITextField!
    
    override func viewWillAppear(animated: Bool) {
        
        if defaults.stringForKey("defaultCalendarID") != "" {
            if let defaultCalendarID  = defaults.stringForKey("defaultCalendarID") {
                
                if let calendar:EKCalendar = EventManager.sharedInstance.getCalendar(defaultCalendarID) {
                    labelCalendarDefault.text = calendar.title
                    labelCalendarDefault.textColor = UIColor(CGColor: calendar.CGColor)
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelDefaultDuration.delegate = self
        labelDefaultAlert.delegate = self
        
        if defaults.stringForKey("defaultCalendarID") != "" {
            if let defaultCalendarID  = defaults.stringForKey("defaultCalendarID") {
                
                if let calendar:EKCalendar = EventManager.sharedInstance.getCalendar(defaultCalendarID) {
                    labelCalendarDefault.text = calendar.title
                    labelCalendarDefault.textColor = UIColor(CGColor: calendar.CGColor)
                }
            }
        }
        
        let duration    = defaults.objectForKey("eventDuration") as! Int
        let alert       = defaults.objectForKey("eventAlert") as! Int
        labelDefaultDuration.text = "\(duration)"
        labelDefaultAlert.text = "\(alert)"

    }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncommentthe following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    //}
    
    
     func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool  {
        
        if (textField == labelDefaultDuration) {
            let currentString = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
            
            if currentString.isEmpty {
                //empty field
            } else {
                let newDuration = Int(currentString)
                defaults.setObject(newDuration, forKey: "eventDuration")
            }
        }
        
        if (textField == labelDefaultAlert) {
            let currentString = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
            
            if currentString.isEmpty {
                //empty field
            } else {
                let newAlert = Int(currentString)!
                defaults.setObject(newAlert, forKey: "eventAlert")
            }
        }
        
        return true;
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SaveCalendarDetail" {
            
        }
        
        //Anil added, Mike changed for Calendar 091015
        if segue.identifier == "PickCalendar"{
            //usually we the value in the next controller from here
            // in our case its not really required, since we are setting it in user defaults, will be globaly available
            //As a better approach iam doing here to show you
            
            let selectedCalendarIdentifier = defaults.objectForKey("defaultCalendar") as? String
            
            //            .setObject(selectedReminder.calendarIdentifier, forKey: "defaultReminderList")
            let calendarPickerController = segue.destinationViewController as! CalendarPickerTableViewController
            calendarPickerController.selectedCalendar = selectedCalendarIdentifier
        }
    }


    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    */

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

}

extension SettingsEventTableViewController  {
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
}
