//
//  GeneralWatch.swift
//  Dictate
//
//  Created by Mike Derr on 8/5/16.
//  Copyright © 2016 ThatSoft.com. All rights reserved.
//

import Foundation
import WatchKit

class GeneralWatch: WKInterfaceController {
    
    class var sharedInstance : GeneralWatch {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : GeneralWatch? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = GeneralWatch()
        }
        return Static.instance!
    }
    
    var player: WKAudioFilePlayer!
    
    func playSound(sound: NSURL) {
        
        /*
         func playSound(sound: NSURL){
         do {
         self.audioPlayer = try AVAudioPlayer(contentsOfURL: sound)
         } catch {
         
         }
         self.audioPlayer.prepareToPlay()
         //player.delegate = self player.play()
         //audioPlayer.delegate = self
         self.audioPlayer.play()
         }
         */
        
        print("GeneralWatch w29 sound: \(sound)")
       // let filePath = NSBundle.mainBundle().pathForResource("beep-08b", ofType: "mp3")!
        //let filePath = NSBundle.mainBundle().pathForResource(fileName, ofType: "mp3")!
        //let fileUrl = NSURL.fileURLWithPath (filePath)
        let asset = WKAudioFileAsset (URL: sound)
        let playerItem = WKAudioFilePlayerItem (asset: asset)
        player = WKAudioFilePlayer (playerItem: playerItem)
        // locks app in simulator 
        
       // self.player.play()
    }
    
    
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    
    
    
}