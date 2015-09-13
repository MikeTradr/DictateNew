//
//  TodayIC.swift
//  Dictate
//
//  Created by Mike Derr on 8/4/15.
//  Copyright (c) 2015 ThatSoft.com. All rights reserved.
//

import WatchKit
import Foundation


class TodayIC: WKInterfaceController {
    
    @IBAction func menuDictate() {
        println("w16 force touch tapped, Dictate Item")
        
        var rawString:String = ""
        //TODO Anil need to call that func! lol thx Bro
       // let (startDT, endDT, output, outputNote, day, calendarName, actionType) = MainIC.grabvoice()
        
        

        
    }

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        println("p19 TodayIC")
        
        super.awakeWithContext(context)
        self.setTitle(context as? String)
        
   //     self.setTitle(“Close”)
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        println("p30 in TodayIC willActivate")

    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func buttonMainIC() {
        
        pushControllerWithName("Main", context: "Today")

    }

    @IBAction func buttonReminders() {
        
        pushControllerWithName("Reminders", context: "Today")
        
    }

}
