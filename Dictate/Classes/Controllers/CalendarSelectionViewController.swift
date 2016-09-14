//
//  CalendarSelectionViewController.swift
//  Dictate
//
//  Created by Anil Varghese on 07/09/15.
//  Copyright (c) 2015 ThatSoft.com. All rights reserved.
//
// 122415 mods by Mike, added ability to remember last selection to NSUserDefaults...

import UIKit
import EventKit

class CalendarSelectionViewController: UITableViewController {
    
    var calendarList = Array<EKCalendar>()
    var allowsMultipleSelection = true
    var selectedCalendars:Array<EKCalendar> = []
    var shouldShowAll = false
    var specialItems = ["All"];
    
    let defaults = UserDefaults(suiteName: "group.com.thatsoft.dictateApp")!  //122415 MJD to retain selection

    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.backgroundColor  = UIColor.blackColor()
        self.tableView.backgroundColor =  UIColor.black
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorStyle = .none

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        if shouldShowAll{
            return 2
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowAll && section == 0{
            return 1
        }
        return self.calendarList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) 
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.backgroundColor = UIColor.black
        
        if !shouldShowAll || (indexPath as NSIndexPath).section == 1{
            
            let calendar = self.calendarList[(indexPath as NSIndexPath).row]
            cell.textLabel?.text = calendar.title
            cell.textLabel?.textColor =  UIColor(cgColor: calendar.cgColor)
            
            if self.selectedCalendars.contains(calendar){
                cell.accessoryType = UITableViewCellAccessoryType.checkmark
                
            }else{
                cell.accessoryType = UITableViewCellAccessoryType.none
            }

        } else {
            cell.textLabel?.text = self.specialItems[(indexPath as NSIndexPath).row]
            cell.textLabel?.textColor = UIColor.white
            if selectedCalendars.count == 0{
                cell.accessoryType = UITableViewCellAccessoryType.checkmark
            }else{
                cell.accessoryType = UITableViewCellAccessoryType.none

            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.tableView.cellForRow(at: indexPath)
        
        if (indexPath as NSIndexPath).section == 0{
            
            // All -
            selectedCalendars.removeAll()
            tableView.reloadData()
            
        }else{
            let selectedCalendar = self.calendarList[(indexPath as NSIndexPath).row];
            
            if self.selectedCalendars.contains(selectedCalendar){
                // Selected same cell, do nothing
                
                //save calendarID to use to show for next time...
                //TODO Anil
                //added by 122415 by mike. need to handle multiple calendars, and all cases!
                defaults.set(selectedCalendar.calendarIdentifier, forKey: "defaultListShowID")
                
            }else{
                
                if !allowsMultipleSelection{
                    if !self.selectedCalendars.isEmpty{
                        self.selectedCalendars.removeLast()
                        
                    }
                    self.selectedCalendars.append(selectedCalendar)
                    self.tableView.reloadData()
                }
                
                
                //                cell?.accessoryType = UITableViewCellAccessoryType.None
                //                self.selectedCalendars.removeAtIndex(find(self.selectedCalendars, selectedCalendar)!)
                //                if allowsMultipleSelection || self.selectedCalendars.count == 0{
                //
                //                cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
                //                self.selectedCalendars.append(selectedCalendar)
                //                }
            }
        }
  
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
    
}
