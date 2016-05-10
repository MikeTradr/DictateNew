//
//  EventEditNotesIC.swift
//  Dictate
//
//  Created by Mike Derr on 9/22/15.
//  Copyright (c) 2015 ThatSoft.com. All rights reserved.
//

import WatchKit
import Foundation
// import AVFoundation //commented for new watchExtension 040516
import EventKit


class EventEditNotesIC: WKInterfaceController {
    
  //  var audioPlayer = AVAudioPlayer()
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
    
    
//---- Menu functions -------------------------------------------
    @IBAction func menuDictate() {
        let (startDT, endDT, output, outputNote, day, calendarName, actionType) = DictateManagerIC.sharedInstance.grabVoice()
    }
    
    @IBAction func menuSettings() {
        presentControllerWithName("Settings", context: "«Details")
    }
//---- end Menu functions ----------------------------------------
    
    @IBAction func buttonGroupMic() {
      
        var alertSound1: NSURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("button-14", ofType: "mp3")!)
        //General.playSound(alertSound3!)
        
        //Second, we currently can't control sounds or haptic feedback from our app's code.
     //   self.playSound(alertSound1) ////commented for new watchExtension 040516        
        let labelNotes:String = grabvoiceNotes()
        
        print("w32 labelNotes: \(labelNotes)")
        
    }
    
    

    
    
    @IBAction func buttonNotes() {
        
        var alertSound1: NSURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("button-14", ofType: "mp3")!)
        //General.playSound(alertSound3!)
        
        //Second, we currently can't control sounds or haptic feedback from our app's code.
       //  self.playSound(alertSound1) ////commented for new watchExtension 040516
        
        let labelNotes:String = grabvoiceNotes()
        
        print("w48 labelNotes: \(labelNotes)")
        
        
    }
    
 
    @IBAction func buttonSaveNote() {
        event.notes = self.dictateResult
        print("w64: self.dictateResult \(self.dictateResult)")
//FIXWC EventManager.sharedInstance.saveEvent(event)
        
        //TODO make a general func call
        var alertSound1: NSURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("212-buttonclick52", ofType: "mp3")!)
       
      //  self.playSound(alertSound1) ////commented for new watchExtension 040516
        
       // self.labelSaveNote.setText("Note for message, \"\(event.title)\" , has been updated")
        
    self.labelSaveNote2.setTextColor(UIColor.whiteColor())

        self.labelSaveNote1.setText("Note for event:")
        self.labelSaveNote2.setText("\"\(event.title)\"")
        self.labelSaveNote3.setText("has been updated.")

        self.groupSaveNote.setHidden(true)
        self.groupClickHere.setHidden(true)
        self.groupNotesText.setHidden(true)
        self.groupSaveMessage.setHidden(false)
        
        WatchGeneral().delay(3.0) {          // do stuff
            
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
                print("There are objects")
                self.dictateResult = results![0] as! String
                print("### w47 self.dictateResult: \(self.dictateResult)")
                
            } else {
                print("No objects")
            }
  
            self.labelNotes.setText(self.dictateResult)

                //completion(“we finished!”)
        })
        
        self.groupSaveNote.setHidden(false)
        self.groupClickHere.setHidden(true)
    
        return self.dictateResult
    }
    
    
/* //   //commented for new watchExtension 040516
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
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        // Configure interface objects here.
        NSLog("%@ w92 awakeWithContext", self)
        print("w93 EventEditNotesIC awakeWithContext")
        
        self.setTitle("«Event Details")
        
        print("w102: event \(event)")

        
        eventID = context as! String
        event = EventManager.sharedInstance.eventStore.eventWithIdentifier(eventID)!
        print("w168: event \(event)")
        
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
        print("w116 EventEditNotesIC didDeactivate")
      

        
        
    }

}
