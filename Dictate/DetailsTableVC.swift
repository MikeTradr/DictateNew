//
//  DetailsTableVC.swift
//  Dictate
//
//  Created by Mike Derr on 1/30/16.
//  Copyright © 2016 ThatSoft.com. All rights reserved.
//

import UIKit

class DetailsTableVC: UITableViewController {
    
    let defaults = NSUserDefaults(suiteName: "group.com.thatsoft.dictateApp")!
    
    var labels = [String]()
    var data = [String]()
    
    @IBOutlet weak var tableV: UITableView!
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labels = ["Buckingham Palace",
            "The Eiffel Tower",
            "The Grand Canyon",
            "Windsor Castle",
            "Empire State Building"]
        
        data = ["data1",
            "data2",
            "d3The Grand Canyon",
            "data4",
            "d5 Empire State Building"]
        
        tableV.estimatedRowHeight = 31
        
        tableV.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")

        
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
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 11
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
       // let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        
        
        
        
        let cell =
        tableView.dequeueReusableCellWithIdentifier(
            "cell", forIndexPath: indexPath)
            as! DetailsTableViewCell
        
        
 /*
        
        let row = indexPath.row
        cell.col1.font =
            UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        cell.col1.text = labels[row]
        cell.col2.text = data[row]
    */
        let shortPath = (indexPath.section, indexPath.row)
        switch shortPath {
        case (0, 0):    cell.textLabel?.text = "Input"
        case (0, 1):    cell.textLabel?.text = "Type"
        case (0, 2):    cell.textLabel?.text = "Day"
        case (0, 3):    cell.textLabel?.text = "Time"
        case (0, 4):    cell.textLabel?.text = "Cell#"
        case (0, 5):    cell.textLabel?.text = "Start"
        case (0, 6):    cell.textLabel?.text = "End"
        case (0, 7):    cell.textLabel?.text = "Title"
        case (0, 8):    cell.textLabel?.text = "Cal."
        case (0, 9):    cell.textLabel?.text = "Alert"
        case (0, 10):    cell.textLabel?.text = "Repeat"
            
        default:
            print("done lol")
            //cell.textLabel?.text = "¯\\_(ツ)_/¯"
        }
        
        
        return cell
    }
    
        // Configure the cell...
        //cell.textLabel?.text = "Section \(indexPath.section) Row \(indexPath.row)"
        //   cell.textLabel?.text = "Row \(indexPath.row)"
 /*
        let shortPath = (indexPath.section, indexPath.row)
        switch shortPath {
        case (0, 0):    cell.textLabel?.text = "Input"
        case (0, 1):    cell.textLabel?.text = "Type"
        case (0, 2):    cell.textLabel?.text = "Day"
        case (0, 3):    cell.textLabel?.text = "Time"
        case (0, 4):    cell.textLabel?.text = "Cell#"
        case (0, 5):    cell.textLabel?.text = "Start"
        case (0, 6):    cell.textLabel?.text = "End"
        case (0, 7):    cell.textLabel?.text = "Title"
        case (0, 8):    cell.textLabel?.text = "Cal."
        case (0, 9):    cell.textLabel?.text = "Alert"
        case (0, 10):    cell.textLabel?.text = "Repeat"
            
            /*
            case (1, 0):
            cell.textLabel?.text = "nameone"
            case (1, 1):
            cell.textLabel?.text = "nametwo"
            case (1, 2):
            cell.textLabel?.text = "namethree"
            */
            
        default:
            print("done lol")
            //cell.textLabel?.text = "¯\\_(ツ)_/¯"
        }
        
        
        return cell
    }
*/
    /*
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    
    return "Section \(section)"
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
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }


}
