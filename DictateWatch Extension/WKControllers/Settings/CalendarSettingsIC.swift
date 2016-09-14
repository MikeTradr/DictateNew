//
//  CalendarSettingsIC.swift
//  Dictate
//
//  Created by Mike Derr on 8/4/15.
//  Copyright (c) 2015 ThatSoft.com. All rights reserved.
//

import WatchKit
import Foundation
//import AVFoundation


class CalendarSettingsIC: WKInterfaceController {
    
   // var audioPlayer = AVAudioPlayer()
    
    
    @IBAction func buttonDefaults() {
        
        print("w26 in buttom Reminders")
        presentController(withName: "CalendarPicker", context: "Settings")    //TODO why no "settings" shown ???
        
    }
    
    
    @IBAction func buttonCalendars() {
         presentController(withName: "ShowCalendars", context: "Settings")
    }
//----- Navigation Buttons ---------------------------------
    @IBAction func navButtonReminders() {
          presentController(withName: "Reminders", context: nil)
    }
    
    
    @IBAction func buttonMic() {
        var alertSound1: URL = URL(fileURLWithPath: Bundle.main.path(forResource: "button-14", ofType: "mp3")!)
        //General.playSound(alertSound3!)
        
        //Second, we currently can't control sounds or haptic feedback from our app's code.
   //     self.playSound(alertSound1)
        
//TODO TOFIX        let (startDT, endDT, output, outputNote, day, calendarName, actionType) = DictateManagerIC.sharedInstance.grabVoice()
        
        
    //    println("p268 startDT: \(startDT)")
    //    println("p269 endDT: \(endDT)")
     //   println("p270 actionType: \(actionType)")
     //   println("p271 calendarName: \(calendarName)")
    }
    
    @IBAction func navButtonToday() {
          presentController(withName: "Events", context: nil)
    }
    
//----- Navigation Buttons ---------------------------------
/*
    func playSound(sound: NSURL){
        var error:NSError?
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOfURL: sound)
        } catch var error1 as NSError {
            error = error1
        }
        self.audioPlayer.prepareToPlay()
        //player.delegate = self player.play()
        //audioPlayer.delegate = self
        self.audioPlayer.play()
    }
*/
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        print("p19 PreferencesIC")
        
        super.awake(withContext: context)
        //self.setTitle(context as? String)
        self.setTitle("«Settings")


        
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        print("p30 in PreferncesIC willActivate")

    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    

}
