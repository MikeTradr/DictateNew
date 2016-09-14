//
//  DetailsTableVC_OLD.swift
//  Dictate
//
//  Created by Mike Derr on 1/30/16.
//  Copyright © 2016 ThatSoft.com. All rights reserved.
//

import UIKit

class DetailsTableVC_OLD: UIViewController,UITableViewDelegate, UITableViewDataSource {


    let defaults = UserDefaults(suiteName: "group.com.thatsoft.dictateApp")!
    
   // class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
        
        var tableView: UITableView  =   UITableView()
 /*
    let nameColumn = NSTableColumn(identifier: "name column")
    nameColumn?.width = tableWidth * 0.4
    nameColumn?.headerCell.title = "Name"
    
        let column1 = NSTabColumnTerminatorsAttributeName(identifier: "Col1")
        let column2 = NSTableColumn(identifier: "Col2")
        column1.width = 252
        column2.width = 198
        tableView.addTableColumn(column1)
        tableView.addTableColumn(column2)
        tableView.setDelegate(self)
        tableView.setDataSource(self)
        tableView.reloadData()
        tableContainer.documentView = tableView
        tableContainer.hasVerticalScroller = true
        window.contentView.addSubview(tableContainer)
*/
        
        var items: [String] = ["Viper", "X", "Games"]
        
        override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view, typically from a nib.
            
            tableView.frame         =   CGRect(x: 2, y: 30, width: 300, height: 350);
            tableView.delegate      =   self
            tableView.dataSource    =   self
            tableView.rowHeight     =   31.0
            tableView.backgroundColor = UIColor.black
            tableView.tintColor     =   UIColor.white
            
           // tableView.tableFooterView = UIView(frame:CGRectZero)    //removes blank lines
          
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            
        

            
            self.view.addSubview(tableView)
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            // Return the number of rows in the section.
            return 11
            //return self.items.count   //counts items in array
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
            
            cell.backgroundColor        =   UIColor.clear
            cell.textLabel?.textColor   =   UIColor.white

            //cell.textLabel?.text = self.items[indexPath.row]  //pulls from array
            
            let shortPath = ((indexPath as NSIndexPath).section, (indexPath as NSIndexPath).row)
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
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print("You selected cell #\((indexPath as NSIndexPath).row)!")
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        
    }

    
 /*
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier("LabelCell", forIndexPath: indexPath)
        
        // Configure the cell...
        //cell.textLabel?.text = "Section \(indexPath.section) Row \(indexPath.row)"
        //   cell.textLabel?.text = "Row \(indexPath.row)"
        
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
*/
