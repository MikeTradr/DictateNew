//
//  SettingsCalendarTableViewController.swift
//  Dictate
//
//  Created by Mike Derr on 8/25/15.
//  Copyright (c) 2015 ThatSoft.com. All rights reserved.
//
//  03/17/2016  Mike added code for checkmark and savign to Defaults.
//

import UIKit

class SettingsCalendarTableViewController: UITableViewController{
    
    let defaults = UserDefaults(suiteName: "group.com.thatsoft.dictateApp")!
    var weekView:Bool = true
    
    @IBOutlet weak var weekCell: UITableViewCell!
    @IBOutlet weak var monthCell: UITableViewCell!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()    //hides blank cells

        weekView = defaults.bool(forKey: "defaultWeekView")
        print("p26 weekView: \(weekView)")

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func tableView(_ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath) {
            let cell = tableView.cellForRow(at: indexPath)
            
            if (indexPath as NSIndexPath).row == 1 {
                cell!.accessoryType = UITableViewCellAccessoryType.checkmark
                weekView = true
                monthCell.accessoryType = .none
            }
            if (indexPath as NSIndexPath).row == 2 {
                cell!.accessoryType = UITableViewCellAccessoryType.checkmark
                weekView = false
                weekCell.accessoryType = .none
            }
            
            tableView.deselectRow(at: indexPath, animated: true)
            
            print("p63 weekView: \(weekView)")
            defaults.set(weekView, forKey: "defaultWeekView")     //save to defaults calendar display view, true = week view, false = month view
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        print("p73 weekView: \(weekView)")

        if (indexPath as NSIndexPath).row == 0 {     //weekView = true set check mark

            if weekView {
                weekCell.accessoryType = UITableViewCellAccessoryType.checkmark
            }
            
        } else {     //weekView = false set check mark
            
            if !weekView {
                monthCell.accessoryType = UITableViewCellAccessoryType.checkmark
            }
        }
        
    }

    
    
    
/*

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        if indexPath.row == 1 {     //weekView = true set check mark
            if weekView {
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            }
        }
        
        if indexPath.row == 2 {     //weekView = false set check mark
            if !weekView {
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            }
        }
        

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
