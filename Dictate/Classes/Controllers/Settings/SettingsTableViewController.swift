//
//  SettingsTableViewController.swift
//  Dictate
//
//  Created by Mike Derr on 8/25/15.
//  Copyright (c) 2015 ThatSoft.com. All rights reserved.
//

import UIKit
import AVFoundation

class SettingsTableViewController: UITableViewController{
    
    let defaults = UserDefaults(suiteName: "group.com.thatsoft.dictateApp")!

    var defaultReminderList:String = "Default"
    
    var audioPlayer = AVAudioPlayer()
    
    @IBOutlet weak var labelReminderDefault: UILabel!
    
    func playSound(_ sound: URL){
        var error:NSError?
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: sound)
        } catch var error1 as NSError {
            error = error1
        }
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    
    func removeKeyboard() {
      //  prefsDefaultCalendar.resignFirstResponder()
      //  prefsDefaultDuration.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ prefsDefaultDuration: UITextField) -> Bool {
        prefsDefaultDuration.resignFirstResponder()
        return true;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let alertSound3: URL = URL(fileURLWithPath: Bundle.main.path(forResource: "262-buttonclick57", ofType: "mp3")!)
        //General.playSound(alertSound3!)
        playSound(alertSound3)
        
        if defaults.string(forKey: "defaultReminderID") != "" {
            if let defaultReminderID  = defaults.string(forKey: "defaultReminderID") {
                
                print("p83 defaultReminderID: \(defaultReminderID)")
                
                //  if let reminder:EKCalendar = ReminderManager.sharedInstance.eventStore.calendarWithIdentifier("defaultReminderID") {
                
                if let reminder:EKCalendar = ReminderManager.sharedInstance.getCalendar(defaultReminderID) {
                    
                    print("p87 reminder: \(reminder)")
                    
                    labelReminderDefault.text = reminder.title
                    labelReminderDefault.textColor = UIColor(cgColor: reminder.cgColor)
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if defaults.string(forKey: "defaultReminderID") != "" {
            if let defaultReminderID  = defaults.string(forKey: "defaultReminderID") {
                print("p83 defaultReminderID: \(defaultReminderID)")
                if let reminder:EKCalendar = ReminderManager.sharedInstance.eventStore.calendar(withIdentifier: "defaultReminderID") {
                    print("p75 reminder: \(reminder)")
                    labelReminderDefault.text = reminder.title
                    labelReminderDefault.textColor = UIColor(cgColor: reminder.cgColor)
                }
            }
        }
        
        tableView.tableFooterView = UIView()    //hides blank cells

        
     //   let defaultReminderID = defaults.stringForKey("defaultReminderID")

        
       // labelReminderDefault.text = defaultReminderID
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SaveReminderDetail" {
            
        }
        
        //Anil added
        if segue.identifier == "PickReminder"{
            //usually we the value in the next controller from here
            // in our case its not really required, since we are setting it in user defaults, will be globaly available
            //As a better approach iam doing here to show you
            
            let selectedCalendarIdentifier = defaults.object(forKey: "defaultReminderList") as? String
            
            let reminderPickerController = segue.destination as! ReminderPickerTableViewController
            reminderPickerController.selectedReminder = selectedCalendarIdentifier
        }
    }
    

    
    @IBAction func selectedReminderList(_ segue: UIStoryboardSegue) {
//        if let reminderPickerTabelViewController = segue.sourceViewController as? ReminderPickerTabelViewController,
//            selectedReminder = ReminderPickerTabelViewController.selectedReminder {
//                labelReminderDefault.text = selectedReminder
//                defaultReminderList = selectedReminder
//        }
        
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

extension SettingsTableViewController : UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
