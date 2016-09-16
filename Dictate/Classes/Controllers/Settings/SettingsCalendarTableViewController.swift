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

class SettingsCalendarTableViewController: UITableViewController {
    
    let defaults = NSUserDefaults(suiteName: "group.com.thatsoft.dictateApp")!
    var weekView:Bool = true
    var calendarViewType:Int = 0
    
    @IBOutlet weak var weekCell: UITableViewCell!
    @IBOutlet weak var monthCell: UITableViewCell!
    @IBOutlet weak var noneCell: UITableViewCell!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()    //hides blank cells

        calendarViewType = defaults.integerForKey("calendarViewType")
        
        


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func tableView(tableView: UITableView,
        didSelectRowAtIndexPath indexPath: NSIndexPath) {
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            
            if indexPath.row == 1 {
                cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
                calendarViewType = 1    //weak view
                monthCell.accessoryType = .None
                noneCell.accessoryType = .None
                
            } else if indexPath.row == 2 {
                cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
                calendarViewType = 2    //month view
                weekCell.accessoryType = .None
                noneCell.accessoryType = .None
                
            } else if indexPath.row == 3 {
                cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
                calendarViewType = 0    //none view
                weekCell.accessoryType = .None
                monthCell.accessoryType = .None
            }
        
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            
           // print("p63 weekView: \(weekView)")
            defaults.setObject(calendarViewType, forKey: "calendarViewType")     ////0=none, 1=week, 2= month, 3= year ? possible Bro?
    }
    
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        print("p76 calendarViewType: \(calendarViewType)")
 
        if indexPath.row == 0 {
            if calendarViewType == 1 {
                 weekCell.accessoryType = UITableViewCellAccessoryType.Checkmark
            } else if calendarViewType == 2 {
                monthCell.accessoryType = UITableViewCellAccessoryType.Checkmark
            } else if calendarViewType == 0 {
                noneCell.accessoryType = UITableViewCellAccessoryType.Checkmark
            }
        
      /*

        if indexPath.row == 0 {     //weekView = true set check mark

            if weekView {
                weekCell.accessoryType = UITableViewCellAccessoryType.Checkmark
            }
            
        } else {     //weekView = false set check mark
            
            if !weekView {
                monthCell.accessoryType = UITableViewCellAccessoryType.Checkmark
            }
        }
      */
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
