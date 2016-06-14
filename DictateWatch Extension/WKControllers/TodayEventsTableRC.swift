//
//  TodayEventsTableRC.swift
//  Dictate
//
//  Created by Mike Derr on 9/19/15.
//  Copyright (c) 2015 ThatSoft.com. All rights reserved.
//

import UIKit
import WatchKit

class TodayEventsTableRC: NSObject {
    
    @IBOutlet var labelX: WKInterfaceLabel!
    @IBOutlet weak var labelEventTitle: WKInterfaceLabel!
 
    @IBOutlet weak var labelStartTime: WKInterfaceLabel!
    
    @IBOutlet weak var labelEndTime: WKInterfaceLabel!
    @IBOutlet var labelTimeUntil: WKInterfaceLabel!
    
    @IBOutlet var groupTime: WKInterfaceGroup!
    
    @IBOutlet weak var labelEventLocation: WKInterfaceLabel!
   
    @IBOutlet var imageVertBar: WKInterfaceImage!
    
    @IBOutlet weak var verticalBar: WKInterfaceGroup!
    
    @IBOutlet var groupEvent: WKInterfaceGroup!
}
