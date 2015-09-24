//
//  EventEditNotesIC.swift
//  Dictate
//
//  Created by Mike Derr on 9/22/15.
//  Copyright (c) 2015 ThatSoft.com. All rights reserved.
//

import WatchKit
import Foundation
import AVFoundation



class EventEditNotesIC: WKInterfaceController {
    
    var audioPlayer = AVAudioPlayer()
    var notes:String = ""
    var eventID:String = ""
    
    let eventStore = EKEventStore()
    
    var event:EKEvent = EKEvent(eventStore: EKEventStore())
    var dictateResult:String = ""
    
    @IBOutlet weak var labelNotes: WKInterfaceLabel!
    
    @IBOutlet weak var labelSaveNote1: WKInterfaceLabel!
    @IBOutlet weak var labelSaveNote2: WKInterfaceLabel!
    @IBOutlet weak var labelSaveNote3: WKInterfaceLabel!

    @IBOutlet weak var groupSaveMessage: WKInterfaceGroup!
    @IBOutlet weak var groupSaveNote: WKInterfaceGroup!
    @IBOutlet weak var groupClickHere: WKInterfaceGroup!
    @IBOutlet weak var groupNotesText: WKInterfaceGroup!
    
    @IBAction func buttonGroupMic() {
      
        var alertSound1: NSURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("button-14", ofType: "mp3")!)!
        //General.playSound(alertSound3!)
        
        //Second, we currently can't control sounds or haptic feedback from our app's code.
        self.playSound(alertSound1)
        
        let labelNotes:String = grabvoiceNotes()
        
        println("w32 labelNotes: \(labelNotes)")
        
    }
    
    

    
    
    @IBAction func buttonNotes() {
        
        var alertSound1: NSURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("button-14", ofType: "mp3")!)!
        //General.playSound(alertSound3!)
        
        //Second, we currently can't control sounds or haptic feedback from our app's code.
        self.playSound(alertSound1)
        
        let labelNotes:String = grabvoiceNotes()
        
        println("w48 labelNotes: \(labelNotes)")
        
        
    }
    
 
    @IBAction func buttonSaveNote() {
        event.notes = self.dictateResult
        println("w64: self.dictateResult \(self.dictateResult)")
        EventManager.sharedInstance.saveEvent(event)
        
        //TODO make a general func call
        var alertSound1: NSURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("212-buttonclick52", ofType: "mp3")!)!
       
        self.playSound(alertSound1)
        
       // self.labelSaveNote.setText("Note for message, \"\(event.title)\" , has been updated")
        
    self.labelSaveNote2.setTextColor(UIColor.whiteColor())

        self.labelSaveNote1.setText("Note for event:")
        self.labelSaveNote2.setText("\"\(event.title)\"")
        self.labelSaveNote3.setText("has been updated.")

        self.groupSaveNote.setHidden(true)
        self.groupClickHere.setHidden(true)
        self.groupNotesText.setHidden(true)
        self.groupSaveMessage.setHidden(false)
        
        General().delay(3.0) {          // do stuff
            
            self.presentControllerWithName("EventDetails", context: self.eventID)
        }
        
        
   // presentControllerWithName("EventDetails", context: eventID)
        
    }
 /*
    override func contextForSegueWithIdentifier(segueIdentifier: String) ->  AnyObject? {
        if segueIdentifier == "backToDetails" {
            
            eventID = event.eventIdentifier
            
            println("w171 eventID \(eventID)")
        }
        return eventID
    }
 */
    
    

    
    
    func grabvoiceNotes() -> (String)  {
        self.presentTextInputControllerWithSuggestions(["this is an updated note"], allowedInputMode: WKTextInputMode.Plain, completion: { results -> Void in
            
            //println("34 Results: \(results)")
            //println("35 Results: \(results[0])")
            
            if results != nil {
                println("There are objects")
                self.dictateResult = results[0] as! String
                println("### w47 self.dictateResult: \(self.dictateResult)")
                
            } else {
                println("No objects")
            }
  
            self.labelNotes.setText(self.dictateResult)

                //completion(“we finished!”)
        })
        
        self.groupSaveNote.setHidden(false)
        self.groupClickHere.setHidden(true)
    
        return self.dictateResult
    }
    
    
    
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
        NSLog("%@ w92 awakeWithContext", self)
        println("w93 EventEditNotesIC awakeWithContext")
        
        self.setTitle("«Event Details")
        
        println("w102: event \(event)")

        
        eventID = context as! String
        event = EventManager.sharedInstance.eventStore.eventWithIdentifier(eventID)
        println("w168: event \(event)")
        
        self.labelNotes.setText(event.notes)
        self.groupSaveNote.setHidden(true)
        self.groupSaveMessage.setHidden(true)


    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        NSLog("%@ w115 didDeactivate", self)
        println("w116 EventEditNotesIC didDeactivate")
      

        
        
    }

}
