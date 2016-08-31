//
//  TodayViewController.swift
//  todayWidget
//
//  Created by Mike Derr on 8/31/16.
//  Copyright © 2016 ThatSoft.com. All rights reserved.
//
/// https://github.com/maximbilan/iOS-Today-Extension-Simple-Tutorial
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    private var data: Array<NSDictionary> = Array()
    
    var attractionNames = [String]()
    
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var labelTest: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        
        attractionNames = ["Buckingham Palace",
                           "The Eiffel Tower",
                           "The Grand Canyon",
                           "Windsor Castle",
                           "Empire State Building"]

        
       // loadData()
        
        self.preferredContentSize.height = 170
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        loadData()


        completionHandler(NCUpdateResult.NewData)
    }
    
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> (UIEdgeInsets) {
        return UIEdgeInsetsZero
    }
    
    // MARK: - Loading of data
    
    func loadData() {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            
            self.data.removeAll()
            
            if let path = NSBundle.mainBundle().pathForResource("Data", ofType: "plist") {
                if let array = NSArray(contentsOfFile: path) {
                    for item in array {
                        self.data.append(item as! NSDictionary)
                    }
                }
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - TableView Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attractionNames.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       // let cell = tableView.dequeueReusableCellWithIdentifier("tableViewCellIdentifier", forIndexPath: indexPath)
        
        var identifier = "tableViewCellIdentifier"
        
        let cell = tableView.dequeueReusableCellWithIdentifier( identifier, forIndexPath: indexPath) as! TodayTableViewCell
       // cell.delegate = self
        
       let row = indexPath.row
        
       // let item = data[indexPath.row]
        
        cell.labelTitle.text = attractionNames[row]

       // cell.textLabel?.text = item["title"] as? String
        //cell.textLabel?.textColor = UIColor.whiteColor()
        return cell
    }
    
    
    
}
