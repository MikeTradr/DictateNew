//
//  GlanceTodayEventsTableRC.swift
//  Dictate
//
//  Created by Mike Derr on 10/20/15.
//  Copyright © 2015 ThatSoft.com. All rights reserved.
//

import WatchKit

//new file for Anil test

class GlanceTodayEventsTableRC: NSObject {
    
    @IBOutlet weak var labelEventTitle: WKInterfaceLabel!
    
    @IBOutlet weak var labelStartTime: WKInterfaceLabel!
    
    @IBOutlet var labelEndTime: WKInterfaceLabel!
    
    @IBOutlet var labelTimeUntil: WKInterfaceLabel!
    
    @IBOutlet var groupTime: WKInterfaceGroup!
    @IBOutlet weak var labelEventLocation: WKInterfaceLabel!
    
    @IBOutlet var imageVertBar: WKInterfaceImage!
    
    @IBOutlet weak var verticalBar: WKInterfaceGroup!
    
    @IBOutlet var groupEvent: WKInterfaceGroup!
}
