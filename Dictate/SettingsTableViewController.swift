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
    
    var defaultReminderList:String = "Default"
    
    var audioPlayer = AVAudioPlayer()
    
    @IBOutlet weak var labelReminderDefault: UILabel!
    
    func playSound(sound: NSURL){
        var error:NSError?
        audioPlayer = AVAudioPlayer(contentsOfURL: sound, error: &error)
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    
    func removeKeyboard() {
      //  prefsDefaultCalendar.resignFirstResponder()
      //  prefsDefaultDuration.resignFirstResponder()
    }
    
    func textFieldShouldReturn(prefsDefaultDuration: UITextField) -> Bool {
        prefsDefaultDuration.resignFirstResponder()
        return true;
    }
    
    override func viewWillAppear(animated: Bool) {
        var alertSound3: NSURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("262-buttonclick57", ofType: "mp3")!)!
        //General.playSound(alertSound3!)
        playSound(alertSound3)
        
        
        let selectedReminderIdentifier = NSUserDefaults.standardUserDefaults().objectForKey("defaultReminderList") as? String
        println("p44 selectedReminderIdentifier: \(selectedReminderIdentifier)")
        
        let reminder = ReminderManager.sharedInstance.eventStore.calendarWithIdentifier("selectedReminderIdentifier")
        
        println("p46 reminder: \(reminder)")
        
        // labelReminderDefault.text = reminder.title
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let selectedReminderIdentifier = NSUserDefaults.standardUserDefaults().objectForKey("defaultReminderList") as? String
        
        labelReminderDefault.text = selectedReminderIdentifier
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SaveReminderDetail" {
            
        }
        
        //Anil added
        if segue.identifier == "PickReminder"{
            //usually we the value in the next controller from here
            // in our case its not really required, since we are setting it in user defaults, will be globaly available
            //As a better approach iam doing here to show you
            
            let selectedCalendarIdentifier = NSUserDefaults.standardUserDefaults().objectForKey("defaultReminderList") as? String
            
//            .setObject(selectedReminder.calendarIdentifier, forKey: "defaultReminderList")
            let reminderPickerController = segue.destinationViewController as! ReminderPickerTableViewController
            reminderPickerController.selectedReminder = selectedCalendarIdentifier
        }
    }
    
    
    @IBAction func buttonGoToPrefs(sender: AnyObject) {
            
            let storyboard = UIStoryboard(name: "Preferences", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("someViewController") as! UIViewController
            self.presentViewController(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func selectedReminderList(segue: UIStoryboardSegue) {
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
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
}
