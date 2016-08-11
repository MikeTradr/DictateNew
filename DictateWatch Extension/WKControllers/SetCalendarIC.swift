//
//  SetCalendarIC.swift
//  Dictate
//
//  Created by Mike Derr on 9/22/15.
//  Copyright (c) 2015 ThatSoft.com. All rights reserved.
//

import WatchKit
import Foundation
import EventKit


class SetCalendarIC: WKInterfaceController {
    
    var selectedRow:Int! = nil
    let defaults = NSUserDefaults(suiteName: "group.com.thatsoft.dictateApp")!
    
    let eventStore = EKEventStore()    
    var checked:Bool = false
    var eventID:String = ""
    var event:EKEvent = EKEvent(eventStore: EKEventStore())

    
    @IBOutlet weak var table: WKInterfaceTable!
    
    let allCalendarLists: Array<EKCalendar> = EKEventStore().calendarsForEntityType(EKEntityType.Event) 
    
//---- Menu functions -------------------------------------------
    @IBAction func menuDictate() {
         let (startDT, endDT, output, outputNote, day, calendarName, actionType, duration, alert, eventLocation, eventRepeat) = DictateManagerIC.sharedInstance.grabVoice()
    }
    
    @IBAction func menuSettings() {
        presentControllerWithName("Settings", context: "«Events")
    }
//---- end Menu functions ----------------------------------------
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        NSLog("%@ will activate", self)
        print("w42 in SetCalendarIC willActivate")
        
       // var sceneTitle:String = (context as? String)!
        //self.setTitle("«\(sceneTitle)")
        self.setTitle("«Event Details")

        
        // loadTableData()
    }
    
    func loadTableData () {
        table.setNumberOfRows(allCalendarLists.count, withRowType: "tableRow")
        print("w46 allCalendarLists.count: \(allCalendarLists.count)")
        
        for (index, title) in allCalendarLists.enumerate() {
            print("---------------------------------------------------")
            print("w40 index, title: \(index), \(title)")
            
            let row = table.rowControllerAtIndex(index) as! SetCalendarTableRC
            let item = allCalendarLists[index]
            
            row.tableRowLabel.setText(item.title)
            row.tableRowLabel.setTextColor(UIColor(CGColor: item.CGColor))
            row.verticalBar.setBackgroundColor(UIColor(CGColor: item.CGColor))
        }
    }   //end loadTableData
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        // Configure interface objects here.
        print("w72 SetCalendarIC")
        print("-----------------------------------------")
        
        eventID = context as! String
        //FIXME:7
        event = EventManager.sharedInstance.eventStore.eventWithIdentifier(eventID)!
        print("w168: event \(event)")
        
        //TODO Anil TODO Mike needed? or willActivate instead?
        loadTableData()
    }
    
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        print("w116 clicked on row: \(rowIndex)")
        
        selectedRow = rowIndex //for use with insert and delete, save selcted row index
        let row = self.table.rowControllerAtIndex(rowIndex) as! SetCalendarTableRC
        
        if self.checked {               // Turn checkmark off
            row.imageCheckbox.setImageNamed("cbBlank40px")
            self.checked = false
        } else {                        // Turn checkmark on
            row.imageCheckbox.setImageNamed("cbChecked40px")
            let defaultCalendar: EKCalendar = allCalendarLists[rowIndex]
            let defaultCalendarID = defaultCalendar.calendarIdentifier
            
            print("w130 defaultCalendarID: \(defaultCalendarID)")
            
            defaults.setObject(defaultCalendarID, forKey: "defaultCalendarID")    //sets defaultReminderListID String
            
            self.checked = true
        }
    }
    
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        NSLog("%@ did deactivate", self)
        super.didDeactivate()
        print("w110 in SetCalendarIC didDeactivate")
        
    }
    
}
