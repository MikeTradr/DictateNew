//
//  General.swift
//  Dictate
//
//  Created by Mike Derr on 6/13/15.
//  Copyright (c) 2015 ThatSoft.com. All rights reserved.
//

import UIKit
import MessageUI
import AVFoundation

class General: NSObject, UITextFieldDelegate, MFMailComposeViewControllerDelegate {
    

  // var sound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Beep2", ofType: "mp3")!)
    
    // make sure to add this sound to your project
  //  var alertSound3 = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Beep2", ofType: "mp3")!)
  //  var audioPlayer = AVAudioPlayer()

  //  var sound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Beep2", ofType: "mp3")!)
    
    // make sure to add this sound to your project
 //   var alertSound3 = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Beep2", ofType: "mp3")!)
   // var audioPlayer = AVAudioPlayer()
    
    //---- my General functions ----------------------------------------
    
    func switchScreen(scene: String) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier(scene) 
        // TODO FIX    self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func cleardata() {
        print("General p37 we here cleardata")
        
        var mainType = ""
        var day = ""
        var timeString = ""
        var phone = ""
        var fullDT = ""
        var fullDTEnd = ""
        var outputNote = ""
        var calendarName = ""
        
        /*
        resultType.text = ""
        resultDate.text = ""
        resultTime.text = ""
        resultPhone.text = ""
        resultStartDate.text = ""
        resultEndDate.text = ""
        resultTitle.text = ""
        resultCalendar.text = ""
        
        enteredText2.text = ""
        
        */
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // self.view.endEditing(true)
        return false
    }
    
    func makeCall(toPhone:String) {
        
        if let url = NSURL(string: "tel://\(toPhone)") {
            //TODO Anl can this work here?
            //UIApplication.sharedApplication().openURL(url)
        }
    }
    


    

    //---- end my Gerneral functions -------------------------------------
    
}


