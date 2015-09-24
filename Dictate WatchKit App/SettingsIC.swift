//
//  SettingsIC.swift
//  Dictate
//
//  Created by Mike Derr on 8/4/15.
//  Copyright (c) 2015 ThatSoft.com. All rights reserved.
//

import WatchKit
import Foundation
import AVFoundation


class SettingsIC: WKInterfaceController {
    
    var audioPlayer = AVAudioPlayer()
    
    @IBAction func buttonReminders() {
        println("w19 in buttom Reminders")
          presentControllerWithName("ReminderPicker", context: "Settings")    //TODO why no "settings" shown ???
    }
    
    @IBAction func buttonCalendars() {
         presentControllerWithName("CalendarPicker", context: "Settings")
    }
//----- Navigation Buttons ---------------------------------
    @IBAction func navButtonReminders() {
          presentControllerWithName("Reminders", context: nil)
    }
    
    
    @IBAction func buttonMic() {
        var alertSound1: NSURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("button-14", ofType: "mp3")!)!
        //General.playSound(alertSound3!)
        
        //Second, we currently can't control sounds or haptic feedback from our app's code.
        self.playSound(alertSound1)
        
//TODO TOFIX        let (startDT, endDT, output, outputNote, day, calendarName, actionType) = DictateManagerIC.sharedInstance.grabVoice()
        
        
    //    println("p268 startDT: \(startDT)")
    //    println("p269 endDT: \(endDT)")
     //   println("p270 actionType: \(actionType)")
     //   println("p271 calendarName: \(calendarName)")
    }
    
    @IBAction func navButtonToday() {
          presentControllerWithName("TodayEvents", context: nil)
    }
    
//----- Navigation Buttons ---------------------------------

    func playSound(sound: NSURL){
        var error:NSError?
        self.audioPlayer = AVAudioPlayer(contentsOfURL: sound, error: &error)
        self.audioPlayer.prepareToPlay()
        //player.delegate = self player.play()
        //audioPlayer.delegate = self
        self.audioPlayer.play()
    }

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        println("p19 PreferencesIC")
        
        super.awakeWithContext(context)
        
        var sceneTitle:String = (context as? String)!
        self.setTitle("«\(sceneTitle)")
        //self.setTitle("Settings")


        
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        println("p30 in PreferncesIC willActivate")

    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    

}
