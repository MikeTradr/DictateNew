//
//  MessageComposer.swift
//  WatchInput
//
//  Created by Mike Derr on 6/30/15.
//  Copyright (c) 2015 ThatSoft.com. All rights reserved.
//
// from:   http://www.andrewcbancroft.com/2014/10/28/send-text-message-in-app-using-mfmessagecomposeviewcontroller-with-swift/

import Foundation
import MessageUI

let textMessageRecipients = ["1-608-242-7700"] // for pre-populating the recipients list (optional, depending on your needs)

class MessageComposer: NSObject, MFMessageComposeViewControllerDelegate {
    
    let defaults = NSUserDefaults(suiteName: "group.com.thatsoft.dictateApp")!

    
    // A wrapper function to indicate whether or not a text message can be sent from the user's device
    func canSendText() -> Bool {
        return MFMessageComposeViewController.canSendText()
    }
    
    
    // Configures and returns a MFMessageComposeViewController instance
    func configuredMessageComposeViewController() -> MFMessageComposeViewController {
        
        print("p29 We in MessageComposer")
        
        let output:String = defaults.stringForKey("output")!
        
        
        //TODO fix the forced downcast below
        let tempPhone:String = defaults.stringForKey("toPhone")!
        
        var toPhone:[String] = []
        
        toPhone.append(tempPhone)
        
        print("p41 toPhone: \(toPhone)")

        
        let newOutput = "\(output) - sent from Dictate™ App"
        
        let messageBody = newOutput

        
        //let toPhone:[String] = [defaults.stringForKey("toPhone") as! String]
        
        let testBody    = "Hey friend - Just sending a text message in-app using Swift!"

        
        let messageComposeVC = MFMessageComposeViewController()
        messageComposeVC.messageComposeDelegate = self  //  Make sure to set this property to self, so that the controller can be dismissed!
        //messageComposeVC.recipients = textMessageRecipients
        
        messageComposeVC.recipients = toPhone
        messageComposeVC.body = messageBody
        return messageComposeVC
    }
    
    // MFMessageComposeViewControllerDelegate callback - dismisses the view controller when the user is finished with it
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}