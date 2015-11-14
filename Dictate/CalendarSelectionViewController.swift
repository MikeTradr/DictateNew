//
//  CalendarSelectionViewController.swift
//  Dictate
//
//  Created by Anil Varghese on 07/09/15.
//  Copyright (c) 2015 ThatSoft.com. All rights reserved.
//

import UIKit
import EventKit

class CalendarSelectionViewController: UITableViewController {
    
    var calendarList = Array<EKCalendar>()
    var allowsMultipleSelection = true
    var selectedCalendars:Array<EKCalendar> = []
    var shouldShowAll = false
    var specialItems = ["All"];
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.backgroundColor  = UIColor.blackColor()
        self.tableView.backgroundColor =  UIColor.blackColor()
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorStyle = .None

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
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        if shouldShowAll{
            return 2
        }
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowAll && section == 0{
            return 1
        }
        return self.calendarList.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) 
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.backgroundColor = UIColor.blackColor()
        
        if !shouldShowAll || indexPath.section == 1{
            
            let calendar = self.calendarList[indexPath.row]
            cell.textLabel?.text = calendar.title
            cell.textLabel?.textColor =  UIColor(CGColor: calendar.CGColor)
            
            if self.selectedCalendars.contains(calendar){
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                
            }else{
                cell.accessoryType = UITableViewCellAccessoryType.None
            }

        }
        else
        {
            cell.textLabel?.text = self.specialItems[indexPath.row]
            cell.textLabel?.textColor = UIColor.whiteColor()
            if selectedCalendars.count == 0{
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            }else{
                cell.accessoryType = UITableViewCellAccessoryType.None

            }
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = self.tableView.cellForRowAtIndexPath(indexPath)
        
        if indexPath.section == 0{
            
            // All -
            selectedCalendars.removeAll()
            tableView.reloadData()
            
        }else{
            let selectedCalendar = self.calendarList[indexPath.row];
            
            if self.selectedCalendars.contains(selectedCalendar){
                // Selected same cell, do nothing
                
                
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
