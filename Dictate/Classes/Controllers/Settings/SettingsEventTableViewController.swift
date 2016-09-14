//
//  SettingsEventTableViewController.swift
//  Dictate
//
//  Created by Mike Derr on 8/26/15.
//  Copyright (c) 2015 ThatSoft.com. All rights reserved.
//

import UIKit


class SettingsEventTableViewController: UITableViewController, UITextFieldDelegate{
    
    let defaults = UserDefaults(suiteName: "group.com.thatsoft.dictateApp")!
    
    let calendars = ReminderManager.sharedInstance.getCalendars(EKEntityType.event)  //EKCalendar Array

    @IBOutlet weak var labelCalendarDefault: UILabel!
    @IBOutlet weak var labelDefaultDuration: UITextField!
    @IBOutlet weak var labelDefaultAlert: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        
        if defaults.string(forKey: "defaultCalendarID") != "" {
            if let defaultCalendarID  = defaults.string(forKey: "defaultCalendarID") {
                
                if let calendar:EKCalendar = EventManager.sharedInstance.getCalendar(defaultCalendarID) {
                    labelCalendarDefault.text = calendar.title
                    labelCalendarDefault.textColor = UIColor(cgColor: calendar.cgColor)
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelDefaultDuration.delegate = self
        labelDefaultAlert.delegate = self
        
        if defaults.string(forKey: "defaultCalendarID") != "" {
            if let defaultCalendarID  = defaults.string(forKey: "defaultCalendarID") {
                
                if let calendar:EKCalendar = EventManager.sharedInstance.getCalendar(defaultCalendarID) {
                    labelCalendarDefault.text = calendar.title
                    labelCalendarDefault.textColor = UIColor(cgColor: calendar.cgColor)
                }
            }
        }
        
        print("p51 defaults.objectForKey(\"defaultEventDuration\"): \(defaults.object(forKey: "defaultEventDuration"))")
   /*
        if defaults.objectForKey("defaultEventDuration") == nil {
            let defaultDurationInitially = 10
            defaults.setObject(defaultDurationInitially, forKey: "defaultEventDuration")
        }
    */
         print("p58 defaults.objectForKey(\"defaultEventDuration\"): \(defaults.object(forKey: "defaultEventDuration"))")
        
        let duration    = defaults.object(forKey: "defaultEventDuration") as! Int     //changed from eventDuration 112715
        
         print("p62 defaults.objectForKey(\"defaultEventAlert\"): \(defaults.object(forKey: "defaultEventAlert"))")
        
        let alert       = defaults.object(forKey: "defaultEventAlert") as! Int        //changed from eventAlert 112715
        labelDefaultDuration.text = "\(duration)"
        labelDefaultAlert.text = "\(alert)"
        
        tableView.tableFooterView = UIView()    //hides blank cells


    }
    
    

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncommentthe following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    //}
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
     func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool  {
        
        if (textField == labelDefaultDuration) {
            let currentString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            
            if currentString.isEmpty {
                //empty field
            } else {
                let newDuration = Int(currentString)
                print("p98 newDuration: \(newDuration)")
                defaults.set(newDuration, forKey: "defaultEventDuration")
            }
        }
        
        if (textField == labelDefaultAlert) {
            let currentString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            
            if currentString.isEmpty {
                //empty field
            } else {
                let newAlert = Int(currentString)
                defaults.set(newAlert, forKey: "defaultEventAlert")
            }
        }
        
        return true;
    }
    
    
    func removeKeyboard() {
        labelDefaultAlert.resignFirstResponder()
        labelDefaultDuration.resignFirstResponder()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SaveCalendarDetail" {
            
        }
        
        //Anil added, Mike changed for Calendar 091015
        if segue.identifier == "PickCalendar"{
            //usually we the value in the next controller from here
            // in our case its not really required, since we are setting it in user defaults, will be globaly available
            //As a better approach iam doing here to show you
            
            let selectedCalendarIdentifier = defaults.object(forKey: "defaultCalendar") as? String
            
            //            .setObject(selectedReminder.calendarIdentifier, forKey: "defaultReminderList")
            let calendarPickerController = segue.destination as! CalendarPickerTableViewController
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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
