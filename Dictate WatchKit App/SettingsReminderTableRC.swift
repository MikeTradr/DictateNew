//
//  SettingsReminderTableRC.swift
//  Dictate
//
//  Created by Mike Derr on 9/11/15.
//  Copyright (c) 2015 ThatSoft.com. All rights reserved.
//

import UIKit
import WatchKit

class SettingsReminderTableRC: NSObject {
   
    @IBOutlet weak var tableRowLabel: WKInterfaceLabel!
    
    @IBOutlet weak var buttonCheckbox: WKInterfaceButton!
    
    @IBOutlet weak var imageCheckBox: WKInterfaceImage!
    
    @IBOutlet weak var verticalBar: WKInterfaceGroup!
    
    var checked:Bool = false
    
    @IBAction func buttonTapped() {
        if self.checked {
            // Turn bulb off
            self.buttonCheckbox.setBackgroundImageNamed("cbBlank40px")
            //self.imageCheckBox.setImageNamed("cbBlank40px")
            //self.lightbulbButton.setTitle("Turn On")
            self.checked = false
        } else {
            // Turn bulb on
            self.buttonCheckbox.setBackgroundImageNamed("cbChecked40px")
            //self.imageCheckBox.setImageNamed("cbChecked40px")
            //self.lightbulbButton.setTitle("Turn Off")
            self.checked = true
        }
        
    }
    
    
}
