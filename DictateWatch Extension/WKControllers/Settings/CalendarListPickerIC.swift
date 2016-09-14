//
//  CalendarListPickerIC.swift
//  Dictate
//
//  Created by Mike Derr on 9/15/15.
//  Copyright (c) 2015 ThatSoft.com. All rights reserved.
//

import WatchKit
import Foundation
import EventKit


class CalendarListPickerIC: WKInterfaceController {
    
    var selectedRow:Int! = nil
    let defaults = UserDefaults(suiteName: "group.com.thatsoft.dictateApp")!

    let eventStore = EKEventStore()
    var checked:Bool = false

    @IBOutlet weak var table: WKInterfaceTable!
    
    
    //TODO call from EventManager get local calendars
   // let allCalendarLists: Array<EKCalendar> = EventManager.sharedInstance.getLocalEventCalendars()
    
    let allCalendarLists: Array<EKCalendar> = EKEventStore().calendars(for: EKEntityType.event) 
   
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        NSLog("%@ will activate", self)
        print("w34 in CalendarListPickerIC willActivate")
        
       // loadTableData()
    }
    
    func loadTableData () {
        table.setNumberOfRows(allCalendarLists.count, withRowType: "tableRow")
        print("w46 allCalendarLists.count: \(allCalendarLists.count)")
        
        for (index, title) in allCalendarLists.enumerated() {
            print("---------------------------------------------------")
            print("w40 index, title: \(index), \(title)")
            
            let row = table.rowController(at: index) as! DefaultCalendarListTableRC
            let item = allCalendarLists[index]
            
            row.tableRowLabel.setText(item.title)
            row.tableRowLabel.setTextColor(UIColor(cgColor: item.cgColor))
            row.verticalBar.setBackgroundColor(UIColor(cgColor: item.cgColor))
        }
    }   //end loadTableData
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
        print("w59 CalendarListPickerIC")
        print("-----------------------------------------")
        
        self.setTitle("«Settings")
        
        //TODO Anil TODO Mike needed? or willActivate instead?
        loadTableData()
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        print("w72 clicked on row: \(rowIndex)")
        
        selectedRow = rowIndex //for use with insert and delete, save selcted row index
        let row = self.table.rowController(at: rowIndex) as! DefaultCalendarListTableRC
  
        if self.checked {               // Turn checkmark off
            row.imageCheckbox.setImageNamed("cbBlank40px")
            self.checked = false
        } else {                        // Turn checkmark on
            row.imageCheckbox.setImageNamed("cbChecked40px")
            let defaultCalendar: EKCalendar = allCalendarLists[rowIndex]
            let defaultCalendarID = defaultCalendar.calendarIdentifier
            
            print("w85 defaultCalendarID: \(defaultCalendarID)")
            
            defaults.set(defaultCalendarID, forKey: "defaultCalendarID")    //sets defaultReminderListID String
            
            self.checked = true
        }
    }


    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        NSLog("%@ did deactivate", self)
        super.didDeactivate()
        print("w98 in CalendarListPickerIC didDeactivate")

    }

}
