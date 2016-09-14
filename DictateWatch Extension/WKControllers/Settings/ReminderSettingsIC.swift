//
//  ReminderSettingsIC.swift
//  Dictate
//
//  Created by Mike Derr on 8/4/15.
//  Copyright (c) 2015 ThatSoft.com. All rights reserved.
//

import WatchKit
import Foundation
//import AVFoundation

class ReminderSettingsIC: WKInterfaceController {
    
 //   var audioPlayer = AVAudioPlayer()
   // var player: WKAudioFilePlayer!
    
    
    @IBAction func buttonSetDefault() {
        print("w19 in buttom Reminders")
        presentController(withName: "ReminderPicker", context: "Settings")
    }
    
    @IBAction func buttonShowReminders() {
          presentController(withName: "ShowReminders", context: "Settings")
    }

//----- Navigation Buttons ---------------------------------
    @IBAction func navButtonReminders() {
          presentController(withName: "Reminders", context: nil)
    }
    
    @IBAction func buttonMic() {
        let alertSound1: URL = URL(fileURLWithPath: Bundle.main.path(forResource: "button-14", ofType: "mp3")!)
        //General.playSound(alertSound3!)
 
        // TODO Fix sound playing on watch
        let filePath = Bundle.main.path(forResource: "se_tap", ofType: "m4a")!
        let fileUrl = URL(fileURLWithPath: filePath)
/*        let asset = WKAudioFileAsset(URL: fileUrl)
        let playerItem = WKAudioFilePlayerItem(asset: asset)
        player = WKAudioFilePlayer(playerItem: playerItem)
        
        
        
        self.presentMediaPlayerControllerWithURL(alertSound1,
            options: [WKMediaPlayerControllerOptionsAutoplayKey: true],
            completion: { (didPlayToEnd : Bool,
                endTime : NSTimeInterval,
                error : NSError?) -> Void in
                if let anErrorOccurred = error {
                    // Handle the error.
                }
                // Perform other tasks
        })
        
 */
        
        
        
        
        //Second, we currently can't control sounds or haptic feedback from our app's code.
    //    self.playSound(alertSound1)
        
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
