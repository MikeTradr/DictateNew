//
//  ReminderItemsTableRC.swift
//  Dictate
//
//  Created by Mike Derr on 9/11/15.
//  Copyright (c) 2015 ThatSoft.com. All rights reserved.
//

import UIKit
import WatchKit
import EventKit

class ReminderItemsTableRC: NSObject {
    
    @IBOutlet weak var tableRowLabel: WKInterfaceLabel!
    @IBOutlet weak var buttonCheckbox: WKInterfaceButton!
    @IBOutlet weak var verticalBar: WKInterfaceGroup!
    @IBOutlet weak var imageCheckbox: WKInterfaceImage!
    
   // var checked:Bool = false
    var reminder:EKReminder?
    

 /*
    @IBAction func buttonTapped() {
        if self.checked {   // Turn checkmark off
            self.buttonCheckbox.setBackgroundImageNamed("cbBlank40px")
            self.checked = false
            reminder?.completed = false
        } else {    // Turn checkmark on
            self.buttonCheckbox.setBackgroundImageNamed("cbChecked40px")
            self.checked = true
            reminder?.completed = true
        }
        
        ReminderManager.sharedInstance.eventStore.saveCalendar(reminder?.calendar, commit: true, error: nil)
        
    }   //end buttonTapped func

*/
    
}
