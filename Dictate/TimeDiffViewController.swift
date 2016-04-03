//
//  TimeDiffViewController.swift
//  Dictate
//
//  Created by Mike Derr on 3/29/16.
//  Copyright © 2016 ThatSoft.com. All rights reserved.
//

import UIKit

class TimeDiffViewController: UIViewController {
    
    @IBOutlet weak var labelNow: UILabel!
    @IBOutlet weak var labelEventTime: UILabel!
    @IBOutlet weak var labelTimeUntil: UILabel!
    
    var label = ""
    let now = NSDate()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let calendar = NSCalendar.currentCalendar()
        
        let components = NSDateComponents()
        components.day = 29
        components.month = 03
        components.year = 2016
        components.hour = 19
        components.minute = 30
        let newDate: NSDate = calendar.dateFromComponents(components)!
        
        //let eventTime: NSDate = calendar.dateBySettingHour(5, minute: 30, second: 0, ofDate: now, options: NSCalendarOptions())!
        
        print("p31 now: \(now)")
       // print("p32 eventTime: \(eventTime)")
       
        var timeOutput = ""
        
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        var dateAsString = "2016-04-03 12:40:00"
        let date3 = dateFormatter.dateFromString(dateAsString)!
        
        labelTimeUntil.text = TimeManger.sharedInstance.timeInterval(date3)
        
        if (labelTimeUntil.text == "Now" || labelTimeUntil.text == "in 1 minute") {
            labelTimeUntil.textColor = UIColor.redColor()
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
