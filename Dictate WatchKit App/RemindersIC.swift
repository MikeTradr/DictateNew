//
//  RemindersIC.swift
//  Dictate
//
//  Created by Mike Derr on 8/4/15.
//  Copyright (c) 2015 ThatSoft.com. All rights reserved.
//

import WatchKit
import Foundation


class RemindersIC: WKInterfaceController {

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
           println("p19 RemindersIC")
        
        super.awakeWithContext(context)
        self.setTitle(context as? String)
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func buttonToday() {
        pushControllerWithName("TodayEvents", context: "Reminders")

    }
    
    @IBAction func buttonMain() {
        pushControllerWithName("Main", context: "Reminders")

    }

}
